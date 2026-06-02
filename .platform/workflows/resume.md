# Resume Workflow (Option 4)

> Loaded lazily when the user picks Option 4 (or says "resume" / "continue") in `AGENTS.md`.
> Read this file fully before starting.

When the user says "resume" or "continue", pick up exactly where the last session left off.

## Step 1 — Read the master state

Read `.planning/STATE.md`. From it, identify:
- The active project (domain slug)
- The current phase and its status
- The path to the active phase plan (`.planning/phases/NN-name/PLAN.md`)

## Step 2 — Read the active PLAN.md

Open the active `.planning/phases/NN-name/PLAN.md`.
Scan its task checklist top to bottom and find the **FIRST unchecked `- [ ]` task**.
That task is exactly where work resumes — do not restart the phase, and do not skip past it.

## Step 3 — Show the user before continuing

Before doing any work, report to the user:
- **Current phase:** `<NN-name>` — `<status>`
- **Last completed:** what was finished (the last checked `- [x]` task, or STATE.md's last-completed note)
- **Next unchecked task:** the exact `- [ ]` line text you found in PLAN.md
- The `▶ Next Up` block from STATE.md, if present

Then ask:
> "Shall I continue with this task, or do you want to do something else?"

## Step 4 — Resume

On confirmation, resume exactly at the first unchecked task. If that task belongs to one of the
other workflows (audit / content / strategy), read the matching workflow file from
`.platform/workflows/` and follow it from the relevant step.

When work pauses or the session ends, run the **Session End Protocol** in `AGENTS.md`
(update `.planning/STATE.md`: `last_updated`, `last_agent`, `phase_status`, and a fresh `▶ Next Up` block).
