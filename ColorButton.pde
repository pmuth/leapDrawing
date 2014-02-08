import toxi.color.*;
import toxi.color.theory.*;
import toxi.util.datatypes.*;

class ColorButton {
  float h;
  float s;
  float b;
  
  ColorButton (float _h, float _s, float _b) {
     h = _h;
     s = _s;
     b = _b;
  }
  
  void displayHorizontal () {
   
    TColor tempColor = TColor.newHSV(h, s, b);
    fill(tempColor.hue(), tempColor.saturation(), tempColor.brightness());
    rect(0,0,width/11.0,width/11.0); 
    
  }
  
    void displayVertical () {
   
    TColor tempColor = TColor.newHSV(h, s, b);
    fill(tempColor.hue(), tempColor.saturation(), tempColor.brightness());
    rect(0,0,(height)/11.0,height/11.0); 
    
  }
  
}
