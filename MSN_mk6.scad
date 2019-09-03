// ####################################
// INPUTS #############################
// ####################################

compose =                   "none"; // ["none", "single part", "tail", "nunchaku", "staff"]
$fn =                       16; // 100~150

/* [Variations: Generic] */

var_tail_tube_length =      200; // [30:400]
var_exterior_thickness =    24; // [24:30]
var_tail_mode =             "training"; // ["training", "esp", "saber", "none"]
var_selected_part =         "pin"; // ["pin", "classic top", "magnetic top", "cap", "connector", "electric"]
var_connector_type =        "male"; // ["male", "female hole", "female stop", "double male", "male female stop", "male female hole", "double female stop", "double female hole"]
var_connector_pin_holes =   0; // [0:2]
var_show_electronics =      false;

/* [Variations: Nunchaku] */

var_nun_link =              "classic"; // ["classic", "magnetic"]
var_nun_storage_length =    80; // [30:300]
var_nun_magnetic =          false;

/* [Variations: Staff] */

var_staff_link_length =     250; // [30:500]

/* [Variations: Electric] */

var_electric_part =         "rope storage"; // ["rope storage", "cap", "battery stage", "lock", "leds support", "leds hull (right)", "leds hull (left)"]

/* [Eclate] */

eclate_top =                false;
eclate_classic_cap =        false;
eclate_connect =            false;

eclate_electric_rope =      false;
eclate_electric_cap =       false;
eclate_electric_stage =     false;
//eclate_electric_lock =      false;

// ####################################
// MODULES ############################
// ####################################

include <Thread_Library.scad>
include <electronic_parts.scad>

// ####################################
// GLOBAL PARAMETERS ##################
// ####################################

function d_ext() = var_exterior_thickness;
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
function h_pin_top() = (d_ext()-d_tube_int())/2-h_pin_base();
function d_stop() = 8;
function slice_thickness() = 1.2;
function v_gap() = 0.8;

function thread_radius_1() = 10;
function thread_length_1() = 8;
function thread_pitch_1() = 2.4;
function h_th_correction() = 10.2;
function d_th_correction() = 17.4;

function h_ers_in_tube() = 50;
function v_ers_d() = 0.8;
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
function h_lock_guide() = 12;
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

module pin_hole(h_hole,inverse = false) {
    translate([d_ext()/((inverse)? -2 : 2),0,h_hole])
    rotate([0,90*((inverse)? 1 : -1),0])
    scale([1.2,1.2,1])
    pin();
}

module pin_holes(h_hole) {
    if (var_connector_pin_holes >= 1) {
        pin_hole(h_hole);
        if (var_connector_pin_holes == 2) { pin_hole(h_hole,true); }
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
        if (eclate_top) {
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
        pin_holes(3*slice_thickness()+h_tube_cover()/2);
        if (eclate_classic_cap) {
            translate([0,0,-0.1])
            cube([d_ext()/2+0.1,d_ext()/2+0.1,3*slice_thickness()+h_tube_cover()+0.2]);
        }
    }
}

function classic_cap_length() = h_tube_cover()+3*slice_thickness();

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
        pin_holes(h_tube_cover()/2);
        if (eclate_connect) {
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
        pin_holes(h_tube_cover()/2);
        if (eclate_connect) {
            translate([0,0,-0.1])
            cube([d_ext()/2+0.1,d_ext()/2+0.1,female_connect_length()+0.2]);
        }
    }
}

module female_connect_hole() {
    difference() {
        female_connect_stop();
        translate([0,0,h_tube_cover()-0.1])
        cylinder(d=d_intern(),h=slice_thickness()+0.2);
    }
}

function female_connect_length() = thread_length_1()+thread_pitch_1()+slice_thickness()+h_tube_cover();

