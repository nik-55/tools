# Cold Outreach Helper Assistant

A workspace pre-configured to help write cold outreach emails, LinkedIn messages, cover letters, and job application form answers — tuned to your background and the specific company you're targeting.

Works with any AGENTS.md-aware coding assistant (Codex CLI, Cursor, Google Antigravity, etc.). The assistant instructions live in `AGENTS.md`. A `CLAUDE.md` symlink is included for Claude Code compatibility.

> Note: this has been primarily tested against Claude Code. Other AGENTS.md-aware assistants should work, but behavior may vary.

## Setup

Before using, fill in these three files in the root of this folder:

- `resume.md` — your resume in markdown
- `non_resume.md` — things about you that aren't on your resume (side projects, preferences, soft context, anything you want the assistant to know)
- `additional_context.md` — starts empty; the assistant will auto-save new facts it learns about you here over time

These files are gitignored by default — keep your personal info out of version control.

## How to use

1. Open this folder in your coding assistant of choice:
   ```bash
   cd cold-outreach-helper-assistant
   ```

2. Tell the assistant what you need. Examples:
   - `Write a cold email to the careers inbox at Stripe for a backend engineer role`
   - `Write a LinkedIn message to the CTO of a fintech startup`
   - `Help me fill out this application form: <link or paste questions>`
   - `Write a cover letter for this role: <link>`

3. Share company context — paste their website, a job posting link, or describe what they do. The assistant uses this to tune the message to the specific company.

4. The assistant writes the output to `applications/<company_name>/<type>` so you can review, edit, and iterate without losing previous drafts.

## Output files

| Type | Path | Format |
|---|---|---|
| Email | `applications/<company>/email.html` | HTML (preserves formatting for copy-paste) |
| LinkedIn message | `applications/<company>/linkedin.txt` | Plain text |
| Cover letter | `applications/<company>/cover_letter.md` | Markdown |
| Application form | `applications/<company>/form.md` | Markdown |

## Notes

- The assistant will never use marketing language or buzzwords from the company's website — it reads them to understand context, then writes in neutral wording.
- New facts you share during a session get saved to `additional_context.md` automatically, so future sessions build on past ones.
