//------------------------------------------------------------------------
// Two-relays module manufactured by SainSmart (or alike).
//------------------------------------------------------------------------
module board_2relays_sainsmart() {
    // Board with 3.6 mm holes.
    pcb_thick = 1.6;
    difference() {
        color("darkgreen") cube([39.0, 51.0, pcb_thick]);
        translate([2.75, 2.75, -overlap]) {
            translate([   0,    0, 0]) cylinder(r=1.5, h=(2 + overlap * 2), $fn=16);
            translate([33.5,    0, 0]) cylinder(r=1.5, h=(2 + overlap * 2), $fn=16);
            translate([   0, 45.5, 0]) cylinder(r=1.5, h=(2 + overlap * 2), $fn=16);
            translate([33.5, 45.5, 0]) cylinder(r=1.5, h=(2 + overlap * 2), $fn=16);
        }
    }
    translate([ 3.8, 12.2, pcb_thick])  color("blue") cube([15, 19, 16]);
    translate([20.2, 12.2, pcb_thick])  color("blue") cube([15, 19, 16]);
    translate([ 3.8,    4, pcb_thick])  color("blue") cube([15, 8, 10.2]);
    translate([20.2,    4, pcb_thick])  color("blue") cube([15, 8, 10.2]);
    translate([ 9, 46.5, 1.6]) pin_connector(4, 1);
    translate([ 9, 46.5, 1.6]) dupont_female(4, 1, [-1, 1, 0]);
    translate([24, 46.5, 1.6]) pin_connector(3, 1);
}

//------------------------------------------------------------------------
// Two-relays module manufactured by Keyes.
//------------------------------------------------------------------------
module board_2relays_keyes() {
    // Board with 3.6 mm holes.
    difference() {
        color("red") cube([45.5, 55, 2]);
        translate([3.5, 9, -overlap]) {
            translate([ 0,  0, 0]) cylinder(r=1.8, h=(2 + overlap * 2), $fn=16);
            translate([38,  0, 0]) cylinder(r=1.8, h=(2 + overlap * 2), $fn=16);
            translate([0,  40, 0]) cylinder(r=1.8, h=(2 + overlap * 2), $fn=16);
            translate([38, 40, 0]) cylinder(r=1.8, h=(2 + overlap * 2), $fn=16);
        }
    }
    translate([7.5, 15, 2])  color("blue") cube([15, 19, 16]);
    translate([23, 15, 2])   color("blue") cube([15, 19, 16]);
    translate([14.5, 48, 2]) pin_connector(6, 1);
}

//------------------------------------------------------------------------
// PCD8544 LCD module (from Nokia 5110/3310 phones), blue PCB.
// Pin on bottom, 3.2 mm holes spaced 34.5 x 41
//------------------------------------------------------------------------
module board_pcd8544_blue() {
    difference() {
        color("darkblue") cube([43, 45.5, 1.2]);
        translate([4.25, 2.25, -overlap]) {
            translate([ 0.0,  0, 0]) cylinder(r=1.6, h=(1.2 + overlap * 2), $fn=16);
            translate([34.5,  0, 0]) cylinder(r=1.6, h=(1.2 + overlap * 2), $fn=16);
            translate([ 0.0, 41, 0]) cylinder(r=1.6, h=(1.2 + overlap * 2), $fn=16);
            translate([34.5, 41, 0]) cylinder(r=1.6, h=(1.2 + overlap * 2), $fn=16);
        }
    }
    // Frame and LCD screen.
    difference() {
        translate([1.5, 6.0, 1.2])
            color("silver") cube([40, 34, 4]);
        translate([3.25, 7.5, 1.2 + 4 - 0.5])
            cube([36.5, 26, 0.6]);
    }
    translate([10.5, 2 + 2.54, 0])
        rotate(a=180, v=[1, 0, 0]) {
            pin_connector(8, 1);
            dupont_female(8, 1, [1, 1, 0]);
        }
}

