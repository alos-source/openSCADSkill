// Preview showcase for 3D Board Reference Models & Libraries
// AI Agent: Antigravity

include <boards.scad>
include <fasteners.scad>
include <connectors.scad>

$fn = $preview ? 24 : 48;

// 1. Raspberry Pi 4 B with Standoffs
translate([0, 0, 0]) {
    rpi4_b_mockup(show_components=true);
    rpi4_b_mounting_hole_coords()
        translate([0, 0, -5.0]) pcb_standoff(height=5.0, inner_r=1.35);
}

// 2. WEMOS D1 Mini
translate([100, 0, 0]) {
    wemos_d1_mini_mockup(show_headers=true);
}

// 3. ESP32 DevKit v1 with Heat-Set Bosses
translate([140, 0, 0]) {
    esp32_devkit_v1_mockup(show_headers=true);
    esp32_devkit_v1_mounting_hole_coords()
        translate([0, 0, -6.0]) heatset_boss(height=6.0);
}
