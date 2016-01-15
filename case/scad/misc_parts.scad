//------------------------------------------------------------------------
// Rocker switch.
//------------------------------------------------------------------------
module rocker_switch() {
    x1 = 19.0; y1 = 12.0; z1 = 10.5;
    x2 = 21.5; y2 = 15.0; z2 =  2.0;
    x3 = 0.75; y3 =  4.9; z3 =  8.5;
    x4 = 15;   y4 =  10;  z4 =  4;
    step = 6.8;
    pin = 3;
    union() {
        color("brown") translate([-(x1 / 2), -(y1 / 2), -z1]) cube([x1, y1, z1]);
        color("brown") translate([-(x2 / 2), -(y2 / 2), 0])   cube([x2, y2, z2]);
        color("brown") rotate(a=10, v=[0, 1, 0]) translate([-(x4 / 2), -(y4 / 2), 0]) cube([x4, y4, z4]);
        for(i = [0 : (pin -1)]) {
            translate([-(((pin - 1) * step / 2)) + (step * i) - (x3 / 2), -(y3 / 2), -(z1 + z3)])
                color("silver") cube([x3, y3, z3]);
        }
    }
}

//------------------------------------------------------------------------
// Coaxial power plug 2.1 mm.
//------------------------------------------------------------------------
module coax_power_jack() {
    r1 = 5.00; h1 = 4;
    r2 = 4.00; h2 = 8.0;
    r3 = 2.75; h3 = 10;  // Hole
    r4 = 6.50; h4 = 2.2; // Bolt
    r5 = 1.05; h5 = 3.0; // Center pin
    x1 = 2.2; y1 = 0.3; z1 = 5;
    step = 4.5;
    color([0.15, 0.15, 0.15]) difference() {
        union() {
            cylinder(r=r1, h=h1, $fn=18);
            translate([0, 0, -h2]) cylinder(r=r2, h=h2, $fn=18);
        }
        translate([0, 0, -h3 + h1 ]) cylinder(r=r3, h=(h3 + overcut), $fn=18);
    }
    color("silver") cylinder(r=r5, h=h5, $fn=18);
    translate([0, 0, -(h4 + 2)]) color("gray") cylinder(r=r4, h=h4, $fn=6);
    translate([-(x1 / 2), (step - y1) / 2, -(h2 + z1)])  color("gold") cube([x1, y1, z1]);
    translate([-(x1 / 2), -(step + y1) / 2, -(h2 + z1)]) color("gold") cube([x1, y1, z1]);
}

//------------------------------------------------------------------------
// Mini push button.
//------------------------------------------------------------------------
module push_button() {
    $fn = 24;
    r1 = 2; h1 = 4;
    r2 = 3; h2 = 6.5;
    r3 = 5; h3 = 8.0;
    r4 = 4.5; h4 = 1.8;
    x1 = 2.5; y1 = 0.3; z1 = 6;
    step = 5;
    translate([0, 0, h2])  color("black")  cylinder(r=r1, h=h1);
    translate([0, 0, 0])   color("silver") cylinder(r=r2, h=h2);
    translate([0, 0, -h3]) color("gray")   cylinder(r=r3, h=h3);
    translate([0, 0, 2])   color("gray")   cylinder(r=r4, h=h4, $fn=6);
    translate([-(x1 / 2), (step - y1) / 2, -(h3 + z1)])  color("gold") cube([x1, y1, z1]);
    translate([-(x1 / 2), -(step + y1) / 2, -(h3 + z1)]) color("gold") cube([x1, y1, z1]);
}

//------------------------------------------------------------------------
// Matrix of 2.54 mm dupont female connectors.
//------------------------------------------------------------------------
module dupont_female(cols, rows, wire_v) {
    w = 2.54; h = 14;
    wire_d = 1.2;
    z = 2.74; // Stay 0.2 mm above the pin connector.
    for(x = [0 : (cols -1)]) {
        for(y = [0 : (rows  - 1)]) {
            translate([w * x, w * y, z]) {
                color("black") cube ([w, w, h]);
                translate([w / 2, w / 2, h]) {
                    color("red") cylinder(r=wire_d / 2, h=2.5);
                        translate([0, 0, 2.5]) rotate(a=90, v=wire_v)
                            color("red") cylinder(r=wire_d / 2, h=10, $fn=12);
                }
            }
        }
    }
}

//------------------------------------------------------------------------
// Matrix of 2.54 mm pins.
//------------------------------------------------------------------------
module pin_connector(cols, rows) {
    w = 2.54; h = 2.54; p = 0.64;
    for(x = [0 : (cols -1)]) {
        for(y = [0 : (rows  - 1)]) {
            translate([w * x, w * y, 0]) {
                union() {
                    color("black") cube([w, w, h]);
                    color("gold")  translate([(w - p) / 2, (w - p) / 2, -3]) cube([p, p, 11.54]);
                }
            }
        }
    }
}

//------------------------------------------------------------------------
// Secure Digital Memory Card 24x32 mm.
//------------------------------------------------------------------------
module sd_card() {
    color("blue")
        linear_extrude(height=2.1)
            polygon([[0, 0], [24, 0], [24, 32], [4.5, 32], [0, (32 - 4.5)]]);
}

//------------------------------------------------------------------------
// Generic Micro-USB connector.
//------------------------------------------------------------------------
module microusb_plug() {
    x1 = 6.85; y1 = 6.70; z1 = 1.80;
    x2 = 10.5; y2 = 19;   z2 = 7;
    r1 = 3.2;  r2 = 2.4; h = 10;
    color("silver") cube([x1, y1, z1]);
    color("black") translate([-(x2 - x1) / 2, -19, -(z2 - z1) / 2]) cube([x2, y2, z2]);
    color("black") translate([x1/2, -y2, z1/2]) rotate(a=90, v=[1, 0, 0]) cylinder(r1=r1, r2=r2, h=h);
}

//------------------------------------------------------------------------
// Nano WiFi USB dongle by Edimax (EW-7811UN).
//------------------------------------------------------------------------
module wifi_usb_edimax() {
    x1 = 12.0; y1 = 12.0; z1 = 4.5;
    x2 = 15.0; y2 =  5.5; z2 = 7.0;
    color("gold") cube([x1, y1, z1]);
    translate([(x1 - x2) / 2, y1, (z1 - z2) / 2])
        color("black") cube([x2, y2, z2]);
}
