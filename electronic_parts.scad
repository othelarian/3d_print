module slide_switch() {
    l_handles = 19.7;
    e_handles = 0.4;
    e_total = 5.8;
    h_total = 7.6;
    l_block = 10.7;
    h_block = 5;
    l_button = 2.9;
    h_button = 5;
    e_button = 6;
    d_hole = 2.1;
    e_hole = 12.8; // ecart bord à bord, et pas centre à centre
    h_pin = h_total-h_block;
    l_pin = 1.5;
    e_pin = 0.4;
    l_3pins = 7.5;
    $fn = 10;
    module slide_switch_pin() {
        translate([0,e_pin/2,l_pin/2-h_pin])
        rotate([90,0,0]) {
            translate([l_pin/-2,0,0])
            cube([l_pin,h_pin-l_pin/2+0.1,e_pin]);
            cylinder(d=l_pin,h=e_pin);
        }
    }
    color("blue")
    difference() {
        union() {
            translate([l_handles/-2,e_total/-2,h_block-e_handles])
            cube([l_handles,e_total,e_handles]);
            translate([l_block/-2,e_total/-2,0])
            cube([l_block,e_total,h_block]);
            translate([e_button/2-l_button/2,0,0])
            translate([l_button/-2,l_button/-2,h_block-0.1])
            cube([l_button,l_button,h_button+0.1]);
            slide_switch_pin();
            translate([l_3pins/2-l_pin/2,0,0])
            slide_switch_pin();
            translate([l_pin/2-l_3pins/2,0,0])
            slide_switch_pin();
        }
        translate([e_hole/2+d_hole/2,0,h_block-e_handles-0.1])
        cylinder(d=d_hole,h=e_handles+0.2);
        translate([(e_hole/2+d_hole/2)*-1,0,h_block-e_handles-0.1])
        cylinder(d=d_hole,h=e_handles+0.2);
    }
}

module support_board() {
    h_total = 10.5;
    l_block = 10.7;
    h_block = 8.5;
    e_block = 5;
    l_pin = 0.6;
    e_pin = 0.3;
    h_pin = h_total-h_block;
    e_l_pins = 8.3;
    e_h_pins = 3;
    e_calc_l_pins = (e_l_pins-l_pin)/3;
    module support_board_pins() {
        translate([e_pin/-2,l_pin/-2,-h_pin])
        cube([e_pin,l_pin,h_pin+0.1]);
    }
    color("violet")
    union () {
        translate([e_block/-2,l_block/-2,0])
        cube([e_block,l_block,h_block]);
        translate([e_h_pins/-2+e_pin/2,0,0]) {
            translate([0,e_l_pins/-2+l_pin/2,0]) support_board_pins();
            translate([0,e_calc_l_pins/-2,0]) support_board_pins();
            translate([0,e_calc_l_pins/2,0]) support_board_pins();
            translate([0,e_l_pins/2-l_pin/2,0]) support_board_pins();
        }
        translate([e_h_pins/2-e_pin/2,0,0]) {
            translate([0,e_l_pins/-2+l_pin/2,0]) support_board_pins();
            translate([0,e_calc_l_pins/-2,0]) support_board_pins();
            translate([0,e_calc_l_pins/2,0]) support_board_pins();
            translate([0,e_l_pins/2-l_pin/2,0]) support_board_pins();
        }
    }
}

module esp8266_01() {
    l_board = 15;
    h_board = 25;
    e_board = 1.2;
    e_board_block = 0.5;
    h_block = 5;
    l_block = 9.8;
    e_block = 2.5;
    h_pin = 11.4;
    l_pin = 0.6;
    s_pin = 8.4;
    e_h_pins = 3.2;
    e_l_pins = 8.3;
    e_calc_l_pins = (e_l_pins-l_pin)/3;
    module board_pin() {
        translate([l_pin/-2,l_pin/-2,e_block-s_pin])
        cube([l_pin,l_pin,h_pin]);
    }
    color("green")
    union() {
        translate([h_block/-2-e_board_block,l_board/-2,e_block])
        cube([h_board,l_board,e_board]);
        translate([h_block/-2,l_block/-2,0])
        cube([h_block,l_block,e_block+0.1]);
        translate([e_h_pins/-2+l_pin/2,0,0]) {
            translate([0,e_l_pins/-2+l_pin/2,0]) board_pin();
            translate([0,e_calc_l_pins/-2,0]) board_pin();
            translate([0,e_calc_l_pins/2,0]) board_pin();
            translate([0,e_l_pins/2-l_pin/2,0]) board_pin();
        }
        translate([e_h_pins/2-l_pin/2,0,0]) {
            translate([0,e_l_pins/-2+l_pin/2,0]) board_pin();
            translate([0,e_calc_l_pins/-2,0]) board_pin();
            translate([0,e_calc_l_pins/2,0]) board_pin();
            translate([0,e_l_pins/2-l_pin/2,0]) board_pin();
        }
    }
}

module battery() {
    d_battery = 17;
    h_battery = 34;
    color("red")
    cylinder(d=d_battery,h=h_battery);
}

module shock_sensor() {
    d_sensor = 5;
    h_sensor = 11;
    l_pin = 0.6;
    h_pin = 2;
    color("orange")
    union() {
        cylinder(d=d_sensor,h=h_sensor);
        translate([l_pin/-2,l_pin/-2-1,-h_pin])
        cube([l_pin,l_pin,h_pin+0.1]);
        translate([l_pin/-2,l_pin/-2+1,-h_pin])
        cube([l_pin,l_pin,h_pin+0.1]);
    }
}
