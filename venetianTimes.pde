import processing.video.*;
import processing.pdf.*;

//Declare Globals
int rSn; // randomSeed number. put into var so can be saved in file name. defaults to 47
final float PHI = 0.618033989;

boolean PDFOUT = false;

Capture cam;
ArrayList<PImage> vidTimeLine = new ArrayList<PImage>();
int maxArrayListSz;
int sliceCount, targetSliceCount, maxSliceCount, sliceW;
float minPortalDia, maxPortalDia;
/*////////////////////////////////////////
 SETUP
 ////////////////////////////////////////*/
void setup() {
  // size(1000, 750);
  size(800, 600);
  // frameRate(15);

  rSn = 47; // 29, 18;
  randomSeed(rSn);
  targetSliceCount = 30;
  maxArrayListSz = 30 * 4; // 150    FPS * seconds = seconds of history retained.
  maxSliceCount = (targetSliceCount < maxArrayListSz) ? targetSliceCount : maxArrayListSz; // pick whichever is smaller
  sliceW = (width / maxSliceCount)+1; // 640/50 = 12.8      
  sliceCount = maxSliceCount;
  minPortalDia = 0;
  maxPortalDia = width;

  String[] cameras = Capture.list();

  if (cameras.length == 0) {
    exit();
  } else {
    cam = new Capture(this, cameras[0]); // 640x480@15fps
    cam.start();
  }
  println("setup done: " + nf(millis() / 1000.0, 1, 2));
}

void draw() {
  background(255);
  if (cam.available() == true) {
    cam.read();
    PImage f = cam.get();
    vidTimeLine.add(f);
    // sliceCount = (sliceCount < maxSliceCount) ? sliceCount++ : maxSliceCount;
    if (vidTimeLine.size() > maxArrayListSz) vidTimeLine.remove(0); // prevents Arraylist from getting too big and causing memory problems
  }

  if (vidTimeLine.size() > sliceCount+1) { // 500 = approx 33 seconds at 15fps 
    for (int i = 0; i < sliceCount; i++) {
      showSlice(i);
    }
  }
  if (PDFOUT) exit();
}

void showSlice(int _i){
  int imgIndx = int(map(_i, 0, sliceCount, vidTimeLine.size()-1, 0));
  PImage f = vidTimeLine.get(imgIndx * 1);
  f.resize(width,height);

  int imgX = int(map(_i, 0, sliceCount, 0, width));
  
  PImage fm = f.get(imgX, 0, sliceW, height);

  image(fm, imgX, 0);
}

void keyPressed() {
  // if (key == 'S') screenCap(".tif");
}

void mousePressed() {
}