/*
openSCAD model to join two cylinders together, one having a box shape for sitting on a flat surface.
two options, as a single piece, or as two pieces with a ring to bolt them together.

*/

$fn = 1024;

// single piece or 2 piece model
part_type = "single piece"; // ["single piece", "two piece base", "two piece ring"]

// " Model internal view "
cut_model_in_half = true;
model_chop_x = 110; // [-220:5:220]
model_chop_y = 50; // [-220:5:220]


//model chop for print testing. (from simgle piece)
cut_model_top_ring = false;
model_top_ring_chop_z = 50; // [0:1:250]
cut_model_bottom_ring = false;
model_bottom_ring_chop_z = 20; // [0:1:250]

//box part internal cylinder diameter - CHANGE TO FIT TUBE
box_int_cyl_dia = 110.25 * 2;

//cylinder part internal cylinder diameter - CHANGE TO FIT TUBE
cyl_int_cyl_dia = 102.7 * 2;

//oversize the box by this much
box_oversize = 20;

//external dims of the box part, if internal cylinder dia is changed, change these to suit
box_x = box_int_cyl_dia + box_oversize;
box_y = box_int_cyl_dia + box_oversize;
box_z = 50;

//external dims of the cylinder part, change as needed.
cylinder_dia = cyl_int_cyl_dia + 20;
cylinder_z = 50;


//the join between them length
box_to_cyl_join_z = 20;

//the grub screw are m6, using a heat insert
//change meh
m6_insert_dia = 8.5; 
//leave these
m6_insert_length = 10; 
m6_cyl_insert_hole_len = cylinder_dia - cyl_int_cyl_dia+1;
m6_box_insert_hole_len = box_x - box_int_cyl_dia+1;

//the stopper size to prevent tubes from going in too far
stopper_dia = 14;
stopper_z = 4;
box_inner_stopper_dia = box_int_cyl_dia-stopper_dia;
box_inner_stopper_z = stopper_z;

cylinder_inner_stopper_dia = cyl_int_cyl_dia-stopper_dia;
cylinder_inner_stopper_z = stopper_z;
two_piece_ring_lip = 40;
two_piece_ring_dia = cylinder_dia + two_piece_ring_lip;
two_piece_ring_bolt_pos = two_piece_ring_lip/4; //1/4 of the above 40
two_piece_ring_z = 8;
two_piece_ring_bolt_hole_dia = 10;
//offset the bolt hole from the edge of the ring
two_piece_ring_bolt_hole_offset = 0;

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

module two_piece_bolt_holes() {
    for (i = [0:7]) {
        rotate([0, 0, i*90]) {
            translate([(cylinder_dia/2)+two_piece_ring_bolt_pos+two_piece_ring_bolt_hole_offset, 0, -0.001]) {
                rotate([0, 0, 0]) {
                    cylinder(h = two_piece_ring_z+0.002, d = two_piece_ring_bolt_hole_dia);
                }
            }
        }
    }
}

module tube(height, od, id) {
    difference() {
        cylinder(h = height, d = od);
        cylinder(h = height, d = id);
    }
}

module two_piece_ring() {
    difference() {
        tube(two_piece_ring_z, two_piece_ring_dia, cylinder_dia);
        two_piece_bolt_holes();
    }
}

module inner_stopper() {
    color("red") {
        //if ((part_type == "two piece base") || (part_type == "two piece ring")) {
            translate([box_x/2, box_y/2, box_z]) {
                difference() {
                cylinder(h = box_to_cyl_join_z+0.001, d1 = box_int_cyl_dia, d2 = cyl_int_cyl_dia);
                cylinder(h = box_to_cyl_join_z+0.001+box_inner_stopper_z, d1 = box_int_cyl_dia, d2 = cylinder_inner_stopper_dia);
                }


                //tube(box_inner_stopper_z, box_int_cyl_dia, box_inner_stopper_dia);
        //    }
        }
        if (part_type == "single piece") {
            translate([box_x/2, box_y/2, box_z+box_to_cyl_join_z]) {
                tube(cylinder_inner_stopper_z, cyl_int_cyl_dia, cylinder_inner_stopper_dia);
                

            }
        }
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
    union() {
        box(box_x, box_y, box_z, box_int_cyl_dia);
        translate([box_x/2, box_y/2, box_z+box_to_cyl_join_z]) {
            difference() {
                tube(cylinder_z, cylinder_dia, cyl_int_cyl_dia);
                if ((part_type == "single piece") || (part_type == "two piece ring")){
                    cylinder_part_grubby_screws();
                }
        
            }
        }
    }
}




render() {
    difference() {

        if (part_type == "single piece") {
                union() {
                    loft_part();
                    part_join();
                    inner_stopper();
                }

        }


        if (part_type == "two piece base") {
            union() {
                loft_part();
                part_join();
                inner_stopper();
                translate([box_x/2, box_y/2, box_z+box_to_cyl_join_z+cylinder_z+0.001-two_piece_ring_z]) {
                    two_piece_ring();

                }
            }
        }


        if (part_type == "two piece ring") {
            difference() {
                union() {
                    loft_part();
                    part_join();
                    translate([box_x/2, box_y/2, box_z+box_to_cyl_join_z+cylinder_z+0.001-two_piece_ring_z]) {
                        two_piece_ring();

                    }
                }

                cube([box_x+10, box_y+10, box_z+box_to_cyl_join_z+0.001]);
            }
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