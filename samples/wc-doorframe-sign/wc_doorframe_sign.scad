// ==============================================================================
// Project: Modern WC Doorframe Sign / Minimalistisches Türrahmen-Schild "WC"
// Description: Architectural, minimalist 3D printable sign designed to sit
//              perfectly on top of standard interior door frame moldings.
// Features: 
//   - Zero-support 3D printing (optimized flat orientation)
//   - Rear-mounted letters for wall-aligned center of gravity & maximum stability
//   - Self-aligning front retaining lip
//   - 4 aesthetic styles (Silhouette, Elevated Rail, Framed Badge, Corner Wrap)
//   - Fully parametric with OpenSCAD Customizer support
// ==============================================================================

/* [Model Style & Text] */
// Style of the sign
style = "silhouette"; // [silhouette: Connected Silhouette Letters, bar: Letters on Elevated Base Rail, badge: Modern Arched Frame, corner: Corner Bracket Sign]

// Text displayed on the sign
sign_text = "WC";

// Letter height in mm
letter_height = 52.0; // [30:1:90]

// Thickness of the letters in mm
letter_thickness = 3.6; // [2.0:0.2:8.0]

// Spacing between letters (tracking)
letter_spacing = 1.02; // [0.8:0.02:1.4]

// Font choice (installed system font or OpenSCAD standard)
font_family = "Arial:style=Bold"; // ["Arial:style=Bold", "Liberation Sans:style=Bold", "Impact:style=Regular", "Trebuchet MS:style=Bold", "Helvetica:style=Bold", "DejaVu Sans:style=Bold"]

/* [Doorframe Mounting & Stability] */
// Placement of letters on the base (Back is closest to wall for max stability)
letter_position = "back"; // [back: Back Edge (Closest to Wall - Max Stability), front: Front Edge (Over Front Lip), center: Centered on Top Ledge]

// Depth of the flat top ledge of your door frame (mm)
doorframe_top_depth = 18.0; // [10:1:40]

// Thickness of the horizontal base resting on top of the door frame (mm)
base_thickness = 3.0; // [2.0:0.5:6.0]

// Height of the front alignment lip hanging in front of the door frame (mm)
front_lip_drop = 6.0; // [0:1:15]

// Thickness of the front lip (mm)
front_lip_thickness = 3.2; // [2.0:0.5:6.0]

// Extra margin extending to the left and right of the text (mm)
base_margin_x = 6.0; // [2:1:30]

/* [Aesthetic Details] */
// Height of the baseline connecting bar (mm)
baseline_bar_height = 5.5; // [3:0.5:12]

// Corner style horizontal length (mm)
corner_top_width = 110.0; // [70:5:160]

// Corner style vertical side drop (mm)
corner_side_drop = 45.0; // [25:5:80]

// Frame margin for Badge style (mm)
badge_padding = 9.0; // [5:1:20]

// Chamfer size on edges (mm)
edge_chamfer = 0.8;

/* [Assembly & Print Orientation] */
// Render orientation: Assembled (standing upright on frame) or Print Ready (lying flat on bed)
render_mode = "assembled"; // [assembled: Upright as Installed on Doorframe, print_ready: Flat on Build Plate (0 Supports)]

// Show simulated doorframe section for visual preview
show_doorframe_simulation = false;

/* [Smoothness] */
$fn = 64;

// ------------------------------------------------------------------------------
// Internal Dimensions & Position Calculations
// ------------------------------------------------------------------------------
approx_char_width = letter_height * 0.70;
approx_text_span = approx_char_width * len(sign_text) * letter_spacing;
sign_span_x = (style == "corner") ? corner_top_width : (approx_text_span + (base_margin_x * 2));

// Small optical offset to prevent bottom curves (e.g. in 'C') from dipping below baseline
baseline_optical_lift = letter_height * 0.035;

