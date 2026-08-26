/* ====================================================================
   Parametrische GoPro 9/10/11/12 Akku-Box mit Schiebedeckel & SD-Slots
   ====================================================================
   Author: OpenSCAD Designer
   Suitable for: GoPro HERO 9, 10, 11, 12 Enduro & Standard Batteries
   Fix: MicroSD-Kollisionsschutz & Ergonomische SD-Finger-Notches
   - MicroSD-Schacht-Tiefe = 15.0 mm (exakt bündig mit der Unterkante des Schiebedeckels)
   - Deckel schließt 100% kollisionsfrei ohne anzustoßen
   - Front- & Rückseiten-Finger-Notches ermöglichen einfaches Greifen der SD-Karten
   ==================================================================== */

// --- DARSTELLUNGS-MODUS ---
// "assembled": Komplett montiert (Vorschau)
// "exploded": Explosionsteil (Deckel angehoben)
// "box": Nur das Unterteil (für Slicing)
// "lid": Nur der Deckel (für Slicing)
// "print_bed": Unterteil & Deckel nebeneinander flach auf Z=0 (Druckbereit!)
render_mode = "assembled"; // ["assembled", "exploded", "box", "lid", "print_bed"]

// --- PARAMETER AKKU & BOX ---
num_batteries    = 3;    // Anzahl der Akku-Fächer (z.B. 2, 3, 4)
include_sd_slots = true; // MicroSD-Kartenfächer integrieren?

// GoPro 9/10/11/12 Akku-Abmessungen (in mm)
bat_width  = 34.0;  // X-Breite des Akkus
bat_depth  = 15.3;  // Y-Tiefe des Akkus
bat_height = 40.8;  // Z-Höhe des Akkus

// Toleranzen & Wandstärken
clearance_xy   = 0.5;   // Spiel seitlich (mm pro Seite)
clearance_z    = 1.8;   // Extra Höhenspiel für die Textil-Zuglasche oben
wall_thickness = 2.4;   // Außenwandstärke (stabile 6 Wände bei 0.4mm Düse)
divider_wall   = 1.6;   // Trennwand-Stärke zwischen Akkus
bottom_thick   = 2.0;   // Bodenstärke
end_stop_wall  = 2.0;   // Anschlagwand am Ende des Schiebedeckels

// Hexagonal-Deckel Parameter
h_chamfer      = 1.4;   // Höhe der 45°-Fase (oben & unten)
h_mid          = 1.0;   // Höhe des geraden Mittelstegs der Schiene
rail_depth     = 1.4;   // Nut-Tiefe im Gehäuse (mm pro Seite)
snap_size      = 0.6;   // Rastnasen-Vorsprung für Snap-Lock

lid_h          = 2 * h_chamfer + h_mid; // Gesamtdeckelhöhe = 3.8mm

// $fn für runde Formen
$fn = 48;

// --- BERECHNETE MASSE ---
slot_w = bat_width + 2 * clearance_xy;
slot_d = bat_depth + 2 * clearance_xy;
slot_h = bat_height + clearance_z;

// MicroSD Slot Maße (Standard MicroSD: 15x11x1 mm)
// Kartentiefe = 15.0 mm (schließt exakt an Schiebedeckel-Unterkante ab!)
sd_w = 12.0;
sd_d = 2.2;
sd_h = 15.0; 
num_sd = include_sd_slots ? 3 : 0;
sd_section_w = num_sd > 0 ? (sd_w + 3.0) : 0;

// Innere Gesamtmaße der Box
inner_box_w = (num_batteries * slot_w) + ((num_batteries - 1) * divider_wall) + (num_sd > 0 ? (sd_section_w + divider_wall) : 0);
inner_box_d = slot_d;

// Äußere Gesamtmaße
outer_box_w = inner_box_w + wall_thickness + end_stop_wall;
outer_box_d = inner_box_d + 2 * wall_thickness;
outer_box_h = bottom_thick + slot_h + lid_h;

corner_r = 3.0; // Radius der Außenecken

// --- HAUPTAUSFÜHRUNG ---
if (render_mode == "assembled") {
    box_body();
    translate([0, 0, outer_box_h - lid_h])
        sliding_lid();
} else if (render_mode == "exploded") {
    box_body();
    translate([0, 0, outer_box_h + 18])
        sliding_lid();
} else if (render_mode == "box") {
    box_body();
} else if (render_mode == "lid") {
    sliding_lid();
} else if (render_mode == "print_bed") {
    // 1. Unterteil flach auf Z=0
    box_body();
    
    // 2. Deckel aufrecht flach auf Z=0 nebeneinander mit 12mm Abstand
    gap = 12.0;
    translate([0, outer_box_d + gap, 0])
        sliding_lid();
}

