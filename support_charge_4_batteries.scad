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
function l_passage() = 6;
function d_ouverture() = 8;
function h_ouverture() = 8;

function h_socle() = h_batterie()+(h_bord()+h_espacement())*2;

// BASE ###############################

difference() {
    union() { // base du support
        cube([h_socle(),d_ext()*4,d_ext()/2]);
        for (i = [0:3])
        translate([0,d_ext()/2+i*d_ext(),d_ext()/2])
        rotate([0,90,0])
        cylinder(d=d_ext(),h=h_socle());
    }
    for (i = [0:3]) {
        translate([h_espacement()+h_bord(),i*d_ext(),d_ext()/2]) {
            translate([0,-0.1,0])
            cube([h_batterie(),d_ext()+0.2,d_ext()/2+0.1]); // emplacement de la batterie
            translate([0,d_ext()/2,0])
            rotate([0,90,0])
            cylinder(d=d_batterie(),h=h_batterie()); // ouverture de la batterie
        }
        translate([-0.1,(d_ext()-h_creux())/2+i*d_ext(),-0.1])
        cube([h_bord()+0.1,h_creux(),d_ext()+0.2]); // creux dans le premier bord
        translate([h_socle()-h_bord(),(d_ext()-h_creux())/2+i*d_ext(),-0.1])
        cube([h_bord()+0.1,h_creux(),d_ext()+0.2]); // creux dans le deuxième bord
        translate([h_bord()-0.1,(d_ext()-l_plaque())/2+i*d_ext(),d_ext()-h_plaque()+0.1])
        cube([h_espacement()+0.2,l_plaque(),h_plaque()+0.1]); // passage plaque du premier bord
        translate(
            [h_bord()+h_espacement()+h_batterie()-0.1
            ,(d_ext()-l_plaque())/2+i*d_ext()
            ,d_ext()-h_plaque()+0.1]
        )
        cube([h_espacement()+0.2,l_plaque(),h_plaque()+0.1]); // passage plaque du deuxième bord
        translate([h_socle()/2,d_ext()/2+i*d_ext(),-0.1]) { // ouverture pour pousser la batterie
            translate([h_ouverture()/-2,0,0])
            cylinder(d=d_ouverture(),h=d_ext()/2);
            translate([h_ouverture()/-2,d_ouverture()/-2,0])
            cube([h_ouverture(),d_ouverture(),d_ext()/2]);
            translate([h_ouverture()/2,0,0])
            cylinder(d=d_ouverture(),h=d_ext()/2);
        }
    }
    points = [
        [-0.1,-0.1],
        [h_bord(),-0.1],
        [h_bord(),d_ext()/4],
        [0,d_ext()/3+h_bord()],
        [-0.1,d_ext()/3+h_bord()]
    ];
    translate([0,d_ext()*3.5,0])
    rotate([90,0,0])
    linear_extrude(height=d_ext()*3)
    polygon(points); // passage câbles bas premier bord
    translate([h_socle(),d_ext()/2,0])
    rotate([90,0,180])
    linear_extrude(height=d_ext()*3)
    polygon(points); // passage câbles bas deuxième bord
    triangles = [
        [l_passage()/-2,-0.05],
        [0,l_passage()/2],
        [l_passage()/2,-0.05]
    ];
    for (i = [1:3])
    translate([0,d_ext()*i,0])
    rotate([90,0,90])
    linear_extrude(height=h_socle())
    polygon(triangles); // passages des câbles d'un bord à l'autre
}
