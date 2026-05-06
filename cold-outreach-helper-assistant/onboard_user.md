# Onboarding

Run this flow only when both `resume.md` and `non_resume.md` are empty (or contain just the placeholder comment). Skip entirely once they have real content.

## 1. Build `resume.md` from the user's actual resume

- Check the directory for a resume PDF (any `.pdf` file at the root). If one exists, read it directly.
- If none exists, ask the user to drop their resume PDF into this folder, then read it once they confirm.
- Convert the PDF content into `resume.md`. Preserve sections, dates, role titles, bullet points, and links exactly as they appear.
- Do NOT hallucinate. If a field is unclear in the PDF (e.g., a project link is cut off, a date is ambiguous), leave a `TODO:` marker and ask the user to clarify rather than guessing.
- Verify every link in the resume is well-formed and reachable. Flag broken or suspicious links to the user before saving.

## 2. Interview the user to build `non_resume.md`

Once `resume.md` exists, skim it and ask the user a short set of questions grounded in what you saw. Keep it to 5–7 questions, conversational tone. Cover:

- What kinds of problems or domains they actually want to work on (vs. what's on the resume).
- Types of companies or teams they're targeting (stage, size, remote/onsite, geography constraints).
- Things they're explicitly not interested in.
- Any role they may not fully fit on paper but want to apply for anyway, and why.
- Anything personal that shapes how they'd frame motivation in a cold email (background story, recent shift, side interests).
- Opinions or strong views on tech they care about.

Save their answers verbatim (lightly cleaned up) to `non_resume.md`. Do not invent answers they didn't give.

## 3. Stop

Once `resume.md` and `non_resume.md` are populated, onboarding is done. Don't keep asking questions — return to the normal outreach workflow.
