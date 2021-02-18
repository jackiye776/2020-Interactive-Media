/* Reference:-
  https://processing.org/reference/camera_.html
*/

// Controls Perspectives
void cameras() {
  if(play) {
    camera((width/2)*3, height/2, (height/2)+1100 / tan(PI/6), width/2*2 + mouseX, height/2, 0, 0, 1, 0);
  } else {
    if (wallNum == 0) {
      camera(width/2, height/2, (height/2) / tan(PI/6), width/2, height/2, 0, 0, 1, 0);
    }
    if (wallNum == 1) {
      camera((width/2)*3, height/2, (height/2) / tan(PI/6), (width/2)*3, height/2, 0, 0, 1, 0);
    }
    if (wallNum == 2) {
      camera((width/2)*5, height/2, (height/2) / tan(PI/6), (width/2)*5, height/2, 0, 0, 1, 0);
    }
  }
} // end cameras()
