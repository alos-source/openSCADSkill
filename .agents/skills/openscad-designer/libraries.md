# OpenSCAD Hardware & Standard Dimensions Library

Nutze die folgenden vordefinierten Variablen, Maße und Passungen als Standardwerte für deine OpenSCAD-Designs.

---

## 1. 3D-Druck Toleranzen & Passungen (Druckerspezifisch)

Verwende diese Additions-Werte für Aussparungen, Steckverbindungen und Bohrungen (FDM-Drucker Standard):

| Passungstyp | Zugabe auf Durchmesser/Maß | Anwendungsfall |
| :--- | :--- | :--- |
| **Presspassung (Tight Fit)** | `+ 0.15 mm` bis `+ 0.20 mm` | Bauteile, die zusammengedrückt werden und ohne Kleber halten sollen |
| **Schiebesitz (Medium Fit)** | `+ 0.30 mm` bis `+ 0.40 mm` | Bewegliche Teile, Schiebedeckel, Führungsschienen |
| **Freilauf / Spiel (Loose Fit)** | `+ 0.50 mm` bis `+ 0.60 mm` | Schraubeneinführungen, Kabeldurchführungen |

---

## 2. Standard-Metrische Schrauben & Muttern (DIN 912 / ISO 4762)

Maße in Millimetern ($mm$). *Hinweis: Alle Bohrungsdurchmesser enthalten bereits `+ 0.3 mm` Spiel für einfachen Durchgang.*

### M3 Hardware
* `M3_screw_radius = (3.0 + 0.3) / 2;` // 1.65 mm (Schraubenschaft)
* `M3_head_radius = (5.5 + 0.4) / 2;`  // 2.95 mm (Senkkopf/Zylinderkopf)
* `M3_head_height = 3.0;`
* `M3_nut_hex_clearence = 6.0;`          // Schlüsselweite Mutternaussparung (+ Spiel)
* `M3_nut_height = 2.4;`
* `M3_heatset_insert_radius = 2.1;`     // Für Voron/Ruthex Einschmelzmuttern (M3x5x4)

### M4 Hardware
* `M4_screw_radius = (4.0 + 0.3) / 2;` // 2.15 mm
* `M4_head_radius = (7.0 + 0.4) / 2;`  // 3.70 mm
* `M4_head_height = 4.0;`
* `M4_nut_hex_clearence = 7.8;`
* `M4_nut_height = 3.2;`

---

## 3. Elektronik & Single-Board Computers (SBCs)

### Raspberry Pi 4 Model B
```openscad
// Raspberry Pi 4 B - Befestigungslöcher (Rechteck-Muster)
rpi4_hole_pitch_x = 58.0;
rpi4_hole_pitch_y = 49.0;
rpi4_hole_radius = (2.7 + 0.3) / 2; // M2.5 Schrauben
rpi4_board_x = 85.0;
rpi4_board_y = 56.0;
rpi4_corner_radius = 3.0;

```

### ESP32 WROOM-32 DevKit v1 (30 Pins)
```openscad
esp32_board_x = 51.5;
esp32_board_y = 28.5;
esp32_hole_pitch_x = 45.0;
esp32_hole_pitch_y = 23.0;
esp32_hole_radius = (2.0 + 0.2) / 2;
```

4. Stepper-Motoren & Mechanik
NEMA 17 Schrittmotor

```openscad
nema17_width = 42.3;
nema17_hole_pitch = 31.0;          // Lochabstand (Quadrat)
nema17_hole_radius = (3.0 + 0.3) / 2; // M3
nema17_center_pilot_radius = 11.0; // Mittlere Erhöhung/Zentrierung (22mm Dia)
nema17_shaft_radius = 2.5;         // 5mm Welle
```

## 5. Standard-Anschlüsse & Aussparungen
// USB-C Aussparung (Kabelstecker-Toleranz)
usbc_cutout_width = 12.5;
usbc_cutout_height = 6.5;

// Wandstärken-Best-Practices (FDM)
wall_thickness_light = 1.6;  // 4 Wände bei 0.4mm Düse (für leichte Teile)
wall_thickness_std = 2.4;    // 6 Wände (Standard stabil)
wall_thickness_heavy = 3.2;  // Belastbare Strukturen