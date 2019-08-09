// ####################################
// INPUTS #############################
// ####################################

show_all =                  true;
show_test_coupling_1 =      false;
show_magnet_support =       false;
show_rope_keeper =          false;
show_training_base =        false;

show_electronics =          false;

pose =                      "none"; // ["none", "assembly", "print"]

eclate_all =                false;
eclate_test_coupling_1 =    false;
eclate_magnet_support =     false;
eclate_rope_keeper =        false;
eclate_training_base =      false;

$fn =                       16; // 100~150

// ####################################
// MODULES ############################
// ####################################

include <Thread_Library.scad>

// ####################################
// HELPERS ############################
// ####################################

function show(v) = (show_all || v)? true : false;
function pose_mode(a1, a2) = (pose == "assembly")? a1 : (pose == "print")? a2 : [0,0,0];
function eclate(v) = (eclate_all || v)? true : false;

// ####################################
// GLOBAL PARAMETERS ##################
// ####################################

function h_pas_vis_1() = 8;
function d_ext() = 24;
function d_drisse() = 14;
function d_pas_vis_1() = 18;
function pitch_vis_1() = 2.4;
function h_th_correction() = 10.2;
function d_th_correction() = 17.4;

// ####################################
// TEST ###############################
// ####################################

// TEST COUPLING 1 ####################

if (show_test_coupling_1) { // NOTE : non relié au show global (test)
    h_base = 9;
    translate(pose_mode([0,0,0], [18,18,0]))
    difference() { // partie basse
        union() {
            cylinder(d=d_ext(), h=h_base+0.01, center=false); // base basse
            translate([0,0,h_base])
            trapezoidThread( // pas de vis externe
                length=8,
                pitch=2.4,
                pitchRadius=9,
                stepsPerTurn=$fn
            );
        }
        translate([0,0,-0.1])
        cylinder(d=d_drisse(), h=20.2, center=false); // passage drisse
        translate([0,0,-0.1])
        cylinder(d=20, h=h_base-2, center=false); // simulation trou aimant
        translate([11,0,-0.1])
        cube([1,1,h_base+0.2]); // marquage tet coupling 1
        translate([0,0,2])
        if (eclate_test_coupling_1) { translate([0,0,-0.1]) cube(18); }
    }
    translate(pose_mode([0,0,h_base+0.05], [18,48,13]))
    rotate(pose_mode([0,0,0], [0,180,0]))
    difference() { // partie haute
        translate([0,0,0.1])
        cylinder(d=d_ext(), h=13, center=false); // base haute
        trapezoidThreadNegativeSpace( // pas de vis interne
            length=8,
            pitch=2.4,
            pitchRadius=9,
            stepsPerTurn=$fn
        );
        cylinder(d=17.4, h=10.2, center=false); // thread correction
        translate([0,0,10])
        cylinder(d=d_drisse(), h=3.2, center=false); // trou drisse
        translate([11,0,-0.1])
        cube([1,1,13.2]); // marquage test coupling 1
        translate([0,0,2])
        if (eclate_test_coupling_1) { translate([0,0,-0.1]) cube(16); }
    }
}

// ####################################
// SERIOUS PARTS ######################
// ####################################

// MAGNET SUPPORT #####################

if (show(show_magnet_support)) {
    // NOTE : total length = 18mm
    // NOTE : assembled length = 10mm
    d_magnet_stop = 9.6;
    d_magnet = 19.6;
    h_base = 10;
    h_magnet = 7;
    translate(pose_mode([0,-20,15], [18,18,0]))
    rotate(pose_mode([-90,-90,0], [0,0,0]))
    difference() {
        union() {
            cylinder(h=h_base+0.01, d=d_ext(), center=false); // base externe
            translate([0,0,h_base])
            trapezoidThread( // pas de vis
                length=h_pas_vis_1(),
                pitch=pitch_vis_1(),
                pitchRadius=d_pas_vis_1()/2,
                stepsPerTurn=$fn
            );
        }
        difference() { // léger chanfrein externe (bord aimant)
            translate([0,0,-0.1])
            cylinder(d=d_ext()+0.2, h=2.1, center=false);
            translate([0,0,-0.2])
            cylinder(d1=d_ext()-1.3, d2=d_ext()+0.5, h=2.3, center=false);
        }
        translate([0,0,-0.1])
        cylinder(h=h_magnet+0.1, d=d_magnet, center=false); // trou pour l'aimant
        translate([0,0,h_magnet]) { // trou avec stoppeur pour la drisse
            h_angle = 2;
            cylinder(d1=d_magnet_stop, d2=d_drisse(), h=h_angle, center=false);
            translate([0,0,h_angle])
            cylinder(d=d_drisse(), h=h_base+h_pas_vis_1()-h_magnet-h_angle+0.1, center=false);
            translate([0,0,-1])
            cylinder(d=d_magnet_stop, h=1+0.1, center=false);
        }
        if (eclate(eclate_magnet_support)) { translate([0,0,-0.1]) cube([15,15,40]); } // eclate
    }
}

