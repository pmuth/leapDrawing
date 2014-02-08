import com.leapmotion.leap.*;

import toxi.color.*;
import toxi.color.theory.*;
import toxi.util.datatypes.*;

import com.leapmotion.leap.Controller;
import com.leapmotion.leap.Frame;
import com.leapmotion.leap.Gesture;
import com.leapmotion.leap.processing.LeapMotion;

LeapMotion leapMotion;

int w = 800;
int h = 800;

PGraphics canvas;
PVector canvasXY;
PVector buttonXY;
char direction = 'R';
PImage img;
//String imageName;

TColor canvasColor = TColor.newHSV(0.00, 0.00, 0.00);

ColorList drawColor = new ColorList();
Controller leap = new Controller();

float drawingThreshold = 0.5;
float changeThreshold = 0.55;
float cursorThreshold = 0.90;

int numColors = 10;
int selectedColor = 0;

float interfaceSizeHorizontal = float(w)/(numColors+1);
float interfaceSizeVertical = (float(h)/(numColors+1));
int canvas_w=0;
int canvas_h=0;
//int canvas_h = int(h-interfaceSize);
int m = millis();

float maxCursorSize = 100;
float cursorSize = 100;
float brushSize = 25;

boolean erase = false;
boolean drawingMode = true;

ArrayList <PImage> images = new ArrayList<PImage>();

int value = 5;
int imageNumber = 0;
String imageName;
PImage eraser;

void setup()
{
   frameRate(150);
   size(w, h);
   colorMode(HSB,1,1,1);
   background(canvasColor.hue(), canvasColor.brightness(), canvasColor.saturation());
   stroke(0.0, 0.0, 1.0); //WHITE
   getColors();
   TColor frontColor = TColor.newHSV(drawColor.get(selectedColor).hue(), drawColor.get(selectedColor).saturation(), drawColor.get(selectedColor).brightness());
   orientation(direction); 
   //canvas = createGraphics(w, int(h-(interfaceSize)), JAVA2D);
   canvas = createGraphics(w, h, JAVA2D);
   
   canvas.beginDraw();
   canvas.colorMode(HSB, 1, 1, 1);
   canvas.smooth();
   canvas.endDraw();
   println(canvasXY.x + "   " + canvasXY.y +" " + canvas_h + " " + canvas_w);
   //println((float(w)-interfaceSize)/float(w));
   leapMotion = new LeapMotion(this);
   eraser = loadImage("eraser.png");
   

}

void onInit(final Controller controller)
{
  controller.enableGesture(Gesture.Type.TYPE_CIRCLE);
  controller.enableGesture(Gesture.Type.TYPE_KEY_TAP);
  controller.enableGesture(Gesture.Type.TYPE_SCREEN_TAP);
  controller.enableGesture(Gesture.Type.TYPE_SWIPE);
  // enable background policy
  controller.setPolicyFlags(Controller.PolicyFlag.POLICY_BACKGROUND_FRAMES);
}

void draw(){
  int m = millis();
  
  if (drawingMode == true) {
  background(canvasColor.hue(), canvasColor.brightness(), canvasColor.saturation());
   
//  image(canvas, canvasXY.x, canvasXY.y, canvas_w, canvas_h);
  image(canvas, 0, 0, w, h);
  drawControls();
  Frame frame = leap.frame();
  Pointable pointer = frame.pointables().frontmost();
  if( pointer.isValid())
  {
    InteractionBox iBox = frame.interactionBox();
    
    Vector tip = iBox.normalizePoint(pointer.tipPosition());
    if (tip.getZ() < cursorThreshold) {

    changeColor(tip);
    
    if (erase == true) {
      eraseFunction(tip);
    drawCursor(tip, TColor.newHSV(0.0, 0.0, 1.0));
    }
    else {
      drawCursor(tip, drawColor.get(selectedColor));    
      fingerPaint(tip, drawColor.get(selectedColor));
    }
      
    println("X:" + tip.getX() + " Y:" + tip.getY() + " Z:" + tip.getZ());

  }
    
  } 
  //timeLapse();
//  if (m%5000 < 10) {
//  println(m);
//  saveImage();
  //loadImage();
  //}
  //loadImage();
  //println(selectedColor);
  }
  else {
    
    if (m%3000 < 8) {
      canvas.beginDraw(); 
      callImage();
      canvas.endDraw();
    }
  
  // println(m + " !!!!!!");
  }
 // println(m);
  
}

