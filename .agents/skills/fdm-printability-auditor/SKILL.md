---
name: fdm-printability-auditor
description: Automated pre-render and pre-export FDM printability audit for OpenSCAD models. Verifies 3D multi-axis clearances, Z-bound safety, bed-facing surface flatness, per-part print orientation, annular post subtractions, and support-free overhangs.
---

# FDM Printability Auditor

Use this skill before finalizing code, rendering preview images, or exporting STL files for any 3D printable OpenSCAD model. This skill acts as a strict automated FDM quality gate to prevent printing failures, binding parts, ungrounded overhangs, and bed adhesion issues.

---

## 📋 The 6 FDM Audit Checklist

Perform these 6 mandatory audits on every `.scad` model file before generating final previews or STL exports:

### 1. Multi-Axis Mating Clearances (XYZ)
- **Cylindrical Sliding Fits ($d > 20\text{ mm}$)**: Ensure a minimum **$0.60\text{--}0.80\text{ mm}$ diametrical clearance** between inner ID and outer OD (`cap_id = base_od + 0.80`).
- **Key & Slot Interlocking Joints**: Verify clearances in **ALL 3 active axes** simultaneously:
  - **Slot Width ($Y$)**: Minimum $+1.2\text{--}1.6\text{ mm}$ total clearance over key width.
  - **Radial Depth ($X$)**: Slot depth cut must extend $\ge 0.8\text{ mm}$ deeper than the key radial protrusion (`slot_outer_r >= key_outer_r + 0.8`).
  - **Vertical Slide ($Z$)**: Slot height must span full skirt height (`skirt_h + 0.2`).
- **Central Alignment Pins & Screws**: Central pin clearance holes in caps must have $\ge 0.80\text{--}1.0\text{ mm}$ diametrical gap.

### 2. Z-Bound Safety ($Z \ge 0$)
- Verify that **NO geometry extends into negative $Z$ space** below $Z = 0$.
- After any 2D polygon extrusion or 3D rotation (`rotate([rx, ry, rz])`), verify that the minimum $Z$-bounding box coordinate satisfies $Z_{min} \ge 0$.

### 3. Bed-Facing Surface Flatness (`part == "print_bed"`)
- In `part == "print_bed"`, resting faces on $Z = 0$ MUST be **$100\%$ flat**.
- Any punch lead-in funnels, text labels, collars, studs, or bosses on the bed-facing side MUST be **recessed/countersunk into the body** rather than protruding past $Z = 0$.

### 4. Per-Part Print Orientation & Universal Collision Audit (`part == "print_bed"`)
- Do NOT simply layout parts in their assembly orientation.
- For **EVERY individual part** in `part == "print_bed"`, evaluate its geometry and apply an independent rotation (`rotate([rx, ry, rz])`) to ensure:
  - **Largest Flat Face on $Z = 0$**: Maximum bed contact for zero warping.
  - **Cavity Inversion (Anti-Bridging Rule)**: Any part with an open hollow underside/cavity MUST be rotated $180^\circ$ so the cavity faces UP into open space, eliminating internal bridging ceilings and supports.
  - **PEI Surface Finish**: Debossed text/scales lie flat against the build plate.
- **Universal Collision & Disjointness Audit (CRITICAL)**:
  - The $X$ and $Y$ spatial Extents $[X_{min} \dots X_{max}]$ and $[Y_{min} \dots Y_{max}]$ of all parts on the print bed MUST be strictly disjoint!
  - **Zero Collision Guarantee**: For any two parts `part1` and `part2` placed on the print bed, the OpenSCAD CSG boolean intersection `intersection() { part1(); part2(); }` MUST result in an empty volume (zero CSG collision).
  - **$10\text{--}15\text{ mm}$ Separation Gap**: All parts must be separated by a minimum **$10\text{--}15\text{ mm}$ clearance gap** ($Y_{2,min} \ge Y_{1,max} + 10.0\text{ mm}$ or $X_{2,min} \ge X_{1,max} + 10.0\text{ mm}$) regardless of rotation transformations.

