// AI Agent: gemini
// Project: hue-smart-button-v2-base
// Date: 2026-10-18
// User Verification Checklist
// - Geometry reviewed manually: [ ]
// - Render checked in OpenSCAD: [ ]
// - Printed successfully: [ ]
// - Notes: Philips Hue Smart Button v2 base with German light switch compatibility (System 55 and 80x80 DIN 49073), annular washer pocket with central support post, and ergonomic pry notches.

/* [Render Mode & Part Selector] */
// Part selector for rendering and 3D printing
part = "all"; // ["all": Assembled View (with Mockups in Preview), "base": Base Plate Only, "cap": Flush Washer Cover Cap Only, "exploded": Exploded View, "debug": Cross-Section View, "print_bed": 3D Print Layout (Z=0)]

/* [Switch Frame Configuration] */
// German light switch mounting format
plate_type = "system55"; // ["system55": System 55 Frame Insert (55x55mm), "full_frame": Full Wall Plate (80x80mm DIN 49073), "standalone": Standalone Desk / Adhesive Puck]

// Overall thickness of the base plate (mm)
plate_thickness = 6.0; // [4.0:0.5:12.0]

// Corner rounding radius for the base plate (mm)
corner_radius = 2.0; // [0.5:0.5:10.0]

// Outer chamfer on top front rim (mm)
top_rim_chamfer = 0.8; // [0.0:0.2:2.0]

// System 55 specific: outer width & height of insert (standard 55mm frames have a 55.0mm cutout, 54.7mm allows 0.3mm clearance)
sys55_size = 54.7; // [50.0:0.1:56.0]

// Full frame specific: outer width & height (standard German single frame is 80 to 85 mm)
full_frame_size = 80.0; // [75.0:1.0:90.0]

// DIN 49073 flush box screw center spacing (standard German box is 60.0mm)
din_screw_spacing = 60.0; // [58.0:0.5:62.0]

// Screw hole diameter for wall box screws (mm)
din_screw_dia = 3.6; // [3.0:0.1:4.5]

// Countersink diameter for screw heads (mm)
din_screw_head_dia = 6.8; // [5.5:0.1:8.5]

/* [Hue Smart Button v2 Dimensions] */
// Official Hue Smart Button v2 outer diameter (mm)
button_dia = 45.0; // [40.0:0.5:50.0]

// Radial fit clearance around button (mm)
button_clearance = 0.5; // [0.2:0.1:1.0]

// Depth of button seating recess (mm)
button_recess_depth = 2.5; // [1.0:0.5:5.0]

// Add finger/fingernail pry notches for easy battery removal
enable_pry_notches = true;

// Radius of fingernail pry notches at the rim (mm)
pry_notch_radius = 3.5; // [2.0:0.5:6.0]

// Depth of pry notches into the rim (mm)
pry_notch_depth = 1.6; // [1.0:0.2:3.0]

/* [Ferromagnetic Material Pocket & Central Post] */
// Pocket placement style: "internal" (sealed cavity closed by top layers for pause-print), "front" (open pocket), "rear" (open on back)
pocket_position = "internal"; // ["internal": Sealed internal cavity (Closed & bridged over at Z=2.9mm), "front": Open front recess, "rear": Open pocket from back, "none": No pocket]

// Include central alignment/support post inside the washer hole (centers M8 washer & reduces bridging span from 24.8mm to 8.4mm)
enable_center_post = true;

// Diameter of central alignment post (DIN 9021 M8 washer has 8.4mm hole -> 8.0mm post gives 0.4mm clearance; set 0 for solid discs)
washer_center_post_dia = 8.0; // [0.0:0.5:15.0]

// Shape of ferromagnetic pocket
pocket_shape = "round"; // ["round": Circular washer/disc/magnet, "rect": Rectangular metal plate]

// Diameter of round pocket (DIN 9021 M8 washer = 24.0mm OD, 2.0mm thick; 25mm steel disc = 25.0mm)
ferro_dia = 24.8; // [15.0:0.5:35.0]

// Thickness/depth of pocket cavity (mm)
ferro_depth = 2.2; // [1.0:0.1:5.0]

// Solid ceiling thickness covering the washer for internal pause-print mode (mm)
front_skin_thickness = 0.6; // [0.4:0.2:1.6]

// Width of rectangular pocket if pocket_shape is rect (mm)
ferro_rect_w = 25.0; // [10.0:1.0:40.0]

// Length of rectangular pocket if pocket_shape is rect (mm)
ferro_rect_l = 25.0; // [10.0:1.0:40.0]

/* [Wall Box & Wiring Clearance] */
// Recess on the back of full_frame to clear flush box screws / WAGO terminals (mm)
rear_cavity_dia = 54.0; // [40.0:1.0:60.0]

// Depth of rear flush box cavity (mm)
rear_cavity_depth = 2.5; // [0.0:0.5:4.0]

/* [FDM Printability & Quality] */
// Bottom edge chamfer to eliminate elephant-foot (mm)
bottom_chamfer = 0.6; // [0.0:0.1:1.0]

// Curve facet resolution
$fn = $preview ? 48 : 96;

