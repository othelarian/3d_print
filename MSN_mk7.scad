// ####################################
// INPUTS #############################
// ####################################

$fn = 16;

mode = "part"; // ["part", "compose"]
part = "magnet holder"; // ["magnet holder", "electric stage"]
eclate = false;
electric = false;

// ####################################
// GLOBAL PARAMETERS ##################
// ####################################

function FT_tube_DO() = 26;
function FT_tube_DI() = 21;
function FT_tube_T() = 1.6;

function magnet_DO() = 19.6;
function magnet_H() = 7;
function magnet_storage_H() = 70;
function magnet_storage_TR() = 16;
function magnet_storage_DO() = 14;

function slice_thick() = 1.2;

function intern_D() = 16;
function rope_D() = 9.6;


function battery_D() = 18;
function battery_L() = 37;
function battery_open_TR() = 2.8;
function battery_plate_T() = 4;
function battery_plate_TR() = 7;
function battery_led_H() = 5;
function battery_led_T() = 11;
function battery_wires_L() = 7.4;

function thread_L() = 6;
function thread_P() = 2.4;
function thread_R() = 8.5;
function h_th_correction() = 10.2;
function d_th_correction() = 17.4;

// ####################################
// INCLUDES ###########################
// ####################################

include <electronic_parts.scad>
include <Thread_Library.scad>

// ####################################
// HELPERS ############################
// ####################################

module thread() {
    trapezoidThread(
        length=thread_L(),
        pitch=thread_P(),
        pitchRadius=thread_R(),
        stepsPerTurn=$fn
    );
}

module thread_negative() {
    trapezoidThreadNegativeSpace(
        length=thread_L(),
        pitch=thread_P(),
        pitchRadius=thread_R(),
        stepsPerTurn=$fn
    );
    //cylinder(d=d_th_correction(),h=h_th_correction(),center=false);
}

// ####################################
// PARTS ##############################
// ####################################

module magnet_holder() {
    out_part_H = magnet_H()+slice_thick()*3;
    hole_bottom = out_part_H+magnet_storage_TR();
    hole_top = out_part_H+magnet_storage_H()-2*slice_thick()-magnet_storage_TR();
    difference() {
        union() {
            cylinder(d=FT_tube_DO(),h=out_part_H+0.1);
            translate([0, 0, out_part_H])
            cylinder(d=FT_tube_DI(),h=magnet_holder_H()-out_part_H);
        }
        translate([0,0,-0.1]) cylinder(d=magnet_DO(),h=magnet_H()+0.1);
        translate([0,0,magnet_H()-0.1]) cylinder(d=rope_D(),h=slice_thick()+0.2);
        translate([0,0,out_part_H-2*slice_thick()])
        cylinder(d=intern_D(),h=magnet_storage_H()+0.1);
        translate([0,FT_tube_DI()/-2-0.05,0])
        rotate([-90,0,0]) {
            translate([0,-hole_bottom,0])
            cylinder(d=magnet_storage_DO(),h=FT_tube_DI()+0.1);
            translate([0,-hole_top,0])
            cylinder(d=magnet_storage_DO(),h=FT_tube_DI()+0.1);
        }
        translate([magnet_storage_DO()/-2,FT_tube_DI()/-2-0.05,hole_bottom])
        cube([magnet_storage_DO(),FT_tube_DI()+0.1,hole_top-hole_bottom]);
        translate([0,0,magnet_holder_H()])
        rotate([180,0,0])
        thread_negative();
        if (eclate) {
            translate([0,0,-0.05])
            cube([FT_tube_DO()/2+0.05,FT_tube_DO()/2+0.05,magnet_holder_H()+0.1]);
        }
    }
}

function magnet_holder_H() =
    magnet_H()+slice_thick()+magnet_storage_H()+thread_L()+thread_P();

module electric_stage() {
    //
    battery_lvl = thread_L()+battery_led_H()+2*slice_thick();
    battery_cap_H = battery_L()+2*slice_thick();
    plate_cut_D = FT_tube_DI()/2-battery_plate_TR()+0.05;
    //
    //
    translate([0,0,-0.1])
    difference() {
        union() {
            translate([0,0,0.1]) thread();
            translate([0,0,thread_L()])
            cylinder(d=FT_tube_DI(),h=battery_led_H()+3*slice_thick()+battery_L());
            //
            //
        }
        translate([FT_tube_DI()/-2-0.05,battery_led_T()/-2,thread_L()+slice_thick()])
        cube([FT_tube_DI()+0.1,battery_led_T(),battery_led_H()]);
        translate([0,0,battery_lvl]) {
            cylinder(d=battery_D(),h=battery_L());
            translate([battery_open_TR(),FT_tube_DI()/-2-0.05,0])
            cube([FT_tube_DI()/2+0.05,FT_tube_DI()+0.1,battery_L()]);
            translate([battery_plate_TR(),battery_plate_T()/-2,-slice_thick()-0.1])
            cube([plate_cut_D,battery_plate_T(),battery_cap_H+0.2]);
            translate([0,0,-slice_thick()-0.05])
            intersection() {
                difference() {
                    cylinder(d=FT_tube_DI()+0.05,h=battery_cap_H+0.1);
                    translate([0,0,-0.1])
                    cylinder(d=battery_D()-0.05,h=battery_cap_H+0.2);
                }
                translate([FT_tube_DI()/-2-0.05,battery_wires_L()/-2,0])
                cube([FT_tube_DI()/2+0.05,battery_wires_L(),battery_cap_H+0.1]);
            }
        }
        //
        //
        // TODO : connector for esp board
        //
        // TODO : connector for the tail
        //
    }
    if (electric) {
        //
        translate([0,0,battery_lvl+1]) battery();
        //
    }
}

function electric_stage_H() = // TODO : add base anchor and connector stuff
    thread_L()+battery_led_H()+2*slice_thick()+battery_L()+     0       ;

// ####################################
// COMPOSE ############################
// ####################################

if (mode == "part") {
    if (part == "magnet holder") { magnet_holder(); }
    else if (part == "electric stage") { electric_stage(); }
    //
    //
}
else if (mode == "compose") {
    //
    tube_tr = magnet_H()+3*slice_thick()+0.2;
    tube_H = 150;
    //
    //
    magnet_holder();
    color("purple")
    translate([0,0,tube_tr])
    difference() {
        cylinder(d=FT_tube_DO(),h=tube_H);
        translate([0,0,-0.05]) {
            cylinder(d=FT_tube_DI()+0.2,h=tube_H+0.1);
            translate([0,FT_tube_DO()/-2-0.1,0])
            cube([FT_tube_DO()/2+0.1,FT_tube_DO()+0.2,tube_H+0.1]);
            rotate([0,0,70])
            cube([FT_tube_DO()/2+0.1,FT_tube_DO()/2+0.1,tube_H+0.1]);
        }
    }
    //
    translate([0,0,magnet_holder_H()-thread_L()+0.2])
    electric_stage();
    //
    //
}