// ROPE KEEPER ########################

if (show(show_rope_keeper)) {
    // NOTE : longueur totale = 78mm
    // NOTE : longueur assemblé = 70mm
    h_j_grip = 6;
    d_grip = d_ext()-h_j_grip;
    h_c_manchon = 9;
    h_grip = 42;
    h_tampon = 7;
    h_percage = 60;
    //
    translate(pose_mode([0,-10+0.05,15], [18,48,0]))
    rotate(pose_mode([-90,-90,0], [0,0,0])) {
    difference() {
        union() {
            cylinder(d=d_ext(), h=h_c_manchon, center=false); // couplage du manchon
            translate([0,0,h_c_manchon])
            cylinder(d1=d_ext(), d2=d_grip, h=h_j_grip, center=false); // cone manchon vers grip
            translate([0,0,h_c_manchon+h_j_grip])
            cylinder(d=d_grip, h=h_grip, center=false); // grip
            translate([0,0,h_c_manchon+h_j_grip+h_grip])
            cylinder(d1=d_grip, d2=d_ext(), h=h_j_grip, center=false); // cone grip vers tampon
            translate([0,0,h_c_manchon+h_j_grip*2+h_grip])
            cylinder(d=d_ext(), h=h_tampon+0.01, center=false); // tampon avant pas de vis
            translate([0,0,h_c_manchon+h_grip+h_j_grip*2+h_tampon])
            trapezoidThread( // pas de vis
                length=h_pas_vis_1(),
                pitch=pitch_vis_1(),
                pitchRadius=d_pas_vis_1()/2,
                stepsPerTurn=$fn
            );
            //
        }
        trapezoidThreadNegativeSpace( // pas de vis
            length=h_pas_vis_1(),
            pitch=pitch_vis_1(),
            pitchRadius=d_pas_vis_1()/2,
            stepsPerTurn=$fn
        );
        cylinder(d=d_th_correction(), h=h_th_correction(), center=false); // thread correction
        //
        // EN COURS
        //
        translate([0,0,h_c_manchon])
        #cylinder(d=d_drisse(), h=h_percage, center=false); // zone de rangement
        //
        // TODO : zone tampon partie socle
        //
        //#cylinder(d1=d_drisse(),d2=?,h=?);
        //#cylinder(d=?d2?,h=?);
        //#cylinder()
        //
        //
        // TODO : grille d'aération
        //
        if (eclate(eclate_rope_keeper)) { translate([0,0,-0.1]) cube([15,15,80]); } // eclate
    }
    //
    // ZONE DE TEST
    //
    //
    }
}

// TRAINING BASE ######################

if (show(show_training_base)) {
    // NOTE : longueur totale == longueur assemblé = 220mm
    //
    //
    translate(pose_mode([0,0,0], [0,0,0]))
    rotate(pose_mode([0,0,0], [0,0,0])) {
    //
    difference() {
        //
        //
        if (eclate(eclate_training_base)) { translate([0,0,-0.1]) cube([15,15,50]); }
    }
    //
    // ZONE DE TEST
    //
    }
}

// CORPS TRANSPARENT ##################


// ELECTRONICS SUPPORT ################

// ELECTRONICS ########################

