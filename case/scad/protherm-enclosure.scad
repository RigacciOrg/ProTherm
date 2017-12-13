//See:
// http://edutechwiki.unige.ch/en/OpenScad_beginners_tutorial
// https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/

// Global variables.
overcut = 0.1;  // Overcut for solid difference(), to assure complete holes.
overlap = 0.1;  // Intersection for solid union() to avoid the manifold problem.

include <misc_parts.scad>;
include <boards.scad>;
include <rounded_cube.scad>;

// Box internal size.
x_size  = 115.0;
y_size  = 144.0;
z_size  =  29.0;
thick   =   2.2;
chamfer =  13.0;

// Mounting screw holes.
screw_hole1_y = 24;
screw_hole2_y = y_size - 26;
screw_diam    = 3.6;

// Position and size of push button hole.
button_x = x_size;
button_y = 64;
button_z = 16.0;
button_d = 6.4;

// Position and size of power socket hole.
psocket_x = x_size / 2;
psocket_z = 7;
psocket_d = 8.2;

// Position and size for temperature sensor grommet.
tsensor_x  = -thick - 1;
tsensor_y  = 78;
tsensor_z  = 13;
tsensor_h  = thick + 9;
tsensor_d1 = 9.0;
tsensor_d2 = 5.5;

// Positon and size for boiler cable grommet (cable is 5.5 x 3.5 mm).
bcable_x  = 19;
bcable_y  = -thick - 1;
bcable_z  = 9.5;
bcable_h  = thick + 9;
bcable_t  = 1.7; // Grommet thickness
bcable_d1 = 5.4; // Rectangular hole X
bcable_d2 = 3.4; // Rectangular hole Y
bcable_r  = 1.5; // Chamfer radius

//-------------------------------------------------------------------------
// Housing for a rubber foot.
//-------------------------------------------------------------------------
module rubber_foot(d1, d2, h) {
    $fn = 48;
    difference() {
        cylinder(r=(d1 / 2), h=h);
        translate([0, 0, -overcut]) cylinder(r=(d2 / 2), h=(h + overcut * 2));
    }
}

//-------------------------------------------------------------------------
// Housings for rubber feet (grows towards negative z axis).
//-------------------------------------------------------------------------
module box_feet(x, y, margin) {
    d1 = 11.0;
    d2 =  8.2;
    h  =  0.8;
    translate([margin,     margin,     -h]) rubber_foot(d1, d2, h + overlap);
    translate([x - margin, margin,     -h]) rubber_foot(d1, d2, h + overlap);
    translate([x - margin, y - margin, -h]) rubber_foot(d1, d2, h + overlap);
    translate([margin,     y - margin, -h]) rubber_foot(d1, d2, h + overlap);
}

//-------------------------------------------------------------------------
// Flange for screw hole.
//-------------------------------------------------------------------------
module screw_flange(r, t) {
    $fn = 60;
    screw_diameter = 2.2;
    r1 = r * 1.1;
    difference() {
        intersection() {
            cylinder(r=r1, h=t);
            union() {
                translate([r, r, 0]) cylinder(r=r, h=t);
                translate([r, 0, 0]) cube([r, r, t]);
                translate([0, r, 0]) cube([r, r, t]);}}
        translate([r1 / 2, r1 / 2, -overcut]) cylinder(r=(screw_diameter * 0.75 / 2), h=(t + overcut * 2), $fn=24);
    }
}

//-------------------------------------------------------------------------
// Add a flange to the rounded_box() module.
//-------------------------------------------------------------------------
module rounded_box_flange(x, y, z, r) {
    w = 1.5;
    difference() {
        rounded_cube(x_size, y_size, z, r);
        translate([w, w, -overcut])
            rounded_cube(x_size - w * 2, y_size - w * 2, z + overcut * 2, r);
    }
    translate([0, 0, 0]) rotate(a=0 ,  v=[0, 0, 1]) screw_flange(r, z);
    translate([x, 0, 0]) rotate(a=90,  v=[0, 0, 1]) screw_flange(r, z);
    translate([x, y, 0]) rotate(a=180, v=[0, 0, 1]) screw_flange(r, z);
    translate([0, y, 0]) rotate(a=270, v=[0, 0, 1]) screw_flange(r, z);
}

