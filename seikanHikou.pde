float rotatex;
float rotatey;
int offsetz = 0;
int rx = 0;
int ry = 0;
PFont fpslabel;

int blockzwidth = 200;
float v = 16;
int depth = 2000;
int gap = 400;
int speed = 30;

Star stars[] = new Star[300];
FrameTimer timer = new FrameTimer(10);

void setup() {
  size(640, 480, P3D);
  //size(screen.width, screen.height, P3D);
  frameRate(60);
  
  fpslabel = loadFont("Monospaced-16.vlw"); 
  textFont(fpslabel, 16); 
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
  if(timer.tick()) {
  //if(true) {
    int count = 0;
    int i = 0;
    while(count < 10 && i < stars.length) {
      if(stars[i] == null) {
        stars[i] = new Star(int(random(-500, 500)), int(random(-200, 200)), -depth, int(random(10, 50)));
        count++;
      }
      i++;
    }
  }
  
  // 星を描画
  for(int i = 0; i < stars.length; i++) {
    if(stars[i] != null) {
      stars[i].draw();
    }
  }
  
  // 星を移動
  for(int i = 0; i < stars.length; i++) {
    if(stars[i] != null) {
      stars[i].move();
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
  
  popMatrix();
  fill(255);
  text(frameRate, width-80, 20);
}

class Grid {
  Grid() {
  }
  
  void draw() {
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
    sphere(r);
    popMatrix();
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

