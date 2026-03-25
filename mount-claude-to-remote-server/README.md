# Remote Claude Session

Run Claude Code against a remote server from your local machine. Both shell commands and file tools operate on the remote server via SSHFS.

## Prerequisites

Create this directory once. It is mounted into the container as `~/.claude` so credentials and settings persist across sessions:

```bash
mkdir -p ~/.remote-claude-session
echo '{}' > ~/.remote-claude-session/.claude.json  
```

## Build

```bash
docker build -t claude-remote .
```

## Usage

`WORK_DIR` is optional — omit it to open at the remote root.

> **Security note:** This requires FUSE inside Docker and the following flags:
> - `--cap-add SYS_ADMIN` — grants the Linux capability required to mount filesystems
> - `--device /dev/fuse` — exposes the host FUSE device to the container
> - `--security-opt apparmor:unconfined` — disables AppArmor confinement to allow FUSE operations
>
> Only use these flags if you trust the image and understand the implications of running a privileged container.

```bash
docker run -it --rm \
  --cap-add SYS_ADMIN \
  --device /dev/fuse \
  --security-opt apparmor:unconfined \
  -e REMOTE_SERVER=ubuntu@10.0.0.5 \
  -e WORK_DIR=/home/ubuntu/myapp \
  -v ~/.ssh/id_rsa:/root/.ssh/id_rsa:ro \
  -v ~/.remote-claude-session:/root/.claude \
  -v ~/.remote-claude-session/.claude.json:/root/.claude.json \
  claude-remote
```

## Shell aliases

Add to `~/.bashrc` for convenience:

```bash
cr() {
  local server=$1
  local workdir=${2:-/}

  docker run -it --rm \
    --cap-add SYS_ADMIN \
    --device /dev/fuse \
    --security-opt apparmor:unconfined \
    -e REMOTE_SERVER="$server" \
    -e WORK_DIR="$workdir" \
    -v ~/.ssh/id_rsa:/root/.ssh/id_rsa:ro \
    -v ~/.remote-claude-session:/root/.claude \
    -v ~/.remote-claude-session/.claude.json:/root/.claude.json \
    claude-remote
}
```

**Examples:**

```bash
cr ubuntu@10.0.0.5
cr ubuntu@10.0.0.5 /home/ubuntu/myapp
```
