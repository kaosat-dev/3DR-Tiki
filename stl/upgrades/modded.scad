//!OpenSCAD
// Kossel Mini carriage for IGUS DryLin TWE-04-12
// Licence: CC BY-SA 3.0, http://creativecommons.org/licenses/by-sa/3.0/
// Author: Dominik Scholz <schlotzz@schlotzz.com> and contributors
// Based upon: https://github.com/jcrocholl/kossel/blob/master/carriage.scad by jcrocholl
// visit: http://www.schlotzz.com


// Increase this if your slicer or printer make holes too tight.
extra_radius = 0.1;

// OD = outside diameter, corner to corner.
m3_nut_od = 6.1;
m3_nut_radius = m3_nut_od/2 + 0.2 + extra_radius;
m3_washer_radius = 3.5 + extra_radius;

// Major diameter of metric 3mm thread.
m3_major = 2.85;
m3_radius = m3_major/2 + extra_radius;
m3_wide_radius = m3_major/2 + extra_radius + 0.2;

mountToMountWidth = m3_wide_radius + 1.2 + 20 +1.65*2;
echo(mountToMountWidth);

separation = 34;//27.8;
thickness = 2;

horn_zoffset = 2;
horn_thickness = 10;
horn_x = 8;
horn_z = horn_thickness / 2+horn_zoffset;

belt_width = 6;
belt_x = 5.6;
belt_z = thickness;

screw_xdist = mountToMountWidth/2;//15;
screw_ydist = 15;//15;

mounts_height = 2;
mounts_heightTop = 10;

beltClampToCenter = 11;
magnetDia = 4;
magnetThickness = 2;
magnetMountThickness = magnetDia+2;

mountBolt_y = 20;

foo = m3_wide_radius + 1.2;
//carriage();
//magnetMount();
superCool();

module magnetMount(){

	difference(){
   union(){
   
    hull(){
	    for (x = [-screw_xdist, screw_xdist])
		  {
			  translate([x, screw_ydist, 0])
		    cylinder(r = foo, h = magnetMountThickness, center = true, $fn = 20);
		  }
    }
   }

    for (x = [-screw_xdist, screw_xdist])
		{
				translate([x, screw_ydist, thickness])
					 cylinder(r = m3_wide_radius, h = 30, center = true, $fn = 12);
		}
		
		translate([0, screw_ydist+magnetMountThickness/2, 0])
		rotate([90,0,0])
		cylinder(r = magnetDia/2, h = magnetThickness+0.0001, $fn = 20);
  }
}

module superCool(){
  
  boudinHeight = 12;
  difference(){
    union(){
      import("centerPlate3.stl", convexity = 5);
      for (x = [-screw_xdist, screw_xdist])
      {
	      for (y = [-screw_ydist, screw_ydist])
	      {
		      translate([x, y, thickness/2])
			      cylinder(r = m3_wide_radius + 1.2, h = boudinHeight, center = false, $fn = 20);
	      }
      }
       hull() {
              translate([0, -screw_ydist, 0])
              cube([20, 10, thickness], center = true);
              for (x = [-screw_xdist, screw_xdist])
        		{
    					translate([x, -screw_ydist, 0])
    				cylinder(r = m3_wide_radius + 1.2, h = thickness, center = true, $fn = 20);
    				
    				}
        }
        
        hull() {
              translate([0, screw_ydist, 0])
              cube([20, 10, thickness], center = true);
              for (x = [-screw_xdist, screw_xdist])
        		{
    					translate([x, screw_ydist, 0])
    				cylinder(r = m3_wide_radius + 1.2, h = thickness, center = true, $fn = 20);
    				
    				}
        }
	     
	   }
	   
	   for (y = [-screw_ydist+1.2, screw_ydist-1.2])
		 {
		 				translate([0, y, thickness])
	    cylinder(r = m3_wide_radius+0.2, h = 30, center = true, $fn = 12);
	   }
	   
	   // screws for linear slider
		for (x = [-screw_xdist, screw_xdist])
		{
			for (y = [-screw_ydist, screw_ydist])
			{
				translate([x, y, thickness])
					 cylinder(r = m3_wide_radius, h = 30, center = true, $fn = 12);
			}
		}
	   
	}

}


module carriage()
{

	clearance = 0.125;

	// timing belt, up and down
	for (x = [-belt_x, belt_x])
		translate([x, 0, belt_z + belt_width / 2])
			% cube([1.7, 100, belt_width], center = true);


