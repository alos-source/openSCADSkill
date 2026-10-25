# Specification: Philips Hue Smart Button (Gen 2) Base for German Light Switches

## 1. Objective and Function
Design a 3D-printable base plate / adapter for the **Philips Hue Smart Button (Second Version / Gen 2)** that seamlessly integrates into German domestic light switch installations.

The Hue Smart Button v2 has a circular form factor with an outer diameter of 45 mm (enlarged from the 32 mm v1) and an internal permanent magnet. This base plate provides a secure seat for the button and embeds ferromagnetic material (such as a standard DIN 9021 M8 steel washer or steel disc) so the button snaps magnetically into place with satisfying retention.

## 2. Mounting Formats (German Switch Standards)
German light switches follow standard formats defined by DIN 49073:
1. **System 55 Insert (`plate_type = "system55"`):**
   - Fits standard 55x55 mm switch frames (Gira System 55 / E2 / Standard 55, Jung AS 500 / A 500, Merten System M, Berker S.1 / B.3 / Q.1).
   - Outer dimensions: 54.7 mm × 54.7 mm (0.3 mm clearance against 55.0 mm frame).
   - Thickness: 6.0 mm.
   - Corner radius: 2.0 mm with 0.8 mm top rim chamfer.
2. **Full Frame Wall Plate (`plate_type = "full_frame"`):**
   - Replaces the entire switch frame or covers an existing flush-mount wall box (Unterputzdose Ø68 mm).
   - Outer dimensions: 80.0 mm × 80.0 mm (standard single frame DIN dimensions, adjustable up to 85 mm).
   - Thickness: 6.0 mm with beveled edges.
   - Mounting: Standard DIN 49073 screw hole pattern (60.0 mm center-to-center hole spacing, horizontal and vertical pairs).
   - Countersunk holes for standard 3.0 / 3.2 / 3.5 mm electrical box screws.
   - Rear wire clearance cavity (Ø54 mm × 2.5 mm) for WAGO terminals or recessed flush box clearance.

## 3. Button Interface & Tolerances
- **Hue Smart Button v2 Outer Diameter:** 45.0 mm.
- **Seat Recess Diameter:** 45.5 mm (0.5 mm diametrical clearance).
- **Seat Recess Depth:** 2.5 mm (allows secure tactile placement while leaving 10.5 mm of the 13 mm button accessible).
- **Ergonomic Pry Notches:** Two opposing fingernail scallops (radius 3.5 mm, depth 1.6 mm) for easy finger removal when changing the CR2032 battery.

## 4. Annular Pocket & Central Support Post Architecture
- **Standard Insert:** DIN 9021 M8 large washer (Outer Diameter: 24.0 mm, Inner Hole: 8.4 mm, Thickness: 2.0 mm).
- **Annular Ring Pocket:**
  - Outer Diameter: 24.8 mm (0.8 mm diametrical clearance).
  - Depth: 2.2 mm (0.2 mm clearance above washer).
  - **Integrated Solid Central Post:** $\varnothing 8.0\text{ mm}$ solid central column connects the bottom floor directly to the ceiling.
  - **Bridging Span Reduction:** Reduces unsupported bridging distance from $24.8\text{ mm}$ down to $(24.8 - 8.0)/2 = \mathbf{8.4\text{ mm}}$.
  - **Washer Auto-Centering:** Prevents the washer from shifting or sliding off-center during insertion.
  - **Mechanical Rigidity:** Supports the central button click pressure directly to the wall without flexing the plastic skin.

## 5. 3D Printing & Manufacturing Guidelines
- **Orientation:** Base flat on build plate ($Z = 0$), no supports needed.
- **Elephant Foot Mitigation:** 0.6 mm 45° chamfer on bottom outer perimeter.
- **Pause-at-Height:** Pause at $Z = 2.80\text{ mm}$ (Layer 14 at 0.20 mm layer height), drop M8 washer over central post, resume to seal.
