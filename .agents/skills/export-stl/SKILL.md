---
name: export-stl
description: Export a finalized .scad file to STL for 3D printing.
---

# Export STL

Use this skill once the preview looks correct and the design is ready to export.

## Workflow
1. Run the export script for the final `.scad` file.
2. Review the generated STL and any validation output.
3. Keep the output next to the project source file.

## Usage
- Run `ai/shared/scripts/export-stl.ps1 -InputFile <path>`.
- The output defaults to `<input>.stl`.
