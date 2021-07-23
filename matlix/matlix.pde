
class SecondApplet extends PApplet {
  PApplet parent;
  
  SecondApplet(PApplet _parent) {
    super();
    // set parent
    this.parent = _parent;
    // init window
    PSurface surface = super.initSurface(java.awt.Color.GRAY, -1, false, false);
    surface.placeWindow(new int[]{0, 0});
  }
  
  void setup() {
    this.size(300, 300);
  }
  
  void draw() {
    background(frameCount % 255);
    fill(0);
    ellipse(width/2, height/2, width/2, height/2);
  }
}

SecondApplet second;

void setup() {
  size(400, 400);
  second = new SecondApplet(this);
}

void draw() {
  background(frameCount % 255);
}
