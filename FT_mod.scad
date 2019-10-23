$fn = 16;
mode = "part"; // ["part", "compose"]
part = "magnet holder"; // ["magnet holder", "slice", "electric stage", "????", "cap"]
electric_stuff = false;

function FT_tube_DO() = 26;
function FT_tube_DI() = 21.6;
function FT_tube_T() = 1.6;
function FT_tube_secure_screw() = 22;
function FT_tube_screw_H() = 17;

function magnet_DO() = 19.6;
function magnet_H() = 7;
function magnet_storage_H() = 80;

function slice_thick() = 1.2;

function intern_D() = 16;
function rope_D() = 9.6;

function battery_D() = 18;
function battery_L() = 37;

include <electronic_parts.scad>

module holder2slice_block(block_height,inverted = false) {
    block_rot = 55+((inverted)? -2 : 0);
    block_span = FT_tube_DI()/2+0.2;
    difference() {
        cylinder(d=FT_tube_DI()+((inverted)? 0.1 : 0),h=block_height);
        translate([0,0,-0.1])
        cylinder(d=intern_D()-((inverted)? 0.1 : 0),h=block_height+0.2);
        translate([0,0,-0.1]) {
            rotate([0,0,block_rot])
            cube([block_span,block_span,block_height+0.2]);
            rotate([0,0,-block_rot])
            translate([-block_span,0,0])
            cube([block_span,block_span,block_height+0.2]);
            rotate([0,0,block_rot])
            translate([-block_span,-block_span,0])
            cube([block_span,block_span,block_height+0.2]);
            rotate([0,0,-block_rot])
            translate([0,-block_span,0])
            cube([block_span,block_span,block_height+0.2]);
        }
    }
}

module screws_and_bolts() {
    screw_D = 3;
    bolt_D = 6.6;
    bolt_deep = 1.4;
    rotate([90,30,0])
    union() {
        translate([0,0,(intern_D()+bolt_deep)/-2])
        cylinder(d=bolt_D,h=intern_D()+bolt_deep,$fn=6);
        translate([0,0,FT_tube_DI()/-2-0.1])
        cylinder(d=3,h=FT_tube_DI()+0.2);
    }
}

module magnet_holder() {
    out_part_H = magnet_H()+slice_thick();
    difference() {
        union() {
            cylinder(d=FT_tube_DO(),h=out_part_H+0.1);
            translate([0,0,out_part_H])
            cylinder(d=FT_tube_DI(),h=FT_tube_secure_screw()+0.1);
            translate([0,0,out_part_H+FT_tube_secure_screw()])
            holder2slice_block(magnet_storage_H()-FT_tube_secure_screw());
        }
        translate([0,0,-0.1])
        cylinder(d=magnet_DO(),h=magnet_H()+0.1); // magnet hole
        translate([0,0,magnet_H()-0.1])
        cylinder(d=rope_D(),h=slice_thick()+0.2); // rope eye
        translate([0,0,out_part_H])
        cylinder(d=intern_D(),h=magnet_storage_H()+0.1); // rope storage
        translate([0,0,out_part_H+FT_tube_screw_H()])
        screws_and_bolts();
        //
        //
        //translate([0,0,-0.1])
        //cube([FT_tube_DO(),FT_tube_DO(),FT_tube_DO()]);
        //
    }
}

module slice() {
    difference() {
        cylinder(d=FT_tube_DI(),h=slice_thick()*2);
        translate([0,0,slice_thick()]) {
            holder2slice_block(slice_thick()+0.1,true);
            cylinder(d=intern_D()-slice_thick()*2,h=slice_thick()+0.1);
        }
    }
}

