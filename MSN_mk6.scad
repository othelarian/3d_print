// ####################################
// INPUTS #############################
// ####################################

compose =                   "none"; // ["none", "tail", "nunchaku", "staff"]
$fn =                       16; // 100~150

/* [Separate show] */

show_pin =                  false;
show_classic_top =          false;
show_magnet_top =           false;
show_classic_cap =          false;
show_electric_cap =         false; // WAIT
show_male_connect =         false;
show_female_connect_hole =  false;
show_female_connect_stop =  false;
show_electric_stage =       false; // WAIT
show_electric_connector =   false; // WAIT
show_classic_leds_support = false; // WAIT
show_classic_leds_hull =    false; // WAIT

// TODO : esp leds classic support

//show_esp_leds_support =     false; // WAIT

// TODO : esp leds saber hilt support

//show_saber_support =

/* [Eclate] */

eclate_generic_top =        false;
eclate_classic_cap =        false;

//eclate_electric_cap =       false;

eclate_generic_connect =    false;

/* [Variations: Generic] */

var_gen_tube_length =       200; // [30:400]
var_gen_mode =              "training"; // ["training", "led", "esp", "saber"]

/* [Variations: Nunchaku] */

var_nun_link =              "classic"; // ["classic", "magnetic"]

/* [Variations: Staff] */

var_staff_link_length =     200; // [30:500]

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
function d_stop() = 8;
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

module tube(h_tube) {
    $fn = 16;
    color("white")
    difference() {
        cylinder(d=d_tube_ext(),h=h_tube);
        translate([0,0,-0.1]) cylinder(d=d_tube_int(),h=h_tube+0.2);
    }
}

module thread_1() {
    trapezoidThread(
        length=thread_length_1(),
        pitch=thread_pitch_1(),
        pitchRadius=thread_radius_1(),
        stepsPerTurn=$fn
    );
}

module thread_negative_1() {
    trapezoidThreadNegativeSpace(
        length=thread_length_1(),
        pitch=thread_pitch_1(),
        pitchRadius=thread_radius_1(),
        stepsPerTurn=$fn
    );
    cylinder(d=d_th_correction(),h=h_th_correction(),center=false); // thread correction
}

module pin_hole(h_hole) {
    translate([d_ext()/2,0,h_hole]) rotate([0,-90,0]) scale([1.2,1.2,1]) pin();
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
            thread_1();
        }
        translate([0,0,h_rope_stop])
        cylinder(d=d_intern(),h=h_total-h_rope_stop+0.1); // intern hole
        translate([0,0,-0.1])
        cylinder(d=d_rope(),h=h_rope_stop+0.2); // rope hole
        translate([0,0,-0.01]) chamfer(d_ext()+0.01,chamfer_top); // chamfer
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

if (part_show(show_classic_top)) { classic_top(); }
if (part_show(show_magnet_top)) { magnet_top(); }

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
        pin_hole(3*slice_thickness()+h_tube_cover()/2);
        if (eclate_classic_cap) {
            translate([0,0,-0.1])
            cube([d_ext()/2+0.1,d_ext()/2+0.1,3*slice_thickness()+h_tube_cover()+0.2]);
        }
    }
}

function classic_cap_length() = h_tube_cover()+3*slice_thickness();

module electric_cap() {
    //
    //
    //
}

if (part_show(show_classic_cap)) { classic_cap(); }
if (part_show(show_electric_cap)) { electric_cap(); }

// CONNECTORS #########################

module male_connect() {
    difference() {
        union() {
            cylinder(d=d_ext(),h=h_tube_cover()+slice_thickness()+0.01);
            translate([0,0,h_tube_cover()+slice_thickness()])
            thread_1();
        }
        translate([0,0,-0.1])
        cylinder(d=d_tube_ext(),h=h_tube_cover()+0.1);
        translate([0,0,h_tube_cover()-0.1])
        cylinder(d=d_intern(),h=thread_length_1()+slice_thickness()+0.2);
        pin_hole(h_tube_cover()/2);
        if (eclate_generic_connect) {
            total_length = h_tube_cover()+slice_thickness()+thread_length_1();
            translate([0,0,-0.1])
            cube([d_ext()/2+0.1,d_ext()/2+0.1,total_length+0.2]);
        }
    }
}