// Calculate Y position of the letters based on selected position mode
// When letter_position == "back", letters sit flush at the rear wall edge (doorframe_top_depth)
calc_y_letter_front = (letter_position == "back") ? (doorframe_top_depth - letter_thickness) :
                      ((letter_position == "center") ? ((doorframe_top_depth - letter_thickness) / 2) : 
                      (-front_lip_thickness));

calc_y_letter_back = calc_y_letter_front + letter_thickness;

// ------------------------------------------------------------------------------
// Mounting Base Modules
// ------------------------------------------------------------------------------

// Standard horizontal resting plate with front retaining lip
module doorframe_ledge_mount(w) {
    union() {
        // 1. Horizontal platform resting on top of door frame
        translate([0, 0, 0])
            cube([w, doorframe_top_depth, base_thickness]);
            
        // 2. Front retaining lip hanging over front face of door trim
        if (front_lip_drop > 0) {
            translate([0, -front_lip_thickness, -front_lip_drop])
                cube([w, front_lip_thickness, front_lip_drop + base_thickness]);
            
            // 45-degree reinforcement gusset for rigidity and clean look
            translate([0, 0, 0])
                rotate([0, 90, 0])
                    linear_extrude(w)
                        polygon([[0, 0], [0, 2.5], [2.5, 0]]);
        }
    }
}

// Corner wrap mount (hooks top horizontal trim + right vertical trim)
module corner_ledge_mount() {
    union() {
        doorframe_ledge_mount(corner_top_width);
        
        // Right side vertical drop section
        translate([corner_top_width - base_thickness, 0, -corner_side_drop]) {
            // Side resting flange
            cube([base_thickness, doorframe_top_depth, corner_side_drop]);
            
            // Side front lip
            if (front_lip_drop > 0) {
                translate([-front_lip_thickness + base_thickness, -front_lip_thickness, 0])
                    cube([front_lip_thickness, front_lip_thickness, corner_side_drop]);
            }
        }
    }
}

// ------------------------------------------------------------------------------
// Style Implementations (With Position Awareness)
// ------------------------------------------------------------------------------

// 1. Silhouette Style: Connected modern bold typography with integrated baseline bar
module build_style_silhouette() {
    union() {
        doorframe_ledge_mount(sign_span_x);
        
        // Integrated monolithic baseline rail along the letters
        translate([0, calc_y_letter_front, base_thickness])
            cube([sign_span_x, letter_thickness, baseline_bar_height]);
        
        // Bold 3D letters standing vertically
        translate([sign_span_x / 2, calc_y_letter_back, base_thickness + baseline_optical_lift]) {
            rotate([90, 0, 0]) {
                linear_extrude(height = letter_thickness) {
                    text(
                        text = sign_text,
                        size = letter_height,
                        font = font_family,
                        halign = "center",
                        valign = "baseline",
                        spacing = letter_spacing
                    );
                }
            }
        }
    }
}

// 2. Bar Style: Floating letters on a defined accent rail
module build_style_bar() {
    bar_h = baseline_bar_height + 4.0;
    union() {
        doorframe_ledge_mount(sign_span_x);
        
        // Prominent accent bar
        translate([0, calc_y_letter_front, base_thickness])
            cube([sign_span_x, letter_thickness, bar_h]);
            
        // Elevated letters
        translate([sign_span_x / 2, calc_y_letter_back, base_thickness + bar_h + baseline_optical_lift]) {
            rotate([90, 0, 0]) {
                linear_extrude(height = letter_thickness) {
                    text(
                        text = sign_text,
                        size = letter_height,
                        font = font_family,
                        halign = "center",
                        valign = "baseline",
                        spacing = letter_spacing
                    );
                }
            }
        }
    }
}

// 3. Badge Style: Modern rounded arch plaque with cut-out letters
module build_style_badge() {
    b_width = approx_text_span + (badge_padding * 2);
    b_height = letter_height + (badge_padding * 2);
    arch_r = b_width / 2;
    
    union() {
        doorframe_ledge_mount(b_width);
        