void onFrame(final Controller controller)
{
  Frame frame = controller.frame();
  for (Gesture gesture : frame.gestures())
  {
    if ("TYPE_SWIPE".equals(gesture.type().toString()) && "STATE_START".equals(gesture.state().toString())) {
    clearImage();
    saveImage();
     println("gesture " + gesture + " id " + gesture.id() + " type " + gesture.type() + " state " + gesture.state() + " duration " + gesture.duration() + " durationSeconds " + gesture.durationSeconds()); 
    }
  }
}

void fingerPaint(Vector tip, TColor paintColor)
{
 
  if (tip.getZ() < drawingThreshold) {
  
  switch(direction) {

  //UP
  case 'U':
  case 'u':
   if (tip.getY() <= (1-(interfaceSizeHorizontal/h))) { 
      canvas.beginDraw();
      canvas.colorMode(HSB, 1, 1, 1);
      canvas.fill(paintColor.hue(), paintColor.saturation(), paintColor.brightness());
      float x = tip.getX() * w;
      float y = h - tip.getY() * h;
      canvas.noStroke();
      //float brushSizeX = random(brushSize-3,brushSize+3);
      //float brushSizeY = random(brushSize-3,brushSize+3);
      canvas.ellipse(x, y, brushSize, brushSize);
      canvas.endDraw();
     
    }
    break;
    
  //DOWN
  case 'D':
  case 'd':
    if (tip.getY() > interfaceSizeHorizontal/h) { 
      canvas.beginDraw();
      canvas.colorMode(HSB, 1, 1, 1);
      canvas.fill(paintColor.hue(), paintColor.saturation(), paintColor.brightness());
      float x = tip.getX() * w;
      float y = h - tip.getY() * h;
      canvas.noStroke();
      //float brushSizeX = random(brushSize-3,brushSize+3);
      //float brushSizeY = random(brushSize-3,brushSize+3);
      canvas.ellipse(x, y, brushSize, brushSize);
      canvas.endDraw();
    }
    break;
      //LEFT
  case 'L':
  case 'l':
    if (tip.getX() >= (interfaceSizeVertical*2)/float(w)) { 
      canvas.beginDraw();
      canvas.colorMode(HSB, 1, 1, 1);
      canvas.fill(paintColor.hue(), paintColor.saturation(), paintColor.brightness());
      float x = tip.getX() * w;
      float y = h - tip.getY() * h;
      canvas.noStroke();
      //float brushSizeX = random(brushSize-3,brushSize+3);
      //float brushSizeY = random(brushSize-3,brushSize+3);
      canvas.ellipse(x, y, brushSize, brushSize);
      canvas.endDraw();
    }
    break;
  //RIGHT
  case 'R':
  case 'r':
    if (tip.getX() <= ((float(w)-(2*interfaceSizeVertical))/float(w))) { 
      canvas.beginDraw();
      canvas.colorMode(HSB, 1, 1, 1);
      canvas.fill(paintColor.hue(), paintColor.saturation(), paintColor.brightness());
      float x = tip.getX() * w;
      float y = h - tip.getY() * h;
      canvas.noStroke();
      //float brushSizeX = random(brushSize-3,brushSize+3);
      //float brushSizeY = random(brushSize-3,brushSize+3);
      canvas.ellipse(x, y, brushSize, brushSize);
      canvas.endDraw();
    }
    break;
}
  }
}

