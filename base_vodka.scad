// INPUTS #############################

$fn = 70;

// MODULES ############################
// HELPERS ############################
// GLOBAL PARAMETERS ##################

function d_ext() = 19.6;
function d_batterie() = 18; // 15~17mm
function h_batterie() = 38; // ~35mm
function h_creux() = 10;
function h_espacement() = 1;
function d_ouverture() = 8;
function h_ouverture() = 20;
function decal_passage() = 25;
function decal_ouverture() = -20;
function p_ancre() = 6;
function c_ancre() = -1;
function l_carte() = 10.5;
function h_carte() = 5.5;
function espace_carte() = 4;

function h_ancre() = h_carte()+espace_carte()+h_espacement();
function l_ancre() = l_carte()+h_espacement()*4; // espacement * 2 de chaque côté
function l_passage() = (d_ext()-d_batterie())/2;
function h_passage() = h_espacement()*2+h_batterie();
function h_base_batterie() = h_creux()+h_espacement()*2+h_batterie();

// BASE ###############################

difference() {
    union() {
        cylinder(d=d_ext(), h=h_base_batterie()); // base de la batterie
        rotate([0,0,180])
        translate([c_ancre(),-l_ancre()/2,h_base_batterie()-0.1])
        cube([p_ancre(),l_ancre(),h_ancre()+0.1]); // base de l'ancre
    }
    translate([-(d_ext()/2+0.5),-d_ext()/4,-0.1])
    cube([d_ext()+1,d_ext()/2,h_creux()+0.1]); // creux pour l'interrupteur
    translate([0,0,h_creux()+h_espacement()])
    union() { // emplacement de la batterie
        cylinder(d=d_batterie(), h=h_batterie());
        translate([0,-(d_ext()/2+0.5),0])
        cube([d_ext()+0.1,d_ext()+1,h_batterie()]);
    }
    rotate([0,0,decal_passage()])
    translate([-(d_ext()/2),-(l_passage()),h_creux()-0.1])
    cube([l_passage()+0.15,l_passage()*2,h_passage()+0.2]); // passage du câble (arrière)
    translate([d_ext()/2-l_passage()*2,-(l_passage()*2),h_creux()-0.1])
    cube([l_passage()*2,l_passage()*4,h_passage()+0.2]); // passage du câble (avant)
    translate([0,0,h_creux()+h_espacement()+h_ouverture()])
    rotate([0,-90,decal_ouverture()])
    cylinder(d=d_ouverture(), h=d_ext()/2+0.1); // ouverture pour pousser la batterie
    rotate([0,0,180])
    translate([c_ancre()-0.1,-(l_carte()/2),h_base_batterie()+espace_carte()])
    cube([p_ancre()+0.2,l_carte(),h_carte()]); // trou pour la carte
}
