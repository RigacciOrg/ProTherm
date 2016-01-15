module rounded_square(x, y, r) {
    $fn = 60;
    points = [[r, 0], [x -r , 0], [x, r], [x, y - r], [x - r, y], [r, y], [0, y - r], [0, r]];
    union() {
        polygon(points);
        translate([r, r]) circle(r=r);
        translate([x - r, r]) circle(r=r);
        translate([x - r, y - r]) circle(r=r);
        translate([r, y - r]) circle(r=r);
    }
}

module rounded_cube(x, y, z, r) {
    linear_extrude(z)
        rounded_square(x, y, r);
}

module rounded_cube_centered(x, y, z, r) {
    translate([-(x / 2), -(y / 2), 0])
        rounded_cube(x, y, z, r);
}

module rounded_cube_border(x, y, z, r, t) {
    difference() {
        translate([-t, -t, 0]) rounded_cube(x + t * 2, y + t * 2, z, r);
        translate([0, 0, -overcut]) rounded_cube(x, y, z + overcut * 2, r);
    }
}
