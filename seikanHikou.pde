float rotatex;
float rotatey;
int offsetz = 0;
int rx = 0;
int ry = 0;
PFont fpslabel;
PFont hiShowLabel;

int blockzwidth = 200;
float v = 16;
int depth = 2000;
int gap = 400;

int speed = 14;
int fontSize = 48;
int objectsDensity = 1;

ArrayList<PImage> images = new ArrayList<PImage>();
ArrayList<String> names = new ArrayList<String>();

//FlyingObject objects[] = new FlyingObject[50];
ArrayList<FlyingObject> objects = new ArrayList<FlyingObject>();
FrameTimer timer = new FrameTimer(10);

PImage photo;

void setup() {
  //size(640, 480, P3D);
  size(displayWidth, displayHeight, P3D);
  frameRate(60);
  
  fpslabel = loadFont("Monospaced-16.vlw");
  //hiShowLabel = loadFont("HiraMinProN-W6-48.vlw");
//  hiShowLabel = createFont("HiraMinProN-W6", fontSize);
  hiShowLabel = createFont("YuGo-Bold", fontSize);
  
  photo = loadImage("vstokyo_n.jpg");
  
  File dir = new File(dataPath("") + "/images");
  String[] list = dir.list();

  if (list == null) {
    println("Folder does not exist or cannot be accessed.");
  }
  else {
    for(int i = 0; i < list.length && i < 300; i++) {
      String filename = list[i];
      PImage image = loadImage(dir + "/" + filename);
      images.add(image);
    }
  }
  println(images.size());

  String namesList[] = loadStrings(dataPath("") + "/names.txt");
  for(int i = 0; i < namesList.length && i < 140; i++) {
    String name = namesList[i];
    names.add(name);
  }
}

void draw() {
//  clear();
  background(0);

  stroke(200);
  
  pushMatrix();
  translate(width/2, height/2, 100);
  if(keyPressed == true) {
    if(keyCode == RIGHT) {
      ry += 1;
    }
    else if(keyCode == LEFT) {
      ry -= 1;
    }
    else if(keyCode == UP) {
      rx += 1;
    }
    else if(keyCode == DOWN) {
      rx -= 1;
    }
  //rotateX(radians(20));
  }
  rotateY(radians(ry));
  rotateX(radians(rx));
  
  v = 60 * speed / frameRate;
  
  if(offsetz > blockzwidth) {
    offsetz = 1;
  }
  else {
    offsetz += v;
  }

  pushMatrix();
  translate(0, -gap/2, 0);
  for(int i = 0; i < depth; i+=blockzwidth) {
    line(-500, 0, -i+offsetz-100, 500, 0, -i+offsetz-100);
  }
  for(int i = 0; i < 11; i+=1) {
    line(-500+i*100, 0, 1000, -500+i*100, 0, -depth);
  }
  popMatrix();
  
  pushMatrix();
  translate(0, gap/2, 0);
  for(int i = 0; i < depth; i+=blockzwidth) {
    line(-500, 0, -i+offsetz-100, 500, 0, -i+offsetz-100);
  }
  for(int i = 0; i < 11; i+=1) {
    line(-500+i*100, 0, 1000, -500+i*100, 0, -depth);
  }
  popMatrix();
  
  lights();

  // generate FlyingObjects
  if(timer.tick()) {
    int count = 0;
    int i = 0;
    while(count < objectsDensity && i < 100) {
      int rnd = int(random(30));
      if(rnd > 1) {
        String name = names.get(int(random(names.size())));
        objects.add(new FlyingText(name, int(random(-500, 500)), int(random(-200, 200)), -depth));
      }
      else if(rnd == 1) {
        objects.add(new FlyingImage(photo, int(random(-500, 500)), int(random(-200, 200)), -depth));
      }
      else {
        PImage image = images.get(int(random(images.size())));
        objects.add(new FlyingImage(image, int(random(-500, 500)), int(random(-200, 200)), -depth));
      }
      count++;
      i++;
    }
  }
  
  // draw FlyingObjects
//  for(int i = 0; i < objects.length; i++) {
//    if(objects[i] != null) {
//      objects[i].draw();
//    }
//  }
  for(int i = 0; i < objects.size(); i++) {
    FlyingObject object = objects.get(i);
    object.draw();
  }
  
  // move FlyingObjects
//  for(int i = 0; i < objects.length; i++) {
//    if(objects[i] != null) {
//      objects[i].move();
//    }
//  }
  for(int i = 0; i < objects.size(); i++) {
    FlyingObject object = objects.get(i);
    object.move();
  }

  // delete FlyingObjects
//  for(int i = 0; i < objects.length; i++) {
//    if(objects[i] != null) {
//      if(objects[i].z > 1000) {
//        objects[i] = null;
//      }
//    }
//  }
  for(int i = 0; i < objects.size(); i++) {
    if(objects.get(i).z > 1000) {
      objects.remove(i);
    }
  }
  
  popMatrix();
  fill(255);
  textFont(fpslabel, 16);
  text(frameRate, width-80, 20);
}

class Grid {
  Grid() {
  }
  
  void draw() {
  }
}

class FlyingObject {
  int x;
  int y;
  float z;
  int c;  // color
  
  FlyingObject(int _x, int _y, float _z) {
    x = _x;
    y = _y;
    z = _z;
    c = color(random(200, 255), random(200, 255), random(200, 255));
  }
  
  void draw() {
    pushMatrix();
    noStroke();
    translate(x, y, z);
    drawContent();
    popMatrix();
  }
  
  void drawContent() {
//    image(photo, 0, 0);
  }
  
  void move() {
    z += v;
  }
}

class FlyingText extends FlyingObject {
  String text;
  
  FlyingText(String _text, int _x, int _y, float _z) {
    super(_x, _y, _z);
    text = _text;
//    text = "耕作放棄地のある農家(世帯)数と耕作放棄地面積（総農家、自給的農家、土地持ち非農家）";
  }
  
  void drawContent() {
    fill(c, 220);
    textFont(hiShowLabel, fontSize);
    textAlign(CENTER, CENTER);
    text(text, 0, 0);
  }
}

class FlyingImage extends FlyingObject {
  PImage image;
  
  FlyingImage(PImage _image, int _x, int _y, float _z) {
    super(_x, _y, _z);
    image = _image;
  }
  
  void drawContent() {
    image(image, -image.width/2, -image.height/2);
  }
}

class FrameTimer {
  int f;
  int t;
  
  FrameTimer(int _f) {
    f = _f;
  }
  
  boolean tick() {
    if(t < f) {
      t++;
      return false;
    }
    else {
      t = 0;
      return true;
    }
  }
}
