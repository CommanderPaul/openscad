//  Note: any mysterious +1 entries are for aestetics when rendering images

/*
// TODO print and push to repo!
  do we need a gap between pin and socket? .2mm?
  is screw hole size correct? or is it off?
// TODO organize modules and code cleanup
// TODO gopro 2 and 3 pin connectors
// TODO add recess for hex nuts
// TODO add hook for device cable

*/

draw_parts();
module draw_parts(){
  knob_height = 15;                     // multiple of 3 is best
  knob_diameter = 15;                   // same as knob_height makes it square
  screw_hole_diameter = 5; // screw hole prints out to 4 when set to 5?
  number_of_fragments = 300;
  
/*
  socket_pin_connector_1(knob_height, knob_diameter, screw_hole_diameter, number_of_fragments);
    translate([0,30,0])
  socket_pin_connector_2(knob_height, knob_diameter, screw_hole_diameter, number_of_fragments);
  translate([0,60,0])
  socket_socket_connector_1(knob_height, knob_diameter, screw_hole_diameter, number_of_fragments);
  translate([0,90,0])
  pin_pin_connector_1(knob_height, knob_diameter, screw_hole_diameter, number_of_fragments);
  translate([0,-30,0])


  translate([0,-60,0])
  post_clamp_pin_connector_1(knob_height, knob_diameter, screw_hole_diameter, number_of_fragments);
    */
 // translate([0,-110,0])
 // post_clamp_socket_connector_1(knob_height, knob_diameter, screw_hole_diameter, number_of_fragments);
  
    socket_pin_connector_for_mic(knob_height, knob_diameter, screw_hole_diameter, number_of_fragments);
  
}

module post_clamp_socket_connector_1(knob_height, knob_diameter, screw_hole_diameter, number_of_fragments){
  rotate_pin = false;
  segment_length = 10;
  post_diameter = 38;
  post_clamp_socket_connector(knob_height, knob_diameter, screw_hole_diameter, rotate_pin, post_diameter, segment_length, number_of_fragments);
}

module post_clamp_socket_connector(knob_height, knob_diameter, screw_hole_diameter, rotate_pin, post_diameter, segment_length, number_of_fragments){
  fill_angle = 345;
  band_thickness = 2;
  base_length = 5;
  socket_gap_override = 0;
  post_clamp(knob_height, knob_diameter, post_diameter, fill_angle, band_thickness, base_length, screw_hole_diameter, number_of_fragments);
  translate([segment_length + knob_diameter/4,0,0])
  if (rotate_pin){
    rotate([90,0,180])
    socket_connector(knob_height, knob_diameter, screw_hole_diameter, segment_length, socket_gap_override, number_of_fragments);
  } else {
    rotate([0,0,180])
    socket_connector(knob_height, knob_diameter, screw_hole_diameter, segment_length, socket_gap_override, number_of_fragments);
  }
}


module post_clamp_pin_connector_1(knob_height, knob_diameter, screw_hole_diameter, number_of_fragments){
  rotate_pin = false;
  segment_length = 10;
  post_diameter = 38;
  post_clamp_pin_connector(knob_height, knob_diameter, screw_hole_diameter, rotate_pin, post_diameter, segment_length, number_of_fragments);
}


module post_clamp_pin_connector(knob_height, knob_diameter, screw_hole_diameter, rotate_pin, post_diameter, segment_length, number_of_fragments){
  fill_angle = 345;
  band_thickness = 2;
  base_length = 5;
  pin_height_override = 0;
  post_clamp(knob_height, knob_diameter, post_diameter, fill_angle, band_thickness, base_length, screw_hole_diameter, number_of_fragments);
  translate([segment_length + knob_diameter/4,0,0])
  if (rotate_pin){
    rotate([90,0,180])
    pin_connector(knob_height, knob_diameter, screw_hole_diameter, segment_length, pin_height_override, number_of_fragments);
  } else {
    rotate([0,0,180])
    pin_connector(knob_height, knob_diameter, screw_hole_diameter, segment_length, pin_height_override, number_of_fragments);
  }
}

module post_clamp(knob_height, knob_diameter, post_diameter, fill_angle, band_thickness, base_length, screw_hole_diameter, number_of_fragments){
  translate([-base_length/2,0,0])
  union(){
    post_band(post_diameter, band_thickness, fill_angle, knob_height, number_of_fragments);  
    post_band_base(post_diameter, base_length, knob_diameter, band_thickness, fill_angle, knob_height, number_of_fragments);
    post_band_tabs(post_diameter, fill_angle, knob_height, band_thickness, screw_hole_diameter, number_of_fragments);
  }
}

module post_band(post_diameter, band_thickness, fill_angle, knob_height, number_of_fragments){
  translate([-post_diameter/2,0,0])
  rotate([0,0,-(fill_angle / 2)])
  color("grey")
  rotate_extrude(convexity = 10, $fn = number_of_fragments, angle = fill_angle){
    translate([post_diameter / 2, 0, 0])
    square([band_thickness, knob_height], center = true);
  }
}