module interrupteur() {
    l_pattes = 19.7;
    e_pattes = 0.4;
    e_total = 5.8;
    h_total = 7.6;
    l_block = 10.7;
    h_block = 5;
    l_baton = 2.9;
    h_baton = 5;
    e_baton = 6;
    d_trou = 2.1;
    e_trou = 12.8; // ecart bord à bord, et pas centre à centre
    h_pin = h_total-h_block;
    l_pin = 1.5;
    e_pin = 0.4;
    l_3pins = 7.5;
    module interrupteur_pin() {
        translate([0,e_pin/2,l_pin/2-h_pin])
        rotate([90,0,0]) {
            translate([l_pin/-2,0,0])
            cube([l_pin,h_pin-l_pin/2+0.1,e_pin]);
            cylinder(d=l_pin,h=e_pin);
        }
    }
    difference() {
        union() {
            translate([l_pattes/-2,e_total/-2,h_block-e_pattes])
            cube([l_pattes,e_total,e_pattes]);
            translate([l_block/-2,e_total/-2,0])
            cube([l_block,e_total,h_block]);
            translate([e_baton/2-l_baton/2,0,0])
            translate([l_baton/-2,l_baton/-2,h_block-0.1])
            cube([l_baton,l_baton,h_baton+0.1]);
            interrupteur_pin();
            translate([l_3pins/2-l_pin/2,0,0])
            interrupteur_pin();
            translate([l_pin/2-l_3pins/2,0,0])
            interrupteur_pin();
        }
        translate([e_trou/2+d_trou/2,0,h_block-e_pattes-0.1])
        cylinder(d=d_trou,h=e_pattes+0.2);
        translate([(e_trou/2+d_trou/2)*-1,0,h_block-e_pattes-0.1])
        cylinder(d=d_trou,h=e_pattes+0.2);
    }
}

module support_carte() {
    h_total = 10.5;
    l_block = 10.7;
    e_block = 8.5;
    h_block = 5;
    l_pin = 0.6;
    e_pin = 0.3;
    h_pin = h_total-h_block;
    e_l_pins = 8.3;
    e_h_pins = 3;
    e_calc_l_pins = (e_l_pins-l_pin)/3;
    module support_carte_pins() {
        translate([e_pin/-2,l_pin/-2,-h_pin])
        cube([e_pin,l_pin,h_pin+0.1]);
    }
    union () {
        translate([h_block/-2,l_block/-2,0])
        cube([h_block,l_block,e_block]);
        translate([e_h_pins/-2+e_pin/2,0,0]) {
            translate([0,e_l_pins/-2+l_pin/2,0]) support_carte_pins();
            translate([0,e_calc_l_pins/-2,0]) support_carte_pins();
            translate([0,e_calc_l_pins/2,0]) support_carte_pins();
            translate([0,e_l_pins/2-l_pin/2,0]) support_carte_pins();        }
        translate([e_h_pins/2-e_pin/2,0,0]) {
            translate([0,e_l_pins/-2+l_pin/2,0]) support_carte_pins();
            translate([0,e_calc_l_pins/-2,0]) support_carte_pins();
            translate([0,e_calc_l_pins/2,0]) support_carte_pins();
            translate([0,e_l_pins/2-l_pin/2,0]) support_carte_pins();
        }
    }
}

module carte() {
    l_carte = 15;
    h_carte = 25;
    e_carte = 1.2;
    e_carte_block = 1.5;
    h_block = 5;
    l_block = 9.8;
    e_block = 2.5;
    h_pin = 11.4;
    l_pin = 0.6;
    s_pin = 8.4;
    e_h_pins = 3.2;
    e_l_pins = 8.3;
    e_calc_l_pins = (e_l_pins-l_pin)/3;
    module carte_pin() {
        translate([l_pin/-2,l_pin/-2,e_block-s_pin])
        cube([l_pin,l_pin,h_pin]);
    }
    union() {
        translate([h_block/-2-e_carte_block,l_carte/-2,e_block])
        cube([h_carte,l_carte,e_carte]);
        translate([h_block/-2,l_block/-2,0])
        cube([h_block,l_block,e_block+0.1]);
        translate([e_h_pins/-2+l_pin/2,0,0]) {
            translate([0,e_l_pins/-2+l_pin/2,0]) carte_pin();
            translate([0,e_calc_l_pins/-2,0]) carte_pin();
            translate([0,e_calc_l_pins/2,0]) carte_pin();
            translate([0,e_l_pins/2-l_pin/2,0]) carte_pin();
        }
        translate([e_h_pins/2-l_pin/2,0,0]) {
            translate([0,e_l_pins/-2+l_pin/2,0]) carte_pin();
            translate([0,e_calc_l_pins/-2,0]) carte_pin();
            translate([0,e_calc_l_pins/2,0]) carte_pin();
            translate([0,e_l_pins/2-l_pin/2,0]) carte_pin();
        }
    }
}

module batterie() {
    d_batterie = 17;
    h_batterie = 34;
    cylinder(d=d_batterie,h=h_batterie);
}

if (show_electronics) {
    translate([0,20,0])
    color("blue") interrupteur();
    translate([0,-20,0])
    color("violet") support_carte();
    translate([-20,0,0])
    color("green") carte();
    translate([20,0,0])
    color("red") batterie();
}

// TO BE CONTINUED ... ################