module double_male_connect() {
    difference() {
        union() {
            thread_1();
            translate([0,0,thread_length_1()-0.1])
            cylinder(d=d_ext(),h=slice_thickness()+0.2);
            translate([0,0,thread_length_1()+slice_thickness()])
            thread_1();
        }
        translate([0,0,-0.1])
        cylinder(d=d_intern(),h=double_male_connect_length()+0.2);
        if (eclate_connect) {
            translate([0,0,-0.1])
            cube([d_ext()/2+0.1,d_ext()/2+0.1,double_male_connect_length()+0.2]);
        }
    }
}

function double_male_connect_length() = slice_thickness()+2*thread_length_1();

module male_female_connect_stop() {
    difference() {
        union() {
            cylinder(d=d_ext(),h=thread_length_1()+thread_pitch_1()+slice_thickness()+0.2);
            translate([0,0,thread_length_1()+thread_pitch_1()+slice_thickness()])
            thread_1();
        }
        thread_negative_1();
        translate([0,0,thread_length_1()+thread_pitch_1()+slice_thickness()])
        cylinder(d=d_intern(),h=thread_length_1()+0.1);
        if (eclate_connect) {
            translate([0,0,-0.1])
            cube([d_ext()/2+0.1,d_ext()/2+0.1,male_female_connect_length()+0.2]);
        }
    }
}

module male_female_connect_hole() {
    difference() {
        male_female_connect_stop();
        translate([0,0,thread_length_1()+thread_pitch_1()-0.1])
        cylinder(d=d_intern(),h=slice_thickness()+0.2);
    }
}

function male_female_connect_length() = 2*thread_length_1()+thread_pitch_1()+slice_thickness();

module double_female_connect_stop() {
    difference() {
        cylinder(d=d_ext(),h=double_female_connect_length());
        thread_negative_1();
        translate([0,0,double_female_connect_length()])
        rotate([180,0,0])
        thread_negative_1();
        if (eclate_connect) {
            translate([0,0,-0.1])
            cube([d_ext()/2+0.1, d_ext()/2+0.1,double_female_connect_length()+0.2]);
        }
    }
}

module double_female_connect_hole() {
    difference() {
        double_female_connect_stop();
        translate([0,0,thread_length_1()+thread_pitch_1()-0.1])
        cylinder(d=d_intern(),h=slice_thickness()+0.2);
    }
}

function double_female_connect_length() = 2*(thread_length_1()+thread_pitch_1())+slice_thickness();

// ELECTRIC PARTS #####################

module electric_rope_storage() {
    h_female_connector = thread_length_1()+thread_pitch_1()+3*slice_thickness();
    difference() {
        union() {
            cylinder(d=d_ext(),h=h_female_connector);
            translate([0,0,h_female_connector-0.1])
            cylinder(d=d_ext()-v_ers_d(),h=h_ers_in_tube()+0.2);
            translate([0,0,h_female_connector+h_ers_in_tube()])
            cylinder(d=d_ext(),h=h_female_connector);
        }
        thread_negative_1();
        translate([0,0,electric_rope_storage_length()])
        rotate([0,180,0])
        thread_negative_1();
        translate([0,0,thread_length_1()+thread_pitch_1()-0.1])
        #cylinder(d=d_intern(),h=h_ers_in_tube()+0.1);
        translate([0,0,thread_length_1()+thread_pitch_1()+h_ers_in_tube()-0.1])
        #cylinder(d1=d_intern(),d2=d_intern()-10*slice_thickness(),h=5*slice_thickness()+0.1);
        if (eclate_electric_rope) {
            translate([0,0,-0.1])
            cube([d_ext()/2+0.1,d_ext()/2+0.1,electric_rope_storage_length()+0.2]);
        }
    }
}