// TODO fix order of parameters
module post_band_base(post_diameter, base_length, knob_diameter, band_thickness, fill_angle, knob_height, number_of_fragments){
  difference(){
    color("lightgreen")
    cube([base_length, knob_diameter, knob_height], center = true);
    translate([-post_diameter/2,0,0])
    cylinder(h = knob_height + 1, d = post_diameter, center = true, $fn = number_of_fragments);
  }
}

module post_band_tabs(post_diameter, fill_angle, knob_height, band_thickness, screw_hole_diameter, number_of_fragments){
  tab_base_length  = 8;
  translate([-post_diameter/2,0,0])
  union(){
    rotate([0,0,(-fill_angle - 360) / 2])
    translate([-post_diameter/2 - (tab_base_length - band_thickness/2),0,0])
    post_band_tab(knob_height, band_thickness, screw_hole_diameter, tab_base_length, number_of_fragments);

    rotate([0,0,(fill_angle - 360) / 2])
    translate([-post_diameter/2 - (tab_base_length - band_thickness/2),0,0])
    post_band_tab(knob_height, band_thickness, screw_hole_diameter, tab_base_length, number_of_fragments);
  }
}

module post_band_tab(knob_height, band_thickness, screw_hole_diameter, tab_base_length,  number_of_fragments){
  difference(){
    color("lightgreen")
    union(){
      rotate([90,0,0])
      cylinder(h = band_thickness, d = knob_height, center = true, $fn = number_of_fragments);  
      translate([tab_base_length/2, 0, 0])
      cube([tab_base_length, band_thickness, knob_height], center = true);
    }
    color("red")  
    rotate([90,0,0])
    cylinder(h = band_thickness + 1, d = screw_hole_diameter, center = true, $fn = number_of_fragments);
  }
}




/////////// custom constructs ///////////////////////
module socket_pin_connector_for_mic(knob_height, knob_diameter, screw_hole_diameter, number_of_fragments){
  span_length = 100;
  rotate_pin = false;
  override_socket_pin_knob_diameter = true;
  socket_pin_knob_diameter = 23;
  socket_gap_override = 6;
  pin_height_override = 0;
  
  segment_length = span_length / 2;  
  span_offset = (span_length) + (knob_diameter / 2);  
  
  if (override_socket_pin_knob_diameter){
  socket_connector(knob_height, socket_pin_knob_diameter, screw_hole_diameter, segment_length, socket_gap_override, number_of_fragments);
  if (rotate_pin) {
     translate([span_offset, 0, 0]) rotate([90,0,180])
  pin_connector(knob_height, knob_diameter, screw_hole_diameter, segment_length, pin_height_override, number_of_fragments); 
  } else {
    translate([span_offset, 0, 0]) rotate([0,0,180])
  pin_connector(knob_height, knob_diameter, screw_hole_diameter, segment_length, pin_height_override, number_of_fragments);
  }
  } else {

  socket_connector(knob_height, knob_diameter, screw_hole_diameter, segment_length, socket_gap_override, number_of_fragments);
  if (rotate_pin) {
     translate([span_offset, 0, 0]) rotate([90,0,180])
  pin_connector(knob_height, knob_diameter, screw_hole_diameter, segment_length, pin_height_override, number_of_fragments); 
  } else {
    translate([span_offset, 0, 0]) rotate([0,0,180])
  pin_connector(knob_height, knob_diameter, screw_hole_diameter, segment_length, pin_height_override, number_of_fragments);
  }
  }
  
  
  




  
  
  
  
  
  
}

module socket_pin_connector_1(knob_height, knob_diameter, screw_hole_diameter, number_of_fragments){
  span_length = 220;
  rotate_pin = false;
  socket_gap_override = 0;
  pin_height_override = 0;
  socket_pin_connector(knob_height, knob_diameter, screw_hole_diameter, span_length, rotate_pin, socket_gap_override, pin_height_override, number_of_fragments);
}

module socket_pin_connector_2(knob_height, knob_diameter, screw_hole_diameter, number_of_fragments){
  span_length = 30;
  rotate_pin = true;
  socket_gap_override = 0;
  pin_height_override = 0;
  socket_pin_connector(knob_height, knob_diameter, screw_hole_diameter, span_length, rotate_pin, socket_gap_override, pin_height_override, number_of_fragments);
}

module socket_socket_connector_1(knob_height, knob_diameter, screw_hole_diameter, number_of_fragments){
  span_length = 30;
  rotate_pin = true;
  socket_gap_override = 0;
  pin_height_override = 0;
  socket_socket_connector(knob_height, knob_diameter, screw_hole_diameter, span_length, rotate_pin, socket_gap_override, pin_height_override, number_of_fragments);
}

module pin_pin_connector_1(knob_height, knob_diameter, screw_hole_diameter, number_of_fragments){
  span_length = 30;
  rotate_pin = true;
  socket_gap_override = 0;
  pin_height_override = 0;
  pin_pin_connector(knob_height, knob_diameter, screw_hole_diameter, span_length, rotate_pin, socket_gap_override, pin_height_override, number_of_fragments);
}

