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
var_show_electric_parts =   false;
var_show_esp =              false;

/* [Variations: Nunchaku] */

var_nun_link =              "classic"; // ["classic", "magnetic"]
var_nun_storage_length =    80; // [30:300]

/* [Variations: Staff] */

var_staff_link_length =     200; // [30:500]

// ####################################
// MODULES ############################
// ####################################

include <Thread_Library.scad>
include <electronic_parts.scad>

// ####################################
// GLOBAL PARAMETERS ##################
// ####################################

function d_ext() = 24;
function d_tube_ext() = 20.6;
function d_tube_int() = 16;
function h_tube_cover() = 15;
function d_intern() = 16;
function d_rope() = 9.6;
function h_top() = 10;
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

function d_electric_stage() = 18.5;

// ####################################
// HELPERS ############################
// ####################################

function part_show(v) = compose == "none" && v;

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
    h_rope_stop = h_magnet()+slice_thickness();
    difference() {
        union() {
            cylinder(d=d_ext(),h=h_top()+0.01);
            translate([0,0,h_top()])
            thread_1();
        }
        translate([0,0,h_rope_stop])
        cylinder(d=d_intern(),h=generic_top_length()-h_rope_stop+0.1); // intern hole
        translate([0,0,-0.1])
        cylinder(d=d_rope(),h=h_rope_stop+0.2); // rope hole
        if (eclate_generic_top) {
            translate([0,0,-0.1])
            cube([d_ext()/2+0.1,d_ext()/2+0.1,generic_top_length()+0.2]);
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

function generic_top_length() = h_top()+thread_length_1();

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

// ELECTRIC STAGE #####################

module electric_stage() {
    difference() {
        union() {
            //
            // TODO : basic cylindric shape
            // TODO : stop ring
            // TODO : support board casing
            //
            // TEST PURPOSE ==========================
            // =======================================
            //
            cylinder(d=18.5,h=20);
            translate([0,0,19.9])
            thread_1();
            translate([0,0,19.9+thread_length_1()])
            cylinder(d=d_ext(),h=10);
            //
        }
        //
        //
    }
    if (var_show_electric_parts) {
        translate([0,0,5]) rotate([180,0,0]) slide_switch();
        //
        translate([-30,30,0])
        support_board();
        //
        translate([-30,0,0])
        battery();
        //
        // TEST PURPOSE ==========================
        // =======================================
        translate([0,30,0])
        shock_sensor();
        //
        translate([0,40,0])
        esp8266_01();
        //
    }
}

function electric_stage_length() = 0;

if (part_show(show_electric_stage)) { electric_stage(); }

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
        translate([0,d_ext()/2,thread_length_1()+slice_thickness()+h_tube_cover()/2])
        rotate([90,0,0])
        color("#aaf")
        pin();
        translate([0,d_ext()/2,tail_length()-3*slice_thickness()-h_tube_cover()/2+0.2])
        rotate([90,0,0])
        color("#aaf")
        pin();
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
    rotate([90,0,90])
    color("#faa")
    if (var_nun_link == "classic") { classic_top(); }
    else if (var_nun_link == "magnetic") { magnet_top(); }
    translate([female_connect_length()+h_top()+0.1,0,0])
    rotate([0,-90,0])
    color("#faa")
    female_connect_hole();
    global_top = h_top()+female_connect_length();
    global_tube = global_top+var_nun_storage_length;
    translate([global_top-h_tube_cover()+0.2,0,0])
    rotate([0,90,0])
    tube(var_nun_storage_length);
    translate([global_tube-2*h_tube_cover()+0.3,0,0])
    rotate([90,0,90])
    color("#faa")
    female_connect_stop();
    translate([global_top-h_tube_cover()/2+0.1,0,d_ext()/2])
    rotate([180,0,0])
    color("#ffa")
    pin();
    translate([global_tube-1.5*h_tube_cover()+0.3,d_ext()/2,0])
    rotate([90,0,0])
    color("#ffa")
    pin();
    global_base = global_tube+female_connect_length()-2*h_tube_cover();
    translate([global_base-thread_length_1()+0.4,0,0])
    rotate([90,0,90])
    compose_tail();
    echo("######## TOTAL LENGTH ########");
    echo(global_base+tail_length()-thread_length_1());
    echo("##############################");
}

// STAFF COMPOSE ######################

if (compose == "staff") {
    translate([var_staff_link_length/-2,0,0])
    rotate([0,90,0])
    tube(var_staff_link_length);
    half_tube = var_staff_link_length/2-h_tube_cover();
    translate([half_tube+0.1,0,0])
    rotate([90,0,90])
    color("#faa")
    female_connect_hole();
    translate([-half_tube-0.1,0,0])
    rotate([0,-90,0])
    color("#faa")
    female_connect_hole();
    translate([var_staff_link_length/2-h_tube_cover()/2+0.1,d_ext()/2,0])
    rotate([90,0,0])
    color("#ffa")
    pin();
    translate([var_staff_link_length/-2+h_tube_cover()/2-0.1,0,d_ext()/2])
    rotate([180,0,0])
    color("#ffa")
    pin();
    translate([half_tube+female_connect_length()-thread_length_1()+0.2,0,0])
    rotate([90,0,90])
    compose_tail();
    translate([-half_tube-female_connect_length()+thread_length_1()-0.2,0,0])
    rotate([0,-90,0])
    compose_tail();
    echo("######## TOTAL LENGTH ########");
    echo(2*(half_tube+female_connect_length()+tail_length()-thread_length_1()));
    echo("##############################");
}
