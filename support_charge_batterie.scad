// INPUTS #############################

$fn = 12;

// MODULES ############################
// HELPERS ############################
// GLOBAL PARAMETERS ##################

function d_ext() = 20;
function d_batterie() = 18; // 15~17mm
function h_batterie() = 38; // ~35mm
function h_espacement() = 1;
function h_bord() = 5; // pour les bords
function h_creux() = 10; // creux dans les bords
function h_plaque() = 2;
function l_plaque() = 4;
function h_passage() = 1.2;
function h_ecart_passage() = 4;
function d_ouverture() = 8;
function h_ouverture() = 8;

function h_socle() = h_batterie()+(h_bord()+h_espacement())*2;

// BASE ###############################

difference() {
    union() { // base du support
        cube([h_socle(),d_ext(),d_ext()/2]);
        translate([0,d_ext()/2,d_ext()/2])
        rotate([0,90,0])
        cylinder(d=d_ext(),h=h_socle());
    }
    translate([h_espacement()+h_bord(),0,d_ext()/2]) {
        translate([0,-0.1,0])
        cube([h_batterie(),d_ext()+0.2,d_ext()/2+0.1]); // emplacement de la batterie
        translate([0,d_ext()/2,0])
        rotate([0,90,0])
        cylinder(d=d_batterie(),h=h_batterie()); // ouverture de la batterie
    }
    translate([-0.1,(d_ext()-h_creux())/2,-0.1])
    cube([h_bord()+0.1,h_creux(),d_ext()+0.2]); // creux dans le premier bord
    translate([h_socle()-h_bord(),(d_ext()-h_creux())/2,-0.1])
    cube([h_bord()+0.1,h_creux(),d_ext()+0.2]); // creux dans le deuxième bord
    translate([h_bord()-0.1,(d_ext()-l_plaque())/2,d_ext()-h_plaque()+0.1])
    cube([h_espacement()+0.2,l_plaque(),h_plaque()+0.1]); // passage plaque du premier bord
    translate(
        [h_bord()+h_espacement()+h_batterie()-0.1
        ,(d_ext()-l_plaque())/2
        ,d_ext()-h_plaque()+0.1]
    )
    cube([h_espacement()+0.2,l_plaque(),h_plaque()+0.1]); // passage plaque du deuxième bord
    translate([h_bord()-0.1,d_ext()/2-h_ecart_passage(),-0.1])
    cube([h_batterie()+h_espacement()*2+0.2,h_passage(),h_passage()+0.1]); // passage du cable
    translate([h_socle()/2,(d_ext()+d_ouverture())/2,-0.1]) { // ouverture pour pousser la batterie
        translate([h_ouverture()/-2,0,0])
        cylinder(d=d_ouverture(),h=d_ext()/2);
        translate([h_ouverture()/-2,d_ouverture()/-2,0])
        cube([h_ouverture(),d_ouverture(),d_ext()/2]);
        translate([h_ouverture()/2,0,0])
        cylinder(d=d_ouverture(),h=d_ext()/2);
    }
}
