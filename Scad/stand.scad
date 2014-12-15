use <lib/screws.scad>;

dim_tol     = 1.0;
width       = 80;
depth       = 70;
face_depth  = 15;
back_releif = 4;
base_height = 10;

riser_depth  = 10;
riser_height = 140;
riser_width  = (width + dim_tol * 2) - (back_releif * 2);
riser_open_height = 80;
riser_pylon_width = 10;

riser_av_cutout_rad = 10;
riser_av_vert_pos   = 45;

screw_slot_width  = 5;
screw_slot_height = 20;
screw_slot_releif = 6;
screw_slot_center_offset = base_height + 100;

base_screw_diameter = 4.0;
base_screw_y_offset_r1 = 9.8;
base_screw_sep = 50.0;

module side_base_cuts() {
  translate([ -(width/2) - dim_tol, (depth/2) + dim_tol - face_depth, 0 ])
    rotate( atan( back_releif / ( depth - face_depth ) ), [0,0,1] )
      translate([0, -depth * 1.6, - dim_tol])
        mirror([1, 0, 0])
          cube( size = [
            20 + (dim_tol * 2), depth * 2, base_height + ( dim_tol * 2 ) ]);
}

module main_base() {
  translate([ -(width/2) - dim_tol, -(depth/2) -dim_tol, 0 ])
    cube( size = [
      width + (2 * dim_tol), depth + ( 2 * dim_tol ), base_height ]);
}

module base() {
  difference() {
    union() {
      translate([0, (depth/2) + dim_tol, 0])
        difference() {
          main_base();

          side_base_cuts();

          mirror([1,0,0])
            side_base_cuts();
        }

        translate([ - (width/2) - dim_tol + back_releif,-riser_depth,0])
          cube( size = [
            width + (2 * dim_tol) - (2 * back_releif), riser_depth + 4, base_height ]);
    }

    translate([ - base_screw_sep / 2.0, base_screw_y_offset_r1, 4])
      recessed_screw( base_screw_diameter, base_screw_diameter + 5.0 );

    translate([ base_screw_sep / 2.0, base_screw_y_offset_r1, 4])
      recessed_screw( base_screw_diameter, base_screw_diameter + 5.0 );

    translate([ - base_screw_sep / 2.0, base_screw_y_offset_r1 + base_screw_sep, 4])
      recessed_screw( base_screw_diameter, base_screw_diameter + 5.0 );

    translate([ base_screw_sep / 2.0, base_screw_y_offset_r1 + base_screw_sep, 4])
      recessed_screw( base_screw_diameter, base_screw_diameter + 5.0 );
  }
}

module riser_screw_slot() {
  screw_slot_depth    = 2 + riser_depth;
  screw_slot_y_offset = - screw_slot_depth + 1;

  translate([  - (screw_slot_width / 2) , screw_slot_y_offset,  -( screw_slot_height / 2.0)])
    screw_slot( screw_slot_width, screw_slot_depth, screw_slot_height );

  releif_slot_width  = screw_slot_width * 3;
  releif_slot_height = screw_slot_height + (2 * screw_slot_releif);
  releif_slot_depth  = screw_slot_releif;

  translate([
    - (releif_slot_width / 2) ,
    screw_slot_y_offset - screw_slot_releif,
    - ( screw_slot_height / 2.0) - screw_slot_releif
  ])

    screw_slot( releif_slot_width, screw_slot_depth, releif_slot_height );
}

module riser() {
  $fs = 0.01;
  $fa = 2;

  finishing_cylinder_radius = riser_width / 2.0;
  scale_factor = riser_height / finishing_cylinder_radius;

  intersection() {
    difference() {
      translate([ - riser_width/2, - riser_depth, 0])
        cube(size = [
          riser_width, riser_depth, riser_height]);

      translate([0, - (riser_depth/2), base_height + riser_av_vert_pos])
        scale([1, 1.1, 2])
          rotate([90, 0, 0])
            cylinder( riser_depth + 2, r = riser_av_cutout_rad, center = true );

      translate([0, 0, screw_slot_center_offset ])
        riser_screw_slot();
    }

    scale( [1, 1, scale_factor ] )
      translate([0, 1, 0])
        rotate([90, 0, 0])
          cylinder( r = finishing_cylinder_radius, riser_depth + 2 );
  }
}

base();
riser();