void drawCursor(Vector tip, TColor paintColor) {
   
      stroke(paintColor.hue(), paintColor.saturation(), paintColor.brightness());
      noFill();
      if (tip.getZ() > drawingThreshold && tip.getZ() < cursorThreshold) {
        strokeWeight(2);
        cursorSize = map(tip.getZ(), drawingThreshold, cursorThreshold, 20.0, maxCursorSize);
      }
      else if (erase == true && tip.getZ() <= drawingThreshold) {
        stroke(0.0, 0.0, 1.0);
        cursorSize = brushSize;
      }
      else  { 
        stroke(0.0, 0.0, 0.0);
        cursorSize = 20.0;
      }
        ellipse(tip.getX() * w, h - tip.getY() * h, cursorSize, cursorSize);
   
 }

void changeColor(Vector tip) {

switch (direction) {  
  
    //UP
  case 'U':
  case 'u':
    //float changeColor = (((interfaceSizeHorizontal)/h)-((brushSize/h)/2));
    float changeColor = (h-interfaceSizeHorizontal)/h+((brushSize/h)/2);
    if (tip.getY() > changeColor && tip.getZ() < drawingThreshold) {
      for (int i = 0; i < numColors+1; i++) {
        float minThreshold = (i/float(numColors+1));
        float maxThreshold = ((i+1)/float(numColors+1));
        
        if (tip.getX() > minThreshold && tip.getX() <= maxThreshold && i < numColors) {
          selectedColor = i;
          erase = false;
        }
        else if (tip.getX() > minThreshold && tip.getX() <= maxThreshold && i == (numColors)) {
          erase = true;
          selectedColor = numColors;
          
        }    
    }
  }
  break;
  //DOWN
  case 'D':
  case 'd':
     changeColor = (((interfaceSizeHorizontal)/h)-((brushSize/h)/2));

    if (tip.getY() < changeColor && tip.getZ() < drawingThreshold) {
      for (int i = 0; i < numColors+1; i++) {
        float minThreshold = (i/float(numColors+1));
        float maxThreshold = ((i+1)/float(numColors+1));
        
        if (tip.getX() > minThreshold && tip.getX() <= maxThreshold && i < numColors) {
          selectedColor = i;
          erase = false;
        }
        else if (tip.getX() > minThreshold && tip.getX() <= maxThreshold && i == (numColors)) {
          erase = true;
          selectedColor = numColors;
          
        }    
    }
  }
  break;
    //Left
  case 'L':
  case 'l':
     changeColor = (((interfaceSizeVertical)/w)-((brushSize/w)/2));

    if (tip.getX() < changeColor && tip.getZ() < drawingThreshold) {
      for (int i = 0; i < numColors+1; i++) {
        float minThreshold = (i/float(numColors+1));
        float maxThreshold = ((i+1)/float(numColors+1));
        
        if ((1-tip.getY()) > minThreshold && (1-tip.getY()) <= maxThreshold && i < numColors) {
          selectedColor = i;
          erase = false;
        }
        else if ((1-tip.getY()) > minThreshold && (1-tip.getY()) <= maxThreshold && i == (numColors)) {
          erase = true;
          selectedColor = numColors;
          
        }    
    }
  }
  break;
      //RIGHT
  case 'R':
  case 'r':
     changeColor = ((w-(interfaceSizeVertical))/w)+((brushSize/w)/2);

    if (tip.getX() > changeColor && tip.getZ() < drawingThreshold) {
      for (int i = 0; i < numColors+1; i++) {
        float minThreshold = (i/float(numColors+1));
        float maxThreshold = ((i+1)/float(numColors+1));
        
        if ((1-tip.getY()) > minThreshold && (1-tip.getY()) <= maxThreshold && i < numColors) {
          selectedColor = i;
          erase = false;
        }
        else if ((1-tip.getY()) > minThreshold && (1-tip.getY()) <= maxThreshold && i == (numColors)) {
          erase = true;
          selectedColor = numColors;
          
        }    
    }
  }
  break;
}
}

void clearImage() {
  color c = color(0, 0);
  canvas.loadPixels(); 


for (int y=0; y<(h*w); y++ ) {
 
        int loc = y;
        canvas.pixels[loc] = c;
    }
  canvas.updatePixels(); 
}