//-------------------------------------------------------------------------
// Round cable grommet.
//-------------------------------------------------------------------------
module cable_grommet(h, d1, d2) {
    $fn = 32;
    cut_width = 3;
    difference() {
        union() {
            cylinder(r=(d1 / 2), h=h);
            translate([0, 0, h - 2.4]) cylinder(r=((d1 + 1.0) / 2), h=2.4);
        }
        translate([0, 0, -overcut]) cylinder(r=(d2 / 2), h=(h + 2 * overcut));
        translate([(d2 / 4), -(d1 / 2), h - (cut_width + 2.5)])
            cube([(d1 / 2), d1, cut_width]);
    }
}

//-------------------------------------------------------------------------
// Rectangular (with chamfer) cable grommet.
// h = height, x, y = hole inner size, r = chamfer radius, t = thickness
//-------------------------------------------------------------------------
module cable_grommet_rect(h, x, y, r, t) {
    cut_width = 3;
    difference() {
        union() {
            translate([-x / 2, -y / 2, 0]) rounded_cube_border(x, y, h, r, t);
            translate([-x / 2, -y / 2, h - 2.4]) rounded_cube_border(x, y, 2.4, r, t + 0.5);
        }
        translate([-(x / 2) - t - overcut, 0, h - (cut_width + 2.5)])
            cube([x + (t + overcut) * 2, y / 2 + t + overcut, cut_width]);
    }
}

//-------------------------------------------------------------------------
// Drill a screw hole with cuts for horizontal and vertical wall mount.
// Screw body diameter is d, head diameter will be d * 2.
//-------------------------------------------------------------------------
module screw_hole(d, depth) {
    $fn = 32;
    hole_depth = depth + overcut * 2;
    hole_bottom = -(depth + overcut);
    cut_length = d * 2;
    union() {
        translate([0, 0, hole_bottom])          cylinder(r=d, h=hole_depth);
        translate([-(d / 2), 0, hole_bottom])   cube([d, cut_length, hole_depth]);
        translate([0, -(d / 2), hole_bottom])   cube([cut_length, d, hole_depth]);
        translate([0, cut_length, hole_bottom]) cylinder(r=(d / 2), h=hole_depth);
        translate([cut_length, 0, hole_bottom]) cylinder(r=(d / 2), h=hole_depth);
    }
}

//-------------------------------------------------------------------------
// Build a cap to place over a screw hole.
// Screw body diameter = d
// Screw head diameter = d * 2
// Screw head height   = d * 0.6
//-------------------------------------------------------------------------
module screw_hole_cap(d, thick) {
    $fn = 36;
    r2 = 1.4142;
    pin_radius = thick * 1.3;
    pin_heigh = (d * 0.6) + (overlap * 2);
    pin_base = -overlap;
    offset = (((pin_radius * r2) - pin_radius) / r2) + ((pin_radius * 2) / r2) + (d / r2);
    size1 = (offset + overlap) * 2;
    size2 = size1 + d * 2;
    translate([-(size1 / 2), -(size1 / 2), 0]) {
        union() {
            translate([0, 0, d * 0.6]) rounded_cube(size1, size2, thick, pin_radius);
            translate([0, 0, d * 0.6]) rounded_cube(size2, size1, thick, pin_radius);
            translate([pin_radius, pin_radius, pin_base])                 cylinder(r=pin_radius, h=pin_heigh);
            translate([size2 - pin_radius, pin_radius, pin_base])         cylinder(r=pin_radius, h=pin_heigh);
            translate([size2 - pin_radius, size1 - pin_radius, pin_base]) cylinder(r=pin_radius, h=pin_heigh);
            translate([size1 - pin_radius, size2 - pin_radius, pin_base]) cylinder(r=pin_radius, h=pin_heigh);
            translate([pin_radius, size2 - pin_radius, pin_base])         cylinder(r=pin_radius, h=pin_heigh);
        }
    }
}

//-------------------------------------------------------------------------
// Make a box with the requested internal size and rounded corners.
// The origin is the lower-left internal corner.
//-------------------------------------------------------------------------
module rounded_box(x_size, y_size, z_size, chamfer, thick) {
    cover_thick = 2;
    union() {
        translate([-overlap, -overlap, -thick])
            rounded_cube(x_size + overlap * 2, y_size + overlap * 2, thick, chamfer + overlap);
        translate([0, 0, -thick])
            rounded_cube_border(x_size, y_size, z_size + thick, chamfer, thick);
        translate([-overlap, -overlap, z_size - cover_thick - thick])
            rounded_box_flange(x_size + overlap * 2, y_size + overlap * 2, thick, chamfer + overlap);
        translate([0, 0, -thick])
            box_feet(x_size, y_size, 10);
        // Draw the box cover, for dimension testing.
        //translate([0, 0, z_size - cover_thick]) 
        //    %rounded_cube(x_size, y_size, cover_thick, chamfer);
    }
}