### 5. Annular Ring Subtractions around Shafts
- Recessed pockets or channels surrounding a central alignment pin or shaft MUST be subtracted as **hollow annular rings**:
  ```scad
  // Correct annular ring cutout preserving central pin
  translate([0, 0, base_h - pocket_h])
      difference() {
          cylinder(d = pocket_dia, h = pocket_h + 0.1);
          translate([0, 0, -0.1])
              cylinder(d = pin_dia + 0.4, h = pocket_h + 0.3);
      }
  ```
- NEVER subtract a solid cylinder at $R \le pocket\_radius$ from a base containing a central pin!

### 6. Full-Pass Through-Holes & Channels
- Through-holes, punch channels, wire slots, and ejection notches MUST pass completely through the parent body from $Z = -0.1$ to $Z = h + 0.1$ (or beyond) to prevent thin accidental end-caps.

---

## 🔍 Visual Inspection & Debug Sectioning

To verify hidden internal geometries and clearances before export:

1. **Debug Highlight Render**:
   - Create a temporary `debug.scad` file highlighting key subtractions with `#`:
     ```scad
     include <model.scad>
     #jig_base();
     ```
   - Render `model_preview_debug.png` and verify that all internal channels are open and clear.

2. **Cross-Section Slice View**:
   - Temporarily slice the assembled model in half using `intersection()` to verify internal clearances:
     ```scad
     intersection() {
         model();
         translate([0, -50, -10]) cube([100, 100, 100]);
     }
     ```

---

## 🔪 Slicer CLI / API Automated Evaluation

When a 3D slicer (PrusaSlicer, OrcaSlicer, Bambu Studio, or CuraEngine) is installed on the system, the auditor can invoke headless CLI slicing on `model.stl` to extract empirical printability metrics:

### 1. Universal Slicer CLI Resolution & Commands

The auditor attempts to resolve the Slicer CLI binary from PATH (`prusa-slicer-console`, `prusa-slicer`, `orca-slicer`, `bambu-studio`, `curaengine`) or standard system installation locations:

- **PrusaSlicer / SuperSlicer / Slic3r**:
  - Command: `prusa-slicer-console --export-gcode --support-material --info model.stl`
  - Windows paths: `"C:\Program Files\Prusa3D\PrusaSlicer\prusa-slicer-console.exe"`, `"C:\Program Files\Tools\PrusaSlicer\prusa-slicer-console.exe"`
  - macOS path: `/Applications/PrusaSlicer.app/Contents/MacOS/PrusaSlicer`
  - Linux path: `/usr/bin/prusa-slicer`
- **OrcaSlicer / Bambu Studio CLI**:
  - Command: `orca-slicer --slice 0 --outputdir ./ model.stl`
  - Windows path: `"C:\Program Files\OrcaSlicer\orca-slicer.exe"`
- **CuraEngine CLI**:
  - Command: `CuraEngine slice -l model.stl -o model.gcode`
  - Windows path: `"C:\Program Files\UltiMaker Cura\CuraEngine.exe"`

### 2. Automated Slicer Audit Metrics

When slicing completes, parse the G-code header/footer comments to evaluate 4 mandatory metrics:

1. **Support-Free Validation Gate (`support_volume == 0`)**:
   - Parse `; total support material volume [mm3]` or `; support material = ...`
   - If support volume $> 0\text{ mm}^3$, flag model as requiring supports and recommend $45^\circ$ chamfering or part inversion!
2. **Print Duration Estimation**:
   - Parse `; estimated printing time = Xh Ym Zs` for exact user print time reporting.
3. **Filament Consumption**:
   - Parse `; filament used [g] = X.XX` for material mass cost estimation.
4. **First Layer Contact Area**:
   - Parse first layer perimeter extents to verify solid $Z = 0$ bed contact.

---

## 🚀 Execution Workflow

1. Perform code self-audit against the 6 FDM Checklists above.
2. Render multi-view preview images (`iso`, `side`, `top`, `bottom`, `print_bed`).
3. Verify that `model_preview_print_bed.png` displays all parts flat on $Z = 0$ with 0 overhang issues.
4. Export finalized binary STL via `openscad --export-format binstl -o model.stl model.scad`.
5. *(Optional Slicer Pass)*: If PrusaSlicer/OrcaSlicer CLI is detected, slice `model.stl` headlessly and parse G-code for 0% support volume confirmation, exact print time, and filament weight.
