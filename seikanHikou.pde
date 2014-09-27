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
int speed = 30;

//PImage images[] = new PImage[300];
ArrayList<PImage> images = new ArrayList<PImage>();
ArrayList<String> names = new ArrayList<String>();

FlyingObject objects[] = new FlyingObject[300];
Star stars[] = new Star[300];
HiShow hishows[] = new HiShow[100];
FrameTimer timer = new FrameTimer(10);

PImage photo;

void setup() {
  //size(640, 480, P3D);
  size(displayWidth, displayHeight, P3D);
  frameRate(60);
  
  fpslabel = loadFont("Monospaced-16.vlw");
  //hiShowLabel = loadFont("HiraMinProN-W6-48.vlw");
  hiShowLabel = createFont("HiraMinProN-W6", 48);
  
  photo = loadImage("vstokyo_n.jpg");
  
  File dir = new File(dataPath("") + "/images");
  String[] list = dir.list();

  if (list == null) {
    println("Folder does not exist or cannot be accessed.");
  } 
  else {
//    println(list);
    for(int i = 0; i < list.length && i < 300; i++) {
      String filename = list[i];
      PImage image = loadImage(dir + "/" + filename);
//      images[i] = image;
      images.add(image);
    }
  }
  println(images.size());
  
//  File namesFile = new File(dataPath("") + "/names.txt");
  String namesList[] = loadStrings(dataPath("") + "/names.txt");
  for(int i = 0; i < namesList.length; i++) {
    String name = namesList[i];
    names.add(name);
  }
//  println("there are " + lines.length + " lines");
//  for (int i = 0 ; i < lines.length; i++) {
//    println(lines[i]);
//  }
}

void draw() {
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

  // 星を生成
//  if(timer.tick()) {
//  //if(true) {
//    int count = 0;
//    int i = 0;
//    while(count < 10 && i < stars.length) {
//      if(stars[i] == null) {
//        stars[i] = new Star(int(random(-500, 500)), int(random(-200, 200)), -depth, int(random(10, 50)));
//        count++;
//      }
//      i++;
//    }
//  }

  // generate FlyingObjects
  if(timer.tick()) {
    int count = 0;
    int i = 0;
    while(count < 3 && i < objects.length) {
      if(objects[i] == null) {
        int rnd = int(random(30));
        if(rnd > 0) {
          String name = names.get(int(random(names.size())));
          objects[i] = new FlyingText(name, int(random(-500, 500)), int(random(-200, 200)), -depth);
        }
        else {
          PImage image = images.get(int(random(images.size())));
          objects[i] = new FlyingImage(image, int(random(-500, 500)), int(random(-200, 200)), -depth);
        }
        count++;
      }
      i++;
    }
  }
  
//  //拝承を生成
//  if(timer.tick()) {
//  //if(true) {
//    int count = 0;
//    int i = 0;
//    while(count < 10 && i < hishows.length) {
//      if(hishows[i] == null) {
//        hishows[i] = new HiShow(int(random(-500, 500)), int(random(-200, 200)), -depth);
//        count++;
//      }
//      i++;
//    }
//  }
  
  // draw FlyingObjects
  for(int i = 0; i < objects.length; i++) {
    if(objects[i] != null) {
      objects[i].draw();
    }
  }
  
  // 星を描画
  for(int i = 0; i < stars.length; i++) {
    if(stars[i] != null) {
      stars[i].draw();
    }
  }
  
  // 拝承を描画
  for(int i = 0; i < hishows.length; i++) {
    if(hishows[i] != null) {
      hishows[i].draw();
    }
  }
  
  // move FlyingObjects
  for(int i = 0; i < objects.length; i++) {
    if(objects[i] != null) {
      objects[i].move();
    }
  }
  
  // 星を移動
  for(int i = 0; i < stars.length; i++) {
    if(stars[i] != null) {
      stars[i].move();
    }
  }
  
  // 拝承を移動
  for(int i = 0; i < hishows.length; i++) {
    if(hishows[i] != null) {
      hishows[i].move();
    }
  }
  
  // delete FlyingObjects
  for(int i = 0; i < objects.length; i++) {
    if(objects[i] != null) {
      if(objects[i].z > 1000) {
        objects[i] = null;
      }
    }
  }
  
  // 星を削除
  for(int i = 0; i < stars.length; i++) {
    if(stars[i] != null) {
      if(stars[i].z > 1000) {
        stars[i] = null;
      }
    }
  }
  
  // 星を拝承
  for(int i = 0; i < hishows.length; i++) {
    if(hishows[i] != null) {
      if(hishows[i].z > 1000) {
        hishows[i] = null;
      }
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
  }
  
  void drawContent() {
    fill(c, 220);
    textFont(hiShowLabel, 60);
    text(text, 100, 20);
  }
}

class FlyingImage extends FlyingObject {
  PImage image;
  
  FlyingImage(PImage _image, int _x, int _y, float _z) {
    super(_x, _y, _z);
    image = _image;
  }
  
  void drawContent() {
//    fill(c, 220);
//    textFont(hiShowLabel, 48);
//    text(text, 100, 20);
    image(image, 0, 0);
  }
}

class HiShow {
  int x;
  int y;
  float z;
  int c;
  
  HiShow(int _x, int _y, float _z) {
    x = _x;
    y = _y;
    z = _z;
    c = color(random(200, 255), random(200, 255), random(200, 255));
  }
  
  void draw() {
    pushMatrix();
    noStroke();
    translate(x, y, z);
    fill(c, 220);
    textFont(hiShowLabel, 48);
    text("拝承", 100, 20);
    popMatrix();
  }
  
  void move() {
    z += v;
  }
}

class Star {
  int x;
  int y;
  float z;
  int r;
  int c;
  
  Star(int _x, int _y, float _z, int _r) {
    x = _x;
    y = _y;
    z = _z;
    r = _r;
    c = color(random(200, 255), random(200, 255), random(200, 255));
  }
  
  void draw() {
    pushMatrix();
    noStroke();
    translate(x, y, z);
    fill(c, 220);
    sphere(r);
    popMatrix();
  }
  
  void move() {
    z += v;
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
