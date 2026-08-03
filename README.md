# OpenSCAD Agent Skill Suite

An advanced agent skill suite for **Google Antigravity** that designs, validates, renders, and slices parametric 3D models using OpenSCAD and FDM Slicers (PrusaSlicer / OrcaSlicer CLI). Also includes a github agent skill.

---

## ✨ Key Features

- **🎨 Parametric 3D CAD Design**:
  - Writes clean, parameterized OpenSCAD code with native Customizer dropdown menus (`part`, `grip_pattern`, `d_size`).
  - Implements support-free FDM overhangs ($45^\circ$ chamfers) and multi-axis mating tolerances ($0.60\text{--}0.80\text{ mm}$).
- **🛡 Automated FDM Printability Auditor (`fdm-printability-auditor`)**:
  - Enforces the 6 FDM Audit Commandments (XYZ clearances, $Z \ge 0$, flat bed contact, anti-bridging cavity inversion, annular ring subtractions, through-holes).
  - Universal Boolean Part Collision & $15\text{ mm}$ Separation Gap Audit (`intersection() == empty`).
- **🔪 Real-Time Slicer CLI Integration**:
  - Headless execution with **PrusaSlicer CLI** / **OrcaSlicer CLI** to extract empirical print duration, filament mass, first-layer time, and 0% support volume confirmation.
  - Automatically records empirical print metrics in `model_log.json` and `README.md`.
- **📸 Headless Multi-View Rendering & Archiving**:
  - Generates multi-angle previews (`iso`, `side`, `top`, `bottom`, `print_bed`, `#debug section`) via OpenSCAD CLI.
  - Automatically archives iteration snapshots under `history/iter_N/`.

---

## 📂 Repository Structure

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

## 🛠 System Requirements & Setup

1. **OpenSCAD**: Installed and accessible in PATH or at `C:\Program Files\OpenSCAD\openscad.com`.
2. **Slicer CLI (Optional for Empirical Metrics)**: PrusaSlicer CLI installed at `C:\Program Files\Tools\PrusaSlicer\prusa-slicer-console.exe` (or system PATH).
3. **Installation**: Copy `.agents/` and `ai/` into your Antigravity workspace root.

---

## 🚀 Usage Commands

Prompt Antigravity directly or use slash commands:

```bash
# Create a new parametric 3D model
/openscad-designer Create a 2-part self-draining FDM soap holder

# Run an FDM printability audit
/fdm-printability-auditor Check models/soap-holder/gemini/model.scad for printability

# Export binary STL for 3D printing
/export-stl Export models/soap-holder/gemini/model.scad
```