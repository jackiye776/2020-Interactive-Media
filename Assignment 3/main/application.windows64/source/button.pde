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
Button button1 = new Button("play", 300, 900 - (900/6/2), 80, 80, #6DFA23, #264B13);
Button button2 = new Button("stop", 0, 0, 1920*3, 900, #FA0818, #5F0B10);
Button button10 = new Button("stop2", 0, 0, 1920*3, 900, #FA0818, #5F0B10);
Button button3 = new Button("reset", 200, 900 - (900/6/2), 80, 80, #FC6100, #C15C1D);

// Instruments
Button button4 = new Button("xylophone", 600, 900 - (900/6/2), 80, 80, #FFE70A, #B9AA1A);
Button button5 = new Button("guitar", 800, 900 - (900/6/2), 80, 80, #9B591B, #6C4520);
Button button6 = new Button("drum", 1000, 900 - (900/6/2), 80, 80, #D3E0DE, #9CAAA8);
Button button9 = new Button("mysound", 1200, 900 - (900/6/2), 80, 80, #7AE320, #59A01D);

// Audio 
Button button7 = new Button("customfile", 1600, 900 - (900/6/2), 80, 80, #FC6100, #C15C1D);
Button button8 = new Button("record", 1400, 900 - (900/6/2), 80, 80, #F00FE1, #8E1586);

// Navigation
Button arrow1 = new Button("left", 80, 900/6/3, 100, 40, #FEFF0A, #E7E85B); 
Button arrow2 = new Button("right", 1720, 900/6/3, 100, 40, #FEFF0A, #E7E85B);

class Button {
  String bName;
  int bPosX, bPosY; // Button's position
  int bW, bH; // Button's size
  color color1, color2; // Hover over / Not hovered over
  boolean bOver = false; // Check if mouse over button
   
  Button(String name, int posx, int posy, int w, int h, color color1, color color2) {
    this.bName = name;
    this.bPosX = posx;
    this.bPosY = posy;
    this.bW = w;
    this.bH = h;
    this.color1 = color1;
    this.color2 = color2;
  }
  
  void display() { // displays the shapes 
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
  
  void pressed(String name) { // all functionality of mouse clicks involved with buttons
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

void buttons() { // a function to display all the buttons
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

void removeAll() {
  while(shapeList.size() != 0) {
    for (int i = 0; i < shapeList.size(); i++) {
      shapeList.remove(i);
    }
  }
  reset = false;
}

void imageDisplay(String name, int x, int y) { // display the images
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
