// OpenSCAD Shared Library: Connectors & Interface Cutouts
// AI Agent: Antigravity
// Date: 2026-08-02

// USB-C Port Cutout
// - wall_thickness: length of cutout tunnel through housing wall
// - clearance: margin around port (default 0.4mm for cable strain relief)
module usbc_port_cutout(depth=10, clearance=0.4, bevel=0.5) {
    w = 8.9 + 2 * clearance;
    h = 2.6 + 2 * clearance;
    r = (h / 2);
    $fn = $preview ? 24 : 48;

    translate([0, -w/2, -h/2])
        hull() {
            translate([0, r, r]) rotate([0, 90, 0]) cylinder(h=depth, r=r);
            translate([0, w - r, r]) rotate([0, 90, 0]) cylinder(h=depth, r=r);
        }
}

// Micro-USB Port Cutout
module microusb_port_cutout(depth=10, clearance=0.4) {
    w = 7.5 + 2 * clearance;
    h = 3.0 + 2 * clearance;
    $fn = $preview ? 16 : 32;

    translate([0, -w/2, -h/2])
        cube([depth, w, h]);
}

// Full-Size HDMI Port Cutout
module hdmi_port_cutout(depth=10, clearance=0.5) {
    w = 15.0 + 2 * clearance;
    h = 6.5 + 2 * clearance;
    $fn = $preview ? 16 : 32;

    translate([0, -w/2, -h/2])
        cube([depth, w, h]);
}

// Micro-HDMI Port Cutout (e.g. Raspberry Pi 4 B)
module micro_hdmi_port_cutout(depth=10, clearance=0.4) {
    w = 7.2 + 2 * clearance;
    h = 3.2 + 2 * clearance;
    $fn = $preview ? 16 : 32;

    translate([0, -w/2, -h/2])
        cube([depth, w, h]);
}

// RJ45 Ethernet Port Cutout
module rj45_port_cutout(depth=10, clearance=0.5) {
    w = 16.0 + 2 * clearance;
    h = 13.8 + 2 * clearance;
    $fn = $preview ? 16 : 32;

    translate([0, -w/2, -h/2])
        cube([depth, w, h]);
}

// USB-A Dual Port Cutout Stack
module usba_dual_port_cutout(depth=10, clearance=0.5) {
    w = 14.8 + 2 * clearance;
    h = 16.0 + 2 * clearance;
    $fn = $preview ? 16 : 32;

    translate([0, -w/2, -h/2])
        cube([depth, w, h]);
}
