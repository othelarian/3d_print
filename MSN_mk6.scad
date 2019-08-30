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
show_male_connect =         false;
show_female_connect_hole =  false;
show_female_connect_stop =  false;

show_electric_cap =         false; // WAIT
show_electric_stage =       false; // WIP
show_electric_lock =        false; // WIP
show_electric_switch =      false; // WIP

show_leds_support =         false; // WAIT
show_leds_hull =            false; // WAIT

/* [Eclate] */

eclate_generic_top =        false;
eclate_classic_cap =        false;
eclate_generic_connect =    false;

eclate_electric_cap =       false;
eclate_electric_stage =     false;
//eclate_electric_lock =      false;

/* [Variations: Generic] */

var_gen_tube_length =       200; // [30:400]
var_gen_mode =              "training"; // ["training", "esp", "saber", "none"]
var_show_electric_parts =   false;
var_show_esp =              false;

/* [Variations: Nunchaku] */

var_nun_link =              "classic"; // ["classic", "magnetic"]
var_nun_storage_length =    80; // [30:300]

/* [Variations: Staff] */

var_staff_link_length =     250; // [30:500]

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
function v_gap() = 0.8;

function thread_radius_1() = 10;
function thread_length_1() = 8;
function thread_pitch_1() = 2.4;
function h_th_correction() = 10.2;
function d_th_correction() = 17.4;

function d_electric_stage() = 18.5;
function d_electric_ring() = 22;
function v_support_board() = -2;
function l_support_board() = 11.4; // real length: 10.7
function t_support_board() = 6; // real height / thickness: 8.5
function h_support_board() = 5.8; // real thickness / height: 5
function d_battery() = 17;
function h_battery() = 38;
function l_plate_pin() = 4;
function h_plate_pin() = 1;
function t_wire_well() = 1.6;
function v_wire_well() = -10.6;
function h_lock_guide() = 6;
function t_lock_guide() = 6;
//
function h_lock() = 10;
//
function t_handles() = 0.5;
function h_handles() = 6;
//

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