module electric_stage() {
    back_cut_H = 4;
    back_cut_L = 12;
    battery_lvl = back_cut_H+slice_thick();
    battery_open_spanX = 2;
    battery_open_spanZ = 7;
    battery_open_H = battery_L()-battery_open_spanZ;
    total_cyl_length = back_cut_H+slice_thick()*2+battery_L();
    wire_D = 1.7;
    plate_hole_H = 1.5;
    plate_hole_L = 4;
    plate_hole_span = 7;
    support_L = 11.4;
    support_total_L = support_L+slice_thick()*2;
    support_T = 6;
    support_H = 5.8;
    support_span_board = 3.5;
    support_total_H = support_H+support_span_board+slice_thick();
    difference() {
        union() {
            cylinder(d=FT_tube_DI(),h=total_cyl_length);
            translate([slice_thick()-support_T,support_total_L/-2,total_cyl_length-0.1])
            cube([support_T,support_total_L,support_total_H+0.1]);
        }
        translate([FT_tube_DI()/-2-0.1,back_cut_L/-2,-0.1])
        cube([FT_tube_DI()+0.2,back_cut_L,back_cut_H+0.1]); // space for back led and wires
        translate([0,0,battery_lvl])
        cylinder(d=battery_D(),h=battery_L());
        translate([battery_open_spanX,FT_tube_DI()/-2-0.1,battery_lvl+battery_open_spanZ])
        cube([FT_tube_DI()/2+0.1,FT_tube_DI()+0.2,battery_open_H]);
        translate([FT_tube_DI()/-2-0.1,wire_D*-2,back_cut_H-0.1])
        cube([wire_D,wire_D*4,battery_L()+slice_thick()*2+0.2]); // wires tunnel
        translate([plate_hole_span,plate_hole_L/-2,back_cut_H-0.1])
        cube([plate_hole_H,plate_hole_L,battery_L()+slice_thick()*2+0.2]); // plate holes
        translate([slice_thick()-support_T-0.1,support_L/-2,total_cyl_length+support_span_board])
        cube([support_T+0.2,support_L,support_H]);
    }
}

module leds_support() {
    //
    //
}

module cap() {
    out_H = magnet_H()+slice_thick();
    in_ext_H = magnet_H()-slice_thick();
    cut_L = 12;
    cut_H = FT_tube_secure_screw()+slice_thick()*2;
    difference() {
        union() {
            cylinder(d=FT_tube_DO(),h=out_H);
            translate([0,0,out_H-0.1])
            cylinder(d=FT_tube_DI(),h=FT_tube_secure_screw()+0.1);
        }
        translate([0,0,-0.1])
        cylinder(d=intern_D(),h=in_ext_H+0.1);
        translate([0,0,in_ext_H-0.1])
        intersection() {
            cylinder(d=intern_D(),h=cut_H+0.2);
            translate([intern_D()/-2-0.1,cut_L/-2,-0.1])
            cube([intern_D()+0.2,cut_L,cut_H+0.4]);
        }
        translate([0,0,out_H+FT_tube_screw_H()])
        screws_and_bolts();
    }
}

if (mode == "part") {
    if (part == "magnet holder") { magnet_holder(); }
    else if (part == "slice") { slice(); }
    else if (part == "electric stage") {
        electric_stage();
        if (electric_stuff) {
            translate([0,0,6.7]) battery();
            translate([-7,0,49.8]) rotate([0,90,0]) support_board();
            translate([2,0,49.8]) rotate([180,-90,0]) esp8266_01();
            translate([-7,0,57]) shock_sensor();
        }
    }
    //
    //
    else if (part == "cap") { cap(); }
}
else if (mode == "compose") {
    tube_tr = magnet_H()+slice_thick()+0.2;
    color("purple")
    translate([0,0,tube_tr])
    difference() {
        cylinder(d=FT_tube_DO()-0.1,h=300);
        translate([0,0,-0.1])
        cylinder(d=FT_tube_DI()+0.1,h=300.2);
        translate([FT_tube_DO()/-2-0.1,0,-0.1])
        cube([FT_tube_DO()+0.2,FT_tube_DO()/2+0.1,300.2]);
    }
    magnet_holder();
    slice_H = magnet_H()+slice_thick()*2+magnet_storage_H()+0.1;
    translate([0,0,slice_H])
    rotate([180,0,0])
    slice();
    //
    //
    //
    translate([0,0,tube_tr+300+magnet_H()+slice_thick()+0.1])
    rotate([180,0,0])
    cap();
}