//-------------------------------------------------------------------------
// Make a box with rounded corners, drill all the required holes.
//-------------------------------------------------------------------------
module rounded_box_holes(x_size, y_size, z_size, chamfer, thick) {

    holes_diam = 3.5;

    // Boiler cable grommet.
    translate([bcable_x, bcable_y, bcable_z])
        rotate(a=180, v=[0, 1, 0])
            rotate(a=270, v=[1, 0, 0])
                cable_grommet_rect(bcable_h, bcable_d1, bcable_d2, bcable_r, bcable_t);

    // Temperature sensor cable grommet.
    translate([tsensor_x, tsensor_y, tsensor_z])
        rotate(a=90, v=[1, 0, 0])
            rotate(a=90, v=[0, 1, 0])
                cable_grommet(tsensor_h, tsensor_d1, tsensor_d2);

    difference() {
        rounded_box(x_size, y_size, z_size, chamfer, thick);

        // Bottom venting holes.
        translate([x_size / 2, 0, z_size / 2])
            rotate(a=90, v=[1, 0, 0]) vent_holes(12, 3, holes_diam, thick);

        // Top venting holes.
        translate([x_size / 2, y_size + thick, z_size / 2])
            rotate(a=90, v=[1, 0, 0]) vent_holes(11, 3, holes_diam, thick);

        // Backplane venting holes.
        translate([83, 88, -thick]) vent_holes(8, 6, holes_diam, thick);
        translate([25, 38, -thick]) vent_holes(5, 4, holes_diam, thick);

        // Mounting screw holes.
        translate([x_size / 2, screw_hole1_y, 0]) rotate(a=90, v=[0, 0, 1]) screw_hole(screw_diam, thick);
        translate([x_size / 2, screw_hole2_y, 0]) rotate(a=90, v=[0, 0, 1]) screw_hole(screw_diam, thick);

        // Temperature sensor hole.
        translate([-(thick + overcut), tsensor_y, tsensor_z])
            rotate(a=90, v=[0, 1, 0]) cylinder(r=(tsensor_d2 / 2), h=(thick + overcut * 2), $fn=24);

        // Push-button hole.
        translate([button_x - overcut, button_y, button_z])
            rotate(a=90, v=[0, 1, 0]) cylinder(r=(button_d / 2), h=(thick + overcut * 2), $fn=24);

        // Power socket hole.
        translate([psocket_x, overcut, psocket_z])
            rotate(a=90, v=[1, 0, 0]) cylinder(r=(psocket_d / 2), h=(thick + overcut * 2), $fn=24);

        // Boiler cable hole.
        translate([bcable_x, bcable_y - overcut, bcable_z])
            rotate(a=270, v=[1, 0, 0]) rounded_cube_centered(bcable_d1, bcable_d2, bcable_h + overcut * 2, bcable_r);

    }

    // Reinforce for power socket hole.
    difference() {
        translate([psocket_x, 0, psocket_z]) rotate(a=90, v=[1, 0, 0]) cylinder(r=(psocket_d / 2) + 2.5, h=thick);
        translate([psocket_x, overcut, psocket_z])
            rotate(a=90, v=[1, 0, 0]) cylinder(r=(psocket_d / 2), h=(thick + overcut * 2), $fn=24);
    }

    // Reinforce for boiler cable hole.
    difference() {
        translate([bcable_x, 0, bcable_z])
            rotate(a=90, v=[1, 0, 0]) rounded_cube_centered(bcable_d1 + 5.5, bcable_d2 + 5.5, thick, 3);
        translate([bcable_x, overcut, bcable_z])
            rotate(a=90, v=[1, 0, 0]) rounded_cube_centered(bcable_d1, bcable_d2, (thick + overcut * 2), bcable_r);
    }

    // Mounting screws holes.
    translate([x_size / 2, screw_hole1_y, 0]) rotate(a=90, v=[0, 0, 1]) #screw_hole_cap(screw_diam, 1.7);
    translate([x_size / 2, screw_hole2_y, 0]) rotate(a=90, v=[0, 0, 1]) #screw_hole_cap(screw_diam, 1.7);
}