// Internal epsilon offset to prevent non-manifold edges
eps = 0.02;

// Effective active plate mode based on part selector override
active_plate_type = (part == "system55") ? "system55" :
                    (part == "full_frame") ? "full_frame" :
                    plate_type;

// Calculated dimensions
plate_w = (active_plate_type == "system55") ? sys55_size :
          (active_plate_type == "full_frame") ? full_frame_size : 56.0;

plate_h = plate_w;

eff_recess_dia = button_dia + button_clearance;
seat_floor_z = plate_thickness - button_recess_depth;

// Helper: 2D Rounded Rectangle (centered at origin)
module rounded_rect_2d(w, h, r) {
    r_eff = min(r, w/2 - 0.1, h/2 - 0.1);
    hull() {
        translate([w/2 - r_eff,  h/2 - r_eff]) circle(r = r_eff);
        translate([-w/2 + r_eff,  h/2 - r_eff]) circle(r = r_eff);
        translate([-w/2 + r_eff, -h/2 + r_eff]) circle(r = r_eff);
        translate([w/2 - r_eff, -h/2 + r_eff]) circle(r = r_eff);
    }
}

// 3D Solid Rounded Plate with Top Rim Chamfer and Flat Bottom
module raw_plate_body() {
    c = top_rim_chamfer;
    if (c <= 0) {
        linear_extrude(height = plate_thickness)
            rounded_rect_2d(plate_w, plate_h, corner_radius);
    } else {
        h_body = plate_thickness - c;
        hull() {
            // Lower body (vertical sides)
            linear_extrude(height = h_body)
                rounded_rect_2d(plate_w, plate_h, corner_radius);
            
            // Top face (inward chamfer)
            translate([0, 0, plate_thickness])
                linear_extrude(height = 0.01)
                    rounded_rect_2d(plate_w - 2*c, plate_h - 2*c, max(0.5, corner_radius - c));
        }
    }
}

// Ferromagnetic Pocket Subtraction Volume (Annular ring preserving central post)
module ferro_pocket_subtraction() {
    if (pocket_position != "none") {
        z_pos = (pocket_position == "internal") ?
                    (seat_floor_z - front_skin_thickness - ferro_depth) :
                (pocket_position == "front") ?
                    (seat_floor_z - ferro_depth) :
                    -eps; // rear pocket
        
        pocket_h = ferro_depth + ((pocket_position == "rear") ? eps : 0);

        translate([0, 0, z_pos]) {
            if (pocket_shape == "round") {
                // Annular ring cutout preserving the solid central support post
                difference() {
                    union() {
                        cylinder(d = ferro_dia, h = pocket_h + eps);
                        
                        // Subtle lead-in chamfer for front pocket
                        if (pocket_position == "front") {
                            translate([0, 0, pocket_h - 0.3])
                                cylinder(d1 = ferro_dia, d2 = ferro_dia + 0.8, h = 0.3 + eps);
                        }
                    }
                    
                    // Keep solid central support post inside washer hole
                    if (enable_center_post && washer_center_post_dia > 0) {
                        translate([0, 0, -eps])
                            cylinder(d = washer_center_post_dia, h = pocket_h + 3*eps);
                    }
                }
            } else {
                translate([-ferro_rect_w/2, -ferro_rect_l/2, 0])
                    cube([ferro_rect_w, ferro_rect_l, pocket_h + eps]);
            }
        }
    }
}

// Button Recess Subtraction Volume
module button_recess_subtraction() {
    // Main circular seat
    translate([0, 0, seat_floor_z])
        cylinder(d = eff_recess_dia, h = button_recess_depth + eps + 1.0);
    
    // Ergonomic fingernail pry notches at east and west (+X and -X)
    if (enable_pry_notches) {
        notch_r = eff_recess_dia / 2;
        notch_z = plate_thickness - pry_notch_depth;
        
        // East notch (+X)
        translate([notch_r, 0, notch_z])
            cylinder(r = pry_notch_radius, h = pry_notch_depth + eps + 1.0);
            
        // West notch (-X)
        translate([-notch_r, 0, notch_z])
            cylinder(r = pry_notch_radius, h = pry_notch_depth + eps + 1.0);
    }
}

// DIN 49073 Mounting Screw Holes & Rear Flush Box Cavity (for full_frame)
module wall_mount_features() {
    if (active_plate_type == "full_frame") {
        // Rear cavity over flush-mount box (Unterputzdose)
        if (rear_cavity_depth > 0) {
            translate([0, 0, -eps])
                cylinder(d = rear_cavity_dia, h = rear_cavity_depth + eps);
        }

        // Standard DIN 60mm screw holes (horizontal and vertical pairs)
        screw_coords = [
            [-din_screw_spacing/2, 0],
            [ din_screw_spacing/2, 0],
            [0, -din_screw_spacing/2],
            [0,  din_screw_spacing/2]
        ];

        for (pos = screw_coords) {
            translate([pos[0], pos[1], -eps]) {
                // Pass-through cylinder
                cylinder(d = din_screw_dia, h = plate_thickness + 2*eps);
                
                // Countersink cone from front face
                translate([0, 0, plate_thickness - (din_screw_head_dia - din_screw_dia)/2])
                    cylinder(d1 = din_screw_dia, d2 = din_screw_head_dia, h = (din_screw_head_dia - din_screw_dia)/2 + eps);
                    
                // Screw head recess
                translate([0, 0, plate_thickness - 0.01])
                    cylinder(d = din_screw_head_dia, h = 2.0);
            }
        }
    }
}

