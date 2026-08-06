// OpenSCAD Shared Library: 3D Reference Board Models & Cutouts
// AI Agent: Antigravity
// Date: 2026-08-02

include <connectors.scad>
include <fasteners.scad>

// ==========================================
// 1. RASPBERRY PI 4 MODEL B
// ==========================================

module rpi4_b_mounting_hole_coords() {
    // Hole offsets from PCB origin (0,0)
    translate([3.5, 3.5, 0]) children();
    translate([3.5 + 58.0, 3.5, 0]) children();
    translate([3.5, 3.5 + 49.0, 0]) children();
    translate([3.5 + 58.0, 3.5 + 49.0, 0]) children();
}

module rpi4_b_mockup(show_components=true) {
    $fn = $preview ? 24 : 36;
    pcb_w = 85.0;
    pcb_d = 56.0;
    pcb_h = 1.4;

    color("ForestGreen")
        difference() {
            // PCB base
            hull() {
                translate([3, 3, 0]) cylinder(h=pcb_h, r=3);
                translate([pcb_w - 3, 3, 0]) cylinder(h=pcb_h, r=3);
                translate([3, pcb_d - 3, 0]) cylinder(h=pcb_h, r=3);
                translate([pcb_w - 3, pcb_d - 3, 0]) cylinder(h=pcb_h, r=3);
            }
            // Mounting holes (M2.5)
            rpi4_b_mounting_hole_coords()
                translate([0, 0, -0.1]) cylinder(h=pcb_h + 0.2, r=1.35);
        }

    if (show_components) {
        // USB-C Power Port
        color("Silver") translate([11.2, -1.0, pcb_h]) cube([8.9, 7.5, 3.2]);
        // Micro HDMI 1
        color("Silver") translate([26.0, -1.0, pcb_h]) cube([7.5, 7.5, 3.0]);
        // Micro HDMI 2
        color("Silver") translate([39.5, -1.0, pcb_h]) cube([7.5, 7.5, 3.0]);
        // Audio Jack
        color("Black") translate([53.5, -2.0, pcb_h]) cube([7.0, 11.5, 6.0]);
        // Ethernet Port (Right side)
        color("Silver") translate([pcb_w - 20.0, 2.5, pcb_h]) cube([21.2, 16.0, 13.5]);
        // Dual USB 3.0 Ports
        color("Blue") translate([pcb_w - 17.0, 21.5, pcb_h]) cube([17.5, 14.5, 15.5]);
        // Dual USB 2.0 Ports
        color("Black") translate([pcb_w - 17.0, 38.5, pcb_h]) cube([17.5, 14.5, 15.5]);
        // Broadcom SoC Chip
        color("DarkSlateGray") translate([25.0, 22.0, pcb_h]) cube([14.0, 14.0, 2.2]);
    }
}

// Enclosure Cutout Mask for RPi 4 B Ports
module rpi4_b_cutout(margin=0.4, tunnel_length=15.0) {
    pcb_h = 1.4;
    // USB-C
    translate([11.2, -tunnel_length + 2, pcb_h + 1.6])
        rotate([-90, 0, 0]) usbc_port_cutout(depth=tunnel_length, clearance=margin);
    // Micro HDMI 1
    translate([26.0, -tunnel_length + 2, pcb_h + 1.5])
        rotate([-90, 0, 0]) micro_hdmi_port_cutout(depth=tunnel_length, clearance=margin);
    // Micro HDMI 2
    translate([39.5, -tunnel_length + 2, pcb_h + 1.5])
        rotate([-90, 0, 0]) micro_hdmi_port_cutout(depth=tunnel_length, clearance=margin);
    // Ethernet Cutout
    translate([85.0 - 2, 2.5 + 8.0, pcb_h + 6.75])
        rj45_port_cutout(depth=tunnel_length, clearance=margin);
}

// ==========================================
// 2. WEMOS D1 MINI (ESP8266)
// ==========================================

module wemos_d1_mini_mockup(show_headers=true) {
    $fn = $preview ? 20 : 36;
    pcb_w = 25.6;
    pcb_d = 34.2;
    pcb_h = 1.0;

    color("DodgerBlue")
        difference() {
            cube([pcb_w, pcb_d, pcb_h]);
            // Front notches
            translate([-0.1, -0.1, -0.1]) cube([2.0, 2.0, pcb_h + 0.2]);
            translate([pcb_w - 1.9, -0.1, -0.1]) cube([2.0, 2.0, pcb_h + 0.2]);
        }

    // Micro USB Port
    color("Silver") translate([(pcb_w - 7.5)/2, -1.0, pcb_h]) cube([7.5, 5.5, 2.8]);
    // ESP8266 Metal Shield
    color("Silver") translate([(pcb_w - 16.0)/2, 8.0, pcb_h]) cube([16.0, 20.0, 2.8]);

    if (show_headers) {
        // Pin Headers (Bottom)
        color("Black") translate([1.25, 4.0, -8.5]) cube([2.54, 20.32, 8.5]);
        color("Black") translate([pcb_w - 3.79, 4.0, -8.5]) cube([2.54, 20.32, 8.5]);
    }
}

module wemos_d1_mini_cutout(margin=0.4, tunnel_length=10.0) {
    pcb_w = 25.6;
    pcb_h = 1.0;
    // Front Micro-USB Cutout
    translate([pcb_w/2, -tunnel_length + 2, pcb_h + 1.4])
        rotate([-90, 0, 0]) microusb_port_cutout(depth=tunnel_length, clearance=margin);
}

// ==========================================
// 3. ESP32 DEVKIT V1 (30 PINS)
// ==========================================

module esp32_devkit_v1_mounting_hole_coords() {
    translate([3.25, 2.75, 0]) children();
    translate([3.25 + 45.0, 2.75, 0]) children();
    translate([3.25, 2.75 + 23.0, 0]) children();
    translate([3.25 + 45.0, 2.75 + 23.0, 0]) children();
}

module esp32_devkit_v1_mockup(show_headers=true) {
    $fn = $preview ? 20 : 36;
    pcb_w = 51.5;
    pcb_d = 28.5;
    pcb_h = 1.2;

    color("Black")
        difference() {
            cube([pcb_w, pcb_d, pcb_h]);
            // 4 Mounting holes M2
            esp32_devkit_v1_mounting_hole_coords()
                translate([0, 0, -0.1]) cylinder(h=pcb_h + 0.2, r=1.0);
        }

    // Micro USB / USB-C Port at front (X=0)
    color("Silver") translate([-1.0, (pcb_d - 7.5)/2, pcb_h]) cube([6.0, 7.5, 2.8]);
    // ESP-WROOM-32 Module
    color("Silver") translate([18.0, (pcb_d - 18.0)/2, pcb_h]) cube([25.5, 18.0, 3.0]);

    if (show_headers) {
        // Dual 15-pin headers
        color("Black") translate([6.0, 1.25, -8.5]) cube([38.1, 2.54, 8.5]);
        color("Black") translate([6.0, pcb_d - 3.79, -8.5]) cube([38.1, 2.54, 8.5]);
    }
}

module esp32_devkit_v1_cutout(margin=0.4, tunnel_length=10.0) {
    pcb_d = 28.5;
    pcb_h = 1.2;
    // USB Cutout at front X=0
    translate([-tunnel_length + 2, pcb_d/2, pcb_h + 1.4])
        microusb_port_cutout(depth=tunnel_length, clearance=margin);
}