//-------------------------------------------------------------------------
// Drill a grid of rows x columns vent holes. Each hole has the
// specified diameter and depth, the grid is centered into the origin.
//-------------------------------------------------------------------------
module vent_holes(x, y, diameter, depth) {
    $fn = 6; // 18 = rounded holes, 6 = hexagonal
    step = diameter * 2;
    radius = diameter / 1.8;  // Divide by 2.0 if rounded holes, 1.8 if hexagonal.
    offset_x = (step * (x - 1)) / 2;
    offset_y = (step * (y - 1)) / 2;
    for (i = [1:x]) {
        for (j = [1:y]) {
            translate([(i - 1) * step - offset_x, (j -1) * step - offset_y, -overcut])
              cylinder(r=radius, h=(depth + overcut * 2));
        }
    }
    for (i = [1:x-1]) {
        for (j = [1:y-1]) {
            translate([(i - 1) * step - offset_x + step / 2, (j -1) * step - offset_y + step / 2, -overcut])
                cylinder(r=radius, h=(depth + overcut * 2));
        }
    }
}

//-------------------------------------------------------------------------
// Screw stub: d1 is the outer diameter, d2 is the screw diameter.
// The stub height must be grather than the depth of the hole.
//-------------------------------------------------------------------------
module stub(d1, height, d2, hole_depth) {
    $fn = 36;
    // The hole for a self-tapping screw is narrower than the screw.
    hole_diameter = d2 * 0.75;
    difference() {
        translate([0, 0, -overlap]) {
            union() {
                cylinder(r=(d1 / 2), h=(height + overlap));
                cylinder(r1=(d1 * 0.7), r2=(d1 / 2), h=(4 + overlap));
            }
        }
        translate([0, 0, height - hole_depth])
            cylinder(r=(hole_diameter / 2), h=(hole_depth + overcut));
    }
}

//-------------------------------------------------------------------------
// Screw stubs for relay board (SainSmart like manufacturer).
//-------------------------------------------------------------------------
module stubs_2relays_sainsmart(height) {
    diameter = 7;
    screw_diameter = 2.2;
    hole_depth = 6;
    // Offset of first (lower left) hole from edge.
    translate([2.75, 2.75, 0]) {
        translate([ 0,      0, 0]) stub(diameter, height, screw_diameter, hole_depth);
        translate([33.5,    0, 0]) stub(diameter, height, screw_diameter, hole_depth);
        translate([0,    45.5, 0]) stub(diameter, height, screw_diameter, hole_depth);
        translate([33.5, 45.5, 0]) stub(diameter, height, screw_diameter, hole_depth);
    }
}

//-------------------------------------------------------------------------
// Screw stubs for relay board (Keyes manufacturer).
//-------------------------------------------------------------------------
module stubs_2relays_keyes(height) {
    diameter = 7;
    screw_diameter = 2.2;
    hole_depth = 6;
    // Offset of first (lower left) hole from edge.
    translate([3.5, 9, 0]) {
        translate([ 0,  0, 0]) stub(diameter, height, screw_diameter, hole_depth);
        translate([38,  0, 0]) stub(diameter, height, screw_diameter, hole_depth);
        translate([0,  40, 0]) stub(diameter, height, screw_diameter, hole_depth);
        translate([38, 40, 0]) stub(diameter, height, screw_diameter, hole_depth);
    }
}

//-------------------------------------------------------------------------
// Screw stubs for PCD8544 LCD (Nokia 5110/3310), blue PCB model.
//-------------------------------------------------------------------------
module stubs_pcd8544_blue(height) {
    diameter = 6.5;
    screw_diameter = 2.2;
    hole_depth = 6;
    // Offset of first (lower left) hole from edge.
    translate([4.25, 2.25, 0]) {
        translate([ 0,    0, 0]) stub(diameter, height, screw_diameter, hole_depth);
        translate([34.5,  0, 0]) stub(diameter, height, screw_diameter, hole_depth);
        translate([0,    41, 0]) stub(diameter, height, screw_diameter, hole_depth);
        translate([34.5, 41, 0]) stub(diameter, height, screw_diameter, hole_depth);
    }
}

