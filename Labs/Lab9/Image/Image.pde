PImage img;

int count = 0;
int index;
int cDivide = 2;

color storeClick;

boolean mouseClicked = false;

void setup() {  
  img = loadImage("petty.png"); // Change image
  surface.setSize(img.width, img.height);
}
 
void draw() {
  pushMatrix();
    translate(width/2, height/2);
    imageMode(CENTER);
    image(img, 0, 0, width, height);
  popMatrix();

  if(mouseClicked){
     loadPixels();
      for(int x = 0; x < img.width; x++) {
        for(int y= 0; y< img.height; y++) {
          index = x+y*width;
          color c  = get(x, y);
          if(c <= storeClick){
            pixels[index] = color(red(storeClick/cDivide)/cDivide, green(storeClick)/cDivide, blue(storeClick)/cDivide);
          } 
          else if (c >= storeClick) {
            pixels[index] = color(red(c), green(c), blue(c));          
          }
        }
      }
    updatePixels();
  }
  
  loadPixels(); 
    for(int x = 0; x < img.width; x++) {
      for(int y= 0; y< img.height; y++) {
        index = x+y*width;
        color c = get(x, y);
        float r = red(img.pixels[index]);
        float g = blue(img.pixels[index]);
        float b = green(img.pixels[index]);
        if(count == 1 || count == -3){
          pixels[index] = color(red(c), g, blue(c));
        }
        if(count == 2 || count == -2){
          pixels[index] = color(red(c), green(c), b);
        }
        if(count == 3 || count == -1){
          pixels[index] = color(r, green(c), blue(c));
        }
      }
    }
  updatePixels();
} // end draw()

void mouseClicked() {
  storeClick = get(mouseX, mouseY);
  mouseClicked = true;
}

void keyPressed() {
  if (key == 'a'){
    if(count != 3) {
      count++;
    } else {
      count = 0;
    }
  } else if ( key == 'd') {
    if(count != -3) {
      count--;
    } else {
      count = 0;
    }
  }
  println("Count:" +count);
}
