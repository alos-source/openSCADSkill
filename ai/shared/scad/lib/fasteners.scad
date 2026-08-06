// OpenSCAD Shared Library: Fasteners & Standoffs
// AI Agent: Antigravity
// Date: 2026-08-02

// PCB Standoff Pillar
// - height: height of the standoff pillar above base
// - outer_r: outer radius of the standoff (default 3.0mm = 6mm dia)
// - inner_r: radius of the screw hole (default 1.35mm for M2.5 screw self-tap / clearance)
// - chamfer: base chamfer height for FDM printing strength
module pcb_standoff(height=5.0, outer_r=3.0, inner_r=1.35, chamfer=0.8) {
    $fn = $preview ? 24 : 48;
    difference() {
        union() {
            // Main cylinder
            cylinder(h=height, r=outer_r);
            // Chamfered base reinforcement
            if (chamfer > 0) {
                cylinder(h=chamfer, r1=outer_r + chamfer, r2=outer_r);
            }
        }
        // Screw hole (slightly deeper to clear Z-fighting)
        translate([0, 0, -0.1])
            cylinder(h=height + 0.2, r=inner_r);
    }
}

// Heat-Set Insert Boss Pillar (tuned for M3 Ruthex / Voron heat-set inserts: 4.2mm outer dia -> 2.1mm radius)
module heatset_boss(height=6.0, outer_r=3.6, insert_r=2.1, insert_depth=5.0, chamfer=0.8) {
    $fn = $preview ? 24 : 48;
    difference() {
        union() {
            cylinder(h=height, r=outer_r);
            if (chamfer > 0) {
                cylinder(h=chamfer, r1=outer_r + chamfer, r2=outer_r);
            }
        }
        // Heat-set insert cavity + insertion lead-in chamfer
        translate([0, 0, height - insert_depth])
            cylinder(h=insert_depth + 0.1, r=insert_r);
        // Top lead-in chamfer
        translate([0, 0, height - 0.4])
            cylinder(h=0.5, r1=insert_r, r2=insert_r + 0.4);
    }
}

// M3 Screw Clearance / Tap Hole Cutter
module screw_hole_m3(depth=10, clearance=true, countersink=false) {
    $fn = $preview ? 24 : 48;
    r = clearance ? (3.0 + 0.3)/2 : (3.0 - 0.2)/2;
    union() {
        translate([0, 0, -0.1])
            cylinder(h=depth + 0.2, r=r);
        if (countersink) {
            head_r = (5.5 + 0.4)/2;
            translate([0, 0, depth - 3.0])
                cylinder(h=3.1, r1=r, r2=head_r);
        }
    }
}
