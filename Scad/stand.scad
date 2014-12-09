
dim_tol = 1.0;
width   = 80;
depth   = 70;
face_depth = 15;
back_releif = 4;

base_height = 10;

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
    main_base();

    side_base_cuts();

    mirror([1,0,0])
      side_base_cuts();
  }
}

module riser() {

}

translate([0, (depth/2) + dim_tol, 0])
  base();