//------------------------------------------------------------------------
// PCD8544 LCD module (from Nokia 5110/3310 phones), red PCB.
// Pin on top, 2.5 mm holes spaced 40 x 39
//------------------------------------------------------------------------
module board_pcd8544_red() {
    difference() {
        color("red") cube([43.5, 43.0, 1.2]);
        translate([1.75, 2.0, -overlap]) {
            translate([ 0,  0, 0]) cylinder(r=1.25, h=(1.2 + overlap * 2), $fn=16);
            translate([40,  0, 0]) cylinder(r=1.25, h=(1.2 + overlap * 2), $fn=16);
            translate([ 0, 39, 0]) cylinder(r=1.25, h=(1.2 + overlap * 2), $fn=16);
            translate([40, 39, 0]) cylinder(r=1.25, h=(1.2 + overlap * 2), $fn=16);
        }
    }
    // Frame and LCD screen.
    difference() {
        translate([1.75, 5, 1.2])
            color("silver") cube([40, 34, 4]);
        translate([3.5, 7, 1.2 + 4 - 0.5])
            cube([36.5, 26, 0.6]);
    }
    translate([11.5, 42.5, 0])
        rotate(a=180, v=[1, 0, 0]) {
            pin_connector(8, 1);
            dupont_female(8, 1, [-1, 1, 0]);
        }
}

//------------------------------------------------------------------------
// Sub-models for the Raspberry Pi Model B v.2
//------------------------------------------------------------------------
module video_rca() {
    x = 10; y = 9.8; z = 13;
    d = 8.3; h = 9.5;
    color("yellow") cube([x, y, z]);
    translate([-h, y / 2, (d / 2) + 4])
        rotate(a=90, v=[0, 1, 0])
            color("silver") cylinder(r=(d / 2), h=h);
}
module audio_jack() {
    x = 11.4; y = 12; z = 10.2;
    d = 6.7; h = 3.4;
    color("blue") cube([x, y, z]);
    translate([-h, y / 2, (d / 2) + 3])
        rotate(a=90, v=[0, 1, 0])
            color("blue") cylinder(r=(d / 2), h=h);
}
module ethernet_connector(x, y, z) {
    color("silver") cube([x, y, z]);
}
module usb_connector(x, y, z) {
    f = 0.6; // Flange
    color("silver") cube([x, y, z]);
    translate([-f, y - f, -f])
        color("silver") cube([x + f * 2, f, z + f * 2]);
}
module hdmi_connector(x, y, z) {
    color("silver") cube([x, y, z]);
}
module microusb_connector(x, y, z) {
    color("silver") cube([x, y, z]);
}
module capacitor(d, h) {
    color("silver") cylinder(r=(d / 2), h=h);
}

//------------------------------------------------------------------------
// Raspberry Pi Model B v.2
//------------------------------------------------------------------------
module board_raspberrypi_model_b_v2() {

    x  = 56;     y = 85;    z =  1.6;	// Official
    ex = 15.40; ey = 21.8; ez = 13.0;	// Official
    ex = 16.00; ey = 21.3; ez = 13.5;	// Measured
    ux = 13.25; uy = 17.2; uz = 15.3;	// Official
    hx = 11.40; hy = 15.1; hz = 6.15;	// Official
    mx =  7.60; my =  5.6; mz = 2.40;	// Official

    // The origin is the lower face of PCB.
    translate([0, 0, z]) {
        translate([x - 2 - ex, y - ey + 1, 0])     ethernet_connector(ex, ey, ez);
        translate([1.5, 1.0, 0])                   pin_connector(2, 13);
        translate([1.5, 1.0, 0])                   dupont_female(1, 6, [-1, -1, 0]);
        translate([2.1, 40.6, 0])                  video_rca();
        translate([0, 59.0, 0])                    audio_jack();
        translate([18.8, 85 - uy + 7.7, 0])        usb_connector(ux, uy, uz);
        translate([x - hx + 1.2, 37.5, 0])         hdmi_connector(hx, hy, hz);
        translate([x - mx - 3.6, -0.5, 0])         microusb_connector(mx, my, mz);
        translate([14, -18, -4.4])                 sd_card();     // Inserted
        //translate([14, -32, -4.4])               sd_card();     // Extracted
        translate([x - mx - 3.6 + 0.375, -3, 0.3]) microusb_plug();
        translate([49.35, 12.75])                  capacitor(6.5, 8);
        translate([18.8 + 0.625, 83, 10.4])        wifi_usb_edimax();
        translate([0, 0, -z]) {
            difference() {
                color("green") cube([x, y, z]);
                translate([(x - 18), 25.5, -overcut]) cylinder(r=(2.9 / 2), h=(z + overcut * 2), $fn=16);
                translate([12.5, (y - 5), -overcut])  cylinder(r=(2.9 / 2), h=(z + overcut * 2), $fn=16);
            }
        }
    }
}