/////////// generic constructs ///////////////////////
module pin_pin_connector(knob_height, knob_diameter, screw_hole_diameter, span_length, rotate_pin, socket_gap_override, pin_height_override, number_of_fragments){
  segment_length = span_length / 2;
  span_offset = (span_length) + (knob_diameter / 2);
  pin_connector(knob_height, knob_diameter, screw_hole_diameter, segment_length, socket_gap_override, number_of_fragments);
  if (rotate_pin) {
     translate([span_offset, 0, 0]) rotate([90,0,180])
  pin_connector(knob_height, knob_diameter, screw_hole_diameter, segment_length, socket_gap_override, number_of_fragments); 
  } else {
    translate([span_offset, 0, 0]) rotate([0,0,180])
  pin_connector(knob_height, knob_diameter, screw_hole_diameter, segment_length, socket_gap_override, number_of_fragments);
  }
}



module socket_socket_connector(knob_height, knob_diameter, screw_hole_diameter, span_length, rotate_pin, socket_gap_override, pin_height_override, number_of_fragments){
  segment_length = span_length / 2;
  span_offset = (span_length) + (knob_diameter / 2);
  socket_connector(knob_height, knob_diameter, screw_hole_diameter, segment_length, socket_gap_override, number_of_fragments);
  if (rotate_pin) {
     translate([span_offset, 0, 0]) rotate([90,0,180])
  socket_connector(knob_height, knob_diameter, screw_hole_diameter, segment_length, socket_gap_override, number_of_fragments); 
  } else {
    translate([span_offset, 0, 0]) rotate([0,0,180])
  socket_connector(knob_height, knob_diameter, screw_hole_diameter, segment_length, socket_gap_override, number_of_fragments);
  }
}

module socket_pin_connector(knob_height, knob_diameter, screw_hole_diameter, span_length, rotate_pin, socket_gap_override, pin_height_override, number_of_fragments){
  segment_length = span_length / 2;
  span_offset = (span_length) + (knob_diameter / 2);
  socket_connector(knob_height, knob_diameter, screw_hole_diameter, segment_length, socket_gap_override, number_of_fragments);
  if (rotate_pin) {
     translate([span_offset, 0, 0]) rotate([90,0,180])
  pin_connector(knob_height, knob_diameter, screw_hole_diameter, segment_length, pin_height_override, number_of_fragments); 
  } else {
    translate([span_offset, 0, 0]) rotate([0,0,180])
  pin_connector(knob_height, knob_diameter, screw_hole_diameter, segment_length, pin_height_override, number_of_fragments);
  }
}

module pin_connector(knob_height, knob_diameter, screw_hole_diameter, segment_length, pin_height_override, number_of_fragments){
  pin_end(knob_height, knob_diameter, screw_hole_diameter, pin_height_override, number_of_fragments);
  base_connector(knob_height, knob_diameter, segment_length, number_of_fragments); 
}

module socket_connector(knob_height, knob_diameter, screw_hole_diameter, segment_length, socket_gap_override, number_of_fragments){
  socket_end(knob_height, knob_diameter, screw_hole_diameter, socket_gap_override, number_of_fragments);
  base_connector(knob_height, knob_diameter, segment_length, number_of_fragments);  
}

module pin_end(knob_height, knob_diameter, screw_hole_diameter, pin_height_override, number_of_fragments){
  difference(){
    pin_cylinder(knob_height, knob_diameter, pin_height_override, number_of_fragments);
    knob_screw_hole(knob_height, screw_hole_diameter, number_of_fragments);
  }
}

module socket_end(knob_height, knob_diameter, screw_hole_diameter, socket_gap_override, number_of_fragments){
  difference(){
    socket_cylinder(knob_height, knob_diameter, number_of_fragments);
    knob_screw_hole(knob_height, screw_hole_diameter, number_of_fragments);
    pin_cylinder(knob_height, knob_diameter + 1, socket_gap_override, number_of_fragments);
  }
}

module base_connector(knob_height, knob_diameter, segment_length, number_of_fragments){
  span_offset_from_knob = knob_diameter/4 + segment_length/2;
  difference(){
    translate([span_offset_from_knob,0,0])
    color("lightblue")
    cube([segment_length, knob_height, knob_height], center = true);
    color("red")  
    socket_cylinder(knob_height + 1, knob_diameter, number_of_fragments);
  }
}

module socket_cylinder(knob_height, knob_diameter, number_of_fragments){
  color("lightgreen")  
  cylinder(h = knob_height, d = knob_diameter, center = true, $fn = number_of_fragments);
}


module pin_cylinder(knob_height, knob_diameter, height_override, number_of_fragments){
  color("lightgreen")  
  if (height_override == 0){
    cylinder(h = knob_height / 3, d = knob_diameter, center = true, $fn = number_of_fragments);
  } else {
    cylinder(h = height_override, d = knob_diameter, center = true, $fn = number_of_fragments);
  }
}

module knob_screw_hole(knob_height, screw_hole_diameter, number_of_fragments){
    color("red")
    cylinder(h = knob_height + 1, d = screw_hole_diameter, center = true, $fn = number_of_fragments);
}

