// The shapes / instruments that the user will be placing onto the "wall"

String audioType, instrument;
float pitch, rate = 1, bgRate = 1;
float vol = 0.2, bgVol = 0.05;
color getColour;

class Shape {
  String sName; // Instrument name
  float sNum;
  float sMouseX; // mouseX
  float sMouseY; // mouseY
  int sX; // shape width
  int sY; // shape height
  color sColor;
  
  boolean effect; 
  int expand = sX;
  
  Shape(String name, float num, float sMouseX, float sMouseY, color colour){
    this.sName = name;
    this.sNum = num;
    this.sMouseX = sMouseX;
    this.sMouseY = sMouseY;
    this.sX = 70;
    this.sY = 70;
    this.sColor = colour;
  } // Constructor Shape
  
  void display() {
    if(!play || lineX > width*3+30 || lineX < -100 || sNum > 5000) {
      sNum = 0;
      expand = 0;
      vol = 0.2;
    }
    pushMatrix();
    rectMode(CENTER);
    fill(sColor);
    strokeWeight(4);
    stroke(0);
    translate(0, 0, 1); 
    rect(this.sMouseX, this.sMouseY, sX, sY);
    popMatrix();
  } // end Display
  
  void playSound(float lineX) {
    float distance = (dist(abs(lineX), this.sMouseY, this.sMouseX, this.sMouseY));
    if((distance <= 2 && !fastForward) || (distance <=8 && fastForward)) {
      println("Play Sound!");
      effect = true;
      
      // selects audio depending on shape's name
      if(sName == "xylophone") {
        audioType = audioList.get(0);
      }
      if(sName == "guitar") {
        audioType = audioList.get(1);
      }
      if(sName == "drum") {
        audioType = audioList.get(2);
      }
      if(sName == "mysound") {
        audioType = audioList.get(3);
      }
      
      getColour = sColor; // used for the specialFX function

      SamplePlayer player = new SamplePlayer (ac, SampleManager.sample(audioType));
      if(reverse) {
        player.setToEnd();
        player.setLoopType(SamplePlayer.LoopType.NO_LOOP_BACKWARDS);
      } else { player.setLoopType(SamplePlayer.LoopType.NO_LOOP_FORWARDS); }

      pitch();
      Envelope rateEnv = new Envelope(ac, rate * pitch);
      player.setRate(rateEnv);
      player.setKillOnEnd(true);
      beads.Gain g = new beads.Gain(ac, 1, vol);
      g.addInput(player);
      ac.out.addInput(g);
    } 
    
    // Effect when sound is played
    if(effect && expand <= 200) {
      pushMatrix();
      noFill();
      stroke(sColor);
      strokeWeight(random(10, 15));
      rect(this.sMouseX, this.sMouseY, expand, expand);
      expand++;
      expand++;
      popMatrix();
      noStroke();
      
    } else {
      effect = false;
      expand = this.sX;  
    }
  } //end playSound
  
  void pitch() { 
    if(sMouseY >= 100 && sMouseY <= 220) { pitch = 5; }
    if(sMouseY > 220 && sMouseY <= 340) { pitch = 4; }
    if(sMouseY > 340 && sMouseY <= 460) { pitch = 3; }
    if(sMouseY > 460 && sMouseY <= 580) { pitch = 2; }
    if(sMouseY > 580 && sMouseY <= 700) { pitch = 1; }
  } // end pitch
  
  void specialFX(float offset) { // the special effect when touching the shape 
    pushMatrix();
    translate(sMouseX, sMouseY);
    ranNum = random(1, 4); // some random elements
    if(ranNum >= 1 && ranNum <= 2) {
    rotateX(sNum*-PI/6*offset);
    rotateY(sNum*-PI/6*0.05);
    rotateZ(sNum*-PI/6*0.05);
    }
    if(ranNum > 2 && ranNum <= 3) {
    rotateX(sNum*-PI/6*0.05);
    rotateY(sNum*-PI/6*offset);
    rotateZ(sNum*-PI/6*0.05);
    }
    if(ranNum > 3 && ranNum <= 4) {
    rotateX(sNum*-PI/6*0.05);
    rotateY(sNum*-PI/6*0.05);
    rotateZ(sNum*-PI/6*offset);
    }
    rect(sNum, sNum, 20, 20);
    sNum+= 0.03 ;   
    popMatrix();
  } // end specialFX

} // end Shape


void selectedShape() { // selected shape that user will be placing
  rectMode(CENTER);
  if(instrument == "xylophone"){  
    fill(button4.color1);
    rect(mouseX+wallNum*1800, mouseY, 75, 75);
  }
  if(instrument == "guitar"){  
    fill(button5.color1);
    rect(mouseX+wallNum*1800, mouseY, 75, 75);
  }
  if(instrument == "drum"){  
    fill(button6.color1);
    rect(mouseX+wallNum*1800, mouseY, 75, 75);
  }
  if(instrument == "mysound"){  
    fill(button9.color1);
    rect(mouseX+wallNum*1800, mouseY, 75, 75);
  }
}

void placeShape() { // Check if user can placeShape from main then check name of instrument and add the same name of item to array
  if (instrument == "xylophone") {
    shapeList.add(new Shape("xylophone", 0, mouseX+wallNum*1800, mouseY, button4.color1));
  }
  if (instrument == "guitar") {
    shapeList.add(new Shape("guitar", 0, mouseX+wallNum*1800, mouseY, button5.color1));
  }
  if (instrument == "drum") {
    shapeList.add(new Shape("drum", 0, mouseX+wallNum*1800, mouseY, button6.color1));
  }
  if (instrument == "mysound") {
    shapeList.add(new Shape("mysound", 0, mouseX+wallNum*1800, mouseY, button9.color1));
  }
} // end placeShape
