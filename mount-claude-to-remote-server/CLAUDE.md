# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Purpose

This repo is a Docker image that runs Claude Code against a remote server over SSH. It supports two modes:

- **`crb` (bash only):** Claude's Bash tool executes commands on the remote via SSH; file tools (Read/Write/Glob/Grep) operate on the container filesystem.
- **`cr` (full access):** Bash tool runs on remote AND file tools operate on the remote filesystem, which is mounted via SSHFS at `/remote`.

## Build

```bash
docker build -t claude-remote .
```

## How it works

`entrypoint.sh` is the sole runtime logic:

1. Writes an SSH config with multiplexing (`ControlMaster`) and keepalive settings.
2. Opens a persistent SSH master connection to `$REMOTE_SERVER`.
3. Creates `/usr/local/bin/remote-bash` — a wrapper that pipes commands through `ssh ... bash`. This is set as Claude's `bashPath` in `~/.claude/settings.json`.
4. Detects full-access mode by checking for `/dev/fuse`. If present, mounts `$REMOTE_SERVER:/` at `/remote` via SSHFS and `cd`s into `$MOUNT_POINT/$WORK_DIR`.
5. Execs `claude`.

## Environment variables

| Variable | Required | Default | Description |
|---|---|---|---|
| `REMOTE_SERVER` | Yes | — | SSH target, e.g. `ubuntu@10.0.0.5` |
| `WORK_DIR` | No | `/` | Directory to open Claude in (remote path) |

## Credentials persistence

The host directory `~/.remote-claude-session` is mounted as `~/.claude` inside the container. Copy credentials once:

```bash
mkdir -p ~/.remote-claude-session
cp ~/.claude/.credentials.json ~/.remote-claude-session/
```

Note: `entrypoint.sh` merges `bashPath` into `~/.claude/settings.json` on every run, preserving any other settings.
