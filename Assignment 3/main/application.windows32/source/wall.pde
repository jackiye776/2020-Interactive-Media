// The canvas that shapes are place onto

Wall wall1 = new Wall(0, 0, 1800, 900); // LEFT
Wall wall2 = new Wall(1800, 0, 1800, 900); // MID
Wall wall3 = new Wall(1800*2, 0, 1800, 900); // RIGHT

class Wall {
  int wX; // posX
  int wY; // posYs
  int wW; // width
  int wH; // height
  
  Wall(int x, int y, int w, int h) {
    this.wX = x;
    this.wY = y;
    this.wW = w;
    this.wH = h;
  }
  
  void display() {
    fill(50, 100, 200);
    rectMode(CORNER);
    rect(wX, wY, wW, wH);
  } // end display

} // end Wall

void wallsDisplay() {
  wall1.display();
  wall2.display();
  wall3.display();
} // end wallsDisplay