	difference()
	{

	    union()
		{
			// main body
			translate([0, 0, thickness / 2])
            {
				//cube([27, 36, thickness], center = true);
                hull() {
                  cube([20, 18, thickness], center = true);
                  for (x = [-screw_xdist, screw_xdist])
            		{
        					translate([x, -screw_ydist, 0])
        				cylinder(r = m3_wide_radius + 1.2, h = thickness, center = true, $fn = 20);
        				
        				}
                }

					hull() {
                  cube([20, 18, thickness], center = true);
                  for (x = [-screw_xdist, screw_xdist])
            		{
        					translate([x, screw_ydist, 0])
        				cylinder(r = m3_wide_radius + 1.2, h = thickness, center = true, $fn = 20);
        				
        				}
                }
                
            }
			// ball joint mount horns
			translate([0, -16, 0])
				for (x = [-1, 1])
				{
					scale([x, 1, 1])
					{
						intersection()
						{
							translate([0, 16, horn_z])
								cube([separation, 18, horn_thickness], center = true);
							translate([horn_x, 16, horn_z])
								rotate([0, 90, 0])
									cylinder(r1 = 14, r2 = 2.5, h = separation / 2 - horn_x);
						}
					}
				}

			// screws for linear slider inforcement
			for (x = [-screw_xdist, screw_xdist])
			{
				for (y = [-screw_ydist, screw_ydist])
				{
					translate([x, y, mounts_height / 2])
						cylinder(r = m3_wide_radius + 1.2, h = mounts_height, center = true, $fn = 20);
				}
			}

		// screws for top hall-o magnet mount
			for (x = [-screw_xdist, screw_xdist])
			{

					translate([x, screw_ydist, mounts_heightTop / 2])
						cylinder(r = m3_wide_radius + 1.2, h = mounts_heightTop, center = true, $fn = 20);
				
			}




			// belt clamps for GT2
			difference()
			{
				union()
				{
					for (y = [-beltClampToCenter, beltClampToCenter])
					{
						union()
						{
							translate([-0.5 - clearance * 2, y, horn_thickness / 2 + 1])
								cube([1, 14, horn_thickness - 2], center = true);
							translate([-1 - clearance * 2, y, horn_thickness / 2 + 1])
								cube([2, 12, horn_thickness - 2], center = true);
							for (n = [-6, 6])
								translate([-1 - clearance * 2, y + n, horn_thickness / 2 + 1])
									cylinder(r = 1, h = horn_thickness - 2, center = true, $fn = 16);

							translate([3.25 - clearance, y, horn_thickness / 2 + 1])
								cube([5, 14, horn_thickness - 2], center = true);

							translate([7.5, y, horn_thickness / 2 + 1])
								cube([2, 14, horn_thickness - 2], center = true);
						}
					}
				}

				// tooth cutout
				for (x = [1.125 - 0.300 - clearance, 5.375 + 0.30 - clearance])
				{
					for (y = [0 : 19])
					{
						translate([x, 19 - y * 2, 6 - 0.001-4])
							cylinder(r = 0.7, h = horn_thickness / 2 + 5, $fn = 16);
					}
				}

				// cutout for easier inserting of belt
				for (x = [0.5 - clearance, 6 - clearance])
					translate([x, 0, horn_thickness])
						rotate([0, 45, 0])
							cube([2 + clearance / 2, 50, 2 + clearance / 2], center = true);

				// avoid touching diagonal push rods (carbon tube)
				translate([20, -20, 12.5])
					rotate([35, 35, 30])
						cube([40, 40, 20], center = true);
			}

		}

		// screws for linear slider
		for (x = [-screw_xdist, screw_xdist])
		{
			for (y = [-screw_ydist, screw_ydist])
			{
				translate([x, y, thickness])
					# cylinder(r = m3_wide_radius, h = 30, center = true, $fn = 12);
			}
		}

		// screws for ball joints
		translate([0, 0, horn_z])
			rotate([0, 90, 0])
				# cylinder(r = m3_wide_radius, h = 60, center = true, $fn = 12);

		// lock nuts for ball joints
		for (x = [-1, 1])
		{
			scale([x, 1, 1])
			{
				intersection()
				{
					translate([horn_x, 0, horn_z])
						rotate([90, 0, -90])
							cylinder(r1 = m3_nut_radius, r2 = m3_nut_radius + 0.5, h = 8, center = true, $fn = 6);
				}
			}
		}


	}

}



