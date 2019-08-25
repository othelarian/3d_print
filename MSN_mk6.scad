// ####################################
// INPUTS #############################
// ####################################

compose =                   "none"; // ["none", "nunchaku", "staff"]
$fn =                       16; // 100~150

/* [Separate show] */

show_pin =                  false;
show_classic_top =          false;
show_magnet_top =           false;
show_classic_cap =          false;
show_electric_cap =         false; // WAIT
show_male_connect =         false; // WAIT
show_female_connect_hole =  false; // WAIT
show_female_connect_stop =  false; // WAIT
show_electric_stage =       false; // WAIT

// TODO : classic leds support
// TODO : esp leds classic support
// TODO : esp leds saber hilt support

/* [Eclate] */

eclate_generic_top =        false;
eclate_classic_cap =        false;

/* [Variations: Generic] */

//var_gen_

// TODO : length of the tail

/* [Variations: Nunchaku] */

var_nun_link =              "classic"; // ["classic", "magnetic"]

// ####################################
// MODULES ############################
// ####################################

include <Thread_Library.scad>

// ####################################
// GLOBAL PARAMETERS ##################
// ####################################

function d_ext() = 24;
function d_tube_ext() = 20.6;
function d_tube_int() = 16;
function h_tube_cover() = 15;
function d_intern() = 16;
function d_rope() = 9.6;
function d_magnet() = 19.6;
function h_magnet() = 7;
function d_pin_base() = 4;
function h_pin_base() = 0.8;
function d_pin_top() = 2;
function h_pin_top() = 3;
function slice_thickness() = 1.2;
function thread_radius_1() = 10;
function thread_length_1() = 8;
function thread_pitch_1() = 2.4;
function h_th_correction() = 10.2;
function d_th_correction() = 17.4;

// ####################################
// HELPERS ############################
// ####################################

function part_show(v) = compose == "none" && v;

module chamfer(d_out,d_in) {
    gap = (d_out-d_in)/2;
    difference() {
        cylinder(d=d_out,h=gap);
        translate([0,0,-0.01]) cylinder(d1=d_in,d2=d_out,h=gap+0.02);
    }
}

// ####################################
// PARTS ##############################
// ####################################

// PIN ################################

module pin() {
    union() {
        cylinder(d=d_pin_base(),h_pin_base());
        translate([0,0,h_pin_base()-0.1])
        cylinder(d=d_pin_top(),h=h_pin_top()+0.1);
    }
}

if (part_show(show_pin)) { pin(); }

// TOPS ###############################

module classic_top() {
    h_top = 10;
    chamfer_top = d_ext()-2;
    h_rope_stop = h_magnet()+slice_thickness();
    h_total = h_top+thread_length_1();
    difference() {
        union() {
            cylinder(d=d_ext(),h=h_top+0.01);
            translate([0,0,h_top])
            trapezoidThread(
                length=thread_length_1(),
                pitch=thread_pitch_1(),
                pitchRadius=thread_radius_1(),
                stepsPerTurn=$fn
            );
        }
        translate([0,0,h_rope_stop])
        cylinder(d=d_intern(),h=h_total-h_rope_stop+0.1);
        translate([0,0,-0.1])
        cylinder(d=d_rope(),h=h_rope_stop+0.2);
        translate([0,0,-0.01]) chamfer(d_ext()+0.01,chamfer_top);
        if (eclate_generic_top) {
            translate([0,0,-0.1])
            cube([d_ext()/2+0.1,d_ext()/2+0.1,h_total+0.2]);
        }
    }
}

module magnet_top() {
    difference() {
        classic_top();
        translate([0,0,-0.1])
        cylinder(d=d_magnet(),h=h_magnet()+0.1);
    }
}

if (part_show(show_classic_top || show_magnet_top)) {
    if (show_classic_top) { classic_top(); }
    else if (show_magnet_top) { magnet_top(); }
}

// CAPS ###############################

module classic_cap() {
    difference() {
        t_top_cap = 2*slice_thickness();
        union() {
            cylinder(d1=d_ext()-t_top_cap*2,d2=d_ext(),h=t_top_cap);
            translate([0,0,t_top_cap-0.01])
            cylinder(d=d_ext(),h=h_tube_cover()+slice_thickness()+0.01);
        }
        translate([0,0,t_top_cap+slice_thickness()])
        cylinder(d=d_tube_ext(),h=h_tube_cover()+0.1);
        translate([d_ext()/2,0,3*slice_thickness()+h_tube_cover()/2])
        rotate([0,-90,0])
        scale([1.2,1.2,1])
        pin();
        if (eclate_classic_cap) {
            translate([0,0,-0.1])
            cube([d_ext()/2+0.1,d_ext()/2+0.1,3*slice_thickness()+h_tube_cover()+0.2]);
        }
    }
}

module electric_cap() {
    //
    //
    //
}

if (part_show(show_classic_cap || show_electric_cap)) {
    if (show_classic_cap) { classic_cap(); }
    else if (show_electric_cap) { electric_cap(); }
}

// MALE CONNECTOR #####################

module male_connect() {
    //
    //
}

if (part_show(show_male_connect)) { male_connect(); }

// FEMALE CONNECTOR WITH HOLE #########

// FEMALE CONNECTOR WITH STOP #########

// ####################################
// COMPOSE ############################
// ####################################

// COMPOSE TAIL #######################

module compose_tail() {
    //
    //
}

// NUNCHUK COMPOSE ####################

if (compose == "nunchaku") {
    //
    //
}

// STAFF COMPOSE ######################

if (compose == "staff") {
    //
    //
}
