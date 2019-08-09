// INPUTS #############################

show_all =                  true;
show_test_couplage_1 =      false;
show_test_couplage_2 =      false;
show_manchon =              false;
show_capteur =              false;
show_socle_entrainement =   false;

show_electronique =         false;

pose =                      "none"; // ["none", "assembly", "print"]

eclate_all =                false;
eclate_test_couplage_1 =    false;
eclate_test_couplage_2 =    false;
eclate_manchon =            false;
eclate_capteur =            false;
eclate_socle_entrainement = false;

$fn =                       16; // 100~150

// MODULES ############################

include <Thread_Library.scad>

// HELPERS ############################

function show(v) = (show_all || v)? true : false;
function pose_mode(a1, a2) = (pose == "assembly")? a1 : (pose == "print")? a2 : [0,0,0];
function eclate(v) = (eclate_all || v)? true : false;

module couplage_text(value, profondeur) {
    intersection() {
        difference() {
            cylinder(d=d_ext()+0.05, h=8);
            translate([0,0,-0.1])
            cylinder(d=d_ext()-1, h=8.2);
        }
        translate([0,-((d_ext()/2)-(profondeur-0.1)),1])
        rotate([90,0,0])
        linear_extrude(height=profondeur)
        text(value, size=5, halign="center");
    }
}

// GLOBAL PARAMETERS ##################

function h_pas_vis_1() = 8;
function d_ext() = 24;
function d_drisse() = 14;
function d_pas_vis_1() = 18;
function pitch_vis_1() = 2.4;

// TEST ###############################

// TEST COUPLAGE MANCHON ##############

if (show_test_couplage_1) { // NOTE : non relié au show global (test)
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
        translate([0,0,2])
        couplage_text("TC-1", 4);
        if (eclate_test_couplage_1) { translate([0,0,-0.1]) cube(18); }
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
        translate([0,0,2])
        couplage_text("TC-1", 4);
        if (eclate_test_couplage_1) { translate([0,0,-0.1]) cube(16); }
    }
}

// TEST COUPLAGE BATTERIE #############

if (show_test_couplage_2) { // NOTE : non relié au show global (test)
    //
    //
}

// MANCHON ############################

if (show(show_manchon)) {
    // NOTE : longueur total = 18mm
    // NOTE : longueur assemblé = 10mm
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
        if (eclate(eclate_manchon)) { translate([0,0,-0.1]) cube([15,15,40]); } // eclate
    }
}

// CAPTEUR ############################

if (show(show_capteur)) {
    // NOTE : longueur totale = 78mm
    // NOTE : longueur assemblé = 70mm
    h_j_grip = 6;
    d_grip = d_ext()-h_j_grip;
    h_c_manchon = 9;
    h_grip = 42;
    h_tampon = 7;
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
        cylinder(d=17.4, h=10.2, center=false); // thread correction
        //
        // EN COURS
        //
        union() { // creux pour la drisse
            translate([0,0,h_c_manchon-4])
            cylinder(d=d_drisse(), h=40, center=false); // zone de rangement
            //
            // TODO : zone tampon partie socle
            //
        }
        //
        //
        // TODO : grille d'aération
        //
        if (eclate(eclate_capteur)) { translate([0,0,-0.1]) cube([15,15,80]); } // eclate
    }
    //
    // ZONE DE TEST
    //
    //
    }
}

// SOCLE ENTRAINEMENT #################

if (show(show_socle_entrainement)) {
    // NOTE : longueur totale == longueur assemblé = 220mm
    //
    //
    translate(pose_mode([0,0,0], [0,0,0]))
    rotate(pose_mode([0,0,0], [0,0,0])) {
    //
    difference() {
        //
        //
        if (eclate(eclate_socle_entrainement)) { translate([0,0,-0.1]) cube([15,15,50]); }
    }
    //
    // ZONE DE TEST
    //
    }
}

// CORPS TRANSPARENT ##################

// SOCLE BATTERIE #####################

// ELECTRONIQUE #######################

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
    //
    // h total : 10.5
    // l block : 10.7
    // h block : 8.5
    // e block : 5
    // l pin : 0.6
    // e pin : 0.3
    // ecart pin l : 8.3 h : 3
    //
}

module carte() {
    //
    // largeur : 15
    // hauteur : 25
    //
    l_carte = 15;
    h_carte = 25;
    e_carte = 1.2;
    //
    // bloc support -> h : 5, l : 9.8, e : 2.5
    // pin total : 11.4
    // pin sortie bas total : 8.4
    // s pin : 0.6
    // espacement h : 3.2, l : 8.3
    //
    union() {
        //
        translate([0,l_carte/2,0])
        cube([h_carte,l_carte,e_carte]);
        //
        //
    }
    //
}

module batterie() {
    d_batterie = 17;
    h_batterie = 34;
    cylinder(d=d_batterie,h=h_batterie);
}

if (show_electronique) {
    //color("blue")
    //interrupteur();
    //
    color("violet")
    support_carte();
    //
    color("green")
    carte();
    //
    //color("red")
    //batterie();
}

// TO BE CONTINUED ... ################