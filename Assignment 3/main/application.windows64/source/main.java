import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import beads.*; 
import ddf.minim.*; 
import ddf.minim.ugens.*; 
import java.util.Arrays; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class main extends PApplet {

/* Reference:- 
 Bown, O., Crawford, B., Porter, B., Martin, A., Beads (Version 1.01) [Application Library]. Processing.
 http://tutorials.jenkov.com/java-io/file.html#delete-file
 https://processing.org/reference/nf_.html

 Xylophone - https://freesound.org/people/DANMITCH3LL/packs/14220/
 Guitar - https://www.storyblocks.com/audio/stock/acoustic-guitar---c-chord-slund9rniprk0wy4wf3.html
 Drum - https://www.storyblocks.com/audio/stock/drum-snare-hit-rli4spnnivhk0wxv1j8.html
*/

// Libraries :- Beads, Minim, Java





Minim minim; // minim
AudioInput in;
AudioRecorder recorder; 

AudioContext ac; // beads 

float ranNum = 0; // used in specialFX method
int wallNum = 0; // used for the camera and shape's placement (very important in moving text & buttons)
float lineX; // to determine distance of the line to shape (if it should play the shape's audio)
boolean canPlace = false;
boolean fastForward = false, reverse = false;

// Array List
ArrayList<Shape> shapeList = new ArrayList();
ArrayList<PImage> imageList = new ArrayList();
ArrayList<String> audioList = new ArrayList();

// Beads 
SamplePlayer player;
SamplePlayer customPlayer;

public void setup() {
   // Built for Fixed Screen of 1800x900.
  frameRate(60);
  
  getColour = (255);
  
  textAlign(CENTER);
  
  // Add all images to array
  imageMode(CENTER);
  imageList.add(loadImage("play.png")); // 0
  imageList.add(loadImage("clear.png")); // 1
  imageList.add(loadImage("left.png")); // 2
  imageList.add(loadImage("right.png")); // 3
  imageList.add(loadImage("xylo.png")); // 4
  imageList.add(loadImage("guitar.png")); // 5
  imageList.add(loadImage("drum.png")); // 6
  imageList.add(loadImage("customoff.png")); // 7
  imageList.add(loadImage("customon.png")); // 8
  imageList.add(loadImage("norecording.png")); // 9
  imageList.add(loadImage("yesrecording.png")); // 10
  imageList.add(loadImage("nomysound.png")); // 11
  imageList.add(loadImage("yesmysound.png")); // 12
  
  for (int i = 0; i < imageList.size(); i++)
  {
    imageList.get(i).resize(50, 50); // loop to resize all images
  }
  
  //-- Delete previous recorded file
  File file = new File(sketchPath("" + "mysound.wav"));
  boolean success = file.delete();
  println("File Delete? " + success);
  
  //-- Audio setup
  minim = new Minim(this);
  in = minim.getLineIn(Minim.STEREO, 2048);
  recorder = minim.createRecorder(in, "mysound.wav"); // Create the file for audio be saved into
  
  ac = AudioContext.getDefaultContext();
  audioList.add(sketchPath("" + "data/xylophone_C.wav")); // 0
  audioList.add(sketchPath("" + "data/guitar_C.wav")); // 1
  audioList.add(sketchPath("" + "data/drum.wav")); // 2
  audioList.add(sketchPath("" + "mysound.wav")); // 3
  ac.start();
  
} // end setup

// Selection for background music
public void fileSelected(File selection) { 
  String audioFileName = selection.getAbsolutePath();
  customPlayer = new SamplePlayer(SampleManager.sample(audioFileName));
  Envelope rateEnv = new Envelope(ac, bgRate);
  customPlayer.setRate(rateEnv);
  customPlayer.setLoopType(SamplePlayer.LoopType.LOOP_FORWARDS);
  beads.Gain g = new beads.Gain(2, bgVol);
  g.addInput(customPlayer);
  ac.out.addInput(g);
  ac.start();
}

public void draw() {
  background(0);

  noStroke();
  cameras(); // camera function
  wallsDisplay(); 

  //-- Horizontal Lines
  pushMatrix();
  strokeWeight(5);
  stroke(0);
  for (int i = 1; i <=5; i++) {
    line(0, (height/6)*i, width*3, (height/6)*i);
  }
  popMatrix();

  // Shapes / Instruments on the canvas
  for (Shape shape : shapeList) { // L
    shape.display();
    shape.playSound(lineX);
  }

  //-- Text
  pushMatrix();
  fill(255);
  textSize(26);
  if (!play) {
    text("Play", 300+wallNum*1800, 880, 15);
    text("Reset", 200+wallNum*1800, 880, 15); 
    text("Xylophone", 600+wallNum*1800, 880, 15);
    text("Guitar", 800+wallNum*1800, 880, 15); 
    text("Drum", 1000+wallNum*1800, 880, 15); 
    text("My Sound", 1200+wallNum*1800, 880, 15); 
    text("Record SFX", 1400+wallNum*1800, 880, 15); 
    text("Background Audio", 1600+wallNum*1800, 880, 15); 
    
    if (customFile) {
      text("Custom File On", 1600+wallNum*1800, 775, 15);
    } else if (!customFile) {
      text("Custom File Off", 1600+wallNum*1800, 775, 15);
    }
    
    if (recording) {
      text("Recording On!", 1400+wallNum*1800, 775, 15);
      textSize(65);
      text("RECORDING YOUR OWN SOUND EFFECT!", width/2+wallNum*1800, height/2, 15);
    } else if (!recording) {
      text("Recording Off.", 1400+wallNum*1800, 775, 15);
    }
    
    if(customFile) {
    // BACKGROUND AUDIO
      textSize(26);
      text("Press LEFT / RIGHT ARROW KEYS", width/2-300+wallNum*1800, 40, 5);
      text("to change background Rate: " + nf(bgRate, 0, 2), width/2-300+wallNum*1800, 60, 5);
      
      text("Press UP / DOWN ARROW KEYS", width/2+300+wallNum*1800, 40, 5);
      text("change background Volume: " + nf(bgVol*100, 0, 0), width/2+300+wallNum*1800, 60, 5);
    }

  } 
  
  else if (play) {
    textSize(200);
    fill(255);
    if(!clickAgain) {
      text("Click Anywhere To Go Back.", width+900, -300, 15);
    }
    if(clickAgain) {
      text("Click Again To Go Back!", width+900, -300, 15);
    }
    
    textSize(100);
    if (!fastForward) {
      text("Press W for Fast Forward", width, height+height/2-200, 15);
    } 
    else if (fastForward) {
      text("Press S for Normal Speed ", width, height+height/2-200, 15);
    } 
    
    if (!reverse) {
      text("Press A to Play Reverse", width, height+height/2+100, 15);
    } 
    else if (reverse) {
      text("Press D for Play Forward", width, height+height/2+100, 15);
    }
    
    // INSTRUMENT AUDIO
    text("Press LEFT / RIGHT ARROW KEYS", width*2+200, height+height/2-200, 15);
    text("to change instrument Rate: " + nf(rate, 0, 2), width*2+200, height+height/2-100, 15);
    
    text("Press UP / DOWN ARROW KEYS", width*2+200, height+height/2+200, 15);
    text("to change instrument Volume: " + nf(vol*100, 0, 0), width*2+200, height+height/2+300, 15);
  }
  popMatrix();

  //-- Moving Bar
  if (play) {
    pushMatrix();
    strokeWeight(4);
    stroke(0);
    translate(0, 0, 0.9f);
    line(lineX, 0, lineX, height); 
    
    if(reverse) {
      lineX-=5;
    } else {  
      lineX+=5;
    }
  
    if (fastForward && reverse) {
      lineX-=10;
    } 
    else if ( fastForward & !reverse) {
      lineX+=10;
    }
    else { 
      fastForward = false;
    }
    
    if (lineX > width*3+50 && !reverse) {
      lineX = 0;
    }
    else if (lineX < -100 && reverse) {
      lineX = width*3;
    }

    popMatrix();
  } else { 
    lineX = 0;
  }

  //-- Interactive Buttons BG
  rectMode(CORNER);
  fill(0xff373586);
  translate(0, 0, 2);
  rect(0, (height/6*5), width*3, height/6);

  // Place shape 
  if (!play && !recording) {
    if (mouseX >= 125 && mouseX <= width-125) {
      if (mouseY > height/6-50 && mouseY < height/6*5-50) {
        selectedShape();
        canPlace = true;
      } else { 
        canPlace = false;
      }
    } else { 
      canPlace = false;
    }
  }

  // Buttons GUI
  buttons();

  // The effects
  if (play) {
    loadPixels();
    //scan across the pixels
    for (int i = 0; i < width; i++) {
      //for each pixel work out where in the current audio buffer we are
      int buffIndex = i * ac.getBufferSize() / width;
      //then work out the pixel height of the audio data at that point
      int vOffset = (int)((1 + ac.out.getValue(0, buffIndex)) * height / 2);
      //draw into Processing's convenient 1-D array of pixels
      vOffset = min(vOffset, height);

      rectMode(CENTER);
      fill(getColour);
      
      for(Shape shape : shapeList) {
        if (shape.effect) {
          shape.specialFX(vOffset);
        }
      }
      
    }
    updatePixels();
  }
  
} // end draw

public void mousePressed() {
  button1.pressed(button1.bName);
  button2.pressed(button2.bName);
  button3.pressed(button3.bName);
  button4.pressed(button4.bName);
  button5.pressed(button5.bName);
  button6.pressed(button6.bName);
  button7.pressed(button7.bName);
  button8.pressed(button8.bName);
  button9.pressed(button9.bName);
  button10.pressed(button10.bName);
  arrow1.pressed(arrow1.bName);
  arrow2.pressed(arrow2.bName);

  if (canPlace) {
    placeShape();
  }
} // end mousePressed

public void keyPressed() { 
  if(play) { 
    if (key == 'w' || key == 'W') {
      fastForward = true;
    } else if (key == 's' || key == 'S') {
      fastForward = false;
    }
    
    if (key == 'a' || key == 'A') {
      reverse = true;
    } else if (key == 'd' || key == 'D') {
      reverse = false;
    }
    
    if (key == 'i' || key == 'I' && bgVol <= 1) {
      bgVol+=0.05f;
    } else if (key == 'k' || key == 'K' && bgVol >= 0) {
      bgVol-=0.05f;
    }

    if(keyCode == LEFT && rate >= 0.2f) {
      rate-=0.2f;
    }
    if (keyCode == RIGHT && rate <= 3) {
      rate+=0.2f;
    }
    
    if(keyCode == UP && vol <= 1) {
      vol+=0.05f;
    } 
    if (keyCode == DOWN && vol >= 0) {
      vol-=0.05f;
    }
    
  }
  
  if(!play) {
    if(keyCode == LEFT && bgRate >= -4.8f) {
      bgRate-=0.2f;
    }
    if (keyCode == RIGHT && bgRate <= 4.8f) {
      bgRate+=0.2f;
    }
    
    if(keyCode == UP && bgVol <= 1) {
      bgVol+=0.05f;
    } 
    if (keyCode == DOWN && bgVol >= 0) {
      bgVol-=0.05f;
    }
  }
  
} // end keyPressed
/*Reference:- 
  http://learningprocessing.com/exercises/chp09/exercise-09-08-array-buttons
  
  Images:- 
  Xylophone - https://pngtree.com/freepng/cartoon-children-s-musical-instrument-xylophone_4665268.html
  Guitar - https://pngimg.com/download/3374
  Drum - http://pngimg.com/download/14340
  
  Other graphics are drawn by J. Lim on Adobe Photoshop.
  
*/

// The user interface
boolean play = false, pause = false, clickAgain = false;
boolean reset = false;
boolean customFile = false;
boolean recording = false, recorded = false;

// GUI
Button button1 = new Button("play", 300, 900 - (900/6/2), 80, 80, 0xff6DFA23, 0xff264B13);
Button button2 = new Button("stop", 0, 0, 1920*3, 900, 0xffFA0818, 0xff5F0B10);
Button button10 = new Button("stop2", 0, 0, 1920*3, 900, 0xffFA0818, 0xff5F0B10);
Button button3 = new Button("reset", 200, 900 - (900/6/2), 80, 80, 0xffFC6100, 0xffC15C1D);

// Instruments
Button button4 = new Button("xylophone", 600, 900 - (900/6/2), 80, 80, 0xffFFE70A, 0xffB9AA1A);
Button button5 = new Button("guitar", 800, 900 - (900/6/2), 80, 80, 0xff9B591B, 0xff6C4520);
Button button6 = new Button("drum", 1000, 900 - (900/6/2), 80, 80, 0xffD3E0DE, 0xff9CAAA8);
Button button9 = new Button("mysound", 1200, 900 - (900/6/2), 80, 80, 0xff7AE320, 0xff59A01D);

// Audio 
Button button7 = new Button("customfile", 1600, 900 - (900/6/2), 80, 80, 0xffFC6100, 0xffC15C1D);
Button button8 = new Button("record", 1400, 900 - (900/6/2), 80, 80, 0xffF00FE1, 0xff8E1586);

// Navigation
Button arrow1 = new Button("left", 80, 900/6/3, 100, 40, 0xffFEFF0A, 0xffE7E85B); 
Button arrow2 = new Button("right", 1720, 900/6/3, 100, 40, 0xffFEFF0A, 0xffE7E85B);

class Button {
  String bName;
  int bPosX, bPosY; // Button's position
  int bW, bH; // Button's size
  int color1, color2; // Hover over / Not hovered over
  boolean bOver = false; // Check if mouse over button
   
  Button(String name, int posx, int posy, int w, int h, int color1, int color2) {
    this.bName = name;
    this.bPosX = posx;
    this.bPosY = posy;
    this.bW = w;
    this.bH = h;
    this.color1 = color1;
    this.color2 = color2;
  }
  
  public void display() { // displays the shapes 
    rectMode(CENTER);    
    translate(0, 0, 1);
    if(!play) {
      if(dist(mouseX, mouseY, bPosX, bPosY) < bW/2) {
        fill(color1);
        bOver = true;
      } else {
        fill(color2);
        bOver = false;
      }
      strokeWeight(8);
      rect(bPosX+(wallNum*1800), bPosY, bW, bH);
      imageDisplay(bName, bPosX+(wallNum*1800), bPosY);
    }
    
    if(play) { // displays shapes 
      if(dist(mouseX, mouseY, bPosX, bPosY) < bW/2) {
        if(bName == "stop") {
          noFill();
          noStroke();
        }
        bOver = true;
      } else {
        fill(color2);
        bOver = false;
      }
      rect(bPosX+(wallNum*1800), bPosY, bW, bH);
    }
  } // end display
  
  public void pressed(String name) { // all functionality of mouse clicks involved with buttons
    if(bOver) { 
      if(!play && button1.bName == name){
        if(customFile) {
          selectInput("Select an audio file:", "fileSelected");
        }
        play = true;
        bOver = false;
      } 
      else if (play && button2.bName == name) {
        clickAgain = true;
      }
      
      if(play && button10.bName == name) {
         play = false;
         bOver = false;
        
        if(customFile && customPlayer != null) {
          customPlayer.kill(); // Stop custom audio from playing
        }
      }
      
      
      if(button3.bName == name) {
        reset = true;
        bOver = false;
      }
      
      if(button4.bName == name) {
        instrument = "xylophone";
      }
      if(button5.bName == name) {
        instrument = "guitar";
      }
      if(button6.bName == name) {
        instrument = "drum";
      }
      if(button7.bName == name && !customFile) {
        customFile = true;
        println("YES CUSTOM");
      }
      else if (button7.bName == name && customFile) {
        customFile = false;
        println("NO CUSTOM");
      }
      
      if(button8.bName == name && !recording) {
        recording = true;
        recorded = false;
        recorder.beginRecord();
        println("RECORDING");
      }
      else if(button8.bName == name && recording) {
        recording = false;
        recorded = true;
        recorder.endRecord();
        recorder.save();
        println("NO RECORDING");
      }
      
      if(button9.bName == name && recorded) {
        instrument = "mysound";
      }
      
      if (arrow1.bName == name && wallNum == 2) {
        wallNum = 1;
      }
      
      if(arrow2.bName == name && wallNum == 0) {
        wallNum = 1;
      }
      else if (wallNum == 1) {
        if(arrow1.bName == name) { wallNum = 0; }
        if(arrow2.bName == name) { wallNum = 2; }
      }
    }
  } // end Pressed

} // end Button

public void buttons() { // a function to display all the buttons
  if(!play) {
    if(wallNum == 0) {
      arrow2.display();
    }
    else if(wallNum == 1) {
      arrow1.display();
      arrow2.display();
    }
    else if(wallNum == 2) {
      arrow1.display();
    }
    
    button1.display(); 
    button3.display();
    button4.display();
    button5.display();
    button6.display();
    button7.display();
    button8.display();
    button9.display();
    
    if(reset) {
      removeAll();
    }
  }
  
  if(play) { 
    button2.display();
    if(clickAgain) {
      button10.display();
    }
  } else {
    clickAgain = false;
  }
 
} // end buttons

public void removeAll() {
  while(shapeList.size() != 0) {
    for (int i = 0; i < shapeList.size(); i++) {
      shapeList.remove(i);
    }
  }
  reset = false;
}

public void imageDisplay(String name, int x, int y) { // display the images
  if(name == "play") {
    image(imageList.get(0), x, y);
  }
  if(name == "reset") {
    image(imageList.get(1), x, y);
  }
  if(name == "left") {
    image(imageList.get(2), x, y);
  }
  if(name == "right") {
    image(imageList.get(3), x, y);
  }
  if(name == "xylophone") {
    image(imageList.get(4), x, y);
  }
  if(name == "guitar") {
    image(imageList.get(5), x, y);
  }
  if(name == "drum") {
    image(imageList.get(6), x, y);
  }
  
  if(name == "customfile" && !customFile) {
    image(imageList.get(7), x, y);
  }
  else if (name == "customfile" && customFile) {
    image(imageList.get(8), x, y);
  }
  
  if(name == "record" && !recording) {
    image(imageList.get(9), x, y);
  }
  else if (name == "record" && recording) {
    image(imageList.get(10), x, y);
  }
  
  if(name == "mysound" && !recorded) {
    image(imageList.get(11), x, y);
  }
  else if (name == "mysound" && recorded) {
    image(imageList.get(12), x, y);
  }

}
/* Reference:-
  https://processing.org/reference/camera_.html
*/

// Controls Perspectives
public void cameras() {
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
// The shapes / instruments that the user will be placing onto the "wall"

String audioType, instrument;
float pitch, rate = 1, bgRate = 1;
float vol = 0.2f, bgVol = 0.05f;
int getColour;

class Shape {
  String sName; // Instrument name
  float sNum;
  float sMouseX; // mouseX
  float sMouseY; // mouseY
  int sX; // shape width
  int sY; // shape height
  int sColor;
  
  boolean effect; 
  int expand = sX;
  
  Shape(String name, float num, float sMouseX, float sMouseY, int colour){
    this.sName = name;
    this.sNum = num;
    this.sMouseX = sMouseX;
    this.sMouseY = sMouseY;
    this.sX = 70;
    this.sY = 70;
    this.sColor = colour;
  } // Constructor Shape
  
  public void display() {
    if(!play || lineX > width*3+30 || lineX < -100 || sNum > 5000) {
      sNum = 0;
      expand = 0;
      vol = 0.2f;
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
  
  public void playSound(float lineX) {
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
  
  public void pitch() { 
    if(sMouseY >= 100 && sMouseY <= 220) { pitch = 5; }
    if(sMouseY > 220 && sMouseY <= 340) { pitch = 4; }
    if(sMouseY > 340 && sMouseY <= 460) { pitch = 3; }
    if(sMouseY > 460 && sMouseY <= 580) { pitch = 2; }
    if(sMouseY > 580 && sMouseY <= 700) { pitch = 1; }
  } // end pitch
  
  public void specialFX(float offset) { // the special effect when touching the shape 
    pushMatrix();
    translate(sMouseX, sMouseY);
    ranNum = random(1, 4); // some random elements
    if(ranNum >= 1 && ranNum <= 2) {
    rotateX(sNum*-PI/6*offset);
    rotateY(sNum*-PI/6*0.05f);
    rotateZ(sNum*-PI/6*0.05f);
    }
    if(ranNum > 2 && ranNum <= 3) {
    rotateX(sNum*-PI/6*0.05f);
    rotateY(sNum*-PI/6*offset);
    rotateZ(sNum*-PI/6*0.05f);
    }
    if(ranNum > 3 && ranNum <= 4) {
    rotateX(sNum*-PI/6*0.05f);
    rotateY(sNum*-PI/6*0.05f);
    rotateZ(sNum*-PI/6*offset);
    }
    rect(sNum, sNum, 20, 20);
    sNum+= 0.03f ;   
    popMatrix();
  } // end specialFX

} // end Shape


public void selectedShape() { // selected shape that user will be placing
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

public void placeShape() { // Check if user can placeShape from main then check name of instrument and add the same name of item to array
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
  
  public void display() {
    fill(50, 100, 200);
    rectMode(CORNER);
    rect(wX, wY, wW, wH);
  } // end display

} // end Wall

public void wallsDisplay() {
  wall1.display();
  wall2.display();
  wall3.display();
} // end wallsDisplay
  public void settings() {  size(1800, 900, P3D); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "--present", "--window-color=#000000", "--stop-color=#FFFFFF", "main" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
