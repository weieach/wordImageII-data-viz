Table tableLeafBloom;
Table tableWildfire;
Table tableBloomGeo;
Table tableLeafGeo;
Table states;
float angle = radians(25);
float decay = 0.67;

PFont rungli;
PFont rungliItalics;
PFont abcHelvesti;

PImage lilacFlower;
PImage lilacBud;
PImage leafImg;

int fontSize = 16;
int iconSize;

int[] yearsLB;
float[] leafY;
float[] bloomY;

float[] latitude;
float[] longitude;
float[] bloomDateChange;

float[] latitudeLeaf;
float[] longitudeLeaf;
float[] leafDateChange;

float[] statesLat;
float[] statesLong;
String[] statesName;

int[] yearsF;
float[] fireY;

PShape leaf;
PShape honeysuckle;

color orangeRed = #BE3900;
color bgcolor = 245;
color paleBlue = #9BA4BA;
color guidelineColor = 100;
color dotColor = #064189;
color lilacColor = #C4A8C9;
color blueLilac = #A6ADE6;
color yellow = #E3BD3E;
// color brown = #756C6B;
color brown = #755D6C;
color greenSlash = #63BB52;

void setup() {
  size(1800, 2400);
  // size(533, 800);
  smooth(8);

  tableLeafBloom = loadTable("data.csv", "header");
  tableWildfire = loadTable("fig2-Wildfire Extent in the United States, 1983–2022.csv", "header");
  tableBloomGeo = loadTable("leaf-bloom_fig-4-states.csv", "header");
  tableLeafGeo = loadTable("leaf-bloom_fig-3 -leaf-states.csv", "header");
  states = loadTable("states.csv", "header");
  

  leaf = loadShape("leaf-fill.svg");
  honeysuckle = loadShape("honeysuckle.svg");
  lilacFlower = loadImage("lilac-flower.png");
  lilacBud = loadImage("lilac-bud.png");
  leafImg = loadImage("leaf2.png");

  

  rungli = createFont("Rungli-Regular_MP_Pinyin.subset.otf", fontSize);
  // rungliItalics = createFont("sketch/data/Rungli_Italic_MP.subset.otf", fontSize);
  abcHelvesti = createFont("ABCHelveesti-Medium_MP.subset 2.otf", fontSize/1.5);

  iconSize = height/10;


  stroke(40);
  background(bgcolor);
  pixelDensity(2);


  int n = tableLeafBloom.getRowCount();
  yearsLB = new int[n];
  leafY = new float[n];
  bloomY = new float[n];

  int n1 = tableBloomGeo.getRowCount();
  latitude = new float[n1];
  longitude = new float[n1];
  bloomDateChange = new float[n1];

  int n4 = tableLeafGeo.getRowCount();
  latitudeLeaf = new float[n4];
  longitudeLeaf = new float[n4];
  leafDateChange = new float[n4];



  int i = 0;
  for (TableRow row : tableLeafBloom.rows()) {
    yearsLB[i] = row.getInt("year");
    leafY[i] = row.getFloat("Leaf Mean");
    bloomY[i] = row.getFloat("Bloom Mean");
    i++;
  }

  int i1=0;

  for (TableRow row : tableBloomGeo.rows()) {
    latitude[i1] = row.getFloat("Latitude");
    longitude[i1] = row.getFloat("Longitude");
    bloomDateChange[i1] = row.getFloat("Change in first bloom date");
    i1++;
  }

  int i4 = 0;
  for (TableRow row : tableLeafGeo.rows()) {
    latitudeLeaf[i4] = row.getFloat("Latitude");
    longitudeLeaf[i4] = row.getFloat("Longitude");
    leafDateChange[i4] = row.getFloat("Change in first leaf date");
    i4++;
  }


  int n2 = tableWildfire.getRowCount();
  yearsF = new int[n2];
  fireY = new float[n2];

  int i2 = 0;
  for (TableRow row : tableWildfire.rows()) {
    yearsF[i2] = row.getInt("Year");
    fireY[i2] = row.getFloat("National Interagency Fire Center");
    i2++;
  }

  int n3 = states.getRowCount();
  statesLat = new float[n3];
  statesLong = new float[n3];
  statesName = new String[n3];
  int i3 = 0;
  for (TableRow row : states.rows()) {
    statesLat[i3] = row.getFloat("latitude");
    statesLong[i3] = row.getFloat("longitude");
    statesName[i3] = row.getString("state");
    i3++;
  }
}



void draw() {
  textFont(rungli);

  int startingYear = 65;
  int gridSize = height / (yearsLB.length - startingYear);
  imageMode(CENTER);
  rectMode(CENTER);
  translate(width/2, height);


  //branch placeholder
  fill(0);
  rect(0, -height/2, width/40, height);

  

  // // drawMap();
  // drawMapLeaf();
  // labelMap();

  // drawDistMatrix();
  

  //draw guideline - left
  int guidelineNum = 10;
  float guidelineH = width/2.7/guidelineNum;
  pushMatrix();
  translate(-width/2+width/25, -height);
  for (int i=1; i <= guidelineNum; i++) {
    pushMatrix();
    translate(i*guidelineH, 0);
    color indexBasedColor = color(208, 55 + i*15, 0);
    fill(indexBasedColor);
    
    // text(i + " days",  width*0.005, height/20);
    stroke(indexBasedColor);
    float bottomToTop = 0;
    while (bottomToTop < height) {
      pushMatrix();
      translate(0, bottomToTop);
      strokeWeight(width/700);
      line(0, bottomToTop, 0, bottomToTop+ height*0.003);
      bottomToTop += height*0.006;
      popMatrix();
    }
    popMatrix();
  }
  popMatrix();

  // - right
  pushMatrix();
  translate(width/25, -height);
  for (int i=1; i <= guidelineNum; i++) {
    pushMatrix();
    translate(i*guidelineH, 0);
    
    stroke(paleBlue);
    float bottomToTop = 0;
    while (bottomToTop < height) {
      pushMatrix();
      translate(0, bottomToTop);
      strokeWeight(width/700);
      line(0, bottomToTop, 0, bottomToTop+ height*0.003);
      bottomToTop += height*0.006;
      popMatrix();
    }
    popMatrix();
  }
  popMatrix();


  for(int i = startingYear; i < yearsLB.length; i++){
    float gapFromCenter = width/25;
    float horizontalSpan = width/2.7;

    float x = map(leafY[i], -10, 10, -horizontalSpan, horizontalSpan);
    float leafSize = map(abs(leafY[i]), 0, 10, width/30, width/5);
    float rotateDeg = map(leafY[i], -10, 10, -PI/4, PI/4);
    

    pushMatrix();
    translate(0, -height/40);
    if(leafY[i]<0){
      translate(x - gapFromCenter, -(i-startingYear)*gridSize);

      
      rotate(rotateDeg - PI/2.5);
    } else{
      translate(x + gapFromCenter, -(i-startingYear)*gridSize);
      // text(leafY[i], 0, 20);
      rotate(rotateDeg + PI/4);
    }
    int remappedColorI = int(map(abs(leafY[i]), 10, 0,  1, 10));
    noStroke();
    
    image(leafImg, 0, 0, leafSize*0.5, leafSize);
    
          
          if(leafY[i]<0){
            color indexBasedColor = color(228, 75 + remappedColorI*15, 20);
    
            fill(50);
            textSize(height/100);
            rotate(-(rotateDeg - PI/2.5 + PI/2));
        text(leafY[i]*-1, 0, 0);
        fill(indexBasedColor);
          } else {
            fill(#A0AED1);
          }
          circle(0, 0, height/250);
    popMatrix();
          
  }
}