function electric_rope_storage_length() =
    2*(thread_length_1()+thread_pitch_1()+3*slice_thickness())+h_ers_in_tube();

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
    //
    // TODO : add 4 SLICE_THICKNESS for the LOCK instead of 1
    //
    h_base = h_support_board()+4*slice_thickness();
    //
    difference() {
        union() {
            translate([
                t_support_board()/-2+v_support_board(),
                l_support_board()/-2-slice_thickness(),
                0
            ])
            cube([
                t_support_board(),
                l_support_board()+2*slice_thickness(),
                h_base+0.1
            ]);
            //
            s_tube_length = h_battery()+2*slice_thickness()-thread_length_1();
            //
            // IDEA : a thread + ext cyl + a thread
            //
            color("pink")
            translate([0,0,h_base])
            thread_1();
            //
            translate([0,0,h_base+thread_length_1()-0.1])
            cylinder(d=d_ext(),h=         10          +0.2);
            //
            //translate([0,0,h_base+thread_length_1()+      ???       ])
            //thread_1();
            //
            /*
            translate([0,0,h_support_board()+4*slice_thickness()])
            cylinder(d=d_tube_ext(),h=s_tube_length       -15         +0.1);
            //
            //
            translate([0,0,h_support_board()+4*slice_thickness()+s_tube_length     -15    ])
            cylinder(d=d_ext(),h=     15      );
            //
            //
            translate([0,0,h_support_board()+4*slice_thickness()+s_tube_length])
            thread_1();
            */
        }
        /*
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
        */
        //
        //
        if (eclate_electric_stage) {
            translate([0,0,h_support_board()+4*slice_thickness()-0.1])
            cube([d_ext()/2,d_ext()/2,h_battery()+2*slice_thickness()+0.2]);
        }
        //
        //
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
    nb_slices = 4;
    s_t_lock_guide = t_lock_guide()-v_gap();
    s_d_electric_stage = d_electric_stage()-v_gap();
    difference() {
        union() {
            cylinder(d=s_d_electric_stage-slice_thickness(),h=h_lock_guide());
            intersection() {
                cylinder(d=d_electric_stage(),h=h_lock_guide());
                translate([s_t_lock_guide/-2,0,0])
                cube([s_t_lock_guide,d_electric_stage(),h_lock_guide()-v_gap()]);
            }
        }
        translate([0,0,nb_slices*slice_thickness()])
        cylinder(d=d_electric_stage()-slice_thickness(),h=h_lock_guide()-nb_slices*slice_thickness()+0.1);
        translate([l_plate_pin()/-2,(s_d_electric_stage-slice_thickness())/-2,-0.1])
        cube([l_plate_pin(),h_plate_pin(),nb_slices*slice_thickness()+0.2]);
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

// LEDS PARTS #########################

module leds_support() {
    //
    //
}

function leds_support_length() = 0;

module leds_hull_right() {
    //
    //
    //
}

module leds_hull_left() {
    //
    //
    //
}

function leds_hull_length() = 0;

// ####################################
// COMPOSE ############################
// ####################################

// COMPOSE TAIL #######################

module compose_tail() {
    if (var_tail_mode == "training") {
        translate([0,0,female_connect_length()])
        rotate([0,180,-90])
        female_connect_hole();
        translate([0,0,female_connect_length()-h_tube_cover()+0.1])
        tube(var_tail_tube_length);
        connector_and_tube_length = female_connect_length()+var_tail_tube_length;
        translate([0,0,connector_and_tube_length+classic_cap_length()-2*h_tube_cover()+0.2])
        rotate([180,0,90])
        color("#afa")
        classic_cap();
        translate([0,d_ext()/2,thread_length_1()+thread_pitch_1()+slice_thickness()+h_tube_cover()/2])
        rotate([90,0,0])
        color("#aaf")
        pin();
        translate([0,d_ext()/2,tail_length()-3*slice_thickness()-h_tube_cover()/2+0.2])
        rotate([90,0,0])
        color("#aaf")
        pin();
    }
    else if (var_tail_mode == "esp") {
        //
        electric_rope_storage();
        //
        //electric_lock();
        //
        //translate([0,0,electric_stage_length()])
        //rotate([180,0,180])
        //electric_stage();
        //
        //
        // ==========================
        // TEST PURPOSE =============
        // ==========================
        //
        //translate([0,0,-h_tube_cover()-slice_thickness()-0.1])
        //female_connect_hole();
        //
        //translate([0,30,-h_tube_cover()-slice_thickness()-0.1])
        //male_connect();
        //
    }
    else if (var_tail_mode == "saber") {
        //
        //
    }
}

function tail_length() =
    (var_tail_mode == "training")
    ? female_connect_length()+var_tail_tube_length+classic_cap_length()-2*h_tube_cover()
    : (var_tail_mode == "esp")
    ? h_top()+electric_rope_storage_length()
    : (var_tail_mode == "saber")
    ? 0
    : 0
;

// NUNCHUK COMPOSE ####################

module nunchaku() {
    rotate([90,0,90])
    color("#faa")
    if (var_nun_magnetic) { magnet_top(); }
    else { classic_top(); }
    translate([h_top()+0.1,0,0])
    rotate([90,0,90])
    compose_tail();
}

function nunchaku_length() = tail_length()+h_top();

// STAFF COMPOSE ######################

module staff () {
    translate([var_staff_link_length/-2,0,0])
    rotate([0,90,0])
    tube(var_staff_link_length);
    half_tube = var_staff_link_length/2-h_tube_cover();
    translate([half_tube+0.1,0,0])
    rotate([90,0,90])
    color("#faa")
    male_connect();
    translate([-half_tube-0.1,0,0])
    rotate([0,-90,0])
    color("#faa")
    male_connect();
    translate([var_staff_link_length/2-h_tube_cover()/2+0.1,d_ext()/2,0])
    rotate([90,0,0])
    color("#ffa")
    pin();
    translate([var_staff_link_length/-2+h_tube_cover()/2-0.1,0,d_ext()/2])
    rotate([180,0,0])
    color("#ffa")
    pin();
    translate([half_tube+male_connect_length()-thread_length_1()+0.2,0,0])
    rotate([90,0,90])
    compose_tail();
    translate([-half_tube-male_connect_length()+thread_length_1()-0.2,0,0])
    rotate([0,-90,0])
    compose_tail();
}

function staff_length() = 2*(tail_length()+slice_thickness())+var_staff_link_length;

// COMPOSE SELECTOR ###################

if (compose == "single part") {
    if (var_selected_part == "pin") { pin(); }
    else if (var_selected_part == "classic top") { classic_top(); }
    else if (var_selected_part == "magnetic top") { magnet_top(); }  
    else if (var_selected_part == "cap") { classic_cap(); }
    else if (var_selected_part == "connector") {
        if (var_connector_type == "male") { male_connect(); }
        else if (var_connector_type == "female hole") { female_connect_hole(); }
        else if (var_connector_type == "female stop") { female_connect_stop(); }
        else if (var_connector_type == "double male") { double_male_connect(); }
        else if (var_connector_type == "male female stop") { male_female_connect_stop(); }
        else if (var_connector_type == "male female hole") { male_female_connect_hole(); }
        else if (var_connector_type == "double female stop") { double_female_connect_stop(); }
        else if (var_connector_type == "double female hole") { double_female_connect_hole(); }
    }
    else if (var_selected_part == "electric") {
        if (var_electric_part == "rope storage") { electric_rope_storage(); }
        else if (var_electric_part == "cap") { electric_cap(); }
        else if (var_electric_part == "battery stage") { electric_stage(); }
        else if (var_electric_part == "lock") { electric_lock(); }
        else if (var_electric_part == "leds support") {
            //
            //
        }
        else if (var_electric_part == "leds hull (right)") {
            //
            //
        }
        else if (var_electric_part == "leds hull (left)") {
            //
            //
        }
    }
}
else if (compose == "tail") {
    compose_tail();
    echo("######## TAIL LENGTH #########");
    echo(tail_length());
    echo("##############################");
}
else if (compose == "nunchaku") {
    nunchaku();
    echo("######## TOTAL LENGTH ########");
    echo(nunchaku_length());
    echo("##############################");
}
else if (compose == "staff") {
    staff();
    echo("######## TOTAL LENGTH ########");
    echo(staff_length());
    echo("##############################");
}
