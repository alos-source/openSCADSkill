---
name: preview-scad
description: Render an OpenSCAD .scad file to high-resolution preview images for visual inspection.
---

# Preview SCAD Skill

Renders an OpenSCAD 3D model (`.scad`) into high-resolution PNG preview images for visual inspection prior to STL export.

---

## 🔄 Agent Workflow & Tool Sequence

1. **Identify Target File & Preview Mode**:
   - Determine target `.scad` file path and required preview type (Single view, MultiView, or Highlight/Debug).

2. **Execute Multi-View Render Command (`run_command`)**:
   - Execute shared render script via PowerShell:
     - **Single Preview**:
       `powershell -ExecutionPolicy Bypass -File ai/shared/scripts/render-scad.ps1 -InputFile <path_to_model.scad>`
     - **Multi-View Preview (Iso, Side, Top, Bottom, Print Bed)**:
       `powershell -ExecutionPolicy Bypass -File ai/shared/scripts/render-scad.ps1 -InputFile <path_to_model.scad> -MultiView`
     - **Multi-View with Historical Archiving (e.g. Iteration 1, 2, ...)**:
       `powershell -ExecutionPolicy Bypass -File ai/shared/scripts/render-scad.ps1 -InputFile <path_to_model.scad> -MultiView -Iteration <N>`
     - **Highlight / Debug Preview (Requires `<name>.highlight.scad`)**:
       `powershell -ExecutionPolicy Bypass -File ai/shared/scripts/render-scad.ps1 -InputFile <path_to_model.scad> -Highlight -MultiView`

3. **Inspect Generated Previews (`view_file`)**:
   - Open generated PNG images using `view_file` for visual verification:
     - Isometric: `<folder>/model_preview_iso.png`
     - Top-down (Orthographic): `<folder>/model_preview_top.png`
     - Side: `<folder>/model_preview_side.png`
     - Print Bed: `<folder>/model_preview_print_bed.png`

4. **Visual Validation & Refinement**:
   - Inspect wall thickness symmetry, chamfer transitions, self-supporting overhangs ($\le 45^\circ$), and feature alignment.
   - If geometry defects exist, refine code and repeat steps 2 & 3.

---

## 🛠 Direct OpenSCAD CLI Fallback (Windows PowerShell)

If calling CLI directly without the helper script (using call operator `&` and `openscad.com`):
- **Isometric**: `& "C:\Program Files\OpenSCAD\openscad.com" --imgsize=800,600 --camera=0,0,0,60,0,315,200 -o <folder>\model_preview_iso.png <path_to_model.scad>`
- **Top-Down (Ortho)**: `& "C:\Program Files\OpenSCAD\openscad.com" --projection=ortho --autocenter --viewall --imgsize=800,600 --camera=0,0,0,0,0,0,200 -o <folder>\model_preview_top.png <path_to_model.scad>`
- **Side View**: `& "C:\Program Files\OpenSCAD\openscad.com" --imgsize=800,600 --camera=0,0,0,90,0,90,200 -o <folder>\model_preview_side.png <path_to_model.scad>`
- **Print Bed**: `& "C:\Program Files\OpenSCAD\openscad.com" --autocenter --viewall --imgsize=800,600 --camera=0,0,0,120,0,315,200 -o <folder>\model_preview_print_bed.png <path_to_model.scad>`
