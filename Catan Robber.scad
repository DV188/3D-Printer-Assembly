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
 * OpenSCAD model has been designed to represent the shape of this robber token
 * game piece.  The robber can be 3D printed and will be used to create the
 * Catan Robber Trophy for 3D Printing For Computer Scientists.
 *
 * This model is meant to be parameterized and able to be resized outside of
 * the scaling offered by slicing software.  Default measurements are in
 * millimetres (mm).
 */

/*
 * This module is responsible for creating the circular base at the bottom of
 * the Catan robber token.  The result is a chamfered disk with given
 * parameters.
 *
 * Parameters:
 *      radius - determines the radius of the base
 *      height - determines how high the base will be
 */
module robber_base(radius, height) {
    rotate_extrude(convexity = 10, $fn = 100)
        polygon(points = [[0, 0], [radius, 0], [radius, height*0.75], [radius*0.90, height], [0, height]]);
}

/*
 * The robber module produces the robber token based on given parameters.  The
 * robber is meant to replicate the game piece in Settlers of Catan.
 *
 * Parameters:
 *      radius - determines the radius of the robber token wrt. the robber body
 *      height - determines the height of the robber token
 */
module robber(radius, height) {
    head_size = radius*0.75;

    // Combine spherical head with elongated sphere body and the robber base.
    union() {
        translate([0, 0, height - head_size]) {
            sphere(r = head_size);
        }

        translate([0, 0, (height - head_size)/2]) {
            resize([0, 0, height - head_size]) {
                sphere(r = radius);
            }
        }

        robber_base(radius, height*0.10);
    }
}