module thread_1(double = false) {
    trapezoidThread(
        length=thread_length_1()*(double? 2 : 1),
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

if (part_show(show_classic_cap)) { classic_cap(); }

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

module female_connect_stop() {
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

module female_connect_hole() {
    difference() {
        female_connect_stop();
        translate([0,0,h_tube_cover()-0.1])
        cylinder(d=d_tube_int(),h=slice_thickness()+0.2);
    }
}

function female_connect_length() = thread_length_1()+thread_pitch_1()+slice_thickness()+h_tube_cover();

if (part_show(show_male_connect)) { male_connect(); }
if (part_show(show_female_connect_hole)) { female_connect_hole(); }
if (part_show(show_female_connect_stop)) { female_connect_stop(); }

// ELECTRIC PARTS #####################

module electric_cap() {
    difference() {
        union() {
            //
            // TODO : chamfered base
            // TODO : main block
            //
        }
        //
        // TODO : switch hole
        // TODO : cap locking hole
        // TODO : threaded zone
        // TODO : slick zone
        //
    }
}

function electric_cap_length() = 0;

module electric_stage() {
    difference() {
        union() {
            translate([
                t_support_board()/-2+v_support_board(),
                l_support_board()/-2-slice_thickness(),
                0
            ])
            cube([
                t_support_board(), //h
                l_support_board()+2*slice_thickness(), //l
                h_support_board()+4*slice_thickness()+0.1 //t
            ]);
            //
            s_tube_length = h_battery()+2*slice_thickness()-thread_length_1();
            //
            translate([0,0,h_support_board()+4*slice_thickness()])
            cylinder(d=d_tube_ext(),h=s_tube_length       -15         +0.1);
            //
            //
            translate([0,0,h_support_board()+4*slice_thickness()+s_tube_length     -15    ])
            cylinder(d=d_ext(),h=     15      );
            //
            //
            translate([0,0,h_support_board()+6*slice_thickness()+h_battery()-thread_length_1()])
            thread_1();
        }
        translate([t_support_board()/-2+v_support_board()-0.1,l_support_board()/-2,slice_thickness()])
        cube([t_support_board()+0.2,l_support_board(),h_support_board()]);
        translate([
            l_plate_pin()/-2,
            l_support_board()/2+slice_thickness(),
            h_support_board()+4*slice_thickness()-0.1
        ])
        cube([l_plate_pin(),h_plate_pin(),slice_thickness()+0.2]);
        translate([t_wire_well()/-2,v_wire_well(),h_support_board()+4*slice_thickness()-0.1])
        cube([t_wire_well(),1.5*t_wire_well(),h_battery()+2*slice_thickness()+0.2]);
        translate([0,0,h_support_board()+5*slice_thickness()-0.1])
        cylinder(d=d_battery(),h=h_battery()+slice_thickness()+0.2);
        translate([t_lock_guide()/-2,0,h_battery()+11*slice_thickness()-h_lock_guide()])
        cube([t_lock_guide(),d_ext()/2,h_lock_guide()+0.1]);
        translate([0,0,h_support_board()+8*slice_thickness()])
        difference() {
            cylinder(d=d_tube_ext()+0.1,h=2*slice_thickness());
            translate([0,0,-0.1])
            cylinder(d=d_tube_ext()-slice_thickness(),h=2*slice_thickness()+0.2);
        }
        if (eclate_electric_stage) {
            translate([0,0,h_support_board()+4*slice_thickness()-0.1])
            cube([d_ext()/2,d_ext()/2,h_battery()+2*slice_thickness()+0.2]);
        }
    }
    if (var_show_electric_parts) {
        translate([-2,0,0]) {
            translate([-5,0,slice_thickness()+h_support_board()/2])
            rotate([0,90,0])
            support_board();
            translate([4,0,slice_thickness()+h_support_board()/2])
            rotate([0,90,0])
            esp8266_01();
            translate([0,0,-2])
            rotate([0,180,0])
            shock_sensor();
        }
        translate([0,0,h_support_board()+6*slice_thickness()+0.1])
        battery();
    }
}

function electric_stage_length() = h_support_board()+6*slice_thickness()+h_battery();

module electric_lock() {
    s_t_lock_guide = t_lock_guide()-v_gap();
    s_d_electric_stage = d_electric_stage()-v_gap();
    difference() {
        union() {
            cylinder(d=s_d_electric_stage-slice_thickness(),h=slice_thickness());
            intersection() {
                cylinder(d=d_electric_stage(),h=h_lock_guide());
                translate([s_t_lock_guide/-2,0,0])
                cube([s_t_lock_guide,d_electric_stage(),h_lock_guide()-v_gap()]);
            }
        }
        translate([0,0,slice_thickness()])
        cylinder(d=d_electric_stage()-slice_thickness(),h=h_lock_guide()-slice_thickness()+0.1);
        translate([l_plate_pin()/-2,(s_d_electric_stage-slice_thickness())/-2,-0.1])
        cube([l_plate_pin(),h_plate_pin(),slice_thickness()+0.2]);
    }
}

function electric_lock_length() = h_lock_guide();

module electric_switch() {

    difference() {
        union() {
            //
            // TODO : plain base (top)
            //
            cylinder(d=d_electric_stage(),h=h_lock());
            //
            /*
    e_plaque_interrupteur = 0.6; // 0.2 de marge
    e_interrupteur = 6.2; // idem, 0.4 (0.2*2) de marge
    l_interrupteur = 11.2; // 0.5 de marge
            */
            //
            // TODO : intersection for the switch lock guide?
            //
            //
        }
        //
        // TODO : radial cut
        // TODO : switch casing hole
        //
        //
        //
        translate([h_handles()/-2,d_electric_stage()/-2,-0.1])
        cube([h_handles(),d_electric_stage(),t_handles()+0.1]);
        //
        // TODO : plate pin hole
        // TODO : wire cut
        //
        //
        if (eclate_electric_lock) {
            //
            translate([0,0,-0.1])
            cube([d_ext()/2+0.1,d_ext()/2+0.1,h_lock()                +0.2]);
            //
        }
        //
    }
    if (var_show_electric_parts) { translate([0,0,5]) rotate([0,180,90]) slide_switch(); }
}

function electric_switch_length() = 0;

if (part_show(show_electric_cap)) { electric_cap(); }
if (part_show(show_electric_stage)) { electric_stage(); }
if (part_show(show_electric_lock)) { electric_lock(); }
if (part_show(show_electric_switch)) { electric_switch(); }

// LEDS PARTS #########################

module leds_support() {
    //
    //
}

function leds_support_length() = 0;

module leds_hull() {
    //
    //
    //
}

function leds_hull_length() = 0;

if (part_show(show_leds_support)) { leds_support(); }
if (part_show(show_leds_hull)) { leds_hull(); }

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
    else if (var_gen_mode == "esp") {
        electric_lock();
        //
        translate([0,0,electric_stage_length()])
        rotate([180,0,180])
        electric_stage();
        //
        //
        // ==========================
        // TEST PURPOSE =============
        // ==========================
        //
        translate([0,0,-h_tube_cover()-slice_thickness()-0.1])
        female_connect_hole();
        //
        translate([0,30,-h_tube_cover()-slice_thickness()-0.1])
        male_connect();
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
    : (var_gen_mode == "esp")
    ? 0
    : (var_gen_mode == "saber")
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