        translate([0, calc_y_letter_back, base_thickness]) {
            rotate([90, 0, 0]) {
                linear_extrude(height = letter_thickness) {
                    difference() {
                        // Arched outer shield
                        hull() {
                            translate([3, 0]) square([b_width - 6, b_height - arch_r]);
                            translate([arch_r, b_height - arch_r]) circle(r = arch_r - 2);
                        }
                        
                        // Negative cut-out text
                        translate([b_width / 2, badge_padding + baseline_optical_lift])
                            text(
                                text = sign_text,
                                size = letter_height * 0.85,
                                font = font_family,
                                halign = "center",
                                valign = "baseline",
                                spacing = letter_spacing
                            );
                    }
                }
            }
        }
    }
}

// 4. Corner Style: Architectural corner topper for the top-right frame corner
module build_style_corner() {
    union() {
        corner_ledge_mount();
        
        // Baseline rail
        translate([0, calc_y_letter_front, base_thickness])
            cube([corner_top_width, letter_thickness, baseline_bar_height]);
            
        // Letters positioned elegantly on the rail
        translate([corner_top_width * 0.44, calc_y_letter_back, base_thickness + baseline_optical_lift]) {
            rotate([90, 0, 0]) {
                linear_extrude(height = letter_thickness) {
                    text(
                        text = sign_text,
                        size = letter_height,
                        font = font_family,
                        halign = "center",
                        valign = "baseline",
                        spacing = letter_spacing
                    );
                }
            }
        }
        
        // Vertical decorative framing bar along right edge (if on front or back)
        translate([corner_top_width - 4, -front_lip_thickness, -corner_side_drop])
            cube([4, front_lip_thickness, corner_side_drop + base_thickness + baseline_bar_height]);
            
        if (letter_position == "back") {
            // Rear side stabilizer rib for corner style
            translate([corner_top_width - 4, 0, base_thickness])
                cube([4, doorframe_top_depth, baseline_bar_height]);
        }
    }
}

// ------------------------------------------------------------------------------
// Simulated Doorframe & Wall (For Realistic Visualization Only)
// ------------------------------------------------------------------------------
module doorframe_visualizer() {
    df_width = (style == "corner") ? (corner_top_width + 40) : (sign_span_x + 40);
    df_height = 85;
    
    // 1. Doorframe Trim
    color([0.94, 0.93, 0.90, 0.85]) { // Realistic off-white door trim
        translate([-20, 0, -df_height]) {
            cube([df_width, doorframe_top_depth, df_height]);
        }
    }
    
    // 2. Wall section behind doorframe
    color([0.88, 0.86, 0.82, 0.5]) {
        translate([-30, doorframe_top_depth, -df_height]) {
            cube([df_width + 20, 15, df_height + letter_height + 25]);
        }
    }
}

// ------------------------------------------------------------------------------
// Core Geometry Selector
// ------------------------------------------------------------------------------
module sign_raw_geometry() {
    if (style == "silhouette") {
        build_style_silhouette();
    } else if (style == "bar") {
        build_style_bar();
    } else if (style == "badge") {
        build_style_badge();
    } else if (style == "corner") {
        build_style_corner();
    } else {
        build_style_silhouette();
    }
}

// ------------------------------------------------------------------------------
// Main Assembly & Orientation Control
// ------------------------------------------------------------------------------
module main() {
    if (render_mode == "print_ready") {
        // Oriented flat on the print bed for optimal 0-support FDM printing
        if (letter_position == "back") {
            // Rear plane of letters is at Y = doorframe_top_depth
            // Rotate so rear flat face lies on the build plate (Z=0)
            rotate([90, 0, 0])
                translate([0, -base_thickness, -doorframe_top_depth])
                    sign_raw_geometry();
        } else {
            rotate([-90, 0, 0])
                translate([0, front_lip_thickness - letter_thickness, -base_thickness])
                    sign_raw_geometry();
        }
    } else {
        // Assembled view (sitting on door frame)
        color([0.14, 0.14, 0.14]) { // Sleek matte black finish
            sign_raw_geometry();
        }
        
        if (show_doorframe_simulation) {
            doorframe_visualizer();
        }
    }
}

main();
