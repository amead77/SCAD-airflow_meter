/*
openSCAD model to join two cylinders together, one having a box shape for sitting on a flat surface.
two options, as a single piece, or as two pieces with a ring to bolt them together.

*/

$fn = 1024;

// single piece or 2 piece model
part_type = "two piece base"; // ["single piece", "two piece base", "two piece ring"]

// " Model internal view "
cut_model_in_half = false;
model_chop_x = 0; // [-220:5:220]
model_chop_y = 50; // [-220:5:220]


//model chop for print testing. (from simgle piece)
cut_model_top_ring = false;
model_top_ring_chop_z = 50; // [0:1:250]
cut_model_bottom_ring = false;
model_bottom_ring_chop_z = 20; // [0:1:250]

//box part internal cylinder diameter - CHANGE TO FIT TUBE //220.5
box_int_cyl_dia = 80;

//cylinder part internal cylinder diameter - CHANGE TO FIT TUBE //203.4
cyl_int_cyl_dia = 41;

//oversize the box by this much //20
box_oversize = 20;

//external dims of the box part, if internal cylinder dia is changed, change these to suit
box_x = box_int_cyl_dia + box_oversize;
box_y = box_int_cyl_dia + box_oversize;
box_z = 20;

//external dims of the cylinder part, change as needed.
cylinder_dia = cyl_int_cyl_dia + 20;
cylinder_z = 20;


//the join between them length
box_to_cyl_join_z = 20;


//use grub screws in box
box_grub_screws = "false"; //["true", "false"]
//the grub screw are m6, using a heat insert
//change meh
m6_insert_dia = 8.5; 
//leave these
m6_insert_length = 10; 
m6_cyl_insert_hole_len = cylinder_dia - cyl_int_cyl_dia+1;
m6_box_insert_hole_len = box_x - box_int_cyl_dia+1;

//the stopper size to prevent tubes from going in too far
stopper_dia = 0;
stopper_z = 2;
box_inner_stopper_dia = box_int_cyl_dia-stopper_dia;
box_inner_stopper_z = stopper_z;

cylinder_inner_stopper_dia = cyl_int_cyl_dia-stopper_dia;
cylinder_inner_stopper_z = stopper_z;
two_piece_ring_lip = 20;
two_piece_ring_dia = cylinder_dia + two_piece_ring_lip;
two_piece_ring_bolt_pos = two_piece_ring_lip/4; //1/4 of the above 40
two_piece_ring_z = 8;
two_piece_ring_bolt_hole_dia = 6.4;
two_piece_ring_num_holes = 3;
//offset the bolt hole from the edge of the ring
two_piece_ring_bolt_hole_offset = 6;
//put mounting bolts on the box
mounting_bolts = "true"; //["true", "false"]
bolt_dia = 5.2;
bolt_head_dia = 12.5;
bolt_head_length = 80;
bolt_body_length = 80;

module bolt(bolt_dia, bolt_head_dia, bolt_head_length, bolt_body_length) {
    union() {
        cylinder(h = bolt_head_length, d = bolt_head_dia);
        translate([0, 0, bolt_head_length]) {
            cylinder(h = bolt_body_length, d = bolt_dia);
        }
    }
}


module box_part_grubby_screws() {
    if (box_grub_screws == "true") {
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
    for (i = [0:two_piece_ring_num_holes-1]) {
        rotate([0, 0, i*360/two_piece_ring_num_holes]) {
            translate([
                (two_piece_ring_dia / 2)-two_piece_ring_bolt_hole_offset,
                //cylinder_dia/2)+two_piece_ring_bolt_pos+two_piece_ring_bolt_hole_offset, 
                0, 
                -0.001
            ]) {
                rotate([0, 0, 0]) {
                    cylinder(
                        h = two_piece_ring_z+0.002, 
                        d = two_piece_ring_bolt_hole_dia);
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
                    cylinder(
                        h = box_to_cyl_join_z+0.001+box_inner_stopper_z, 
                        d1 = box_int_cyl_dia, 
                        d2 = cyl_int_cyl_dia
                    );
                    cylinder(
                        h = box_to_cyl_join_z+0.001+box_inner_stopper_z, 
                        d1 = box_inner_stopper_dia, 
                        d2 = cylinder_inner_stopper_dia
                    );
                }


                //tube(box_inner_stopper_z, box_int_cyl_dia, box_inner_stopper_dia);
        //    }
        }
        //if (part_type == "two piece ring") {
        //    translate([box_x/2, box_y/2, box_z+box_to_cyl_join_z]) {
        //        tube(cylinder_inner_stopper_z, cyl_int_cyl_dia, cylinder_inner_stopper_dia);
    //    }
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

module insert_bolts() {
    translate([
        bolt_head_dia * 0.75,
        bolt_head_dia * 0.75,
        box_z+(bolt_head_length/2)+(bolt_body_length/2)

    ]) {
        rotate([180, 0, 0]) {
            bolt(bolt_dia, bolt_head_dia, bolt_head_length, bolt_body_length);
        }
    }

    translate([
        box_x-(bolt_head_dia * 0.75),
        (bolt_head_dia * 0.75),
        box_z+(bolt_head_length/2)+(bolt_body_length/2)

    ]) {
        rotate([180, 0, 0]) {
            bolt(bolt_dia, bolt_head_dia, bolt_head_length, bolt_body_length);
        }
    }

    translate([
        box_x-(bolt_head_dia * 0.75),
        box_y-(bolt_head_dia * 0.75),
        box_z+(bolt_head_length/2)+(bolt_body_length/2)

    ]) {
        rotate([180, 0, 0]) {
            bolt(bolt_dia, bolt_head_dia, bolt_head_length, bolt_body_length);
        }
    }  
    
    translate([
        (bolt_head_dia * 0.75),
        box_y-(bolt_head_dia * 0.75),
        box_z+(bolt_head_length/2)+(bolt_body_length/2)

    ]) {
        rotate([180, 0, 0]) {
            bolt(bolt_dia, bolt_head_dia, bolt_head_length, bolt_body_length);
        }
    }        
}


render() {
    //testing here

    //testing end
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

        if (mounting_bolts == "true") {
            insert_bolts();
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