/*
 * Designed for 3D printing For Computer Scientists
 * http://www.catan.com/
 * http://dv188.github.io/3D-Printing-For-Computer-Scientists/#/introduction
 *
 * Settlers of Catan is a popular board game designed by Klaus Teuber.  Players
 * assume the role of settlers with the goal of gathering resources to gain a
 * strategic advantage over their competition.
 *
 * In Settlers of Catan, there exists a robber game piece that can be used to
 * prevent other players from gaining resources in a specific location.  This
 * OpenSCAD model has been designed to represent a trophy in the shape of this
 * robber token game piece.  The trophy can be 3D printed and given as reward
 * to the winner of a Catan game.  The model even includes a bottle opener
 * towards the bottom of the model.
 *
 * This model is meant to be parameterized and able to be resized outside of
 * the scaling offered by slicing software.  Default measurements are in
 * millimetres (mm).
 */

// Specifies the modules from external file containing the Catan Robber.
// Allows the modules to be used in this file as if they were defined here.
use <Catan Robber.scad>

$fn = 60; // Determines the resolution of round features throughout the model.

/*
 * The base of the trophy is designed below.  The trophy base is created to
 * look like a typical trophy base and includes Catan text.
 *
 * Parameters:
 *      length - determines the extrude length which results in increasing the x-axis wrt. the Catan lettering
 *      width - determines the depth of the base wrt. the catan lettering
 *      height - determines the base height wrt. the positive z-axis
 */
module trophy_base(length, width, height) {
    text_angle = 90 - atan((height*0.90)/(width*0.25)); // Determines the angle of the lettering to match that of the size dimenstions.

    // Remove cylinders from base to create an inverse bevelled look.
    difference() {
        // Add text to base.
        union() {
            linear_extrude(height = length, center = true) {
                polygon([[0,0],[width,0],[width,height*0.10],[width*0.75,height],[0,height]]);
            }

            translate([width - 3, height*0.15, 0]) {
                rotate([0, 90, text_angle]) {
                    linear_extrude(3) text("CATAN", font = "Georgia:sltyle=Bold", size = 12, halign = "center");
                }
            }
        }

        // Cylinders to be removed from base.
        translate([0, height, 0])
            cylinder(length, r = height*0.25, center = true);

        translate([width/2, height, length/2])
            rotate([0, 90, 0]) cylinder(width, r = height*0.25, center = true);

        translate([width/2, height, -(length/2)])
            rotate([0, 90, 0]) cylinder(width, r = height*0.25, center = true);
    }
}

/*
 * Board games with friends can take some time to complete.  During the game
 * duration, players will often enjoy refreshments that require bottle openers.
 * Included in the Catan Robber Trophy is a bottle opener.  This module creates
 * the bottle opener that later includes a slot for a coin for which the bottle
 * cap is caught over.
 *
 * Parameters:
 *      large - determines the length of the larger side of the trapezoid
 *      small - determines the length of the smaller side of the trapezoid
 *      height - determines how high the bottle opener will be
 *      radius - determines how rounded the corners will be
 */
module bottle_opener(large, small, height, radius) {
    center_small = (large - small)/2; // Offsets small to be centered with respect to large.

    // Connects four circles at each corner to create rounded trapezoid.
    hull() {
        translate([-(large/2) + radius, -(height/2) + radius, 0]) circle(r = radius);
        translate([(large/2) - radius, -(height/2) + radius, 0]) circle(r = radius);
        translate([(small/2) - radius, (height/2) - radius, 0]) circle(r = radius);
        translate([-(small/2) + radius, (height/2) - radius, 0]) circle(r = radius);
    }
}

/*
 * This module combines submodules created earlier to combine the parts
 * required to build the entire Catan Robber Trophy.  The Trophy module
 * incorporates the robber, trophy base, and bottle opener into one cohesive
 * model.
 *
 * The size of the bottle opener is somewhat set in stone as it's size for a Canadian nickel.
 * Rendering the trophy smaller than the opener will cause problems.
 *
 * Parameters:
 *      base_length - determines the x-axis with respect to the catan lettering
 *      base_width -  determines the depth with respect to the catan lettering
 *      base_height -  determines the z-axis height of the base, used to shift the robber to top of base
 *      robber_radius - determines how round to make the robber, if the robber is too round compared to the height the robber will not show up
 *      robber_height - determines the height of the robber in the z-axis
 */
module Trophy(base_length, base_width, base_height, robber_radius, robber_height) {
    difference () {
        union() {
            translate([0, 0, base_height]) robber(robber_radius, robber_height); // Robber.

            translate([-(base_width*0.375 + base_height*0.125), 0, 0])
                rotate([90, 0, 0]) trophy_base(base_length, base_width, base_height); // Trophy base.
        }

        rotate ([0, 0, -90]) {
            translate([0, 0, 4.99]) {
                linear_extrude(10, center = true)
                    bottle_opener(34 , 28, 30, 1); // Bottle opener.
            }
        }

        // Cutout to store a nickel for bottle opening.
        union() {
            translate([21, 0, 3])
                cylinder(2, r = 11, center = true);
            translate([0, -11, 2])
                cube([21, 22, 2]);
        }
    }
}

Trophy(60, 60, 20, 15, 80); // Draws the trophy.
