# OpenSCAD Agent Skill Suite

An advanced agent skill suite for **Google Antigravity** that designs, validates, renders, and slices parametric 3D models using OpenSCAD and FDM Slicers (PrusaSlicer / OrcaSlicer CLI). Also includes a github agent skill.

---

## Key Features

- **Parametric 3D CAD Design**:
  - Writes clean, parameterized OpenSCAD code with native Customizer dropdown menus (`part`, `grip_pattern`, `d_size`).
  - Implements support-free FDM overhangs ($45^\circ$ chamfers) and multi-axis mating tolerances ($0.60\text{--}0.80\text{ mm}$).
- **Automated FDM Printability Auditor (`fdm-printability-auditor`)**:
  - Enforces the 6 FDM Audit Commandments (XYZ clearances, $Z \ge 0$, flat bed contact, anti-bridging cavity inversion, annular ring subtractions, through-holes).
  - Universal Boolean Part Collision & $15\text{ mm}$ Separation Gap Audit (`intersection() == empty`).
- **Real-Time Slicer CLI Integration**:
  - Headless execution with **PrusaSlicer CLI** / **OrcaSlicer CLI** to extract empirical print duration, filament mass, first-layer time, and 0% support volume confirmation.
  - Automatically records empirical print metrics in `model_log.json` and `README.md`.
- **Headless Multi-View Rendering & Archiving**:
  - Generates multi-angle previews (`iso`, `side`, `top`, `bottom`, `print_bed`, `#debug section`) via OpenSCAD CLI.
  - Automatically archives iteration snapshots under `history/iter_N/`.

---

## Repository Structure

```
openSCADSkill/
├── .agents/
│   ├── AGENTS.md                   # Workspace rules & right-handed coordinate conventions
│   └── skills/
│       ├── openscad-designer/       # Core CAD creation & render loop skill
│       ├── fdm-printability-auditor/ # 6-Commandment FDM printability & collision auditor
│       ├── preview-scad/            # Headless multi-view CLI preview renderer
│       ├── export-stl/              # Binary STL export skill
│       └── validate-model/          # Model validation checklist skill
├── ai/
│   └── shared/
│       ├── instructions/            # Universal FDM & CSG modeling rules
│       └── scripts/                 # PowerShell render-scad.ps1 multi-view script
├── models/                          # Central output directory for generated 3D models (.gitignore)
└── README.md
```

---

## System Requirements & Setup

1. **OpenSCAD**: Installed and accessible in PATH or at `C:\Program Files\OpenSCAD\openscad.com`.
2. **Slicer CLI (Optional for Empirical Metrics)**: PrusaSlicer CLI installed at `C:\Program Files\Tools\PrusaSlicer\prusa-slicer-console.exe` (or system PATH).
3. **Installation**: Copy `.agents/` and `ai/` into your Antigravity workspace root.

## Tested Runtime Environment

This README and the included scripts were validated on:
- `Windows 11`
- `Google Antigravity`
- `Cura` for STL preview and print-ready visualization

> The code is intended to be portable and should work on other configurations that provide a compatible OpenSCAD installation, a PowerShell-capable shell, and a supported slicer CLI. If you use Linux, macOS, or a different slicer, verify your OpenSCAD path and adjust the script commands as needed.
>
> For agent-driven workflows, the same model generation and validation approach should work with other systems such as `Claude` or `GitHub Copilot`. When testing there, validate:
> - prompt fidelity for OpenSCAD-specific instructions
> - script execution environment and installed CLI paths
> - local file placement under `.agents/` and `ai/shared/`
> - whether preview/export commands need shell or path adjustments

---

## What OpenSCAD Is Good For — and What It's Not

OpenSCAD excels at programmatic, parameterized, and geometry-first CAD where precise measurements and repeatability matter. It is script-driven (CSG-based) rather than a direct interactive modeller. The short guidance below helps set realistic expectations and points to alternatives when OpenSCAD is not the best fit.

Good use-cases:

- Parametric designs where dimensions are driven by variables (mounts, enclosures, brackets).
- Constructive Solid Geometry (CSG) workflows: boolean-based parts, cutouts, standoffs, and mounting features.
- Mechanical parts with strict dimensional requirements (fastener holes, press fits, sliding fits).
- Repetitive or programmatic patterns (arrays, gears, teeth, lattice generators written as code).
- Quick prototypes where reproducibility and easy parameter tuning are priorities.

Not ideal for OpenSCAD:

- Organic, sculpted, or free-form shapes (characters, complex ergonomic surfaces).
- High-detail mesh editing or repairing existing STL meshes (use MeshLab, Blender, or Meshmixer).
- Interactive modelling and sculpting workflows that require direct manipulation (use Blender or ZBrush).
- NURBS-based surfacing and advanced CAD features expected from parametric solid modellers (use FreeCAD, Fusion 360, or Rhino).

If your project requires organic forms or mesh-heavy sculpting, model in a dedicated tool and export/import as meshes where needed. For precision mechanical assemblies with repeatable variants, OpenSCAD remains a strong choice.

---

## Usage Commands

Prompt Antigravity directly or use slash commands:

```bash
# Create a new parametric 3D model
/openscad-designer Create a 2-part self-draining FDM soap holder

# Run an FDM printability audit
/fdm-printability-auditor Check models/soap-holder/gemini/model.scad for printability

# Export binary STL for 3D printing
/export-stl Export models/soap-holder/gemini/model.scad
```
## Result Example
Here's an example for the prompt:

```
design a Housing for ESP32-C3 Boards
```

The fully generated model.scad in OpenSCAD (in Exploded View):
![OpenSCAD exploded view](media/OpenSCAD_Model.png)
Parameters for customization on the right tab, model code on the left.

The model.stl in CURA (ready to print):
![CURA ready-to-print view](media/Cura_Model.png)