// Elephant foot chamfer subtraction around base perimeter (Z = 0)
module bottom_chamfer_subtraction() {
    if (bottom_chamfer > 0) {
        difference() {
            translate([-plate_w/2 - 2, -plate_h/2 - 2, -eps])
                cube([plate_w + 4, plate_h + 4, bottom_chamfer + eps]);
                
            translate([0, 0, -2*eps])
                hull() {
                    linear_extrude(height = 0.01)
                        rounded_rect_2d(plate_w - 2*bottom_chamfer, plate_h - 2*bottom_chamfer, max(0.2, corner_radius - bottom_chamfer));
                    translate([0, 0, bottom_chamfer + eps])
                        linear_extrude(height = 0.01)
                            rounded_rect_2d(plate_w, plate_h, corner_radius);
                }
        }
    }
}

// Complete Printable Base Plate Module
module hue_smart_button_base() {
    color([0.92, 0.92, 0.90]) // Pure white/light grey electrical plastic
    difference() {
        raw_plate_body();
        
        // Button seat recess
        button_recess_subtraction();
        
        // Annular ferromagnetic pocket (with solid central post preserved)
        ferro_pocket_subtraction();
        
        // DIN 49073 screw holes & rear box cavity (if full_frame)
        wall_mount_features();
        
        // Elephant foot chamfer
        bottom_chamfer_subtraction();
    }
}

// Optional Snap-In / Drop-In Flush Cover Cap for Front Pocket Mode
module washer_cover_cap() {
    cap_dia = ferro_dia - 0.2; // 0.2mm diametrical clearance
    cap_thick = front_skin_thickness;
    color([0.90, 0.90, 0.92]) {
        difference() {
            cylinder(d1 = cap_dia - 0.4, d2 = cap_dia, h = cap_thick);
            if (enable_center_post && washer_center_post_dia > 0) {
                translate([0, 0, -eps])
                    cylinder(d = washer_center_post_dia + 0.3, h = cap_thick + 2*eps);
            }
        }
    }
}

// Visual Mockup: DIN 9021 M8 Steel Washer (OD 24mm, ID 8.4mm, T 2mm)
module ferro_washer_mockup() {
    color([0.72, 0.75, 0.80, 0.95]) { // Metallic steel
        difference() {
            cylinder(d = 24.0, h = 2.0);
            translate([0, 0, -eps])
                cylinder(d = 8.4, h = 2.0 + 2*eps);
        }
    }
}

// Visual Mockup: Philips Hue Smart Button Gen 2 (Dia 45mm, Height 13mm)
module hue_smart_button_v2_mockup() {
    btn_h = 13.0;
    r_top = 2.0;
    color([0.98, 0.98, 0.98, 0.85]) { // Translucent white button body
        hull() {
            cylinder(d = button_dia, h = btn_h - r_top);
            translate([0, 0, btn_h - r_top])
                cylinder(d = button_dia - 2*r_top, h = r_top);
        }
    }
    // Subtle central indicator LED dot
    color([0.2, 0.55, 0.95, 0.95]) {
        translate([0, 0, btn_h + 0.01])
            cylinder(d = 2.8, h = 0.1);
    }
}

// Main Controller
if (part == "all") {
    // Assembled View
    hue_smart_button_base();
    
    // In GUI / preview mode, show the washer and button mockups
    if ($preview) {
        washer_z = (pocket_position == "internal") ? (seat_floor_z - front_skin_thickness - ferro_depth + 0.1) :
                   (pocket_position == "front") ? (seat_floor_z - ferro_depth + 0.1) : 0.1;
        translate([0, 0, washer_z])
            ferro_washer_mockup();
            
        translate([0, 0, seat_floor_z])
            hue_smart_button_v2_mockup();
    }
}
else if (part == "base" || part == "system55" || part == "full_frame") {
    // 100% printable solid part, sitting flat on Z = 0
    hue_smart_button_base();
}
else if (part == "cap") {
    // Printable flush cover cap sitting flat on Z = 0
    washer_cover_cap();
}
else if (part == "debug") {
    // Half-cutaway section view along Y=0 cutting foreground (Y < 0) so the cut cross-section directly faces camera
    difference() {
        hue_smart_button_base();
        translate([-plate_w/2 - 1, -plate_h/2 - 1, -eps])
            cube([plate_w + 2, plate_h/2 + 1, plate_thickness + 2*eps]);
    }
}
else if (part == "exploded") {
    // Exploded View along Z-axis
    hue_smart_button_base();
    
    // Suspended washer
    translate([0, 0, 16])
        ferro_washer_mockup();
        
    // Suspended button
    translate([0, 0, 36])
        hue_smart_button_v2_mockup();
}
