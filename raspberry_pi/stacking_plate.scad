// raspbery pi mounting plate
// for use with standoffs and screws.
// expecting m2.5 screw sizes for mounting pi
// expecting m3 screw sizes for outer standoffs.

grey = [.9,.9,.9];
red = [1,0,0];
green = [0,.7,0];

plate_thickness = 3;
subtraction_thickness = plate_thickness + 1;

m_25 = 1.9; // M2.5 screw no bite
corner_buffer = 1.5;
buffered_screw_hole_diameter = m_25 + corner_buffer;

m_30 = 2.0; // M3.0 screw no bite

plate_length = 85;
plate_width = 56;
border_width = 18;

draw_everything();

module draw_everything(){
    difference(){
        union(){
        standoff_tab_placement();
        draw_plate();
    }pcb_screw_placement();}
}

module draw_plate(){
    difference(){
        main_plate(plate_length, plate_width, plate_thickness);
        main_plate(plate_length - border_width, plate_width - border_width, subtraction_thickness);
        pcb_screw_placement();
    }
}

module standoff_tab_placement(){
    // x, y, z_rotate
    standoff_tab(29, -29, -90);
    standoff_tab(-29, -29, 90);
    standoff_tab(15, 43.5, 0);
    standoff_tab(-15, 43.5, 0);
    standoff_tab(28, -42.5, 225);
    standoff_tab(-28, -42.5, -225);
    standoff_tab(-28, 42.5, 45);
    standoff_tab(28, 42.5, -45);
}

module standoff_tab(x, y, z_rotate){
    screwhole_offset = 4.4;
    translate([ x, y, 0]) rotate([0,0,z_rotate]) {
        difference(){
            standoff_base(); 
            translate([0, screwhole_offset, 0]) screw(m_30);
        }
    }
}

module standoff_base(){
    $fn = 100;
    minkowski(){
        cylinder(r=5,h=plate_thickness/2 , center = true);
        cube([1,10,plate_thickness/2], center = true);
    }
}

module main_plate(length, width, thickness){

    // using inner outer method to draw curved corners.

    curve_offset = 2 * (m_25 + corner_buffer);
    
    // long cube
    cube(size = [width - curve_offset, length, thickness], center = true);
    
    // wide cube
    cube(size = [width, length - curve_offset, thickness], center = true);
    
    x_offset = (width/2) - (buffered_screw_hole_diameter);
    y_offset = (length/2) - (buffered_screw_hole_diameter);
    
    translate([x_offset,y_offset,0])pcb_corner(thickness);
    translate([-x_offset,y_offset,0])pcb_corner(thickness);
    translate([x_offset,-y_offset,0])pcb_corner(thickness);
    translate([-x_offset,-y_offset,0])pcb_corner(thickness);
}

module pcb_corner(thickness){
    $fn = 100;  // for smoothness
    corner_diameter = buffered_screw_hole_diameter;
    cylinder(thickness, corner_diameter, corner_diameter ,center=true);
}

module pcb_screw_placement(){
    /* 
    This should never be scaled as it relates to the dimensions of the 
    screw holes in the raspberry pi. 
    */
    
    screw_hole_distance_width = 49; // x axis
    screw_hole_distance_length = 58; // y axis
    screw_hole_offset = 3;
    
    y_offset = ( (plate_length - (screw_hole_distance_length + m_25))  / 2) - screw_hole_offset;
    
    translate([0, y_offset, 0])
    {
        translate([screw_hole_distance_width/2, screw_hole_distance_length/2, 0])
            screw(m_25);
        translate([screw_hole_distance_width/2, -screw_hole_distance_length/2, 0])
            screw(m_25);
        translate([-screw_hole_distance_width/2, -screw_hole_distance_length/2, 0])
            screw(m_25);
        translate([-screw_hole_distance_width/2, screw_hole_distance_length/2, 0])
            screw(m_25);
    }
}

module screw(diameter){
    // add more sides to polygon
    $fn = 100;
    cylinder(subtraction_thickness, diameter, diameter, center=true);
}