function male_connect_length() = h_tube_cover()+slice_thickness()+thread_length_1();

module female_connect_generic() {
    difference() {
        cylinder(d=d_ext(),h=female_connect_length());
        translate([0,0,female_connect_length()])
        rotate([180,0,0])
        thread_negative_1();
        translate([0,0,-0.1])
        cylinder(d=d_tube_ext(),h=h_tube_cover()+0.1);
        pin_hole(h_tube_cover()/2);
        if (eclate_generic_connect) {
            translate([0,0,-0.1])
            cube([d_ext()/2+0.1,d_ext()/2+0.1,female_connect_length()+0.2]);
        }
    }
}

function female_connect_length() = thread_length_1()+thread_pitch_1()+slice_thickness()+h_tube_cover();


module female_connect_hole() {
    difference() {
        female_connect_generic();
        translate([0,0,h_tube_cover()-0.1])
        cylinder(d=d_tube_int(),h=slice_thickness()+0.2);
    }
}

module female_connect_stop() {
    difference() {
        female_connect_generic();
        translate([0,0,h_tube_cover()-0.1])
        cylinder(d=d_stop(),h=slice_thickness()+0.2);
    }
}

if (part_show(show_male_connect)) { male_connect(); }
if (part_show(show_female_connect_hole)) { female_connect_hole(); }
if (part_show(show_female_connect_stop)) { female_connect_stop(); }

// ####################################
// COMPOSE ############################
// ####################################

// COMPOSE TAIL #######################

module compose_tail() {
    if (var_gen_mode == "training") {
        translate([0,0,male_connect_length()])
        rotate([180,0,90])
        color("#afa")
        male_connect();
        translate([0,0,male_connect_length()-h_tube_cover()+0.1])
        tube(var_gen_tube_length);
        connector_and_tube_length = male_connect_length()+var_gen_tube_length;
        translate([0,0,connector_and_tube_length+classic_cap_length()-2*h_tube_cover()+0.2])
        rotate([180,0,90])
        color("#afa")
        classic_cap();
        //
        // TODO : add pins (two missing)
        //
    }
    else if (var_gen_mode == "led") {
        //
        //
    }
    else if (var_gen_mode == "esp") {
        //
        //
    }
    else if (var_gen_mode == "saber") {
        //
        //
    }
}

function tail_length() =
    (var_gen_mode == "training")
    ? male_connect_length()+var_gen_tube_length+classic_cap_length()-2*h_tube_cover()
    : (var_gen_mode == "led")
    ? 0
    : 0
;

if (compose == "tail") {
    compose_tail();
    echo("######## TAIL LENGTH #########");
    echo(tail_length());
    echo("##############################");
}

// NUNCHUK COMPOSE ####################

if (compose == "nunchaku") {
    //
    // TODO : add top
    // TODO : add switch for magnet vs classic
    // TODO : add rope storage
    //
    //translate([])
    compose_tail();
    //
    //
    echo("######## TOTAL LENGTH ########");
    echo("Not calculated yet");
    echo("##############################");
}

// STAFF COMPOSE ######################

if (compose == "staff") {
    // central tube for the link
    translate([var_staff_link_length/-2,0,0])
    rotate([0,90,0])
    tube(var_staff_link_length);
    // connectors
    translate([var_staff_link_length/2-h_tube_cover()+0.1,0,0])
    rotate([90,0,90])
    female_connect_hole();
    translate([var_staff_link_length/-2+h_tube_cover()+0.1,0,0])
    rotate([0,-90,0])
    female_connect_hole();
    // tails
    //
    translate([var_staff_link_length/2+slice_thickness(),0,0])
    rotate([90,0,90])
    compose_tail();
    //
    //
    //compose_tail();
    //
    //
    echo("######## TOTAL LENGTH ########");
    echo(var_staff_link_length+2*slice_thickness()+2*tail_length());
    echo("##############################");
}
