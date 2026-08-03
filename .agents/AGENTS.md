# Workspace Rules - OpenSCAD Project

## Coordinate System & Rotation Conventions

> **Source of Truth:** All OpenSCAD coordinate system conventions, rotation rules, symmetry math, and visual verification requirements are documented in:
> [`ai/shared/instructions/openscad-workflow.md`](../ai/shared/instructions/openscad-workflow.md) — section **"Coordinate System & Rotation Conventions"**.

### Agent Guardrails (enforced at runtime)

- **Always** read `ai/shared/instructions/openscad-workflow.md` before generating or modifying any `.scad` file.
- **Never** use a positive X-rotation angle for a reclining backrest or backward-tilting stand. Use `rotate([-tilt_angle, 0, 0])`.
- **Always** inspect `model_preview_side.png` after every render to explicitly confirm tilt direction is correct before proceeding.
