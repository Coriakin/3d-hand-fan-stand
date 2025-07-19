// Fan Stand for Hand Fan
// Base plate: 70mm x 60mm
// Oval cylinder: 30mm x 25mm (positioned in center)

// Parameters
base_length = 70;  // mm
base_width = 60;   // mm
base_thickness = 3; // mm

cylinder_length = 32; // mm (along base length) - increased from 30 to accommodate handle + wall
cylinder_width = 27;  // mm (along base width) - increased from 25 to accommodate handle + wall
cylinder_height = 30; // mm

// Handle cavity parameters
handle_length = 30;   // mm - actual handle size
handle_width = 25;    // mm - actual handle size
wall_thickness = 1;   // mm - wall thickness around handle (should be 2mm total = 1mm each side)

// Taper parameters
taper_height = 5;     // mm - height of the tapered support
taper_scale = 1.5;    // scale factor for taper base (1.5 = 50% larger)

// Cutout parameters
cutout_width = 16;    // mm - width of the oval cutouts
cutout_length = 24;   // mm - length of the oval cutouts
cutout_offset = 6;    // mm - distance from edge to center of cutout

// Create the fan stand
fan_stand();

module fan_stand() {
    difference() {
        union() {
            // Base plate
            base_plate();
            
            // Oval cylinder in the center
            translate([0, 0, base_thickness]) {
                oval_cylinder();
            }
            
            // Tapered support at base of cylinder
            translate([0, 0, base_thickness]) {
                tapered_support();
            }
        }
        
        // Cut out half-moon shapes from all four sides
        cutouts();
        
        // Cut out handle cavity inside cylinder
        translate([0, 0, base_thickness]) {
            handle_cavity();
        }
    }
}

module base_plate() {
    translate([-base_length/2, -base_width/2, 0]) {
        cube([base_length, base_width, base_thickness]);
    }
}

module oval_cylinder() {
    // Create oval cylinder using hull of two cylinders
    hull() {
        // Cylinder at one end
        translate([-(cylinder_length-cylinder_width)/2, 0, 0]) {
            cylinder(h=cylinder_height, d=cylinder_width, center=false);
        }
        
        // Cylinder at other end
        translate([(cylinder_length-cylinder_width)/2, 0, 0]) {
            cylinder(h=cylinder_height, d=cylinder_width, center=false);
        }
    }
}

module tapered_support() {
    // Create tapered support using hull between oval shapes
    hull() {
        // Bottom larger oval (at base plate level)
        translate([0, 0, 0]) {
            scale([taper_scale, taper_scale, 1]) {
                oval_base();
            }
        }
        
        // Top smaller oval (at cylinder base)
        translate([0, 0, taper_height]) {
            oval_base();
        }
    }
}

module oval_base() {
    // Create oval base shape using hull of two cylinders
    hull() {
        // Cylinder at one end
        translate([-(cylinder_length-cylinder_width)/2, 0, 0]) {
            cylinder(h=0.1, d=cylinder_width, center=false);
        }
        
        // Cylinder at other end
        translate([(cylinder_length-cylinder_width)/2, 0, 0]) {
            cylinder(h=0.1, d=cylinder_width, center=false);
        }
    }
}

module cutouts() {
    // Cut out oval shapes from all four sides
    // Long sides (left and right) - vertical ovals
    translate([-base_length/2 + cutout_offset, 0, -1]) {
        scale([1, cutout_length/cutout_width, 1]) {
            cylinder(h=base_thickness + 2, d=cutout_width, center=false);
        }
    }
    translate([base_length/2 - cutout_offset, 0, -1]) {
        scale([1, cutout_length/cutout_width, 1]) {
            cylinder(h=base_thickness + 2, d=cutout_width, center=false);
        }
    }
    
    // Short sides (front and back) - horizontal ovals
    translate([0, -base_width/2 + cutout_offset, -1]) {
        scale([cutout_length/cutout_width, 1, 1]) {
            cylinder(h=base_thickness + 2, d=cutout_width, center=false);
        }
    }
    translate([0, base_width/2 - cutout_offset, -1]) {
        scale([cutout_length/cutout_width, 1, 1]) {
            cylinder(h=base_thickness + 2, d=cutout_width, center=false);
        }
    }
}

module handle_cavity() {
    // Create oval cavity for handle inside cylinder
    hull() {
        // Cylinder at one end
        translate([-(handle_length-handle_width)/2, 0, 0]) {
            cylinder(h=cylinder_height + 1, d=handle_width, center=false);
        }
        
        // Cylinder at other end
        translate([(handle_length-handle_width)/2, 0, 0]) {
            cylinder(h=cylinder_height + 1, d=handle_width, center=false);
        }
    }
}