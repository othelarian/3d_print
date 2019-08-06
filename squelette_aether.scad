// INPUTS #############################

$fn = 20;

// MODULES ############################
// HELPERS ############################
// GLOBAL PARAMETERS ##################

function d_ext() = 19;
function d_batterie() = 17.6;
function h_base_batterie() = 39;
function h_batterie() = 37;
function h_ouv_batterie() = h_batterie() - 1;

// BASE ###############################

difference() {
    union() {
        cylinder(d=d_ext(), h=h_base_batterie()); // base de la batterie
        //
        //
    }
    translate([0,0,1])
    cylinder(d=d_batterie(), h=h_batterie()); // emplacement de la batterie
    translate([(d_ext()+0.1)/-2,0,1.2])
    cube([d_ext()+0.1,d_ext()/2,h_ouv_batterie()]); // ouverture pour insérer la batterie
    translate([-1,d_batterie()/-2,1])
    cube([2,0.8,h_batterie()+10]); // gouttière pole nég. de la batterie
    //
    //
}