void keyPressed() {

 drawControls();
//callImage();
drawingMode = !drawingMode;
 clearImage();
}

void drawControls() {
  fill(0.0, 0.0, 1.0);
  noStroke();
  createButtons(direction);
}


void createButtons(char position) {
   
   ArrayList <ColorButton> colorButtons = new ArrayList<ColorButton>();
   noStroke(); 
 switch(position) { 
 case 'U':
 case 'u':
 //UP
   for (int i = 0; i < drawColor.size(); i++) {
     colorButtons.add(new ColorButton(drawColor.get(i).hue(), drawColor.get(i).saturation(), drawColor.get(i).brightness()));
     pushMatrix();
     if (i < drawColor.size()) {
     translate(0+(i*interfaceSizeHorizontal), 0);
   }
   
 
     colorButtons.get(i).displayHorizontal();
          if (i == drawColor.size()-1) {
     image(eraser,0, 0, width/11.0, width/11.0); 
     }
     popMatrix();
   }
 break;
 //DOWN
 case 'D':
 case 'd':
   for (int i = 0; i < drawColor.size(); i++) {
     colorButtons.add(new ColorButton(drawColor.get(i).hue(), drawColor.get(i).saturation(), drawColor.get(i).brightness()));
     pushMatrix();
     if (i < drawColor.size()) {
     translate(0+(i*interfaceSizeHorizontal), h-(interfaceSizeHorizontal));
   }
     colorButtons.get(i).displayHorizontal();
               if (i == drawColor.size()-1) {
     image(eraser,0, 0, width/11.0, width/11.0); 
     }
     popMatrix();
   }
 break;
  case 'L':
  case 'l':
 //LEFT
   for (int i = 0; i < drawColor.size(); i++) {
     colorButtons.add(new ColorButton(drawColor.get(i).hue(), drawColor.get(i).saturation(), drawColor.get(i).brightness()));
     pushMatrix();
     if (i < drawColor.size()) {
     translate(0, 0+(i*interfaceSizeVertical));
   }
     colorButtons.get(i).displayVertical();
               if (i == drawColor.size()-1) {
     image(eraser,0, 0, height/11.0, height/11.0); 
     }
     popMatrix();
   }
 break;
 case 'R':
 case 'r':
 //RIGHT
    for (int i = 0; i < drawColor.size(); i++) {
     colorButtons.add(new ColorButton(drawColor.get(i).hue(), drawColor.get(i).saturation(), drawColor.get(i).brightness()));
     pushMatrix();
     if (i < drawColor.size()) {
     translate((w-(interfaceSizeVertical)), 0+(i*interfaceSizeVertical));
   }
     colorButtons.get(i).displayVertical();
                    if (i == drawColor.size()-1) {
     image(eraser,0, 0, height/11.0, height/11.0); 
     }
     popMatrix();
    }
 break;

}

}

void eraseFunction(Vector tip) {
  if (tip.getZ() < drawingThreshold && tip.getY() > (interfaceSizeHorizontal/h)) { 
  // establish variables for bounds of brush
  int xStart, yStart, xEnd, yEnd;
  float xTip = tip.getX() * w;
  float yTip = h - tip.getY() * h;
  xStart = int((xTip)-brushSize/2);
  if (xStart<0) xStart=0; //prevents going out of bounds of pixel array X minus
  yStart = int((yTip)-brushSize/2);
  if (yStart<0) yStart=0; //prevents going out of bounds of pixel array Y minus
  xEnd = int((xTip)+brushSize/2);
  if (xEnd>width) xEnd=width; //prevents going out of bounds of pixel array X positive
  yEnd = int((yTip)+brushSize/2);
  if (yEnd>canvas_h) yEnd=canvas_h; //prevents going out of bounds of pixel array Y positive
  color c = color(0, 0);
  canvas.loadPixels();
  for (int x=xStart; x<xEnd; x++) {
    for (int y=yStart; y<yEnd; y++ ) {
      float distance = dist(x, y, xTip, yTip);
      if (distance <= brushSize/2) {
        int loc = x + y*canvas.width;
        canvas.pixels[loc] = c;
      }
    }
  }
  canvas.updatePixels();
  }
}

