screw_tolerance = 0.7;

module screw_slot( diameter, depth, height, tolerance = screw_tolerance ) {
  $fs = 0.01;
  $fa = 2;

  diameter = diameter + tolerance;
  radius   = diameter / 2.0;

  union() {
    translate([ 0, 0, radius ])
      cube( size = [
        diameter, depth, height - (2 * radius) ]);

    translate([ radius, 0, radius ])
      rotate([ -90, 0, 0])
        cylinder( r = radius, depth );

    translate([ 0, 0, height - (2 * radius) ])
      translate([ radius, 0, radius ])
        rotate([ -90, 0, 0])
          cylinder( r = radius, depth );
  }
}


module recessed_screw( inner_diameter, outer_diameter, height = 50, tolerance = screw_tolerance ) {
  $fs = 0.01;
  $fa = 2;

  inner_rad = (inner_diameter / 2) + tolerance;
  outer_rad = (outer_diameter / 2) + tolerance;

  cylinder( r = outer_rad, height );
  translate([ 0, 0, -height + 1 ])
    cylinder( r = inner_rad, height + 1);
}
