---
name: openscad-designer
description: Creates, validates, renders, and slices parametric 3D models with OpenSCAD. Saves each model in its dedicated subfolder and executes FDM printability audits.
---

# OpenSCAD Expert & Slicing-Aware Designer Skill

You are an expert in parametric 3D design and FDM 3D printing using OpenSCAD. Your goal is to create clean, 100% printable, structurally sound, and support-free `.scad` files.

---

## 📚 References & Core Instructions

- **FDM Printability Quality Gate**: Before finalizing any code, you MUST execute the quality gate defined in `.agents/skills/fdm-printability-auditor/SKILL.md`.
- **Workflow & Rules**: Always follow the modeling rules and Customizer standards defined in `ai/shared/instructions/openscad-workflow.md`.
- **Hardware & Dimensions**: Read `ai/shared/instructions/libraries.md` for standard hardware tolerances (M3, M4, M8, ESP32, bearings).

---

## 🛠 Prerequisites & System CLI

- Assume OpenSCAD is installed on the system.
- If `openscad` is not in the system PATH, use the absolute path:
  - **Windows**: `& "C:\Program Files\OpenSCAD\openscad.com"` (use `openscad.com` for synchronous CLI calls).
  - **macOS**: `/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD`
  - **Linux**: `/usr/bin/openscad`
- **Slicer CLI Engine (Optional for Empirical Metrics)**:
  - Dynamically detect available Slicers on PATH (`prusa-slicer-console`, `prusa-slicer`, `orca-slicer`, `bambu-studio`, `curaengine`).
  - Common fallback paths:
    - **Windows**: `"C:\Program Files\Prusa3D\PrusaSlicer\prusa-slicer-console.exe"`, `"C:\Program Files\Tools\PrusaSlicer\prusa-slicer-console.exe"`, `"C:\Program Files\OrcaSlicer\orca-slicer.exe"`
    - **macOS**: `/Applications/PrusaSlicer.app/Contents/MacOS/PrusaSlicer`
    - **Linux**: `/usr/bin/prusa-slicer`
  - *Note*: If no Slicer CLI is detected, skip Slicer pass and perform the 100% verified OpenSCAD CSG Render Audit.

---

## 🔄 Execution Workflow & Render Loop

When the user requests a 3D model:

1. **Create Project Directory Structure**:
   - Choose a concise project name (e.g. `soap-holder`).
   - Write all output files into the models subfolder `models/<project_name>/gemini/`:
     ```
     models/
     └── <project_name>/
         └── gemini/       ← active agent output directory
     ```

2. **Generate Parametric Code (`model.scad`)**:
   - Create `<project_folder>/gemini/model.scad` with all key dimensions, tolerances, and part selectors parameterized near the top.
   - Use dynamic resolution via `$preview` for fast rendering:
     ```scad
     $fn = $preview ? 32 : 64;
     ```
   - Standardize Render Mode Selector:
     ```scad
     /* [Render Mode & Part Selector] */
     part = "all"; // ["all": Assembled View, "part1": Part 1 Only, "print_bed": Both Parts Flat on Z=0, "exploded": Exploded View]
     ```
   - Include header metadata:
     ```scad
     // AI Agent: openscad-designer (Gemini 3.6 Flash)
     // Project: <project_folder>
     // Date: YYYY-MM-DD
     // User Verification Checklist
     // - Geometry reviewed manually: [ ]
     // - Render checked in OpenSCAD: [ ]
     // - Printed successfully: [ ]
     ```

3. **Execute FDM Printability Audit**:
   - Follow the 6 commandments in `.agents/skills/fdm-printability-auditor/SKILL.md`:
     1. Multi-Axis Clearance (0.60–0.80mm sliding fit).
     2. Z-Bound Safety ($Z \ge 0$).
     3. 100% Flat Bed Contact.
     4. Per-Part Optimal Orientation & Universal Disjointness Collision Audit (`part == "print_bed"`).
     5. Annular Ring Subtractions.
     6. Full-Pass Through-Holes.

4. **Multi-View Rendering & Historical Archiving**:
   - Execute multi-view render script:
     ```powershell
     powershell -ExecutionPolicy Bypass -File ai/shared/scripts/render-scad.ps1 -InputFile <project_folder>/gemini/model.scad -MultiView -Iteration <N>
     ```
   - Render print bed layout preview:
     ```powershell
     & "C:\Program Files\OpenSCAD\openscad.com" -D 'part="\"print_bed\""' --autocenter --viewall --imgsize=800,600 --camera=0,0,0,120,0,315,200 -o <project_folder>/gemini/model_preview_print_bed.png <project_folder>/gemini/model.scad
     ```
   - Perform cross-section debug render with `#` highlights if hidden internal geometry exists.

5. **Visual Validation**:
   - Inspect `model_preview_iso.png`, `model_preview_top.png`, `model_preview_print_bed.png`, and `model_preview_debug.png`.
   - Verify zero collisions, 100% flat bed contact, self-supporting overhangs ($\le 45^\circ$), and $15\text{ mm}$ inter-part clearance gaps.

6. **Export Binary STL File**:
   - Export printable STL with `-D 'part="\"print_bed\""'`:
     ```powershell
     & "C:\Program Files\OpenSCAD\openscad.com" -D 'part="\"print_bed\""' --export-format binstl -o <project_folder>/gemini/model.stl <project_folder>/gemini/model.scad
     ```

7. **PrusaSlicer CLI Empirical Validation**:
   - Execute headless slicing on exported STL:
     ```powershell
     & "C:\Program Files\Tools\PrusaSlicer\prusa-slicer-console.exe" --export-gcode --info <project_folder>/gemini/model.stl
     ```
   - Parse `model.gcode` for `estimated printing time`, `filament used [cm3]`, `support_material = 0`, and `manifold = yes`.

8. **Documentation & Logging**:
   - **`model_log.json`**: Record prompt, execution time, iterations, and `"slicer_metrics"` object.
   - **`README.md`**: Create human-readable summary with render previews, PrusaSlicer print metrics table, and recommended 3D print settings.