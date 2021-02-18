// http://eif-research.feit.uts.edu.au/api/csv/?rFromDate=2020-08-20T00%3A00%3A38&rToDate=2020-08-21T21%3A27%3A34&rFamily=weather&rSensor=SR

Table sunTable;
int index = 0;

float radOut;
float radIn;

float theta = 0.0;

int point1 = int(random(5, 9)), point2 = int(random(5, 9)), point3 = int(random(5, 9));

void setup() {
  size(600, 600);
  //sunTable = loadTable("http://eif-research.feit.uts.edu.au/api/csv/?rFromDate=2020-08-20T00%3A00%3A38&rToDate=2020-08-21T21%3A27%3A34&rFamily=weather&rSensor=SR", "csv");
  sunTable = loadTable("Solar Radiation.csv");
  radOut = height/2.3;
  radIn = radOut*.12;
  
}

void draw() {
  background(0);
  translate(width/2, height/2);
  if (index < sunTable.getRowCount()) {
    // read the 2nd column (the 1), and read the row based on index which increments each draw()
    int d = sunTable.getInt(index, 1); // index is the row, 1 is the column with the data.

    if( d > 0) {
      // Morning
      background(252, 238, 69);
      rotate(theta);
      pushMatrix();
      fill(247, 145, 20); // sun colour - #F79114
      star(18, radIn, d);
      popMatrix();
      
    } else {
      // Night
      background(0);
      fill(255);
      ellipse(0, 0, 400, 400);
      
      rotate(theta);
      
      pushMatrix();
      translate(-250, 50);
      star(point1, 20, 5);
      popMatrix();
      
      pushMatrix();
      translate(200, 120);
      star(point2, 20, 5);
      popMatrix();
      
      pushMatrix();
      translate(-100, -250);
      star(point3, 20, 5);
      popMatrix();
    }
    
    theta += 0.015; // rotate sun
    index++; // next row
    
  }
}

void star(int pointCount, float innerRadius, float outerRadius) {
  float theta = 0.0;
  // point count is 1/2 of total vertex count
  int vertCount = pointCount*2;
  float thetaRot = TWO_PI/vertCount;
  float tempRadius = 0.0;
  float x = 0.0, y = 0.0;
  
  beginShape();
  for (int i =0; i<pointCount; i++) {
    for (int j=0; j<2; j++) {
      tempRadius = innerRadius;
      
      // true if j is even
      if (j%2==0) {
        tempRadius = outerRadius;
      }
      
      x = cos(theta)*tempRadius;
      y = sin(theta)*tempRadius;
      vertex(x, y);
      theta += thetaRot;
    }
  }
  endShape(CLOSE);
}
