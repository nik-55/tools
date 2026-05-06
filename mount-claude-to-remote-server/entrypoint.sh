#!/bin/bash
set -e

: "${REMOTE_SERVER:?REMOTE_SERVER is required (e.g. ubuntu@10.0.0.5)}"

WORK_DIR="${WORK_DIR:-/}"
MOUNT_POINT="/remote"

# Set SSH key permissions and write a config with multiplexing and keepalive
mkdir -p ~/.ssh && chmod 700 ~/.ssh
if [ -f /root/.ssh/id_rsa ]; then
    cp /root/.ssh/id_rsa /tmp/id_rsa
    chmod 600 /tmp/id_rsa
fi

cat > ~/.ssh/config << EOF
Host *
    StrictHostKeyChecking no
    UserKnownHostsFile /dev/null
    LogLevel ERROR
    IdentityFile /tmp/id_rsa
    ControlMaster auto
    ControlPath /tmp/ssh-ctrl-%r@%h:%p
    ControlPersist 300
    ServerAliveInterval 15
    ServerAliveCountMax 3
EOF
chmod 600 ~/.ssh/config

# Open a persistent SSH master connection (reused by all subsequent ssh/sshfs calls)
ssh -MNf "$REMOTE_SERVER" || { echo "SSH connection failed"; exit 1; }

# Unmount SSHFS and close the SSH master on exit
cleanup() {
    umount "$WORK_DIR" 2>/dev/null || true
    fusermount3 -u "$MOUNT_POINT" 2>/dev/null || fusermount -u "$MOUNT_POINT" 2>/dev/null || true
    ssh -O exit "$REMOTE_SERVER" 2>/dev/null || true
}
trap cleanup EXIT

# Wrap ssh so Claude's Bash tool runs commands on the remote
cat > /usr/local/bin/remote-bash << EOF
#!/bin/bash
# -T disables pseudo-TTY → bash runs non-interactively → no startup scripts
# printf '%q' properly shell-escapes args before they cross the SSH boundary
if [ "\$#" -eq 0 ]; then
    exec ssh -T "$REMOTE_SERVER" bash --norc --noprofile
else
    cmd=\$(printf '%q ' "\$@")
    exec ssh -T "$REMOTE_SERVER" "bash --norc --noprofile \$cmd"
fi
EOF
chmod +x /usr/local/bin/remote-bash

# Point Claude at the remote bash wrapper via CLAUDE_CODE_SHELL (bashPath is deprecated)
export CLAUDE_CODE_SHELL=/usr/local/bin/remote-bash

# Full access mode: mount the remote filesystem so file tools work on the remote
if [ -e /dev/fuse ]; then
    mkdir -p "$MOUNT_POINT"
    sshfs "$REMOTE_SERVER:/" "$MOUNT_POINT" \
        -o IdentityFile=/tmp/id_rsa \
        -o ControlPath="/tmp/ssh-ctrl-%r@%h:%p" \
        -o StrictHostKeyChecking=no \
        -o UserKnownHostsFile=/dev/null \
        -o reconnect \
        -o ServerAliveInterval=15 \
        -o ServerAliveCountMax=3 \
        || { echo "SSHFS mount failed"; exit 1; }

    # Bind-mount the working dir at its actual remote path so bash and file tools agree
    TARGET_DIR="$MOUNT_POINT/${WORK_DIR#/}"
    if [ -d "$TARGET_DIR" ]; then
        mkdir -p "$WORK_DIR"
        mount --bind "$TARGET_DIR" "$WORK_DIR"
        cd "$WORK_DIR"
    else
        cd "$MOUNT_POINT"
    fi
fi

exec claude
