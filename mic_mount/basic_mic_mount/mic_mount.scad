number_of_fragments = 300;

// the band wraps around the post
band_thickness = 2;
band_height = 22;
band_diameter = 38;
fill_angle = 320;  // fill_angle - 360 = gap between tabs

// draw parts
clamp_ring(fill_angle);
rotate([0,180,0])securing_tab();  // fixed tab 
rotate([0,180,fill_angle])securing_tab();  // angle tab
mount_tab();

module mount_tab(){
  screw_hole_diameter = 6;
  tab_base_length = 30;
  tab_width = 15;
  tab_slot = 6;
  rotate([0,0,(fill_angle - 360) /2])
  translate([-(tab_base_length + band_diameter / 2 - band_thickness / 2), 0,0 ])
  band_tab(tab_slot, screw_hole_diameter, tab_base_length, tab_width);
}

module securing_tab(){
  screw_hole_diameter = 6;
  tab_base_length = 11;
  tab_width = 2;
  tab_slot = 0;
  translate([-(tab_base_length + band_diameter / 2 - band_thickness / 2), 0,0 ])    
  band_tab(tab_slot, screw_hole_diameter, tab_base_length, tab_width);
}

module band_tab(tab_slot, screw_hole_diameter, tab_base_length, tab_width){
  difference(){
    color("lightgreen")
    union(){
      rotate([90,0,0])
      cylinder(h = tab_width, d = band_height, center = true, $fn = number_of_fragments);  
      translate([tab_base_length/2, 0, 0])
      cube([tab_base_length, tab_width, band_height], center = true);
    }
    color("red")  
    union(){
      translate([tab_base_length*1.5, 0, 0])
      cube([tab_base_length, tab_width + 1, band_height], center = true);
      rotate([90,0,0])
      cylinder(h = tab_width + 1, d = screw_hole_diameter, center = true, $fn = number_of_fragments);
      if (tab_slot > 0){
        cube([band_height + 1, tab_slot, band_height + 1], center = true);
      }
    }    
  }
}

module clamp_ring(fill_angle){
  color("lightblue")
  rotate_extrude(convexity = 10, $fn = number_of_fragments, angle = fill_angle){
    translate([band_diameter / 2, 0, 0])
    square([band_thickness, band_height], center = true);
  }
}
