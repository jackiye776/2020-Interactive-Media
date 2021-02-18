size(600, 600);
background(#94FC8F);
ellipseMode(CORNER);

// Variables 
float leftEye_x = 385;
float rightEye_x = 425;
float eye_y = 200;

float leftPupil_x = leftEye_x+5;
float rightPupil_x = rightEye_x+5;
float pupil_y = eye_y;

float leftIris_x = leftPupil_x + 5;
float rightIris_x = rightPupil_x + 5;
float iris_y = pupil_y + 5;

float eyeWidth = 20;
float eyeHeight = eyeWidth/1.5;
float pupil = eyeWidth/2;
float iris = pupil/2;

// TAIL
strokeWeight(2);
stroke(#895620);
fill(#FADD9F);
rect(200, 150, 15, 100, 10, 10, 0, 10);

// LEG
rect(240, 250, 20, 100); // Back L-Leg
rect(360, 250, 20, 100); // Back R-Leg
rect(230, 250, 20, 100); // Front L-leg
rect(350, 250, 20, 100); // Front R-Leg
fill(#F5E2B9);

// BODY
ellipse(200, 200, 200, 100);
fill(#FADFA4);

// HEAD
ellipse(360, 160, 100, 100);

// EARS
triangle(365, 195, 370, 140, 395, 175); // Left
triangle(455, 195, 440, 140, 425, 175); // Right

// EYES
fill(#000000);
ellipse(leftEye_x, eye_y, eyeWidth, eyeHeight); // Left
ellipse(rightEye_x, eye_y, eyeWidth, eyeHeight); // Right
// PUPIL
strokeWeight(1);
fill(#FFFFFF);
ellipse(leftPupil_x, pupil_y, pupil, pupil); // Left
ellipse(rightPupil_x, pupil_y, pupil, pupil); // Right
// IRIS
fill(#1E72F5);
stroke(#FFFFFF);
ellipse(leftIris_x, iris_y, iris, iris); // Left
ellipse(rightIris_x, iris_y, iris, iris); // Right

// WHISKERS
stroke(#FFFFFF);
strokeWeight(3);
//Left 
line(405, 220, 380, 230);
line(410, 222, 385, 235);
line(415, 224, 390, 240);
//Right
line(420, 220, 450, 230); 
line(415, 222, 445, 235); 
line(410, 224, 440, 240);

// NOSE
strokeWeight(2);
fill(0, 0, 0);
stroke(0, 0, 0);
triangle(405, 220, 415, 230, 425, 220);

// MOUTH
line(415, 230, 415, 235);
line(415, 235, 408, 240);
line(415, 235, 422, 240);
