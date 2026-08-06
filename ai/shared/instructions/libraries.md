# OpenSCAD Hardware & Standard Dimensions Library

Use these reference values as a basis for OpenSCAD designs, enclosure cutouts, and mechanical components.

---

## 1. 3D Printing Tolerances & Fits

These values are intended as a starting point for FDM printers. Adjust them based on material, printer, and calibration.

| Fit type | Diameter/size allowance | Use case |
| :--- | :--- | :--- |
| **Press fit (Tight Fit)** | `+ 0.15 mm` to `+ 0.20 mm` | Interlocking parts, tightly fitted components |
| **Sliding fit (Medium Fit)** | `+ 0.30 mm` to `+ 0.40 mm` | Moving parts, sliders, guides |
| **Clearance fit (Loose Fit)** | `+ 0.50 mm` to `+ 0.60 mm` | Holes, cable passages, loose fits |

---

## 2. Standard Metric Screws & Nuts

Dimensions are in millimeters. All hole diameters already include `+ 0.3 mm` clearance for easy assembly.

### M3 Hardware
```openscad
M3_screw_radius          = (3.0 + 0.3) / 2;   // 1.65 mm shaft
M3_head_radius           = (5.5 + 0.4) / 2;   // 2.95 mm head
M3_head_height           = 3.0;
M3_nut_hex_clearance     = 6.0;               // wrench size + clearance
M3_nut_height            = 2.4;
M3_heatset_insert_radius = 2.1;               // heat-set insert M3x5x4
```

### M4 Hardware
```openscad
M4_screw_radius      = (4.0 + 0.3) / 2;   // 2.15 mm shaft
M4_head_radius       = (7.0 + 0.4) / 2;   // 3.70 mm head
M4_head_height       = 4.0;
M4_nut_hex_clearance = 7.8;
M4_nut_height        = 3.2;
```

---

## 3. Electronics & Single-Board Computers (SBC)

### Raspberry Pi 4 Model B
```openscad
// Raspberry Pi 4 B mounting holes
rpi4_hole_pitch_x  = 58.0;
rpi4_hole_pitch_y  = 49.0;
rpi4_hole_radius   = (2.7 + 0.3) / 2; // M2.5 screws
rpi4_board_x       = 85.0;
rpi4_board_y       = 56.0;
rpi4_corner_radius = 3.0;
```

### ESP32 WROOM-32 DevKit v1 (30 pins)
```openscad
esp32_board_x      = 51.5;
esp32_board_y      = 28.5;
esp32_hole_pitch_x = 45.0;
esp32_hole_pitch_y = 23.0;
esp32_hole_radius  = (2.0 + 0.2) / 2;
```

---

## 4. Stepper Motors & Mechanics

### NEMA 17 Stepper Motor
```openscad
nema17_width               = 42.3;
nema17_hole_pitch          = 31.0;           // square hole spacing
nema17_hole_radius         = (3.0 + 0.3) / 2; // M3
nema17_center_pilot_radius = 11.0;           // pilot diameter 22 mm
nema17_shaft_radius        = 2.5;            // 5 mm shaft
```

---

## 5. Standard Connectors & Cutouts

```openscad
// USB-C cutout
usbc_cutout_width  = 12.5;
usbc_cutout_height = 6.5;

// Wall thickness guidelines for FDM
wall_thickness_light = 1.6;  // 4 walls with 0.4 mm nozzle
wall_thickness_std   = 2.4;  // 6 walls (standard)
wall_thickness_heavy = 3.2;  // high stress
```

---

## 6. Shared OpenSCAD 3D Library & Housing Workflow

The SCAD libraries under `ai/shared/scad/lib/` include standardized generators for enclosures, PCB mockups, and connector cutouts.

- `include <../../ai/shared/scad/lib/boards.scad>` (RPi 4, WEMOS D1 Mini, ESP32)
- `include <../../ai/shared/scad/lib/connectors.scad>` (USB-C, Micro-USB, HDMI, RJ45)
- `include <../../ai/shared/scad/lib/fasteners.scad>` (standoffs, heat-set insert bosses)

### Example: Enclosure with Board Integration
```openscad
include <../../ai/shared/scad/lib/boards.scad>

difference() {
    union() {
        // 1. enclosure base / lower shell
        cube([95, 66, 25]);
        // 2. place PCB standoffs at board mounting holes
        translate([5, 5, 2])
            rpi4_b_mounting_hole_coords()
                pcb_standoff(height=5.0, inner_r=1.35);
    }
    // 3. subtract port cutouts
    translate([5, 5, 7])
        rpi4_b_cutout(margin=0.4, tunnel_length=20);
}

// 4. show the debug mockup
#translate([5, 5, 7])
    rpi4_b_mockup(show_components=true);
```

