# Tools

Vibe Coded tools I use

### [mount-claude-to-remote-server](./mount-claude-to-remote-server)
Run Claude Code against a remote server from your local machine. Bash tool commands and file tools (Read/Write/Glob/Grep) both operate on the remote over SSH/SSHFS inside a Docker container. No extra setup needed on the remote server.

### [cold-outreach-helper-assistant](./cold-outreach-helper-assistant)
Assists with writing cold outreach and job applications. Uses personal context files (`resume.md`, `non_resume.md`, `additional_context.md`) to generate human-sounding, jargon-free cover letters and emails tailored to specific companies. Works with any AGENTS.md-aware coding assistant.

### [serve-folders-over-http](./serve-folders-over-http)
Serve local folders over HTTP with nginx, each behind its own unguessable URL. One script adds or removes a folder, generates the Compose and nginx config, restarts the container, and keeps a text file of which URL points where.

## Download a single tool

You don't need to clone the whole repo — grab just the tool you want as a ZIP:

- [Download mount-claude-to-remote-server](https://download-directory.github.io/?url=https://github.com/nik-55/tools/tree/master/mount-claude-to-remote-server)
- [Download cold-outreach-helper-assistant](https://download-directory.github.io/?url=https://github.com/nik-55/tools/tree/master/cold-outreach-helper-assistant)
- [Download serve-folders-over-http](https://download-directory.github.io/?url=https://github.com/nik-55/tools/tree/master/serve-folders-over-http)

Or from the terminal — replace `<tool>` with the folder name:

```bash
curl -L https://github.com/nik-55/tools/archive/refs/heads/master.tar.gz \
  | tar -xz --strip-components=1 tools-master/<tool>
```
