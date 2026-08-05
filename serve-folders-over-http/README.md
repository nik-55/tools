# Serve Folders Over HTTP

Serve local folders over HTTP with nginx, each behind its own unguessable URL.

Point it at a folder and you get a link. Open the link and you get a browsable tree of everything inside — nested directories included. Folders are independent: knowing one link tells you nothing about the others, and the server root returns 404.

One script manages everything. It keeps the list of shared folders, generates the Compose and nginx config from that list, and restarts the container whenever the list changes.

## Setup

```bash
python3 -m venv .venv
.venv/bin/pip install -r requirements.txt
cp .env.sample .env
chmod +x share
```

Run the script with the venv's Python:

```bash
.venv/bin/python share list
```

Or activate the venv once (`source .venv/bin/activate`) and use `./share` directly, as shown below.

## Usage

```bash
./share add ~/documents/reports        # serve a folder, print its URL
./share add ~/photos holiday           # ...with a name of your choosing
./share list                           # show what is being served
./share rm reports                     # stop serving a folder
./share rotate reports                 # issue a new URL, kill the old one
```

`add`, `rm` and `rotate` each rewrite the config and restart the container, so the change is live when the command returns.

```bash
./share up      # start
./share down    # stop
./share apply   # rebuild config and restart
./share logs    # follow the nginx logs
```

## Files

| File | |
|---|---|
| `share` | the script — the only thing you run |
| `shares.json` | the list of shared folders, maintained by the script |
| `endpoints.txt` | current URLs and the folder each one points to, rewritten on every change |
| `templates/nginx.conf.j2` | edit this to change nginx behaviour |
| `.env` | port, bind address, image |
| `docker-compose.yml`, `nginx/conf.d/` | generated — do not edit |

Your own files are never touched. Folders are mounted read-only, and `rm` only removes the mount.

## Notes

**The URL is the only lock.** Each share gets 96 bits of randomness in its path, which is not guessable, but anyone who has the link can read the folder. Treat links as secrets. Use `rotate` if one leaks. If you need real access control, put basic auth or a VPN in front of it.

**Bind address.** `BIND_ADDR=0.0.0.0` publishes to your whole network. Set it to `127.0.0.1` for this machine only.

**Permissions.** nginx runs as an unprivileged user inside the container, so a folder it cannot read returns 403. `chmod o+rX` on the folder fixes it.

**Dotfiles** are not served, so a stray `.env` or `.git` inside a shared folder stays private.
