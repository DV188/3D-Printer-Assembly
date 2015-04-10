// Settlers of Catan robber game piece.
// Sizes are represented as mm.

$fn = 60;

// Letter to be extracted form the top of the piece, including font.
extrudeLetter = "S";
extrudeFont = "Vani:style=Bold";


module robberBase(radius, height) {
	rotate_extrude(convexity = 10, $fn = 100)
		polygon(points = [[0,0],[radius,0],[radius, height*0.75],[radius*0.90, height],[0, height]]);
}

/* Parameters:  height represents the height from the underside of the base to the top of the head.
				radius determins the size of the largest part of the body/base. */
module robber(radius, height) {
	headSize = radius*0.75;
	letterSize = radius;

	difference() {
		union() {

			translate([0, 0, height - headSize]) {
				sphere(r = headSize);
			}

			translate([0, 0, (height - headSize)/2]) {
				resize([0, 0, height - headSize]) {
					sphere(r = radius);
				}
			}

			robberBase(radius, height*0.10);
		}

		translate([-letterSize/2.25, -letterSize/2.25, height - radius/8]) {
			linear_extrude(radius/4, center = true) {
				text(extrudeLetter, font = extrudeFont, size = letterSize);
			}
		}
	}
}

robber(6.5, 30);