void getColors() {

//PRIMARY COLORS
//for (int i = 0; i < numColors; i++) {
//  float degree = (360/numColors)*i;
//  float hue = (degree%360)/360;
//  drawColor.add(TColor.newHSV(hue, 1.0, 1.0));
//  }
//  drawColor.add(TColor.newHSVA(0.0,0.0,0.0,0.5));

//BOSSA COLORS
drawColor.add(TColor.newHSV(0.480, 0.568, 0.871));
drawColor.add(TColor.newHSV(0.125, 1.000, 1.000));
drawColor.add(TColor.newHSV(0.033, 1.000, 1.000));
drawColor.add(TColor.newHSV(0.088, 0.087, 0.769));
drawColor.add(TColor.newHSV(0.027, 0.349, 1.000));
drawColor.add(TColor.newHSV(0.517, 0.287, 0.792));
drawColor.add(TColor.newHSV(0.525, 1.000, 0.804));
drawColor.add(TColor.newHSV(-0.156, 0.780, 0.714));
drawColor.add(TColor.newHSV(0.075, 0.040, 0.878));
drawColor.add(TColor.newHSV(-0.050, 0.855, 0.945));

drawColor.add(TColor.newHSVA(0.0,0.0,0.0,0.5));

}

void saveImage() {
  println("Saving high quality image");
  canvas.save("bossa_" + imageNumber + ".tga");
  println("Saved");
  imageNumber++;
}

void orientation(char position) {
 
 switch(position) { 
 case 'U':
 //TOP
 canvasXY = new PVector(0, 0);
 canvas_h = int(h-interfaceSizeHorizontal);
 canvas_w = w;
// buttonXY = new PVector(0+(i*interfaceSize), 0);
 break;
 //BOTTOM
 case 'D':
 canvasXY = new PVector(0, 0);
 canvas_h = int(h-interfaceSizeHorizontal);
 canvas_w = w;
// buttonXY = new PVector(0+(i*interfaceSize), h-(interfaceSize));
 break;
  case 'L': 
 //LEFT
 //canvasXY = new PVector(interfaceSize/w, 0);
 canvasXY = new PVector(0, 0);
 canvas_h = h;
 canvas_w = int(w-interfaceSizeVertical);
// buttonXY = new PVector(0, 0+(i*interfaceSizeVertical));
 break;
 case 'R':
 //RIGHT
 canvasXY = new PVector(0, 0);
 canvas_h = h;
 canvas_w = int(w-interfaceSizeVertical);
// buttonXY = new PVector((w-interfaceSizeVertical), 0+(i*interfaceSizeVertical));

 break;
 
  
}
println(canvas_h + ", " + canvas_w);
}

void loadImage() {
  imageName = "bossa_" + imageNumber + ".tga";
  //images.add(imageName);
  println(imageName);
}

void callImage () {
  String sketchPath = "/Users/patrickmuth/Dropbox/Projects/simpleDrawingBossa2";
  File data = new File (sketchPath);
  String [] list = data.list();
  println(list.length-5);
  imageName = "bossa_" + imageNumber + ".tga"; 
  canvas.background(canvasColor.hue(), canvasColor.brightness(), canvasColor.saturation());
  
  img = loadImage (imageName);
  //canvas.fill(canvasColor.hue(), canvasColor.brightness(), canvasColor.saturation());
  //canvas.rect(0,0,w-interfaceSizeVertical,h); 
  image(img, 0, 0);
    // background(canvasColor.hue(), canvasColor.brightness(), canvasColor.saturation());

  println(imageName);
  imageNumber++;
  if (imageNumber > 13) 
    imageNumber = 0;
}


boolean sketchFullScreen() {
  return true;
}
