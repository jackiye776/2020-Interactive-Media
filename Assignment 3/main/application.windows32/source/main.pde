/* Reference:- 
 Bown, O., Crawford, B., Porter, B., Martin, A., Beads (Version 1.01) [Application Library]. Processing.
 http://tutorials.jenkov.com/java-io/file.html#delete-file
 https://processing.org/reference/nf_.html

 Xylophone - https://freesound.org/people/DANMITCH3LL/packs/14220/
 Guitar - https://www.storyblocks.com/audio/stock/acoustic-guitar---c-chord-slund9rniprk0wy4wf3.html
 Drum - https://www.storyblocks.com/audio/stock/drum-snare-hit-rli4spnnivhk0wxv1j8.html
*/

// Libraries :- Beads, Minim, Java
import beads.*;
import ddf.minim.*;
import ddf.minim.ugens.*;
import java.util.Arrays;

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

void setup() {
  size(1800, 900, P3D); // Built for Fixed Screen of 1800x900.
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
void fileSelected(File selection) { 
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

void draw() {
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
    translate(0, 0, 0.9);
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
  fill(#373586);
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

void mousePressed() {
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

void keyPressed() { 
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
      bgVol+=0.05;
    } else if (key == 'k' || key == 'K' && bgVol >= 0) {
      bgVol-=0.05;
    }

    if(keyCode == LEFT && rate >= 0.2) {
      rate-=0.2;
    }
    if (keyCode == RIGHT && rate <= 3) {
      rate+=0.2;
    }
    
    if(keyCode == UP && vol <= 1) {
      vol+=0.05;
    } 
    if (keyCode == DOWN && vol >= 0) {
      vol-=0.05;
    }
    
  }
  
  if(!play) {
    if(keyCode == LEFT && bgRate >= -4.8) {
      bgRate-=0.2;
    }
    if (keyCode == RIGHT && bgRate <= 4.8) {
      bgRate+=0.2;
    }
    
    if(keyCode == UP && bgVol <= 1) {
      bgVol+=0.05;
    } 
    if (keyCode == DOWN && bgVol >= 0) {
      bgVol-=0.05;
    }
  }
  
} // end keyPressed