// ====================================================================
// MODULE: Unterteil (Box Body)
// ====================================================================
module box_body() {
    difference() {
        // 1. Außenkörper mit verrundeten Ecken
        rounded_cube([outer_box_w, outer_box_d, outer_box_h], r=corner_r);

        // 2. Akku-Fächer ausschneiden
        for (i = [0 : num_batteries - 1]) {
            x_pos = wall_thickness + i * (slot_w + divider_wall);
            translate([x_pos, wall_thickness, bottom_thick]) {
                cube([slot_w, slot_d, slot_h + 10]);
            }
        }

        // 3. MicroSD Fächer (15mm Schachttiefe für kollisionsfreies Schließen)
        if (num_sd > 0) {
            sd_x_start = wall_thickness + num_batteries * (slot_w + divider_wall);
            for (j = [0 : num_sd - 1]) {
                sd_y_pos = wall_thickness + (slot_d - (num_sd * sd_d + (num_sd - 1) * 1.5)) / 2 + j * (sd_d + 1.5);
                translate([sd_x_start + (sd_section_w - sd_w)/2, sd_y_pos, outer_box_h - lid_h - sd_h]) {
                    cube([sd_w, sd_d, sd_h]);
                }
            }

            // Ergonomische Finger-Notch für SD-Karten (Vorder- & Rückseite)
            sd_center_x = sd_x_start + sd_section_w / 2;
            translate([sd_center_x, -0.1, outer_box_h - lid_h - 8.0])
                finger_cutout_shape(w=10, depth=10, wall=wall_thickness + 0.5);
            translate([sd_center_x, outer_box_d - wall_thickness - 0.4, outer_box_h - lid_h - 8.0])
                finger_cutout_shape(w=10, depth=10, wall=wall_thickness + 0.5);
        }

        // 4. Ergonomische Finger-Greif-Aussparungen für Akkus (20mm Tiefe)
        for (i = [0 : num_batteries - 1]) {
            center_x = wall_thickness + i * (slot_w + divider_wall) + slot_w / 2;
            cutout_depth = 20.0;
            
            // Vorne (Y = 0)
            translate([center_x, -0.1, outer_box_h - cutout_depth])
                finger_cutout_shape(w=16, depth=cutout_depth, wall=wall_thickness + 0.5);

            // Hinten (Y = outer_box_d)
            translate([center_x, outer_box_d - wall_thickness - 0.4, outer_box_h - cutout_depth])
                finger_cutout_shape(w=16, depth=cutout_depth, wall=wall_thickness + 0.5);
        }

        // 5. Hexagonale Trapez-Führungsschiene
        rotate([90, 0, 90])
            linear_extrude(height = outer_box_w - end_stop_wall + 0.1)
                polygon(points=[
                    [wall_thickness, outer_box_h - lid_h - 0.1],
                    [wall_thickness - rail_depth, outer_box_h - lid_h + h_chamfer],
                    [wall_thickness - rail_depth, outer_box_h - h_chamfer],
                    [wall_thickness, outer_box_h + 0.1],
                    [outer_box_d - wall_thickness, outer_box_h + 0.1],
                    [outer_box_d - wall_thickness + rail_depth, outer_box_h - h_chamfer],
                    [outer_box_d - wall_thickness + rail_depth, outer_box_h - lid_h + h_chamfer],
                    [outer_box_d - wall_thickness, outer_box_h - lid_h - 0.1]
                ]);

        // 6. Snap-Lock Vertiefung in der oberen 45°-Nutdecke
        translate([outer_box_w - end_stop_wall - 6.0, outer_box_d / 2, outer_box_h - h_chamfer]) {
            sphere(r=snap_size + 0.15);
        }

        // 7. 45° Einführfase an der Vorderseite der Führungsschiene
        translate([-0.1, wall_thickness - rail_depth - 0.5, outer_box_h - lid_h - 0.5]) {
            rotate([0, 45, 0])
                cube([2.5, outer_box_d, 2.5]);
        }
    }
}

// ====================================================================
// MODULE: Schiebedeckel (Sliding Lid) - Hexagonal-Trapez-Profil
// ====================================================================
module sliding_lid() {
    play = 0.25; // Optimales Gleitspiel
    lid_w = outer_box_w - end_stop_wall - play;
    
    y_in_min  = wall_thickness + play;
    y_in_max  = outer_box_d - wall_thickness - play;
    y_out_min = wall_thickness - rail_depth + play;
    y_out_max = outer_box_d - wall_thickness + rail_depth - play;

    difference() {
        union() {
            // Hexagonales Trapez-Profil: 100% flach auf Z=0 gedruckt.
            rotate([90, 0, 90])
                linear_extrude(height = lid_w)
                    polygon(points=[
                        [y_in_min, 0],
                        [y_out_min, h_chamfer],
                        [y_out_min, h_chamfer + h_mid],
                        [y_in_min, lid_h],
                        [y_in_max, lid_h],
                        [y_out_max, h_chamfer + h_mid],
                        [y_out_max, h_chamfer],
                        [y_in_max, 0]
                    ]);

            // Snap-Lock Rastnase auf der oberen Schrägfläche verankert
            translate([lid_w - 6.0, outer_box_d / 2, lid_h - h_chamfer]) {
                sphere(r=snap_size);
            }
        }

        // Finger-Grip Riffelung auf der Oberseite
        for (k = [0 : 4]) {
            translate([lid_w - 10 - k * 4, outer_box_d / 2, lid_h]) {
                rotate([0, 45, 0])
                    cube([1.2, inner_box_d - 4, 1.2], center=true);
            }
        }

        // Gravur / Beschriftung auf der Oberseite
        translate([lid_w / 2 - 4, outer_box_d / 2, lid_h - 0.4]) {
            linear_extrude(height = 0.8)
                text("GOPRO 12", size = 5.0, halign = "center", valign = "center", font = "Arial:style=Bold");
        }
    }
}

// ====================================================================
// HELPER MODULES
// ====================================================================
module finger_cutout_shape(w, depth, wall) {
    rotate([-90, 0, 0])
        linear_extrude(height = wall)
            hull() {
                translate([0, depth - w/2]) circle(r=w/2);
                translate([0, depth + 10]) circle(r=w/2);
            }
}

module rounded_cube(size, r) {
    x = size[0];
    y = size[1];
    z = size[2];

    hull() {
        translate([r, r, 0]) cylinder(r=r, h=z);
        translate([x - r, r, 0]) cylinder(r=r, h=z);
        translate([r, y - r, 0]) cylinder(r=r, h=z);
        translate([x - r, y - r, 0]) cylinder(r=r, h=z);
    }
}
