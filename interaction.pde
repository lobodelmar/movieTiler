int sliderMargin = 5;
int startPosX = 10;
int startPosY = 10;
int marginY=20;
int labelColor = 125;
int sliderWidth = 255;
int sliderHeight = 15;

void initializeGUI()
{
  cp5 = new ControlP5(this);

  cp5.addSlider("OUTPUT_WIDTH")
    .setPosition(startPosX, startPosY)
    .setLabel("output width in px")
    .setSize(sliderWidth, sliderHeight)
    .setRange(2000, 10000)
    .setValue(5000)
    //.setColorCaptionLabel(labelColor)
//    .setGroup("g1")
    ;

  cp5.addSlider("ROW_MARGIN")
    .setLabel("row margin in px")
    .setPosition(startPosX, startPosY+marginY)
    .setSize(sliderWidth, sliderHeight)
    .setRange(0, 200)
    .setValue(32)
    //.setColorCaptionLabel(255)
//    .setGroup("g1")
    ;

  cp5.addSlider("STILLS_PER_ROW")
    .setLabel("still per row")
    .setPosition(startPosX, startPosY+marginY*2)
    .setSize(sliderWidth, sliderHeight)
    .setRange(1, 200)
    .setValue(60)
    //.setColorCaptionLabel(labelColor)
    ;

  cp5.addSlider("STILL_INTERVAL_IN_SEC")
    .setLabel("still inverval in sec")
    .setPosition(startPosX, startPosY+marginY*3)
    .setSize(sliderWidth, sliderHeight)
    .setRange(0.1, 10)
    .setValue(1)
    //.setColorCaptionLabel(labelColor)
    ;

  cp5.addSlider("BACKGROUND_RED")
    .setPosition(startPosX, startPosY+marginY*4+10)
    .setLabel("red")
    .setSize(sliderWidth, 10)
    .setRange(0, 255)
    .setValue(0)
    //.setColorCaptionLabel(labelColor)
    ;
    

  cp5.addSlider("BACKGROUND_GREEN")
    .setPosition(startPosX, startPosY+marginY*4+22)
    .setLabel("GREEN")
    .setSize(sliderWidth, 10)
    .setRange(0, 255)
    .setValue(0)
    //.setColorCaptionLabel(labelColor)
    ;

  cp5.addSlider("BACKGROUND_BLUE")
    .setPosition(startPosX, startPosY+marginY*4+34)
    .setLabel("BLUE")
    .setSize(sliderWidth, 10)
    .setRange(0, 255)
    .setValue(0)
    //.setColorCaptionLabel(labelColor)
    ;

}

void controlEvent(ControlEvent theEvent) {
  if (!running) initializeParameters();
}

void keyPressed() {
  if (key == 'g' || key == 'G') {
    thread("generate");
  } else if (key == 'q' || key == 'Q') {
    interrupt=true;
  }
}
void movieEvent(Movie m) {
  m.read();
}