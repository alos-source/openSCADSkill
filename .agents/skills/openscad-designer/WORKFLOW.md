# Polished OpenSCAD Workflow

This workflow is a simple, repeatable process for creating printable OpenSCAD models.

## 1. Define the goal
- Clarify the object, size, mounting method, and print constraints.
- Note any important tolerances, hardware, or support-free requirements.

## 2. Create a clean first version
- Create or reuse a dedicated project folder.
- Start with a simple, valid model and keep parameters at the top of the file.
- Use a clear naming convention such as `model.scad` for the current version.

## 3. Code-Audit & Symmetry Check
- Audit all `translate()` and `linear_extrude()` commands for nested/stacked geometry (lips, steps, chamfers).
- Verify that scaled or inset features are explicitly centered relative to parent dimensions (`translate([(W-w)/2, (D-d)/2])`).
- Prevent asymmetric offsets caused by default `(0,0)` corner placement of OpenSCAD primitives.
- **CSG & Hull Optimization:** Group continuous organic shapes (e.g. fingers from base to tip) into a **single** `hull()` block with multiple spheres/cylinders instead of nesting multiple separate overlapping `hull()` calls. This speeds up CGAL boolean evaluations dramatically.
- **Dynamic Resolution:** Use `$fn = $preview ? 32 : 48;` to ensure fast PNG preview generation while retaining smooth mesh quality for exports.

## 4. Preview early
- Run a small multi-view render loop before refining the model further.
- Render at least one isometric preview (`preview_iso.png`), one side view (`preview_side.png`), and one orthogonal top-down view (`preview_top.png`).
- Use the top-down view (`--projection=ortho`) to explicitly verify wall thickness symmetry, lip insets, and hole alignment.

## 5. Iterate deliberately
- Fix one issue at a time.
- If a design changes significantly, keep historic render snapshots by passing `-Iteration <N>` to `render-scad.ps1`.
- Old iteration previews are automatically preserved under `history/iter_<N>/` while root preview images update to the latest state.
- Prefer small, focused improvements over large rewrites.

## 6. Validate for print readiness
- Check for overhangs, weak geometry, and obvious mesh issues.
- Make sure the model is manifold and practical to print.
- Only consider it ready once the previews look correct.

## 7. Export and document
- Export the final model to binary STL (`--export-format binstl` or `ai/shared/scripts/export-stl.ps1`) when the design is stable.
- Save the final artifacts in the project folder, for example:
  - `model.scad`
  - `model_preview_iso.png`
  - `model_preview_side.png`
  - `model_preview_top.png`
  - `model_preview_debug.png`
  - `model_preview_print_bed.png`
  - `history/iter_1/`, `history/iter_2/` (Iteration snapshots)
  - `model.stl`
  - `README.md` (optional)

## Quality bar
A design is ready when:
- the shape matches the request,
- the model is printable without obvious issues,
- the file structure is clear,
- and the result is easy to review later.