//-------------------------------------------------------------------------
// Screw stubs for PCD8544 LCD (Nokia 5110/3310), red PCB model.
//-------------------------------------------------------------------------
module stubs_pcd8544_red(height) {
    diameter = 6.0;
    screw_diameter = 2.2;
    hole_depth = 6;
    // Offset of first (lower left) hole from edge.
    translate([1.75, 2.0, 0]) {
        translate([ 0,  0, 0]) stub(diameter, height, screw_diameter, hole_depth);
        translate([40,  0, 0]) stub(diameter, height, screw_diameter, hole_depth);
        translate([ 0, 39, 0]) stub(diameter, height, screw_diameter, hole_depth);
        translate([40, 39, 0]) stub(diameter, height, screw_diameter, hole_depth);
    }
}

//-------------------------------------------------------------------------
// Screw stubs for Raspberry Pi Model B v.2.
//-------------------------------------------------------------------------
module stubs_raspberrypi_model_b_v2(height) {
    screw_diameter = 2.2;
    hole_depth = 6;
    translate([38, 25.5, 0]) {
        translate([    0,    0, 0]) stub(6.5, height, screw_diameter, hole_depth);
        translate([-25.5, 54.5, 0]) stub(6.5, height, screw_diameter, hole_depth);
    }
}

//-------------------------------------------------------------------------
// Main procedure.
//-------------------------------------------------------------------------
translate([-(x_size / 2), -(y_size/2), 0]) {
    rounded_box_holes(x_size, y_size, z_size, chamfer, thick);
    translate([ 5, 12,  0.0]) stubs_2relays_sainsmart(5.0);
    translate([ 8, 90,  0.0]) stubs_pcd8544_red(20.5); // Non diminuire Y sennò tocca il coprivite!
    translate([55, 37,  0.0]) stubs_raspberrypi_model_b_v2(5.0);
    //translate([55, 37 , 5.0]) board_raspberrypi_model_b_v2();
    //translate([ 8, 90, 20.5]) board_pcd8544_red();
    //translate([ 5, 12,  5.0]) board_2relays_sainsmart();
    //translate([button_x, button_y, button_z]) rotate(a=90, v=[0, 1, 0]) push_button();
    //translate([psocket_x, -thick, psocket_z]) rotate(a=90, v=[1, 0, 0]) coax_power_socket();
}

include <RigacciOrg.scad>;
translate([-x_size / 2 - thick + overlap, -29, 13])
    rotate(a=270, v=[0,0,1]) rotate(a=90, v=[1,0,0]) {
        //#cube([55, 12.54, 0.5], center=true);
        RigacciOrg(0.5);
    }

include <ccbysa.scad>;
translate([-x_size / 2 - thick + overlap, 34, 13])
    rotate(a=270, v=[0,0,1]) rotate(a=90, v=[1,0,0]) {
        //#cube([35.60, 12.54, 0.5], center=true);
        ccbysa(0.5);
    }

//-------------------------------------------------------------------------
// The cover: 2D shape for laser cutting. Load this geometry alone,
// Compile and Render (F6), Export to DXF (protherm-2d-cover.dxf).
//
// Nominal size on the X axis:
//
//   x_size - overcut * 2   =>   115.0 - 0.1 * 2 = 114.8
//
// The cutted real piece turned out to be 114.5 mm, then we suppose
// that the laser track on plexiglass is about 0.3 mm.
//-------------------------------------------------------------------------
screw_diameter = 2.5;
r1 = (chamfer - overcut) * 1.1;
x = x_size + overlap * 2;
y = y_size + overlap * 2;
translate([-(x_size / 2), -(y_size/2)]) {
    difference() {
      rounded_square(x_size - (overcut * 2), y_size - (overcut * 2), (chamfer - overcut));
      union() {
          translate([0, 0]) rotate(a=0 ,   v=[0, 0, 1]) translate([r1 / 2, r1 / 2]) circle(r=(screw_diameter / 2), $fn=24);
          translate([x, 0]) rotate(a=90,   v=[0, 0, 1]) translate([r1 / 2, r1 / 2]) circle(r=(screw_diameter / 2), $fn=24);
          translate([x, y]) rotate(a=180,  v=[0, 0, 1]) translate([r1 / 2, r1 / 2]) circle(r=(screw_diameter / 2), $fn=24);
          translate([0, y]) rotate(a=270,  v=[0, 0, 1]) translate([r1 / 2, r1 / 2]) circle(r=(screw_diameter / 2), $fn=24);
      }
    }
}
