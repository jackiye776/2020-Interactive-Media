// Reference:- Bown, O., Crawford, B., Porter, B., Martin, A., Beads (Version 1.01) [Application Library]. Processing.

import beads.*;
import java.util.Arrays;

AudioContext ac;

int clicked = 0;
String audioFile = ""; // Insert audio between the speech marks 
String audioFile2 = ""; // Insert audio between the speech marks 

void setup() {
  size(500, 500);
  ac = new AudioContext();
  SamplePlayer player = new SamplePlayer(ac, SampleManager.sample(audioFile));
  
  player.setLoopType(SamplePlayer.LoopType.LOOP_FORWARDS);
  Gain gPlayer = new Gain(ac, 1, 0.2);
  Envelope speed = new Envelope(ac, 0.5);
  player.setRate(speed);
  
  WavePlayer freqModulator = new WavePlayer(ac, 1000, Buffer.SINE);

  Function function = new Function(freqModulator) {
    public float calculate() {
      return x[0] * 200 + mouseX;
    }
  };
  
  
  WavePlayer wp = new WavePlayer(ac, function, Buffer.SINE);
  Gain gWp = new Gain(ac, 1, 0.01);
  
  gWp.addInput(wp);
  ac.out.addInput(gWp);
  
  
  gPlayer.addInput(player);
  ac.out.addInput(gPlayer);
  ac.start();
  
}

color waveColour = color(255, 255, 255);
color background = color(0,0,0);

void draw() {
  loadPixels();
  //set the background
  Arrays.fill(pixels, background);
  //scan across the pixels
  for(int i = 0; i < width; i++) {
    //for each pixel work out where in the current audio buffer we are
    int buffIndex = i * ac.getBufferSize() / width;
    //then work out the pixel height of the audio data at that point
    int vOffset = (int)((1 + ac.out.getValue(0, buffIndex)) * height / 2);
    //draw into Processing's convenient 1-D array of pixels
    vOffset = min(vOffset, height);
    pixels[vOffset * height + i] = waveColour;
  }
  updatePixels();
  
  fill(255, 166, 0);
  ellipse(mouseX, mouseY, 10, 10);
}

void mousePressed() { //<>//
  ellipseMode(CENTER);
  fill(255, 255, 255);
  ellipse(mouseX, mouseY, 50, 50);
  
  SamplePlayer player = new SamplePlayer(ac, SampleManager.sample(audioFile2));
  Envelope rate = new Envelope(ac, 1);
  Gain g = new Gain(ac, 1, 0.45);

  if(!(clicked <= 1)) {
    if(clicked % 4 == 0) {
      fill(100, 21, 170);
      ellipse(mouseX+50, mouseY+50, 50, 50);
      ellipse(mouseX+50, mouseY-50, 50, 50);
      ellipse(mouseX-50, mouseY+50, 50, 50);
      ellipse(mouseX-50, mouseY-50, 50, 50);
      rate.addSegment(2, 1000, new KillTrigger(player)); 
      System.out.println("4th beat");
    }
    if(clicked % 5 == 0) {
      fill(255, 3, 3);
      ellipse(mouseX+100, mouseY+100, 50, 50);
      ellipse(mouseX+100, mouseY-100, 50, 50);
      ellipse(mouseX-100, mouseY+100, 50, 50);
      ellipse(mouseX-100, mouseY-100, 50, 50);
      rate.addSegment(-2, 2000, new KillTrigger(player)); 
      System.out.println("7th beat");
    }
  }
  
  player.setRate(rate);
  g.addInput(player);
  ac.out.addInput(g);
  
  clicked++;
  System.out.println(clicked); // Debugging
  fill(255, 255, 255);
  
}
