$fn = 64;

// " Model internal view "
cut_model_in_half = true;
model_chop_x = 110; // [-220:5:220]
model_chop_y = 0; // [-220:5:220]

cut_model_top_ring = false;
model_top_ring_chop_z = 50; // [0:1:250]
cut_model_bottom_ring = false;
model_bottom_ring_chop_z = 20; // [0:1:250]

//external dims of the box part, if internal cylinder dia is changed, change these to suit
box_x = 220;
box_y = 220;
box_z = 50;

//external dims of the cylinder part, change as needed.
cylinder_dia = 190;
cylinder_z = 50;

//box part internal cylinder diameter - CHANGE TO FIT TUBE
box_int_cyl_dia = 195;

//cylinder part internal cylinder diameter - CHANGE TO FIT TUBE
cyl_int_cyl_dia = 170;

//the join between them length
box_to_cyl_join_z = 10;

//the grub screw are m6, using a heat insert
//change meh
m6_insert_dia = 8.5; 
//leave these
m6_insert_length = 10; 
m6_cyl_insert_hole_len = cylinder_dia - cyl_int_cyl_dia+1;
m6_box_insert_hole_len = box_x - box_int_cyl_dia+1;

module box_part_grubby_screws() {
    translate([box_x/2, box_y/2, box_z/2]) {
        for (i = [0:3]) {
            rotate([0, 0, i*90]) {
                translate([box_x/2-m6_box_insert_hole_len/2, 0, 0]) {
                    rotate([0, 90, 0]) {
                        cylinder(h = m6_box_insert_hole_len, d = m6_insert_dia);
                    }
                }
            }
        }
    }
}

module box(x, y, z, id) {
    difference() {
        cube([x, y, z]);
        translate([x/2, y/2, 0]) {
            cylinder(h = z, d = id);
        }
        box_part_grubby_screws();
    }


}

module cylinder_part_grubby_screws() {
    for (i = [0:3]) {
        rotate([0, 0, i*90]) {
            translate([cylinder_dia/2- m6_cyl_insert_hole_len, 0, cylinder_z/2]) {
                rotate([0, 90, 0]) {
                    cylinder(h = m6_cyl_insert_hole_len, d = m6_insert_dia);
                }
            }
        }
    }
}


module cylinder_part(height, od, id) {
    difference() {
        cylinder(h = height, d = od);
        cylinder(h = height, d = id);
        cylinder_part_grubby_screws();
    }
}

module loft_part() {
    difference() {
        hull() {
            translate([0, 0, box_z]) {
                cube([box_x, box_y, 0.001]);
            }
            translate([box_x/2, box_y/2, box_z+box_to_cyl_join_z]) {
                cylinder(h = 0.001, d = cylinder_dia);
            }
        }
        translate([box_x/2, box_y/2, box_z]) {
            cylinder(h = box_to_cyl_join_z+0.001, d1 = box_int_cyl_dia, d2 = cyl_int_cyl_dia);
        }
    }
}

module part_join() {
    box(box_x, box_y, box_z, box_int_cyl_dia);
    translate([box_x/2, box_y/2, box_z+box_to_cyl_join_z]) {
        cylinder_part(cylinder_z, cylinder_dia, cyl_int_cyl_dia);
    }
}



render() {
    difference() {
        union() {
            loft_part();
            part_join();
        }
        if (cut_model_in_half) {
            translate([model_chop_x, model_chop_y, 0]) {
                cube([box_x+10, box_y+10, 1000]);
            }
        } else {
            if (cut_model_bottom_ring) {
                translate([0, 0, model_bottom_ring_chop_z]) {
                    cube([box_x+10, box_y+10, 1000]);
                }
            }
            if (cut_model_top_ring) {
                translate([0, 0, 0]) {
                    cube([box_x+10, box_y+10, model_top_ring_chop_z]);
                }
            }

        }
    }
}