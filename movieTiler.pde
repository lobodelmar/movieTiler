import processing.video.*;
import controlP5.*;

//*******************************
String VIDEO_FILENAME = "spaceodyssey.mp4";
String OUTPUT_FILENAME = "spaceodyssey2.tiff";
int OUTPUT_WIDTH = 10000;
int ROW_MARGIN = 32;  // in pixels - margin between rows (suggested: half the size of a frame)
int STILLS_PER_ROW = 60;                    // number of frames per row
float STILL_INTERVAL_IN_SEC = 1;                     // how often to save a frame (in seconds)
int BACKGROUND_RED = 0;
int BACKGROUND_GREEN = 0;
int BACKGROUND_BLUE = 0;
//*******************************
Movie video;
PGraphics pg;
boolean alreadyRun;
int currentStill;
int tileWidth, tileHeight;
int outputHeight;
float videoDuration;
boolean interrupt;
int curLocX, curLocY;
color background_color = color(BACKGROUND_RED, BACKGROUND_GREEN, BACKGROUND_BLUE);
int progressPct;
boolean running;
PFont font;
  
ControlP5 cp5;
ColorPicker cp;

void setup() {
  size(620, 320);
  background(150);

  video = new Movie(this, VIDEO_FILENAME);
  video.play();
  video.volume(0);

  initializeGUI();

  // String[] fontList = PFont.list();
  // printArray(fontList);
  font = createFont("Courier 10 Pitch", 20);
  textFont(font);
}

void initializeParameters() {

  video.read();
  while (video.get().width==0 || video.get().height==0) {
    //do nothing
  }
  tileWidth = OUTPUT_WIDTH / STILLS_PER_ROW;                                       
  tileHeight = int(tileWidth / float(video.get().width) * video.get().height);     

  int totalStills = ceil(video.duration() / STILL_INTERVAL_IN_SEC);
  videoDuration = video.duration();
  int totalRows = ceil(totalStills  / float(STILLS_PER_ROW));
  outputHeight = ceil(totalRows * ( tileHeight + ROW_MARGIN ));
  OUTPUT_WIDTH = tileWidth*STILLS_PER_ROW;
  background_color = color(BACKGROUND_RED, BACKGROUND_GREEN, BACKGROUND_BLUE); 

  /*
  println("---------------------------");
   println("TILE WIDTH: " + tileWidth);
   println("TILE HEIGHT: " + tileHeight);
   println("ROW MARGIN: " + ROW_MARGIN);
   println("OUTPUT WIDTH: " + OUTPUT_WIDTH);
   println("OUTPUT HEIGHT: " + outputHeight);
   println("STILLS PER ROW: " + STILLS_PER_ROW);
   println("STILL INTERVAL: " + STILL_INTERVAL_IN_SEC);                     // how often to save a frame (in seconds)*/
  pg = createGraphics(OUTPUT_WIDTH, outputHeight);//, PDF, PDF_FILENAME);
}

void draw() {
  background(150);
  preview();
}

void generate() {
  println("generating....");
  running=true;
  if (!alreadyRun) {
    pg.beginDraw();
    pg.background(background_color);
    alreadyRun = true;
    video.jump(0);
    interrupt = false;
  }

  for (float currentTime=0; currentTime < videoDuration; currentTime+=STILL_INTERVAL_IN_SEC)
  {
    video.jump(currentTime);
    video.read();
    curLocX = tileWidth*(currentStill % STILLS_PER_ROW);
    curLocY = tileHeight*(currentStill / STILLS_PER_ROW) + ROW_MARGIN * (currentStill / STILLS_PER_ROW);
    PImage resizedImage = video.get();
    resizedImage.resize(tileWidth, tileHeight);
    pg.image(resizedImage, curLocX, curLocY);
    currentStill++;

    progressPct = round(currentTime/videoDuration * 100);
    if (interrupt) break;
  }
  pg.endDraw();
  pg.save(OUTPUT_FILENAME);
  println("saving... do not interrupt");
  alreadyRun=false;
  exit();
}


void preview() {

  //preview rectangle
  pushMatrix();
  pushStyle();
  translate(400, 10);
  float rectWidth = 200;
  float rectHeight= outputHeight/(float)OUTPUT_WIDTH * rectWidth;
  float scaling=1;
  if (rectHeight>290) scaling = 290/rectHeight;
  scale(scaling, scaling);
  fill(background_color);
  stroke(0);
  rect(0, 0, rectWidth, rectHeight);
  stroke(125);
  line(0, 0, rectWidth, rectHeight);
  line(rectWidth, 0, 0, rectHeight);
  popStyle();
  popMatrix();

  //output document parameters
  pushMatrix();
  translate(10, height/2);
  textSize(14);
  fill(255);
  int textMargin = 18;
  String outputWidthString = "w: " + OUTPUT_WIDTH + " px";
  String outputHeightString = "  h: "+ outputHeight + " px";
  text("document size  " + outputWidthString + outputHeightString, 0, 0);

  //output tile parameters
  String tileWidthString = "w: " + tileWidth + " px";
  String tileHeightString = "  h: "+ tileHeight + " px";
  text("tile size  " + tileWidthString + tileHeightString, 0, textMargin);

  translate(0, 10);
  text("input file: " + VIDEO_FILENAME, 0, textMargin*2);
  text("output file: " + OUTPUT_FILENAME, 0, textMargin*3);

  translate(0, 25);
  text("'g' to generate", 0, textMargin*4);
  text("'q' to interrupt", 0, textMargin*5);

  translate(0, 10);
  if (running) {
    text(progressPct+ "% complete", 0, textMargin*6-3);
    fill(255);
    noStroke();
    rect(-10, textMargin*6+2, lerp(0, width, progressPct/100.0), 10);
  }

  popMatrix();
}