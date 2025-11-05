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
color paleBlue = #A1AED1;
color guidelineColor = 100;
color dotColor = #064189;
color lilacColor = #C4A8C9;
color blueLilac = #A6ADE6;
color yellow = #E3BD3E;
color brown = #756C6B;

void setup() {
  size(1300, 800);
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
  int gridSizeLBG = bloomDateChange.length;
  translate(-width/20, 0);
  // noStroke();
  stroke(#DECEDF); //pink stroke
  stroke(#B6B0B0); //brown stroke
  // rectMode(CENTER);

  // drawMap();
  drawMapLeaf();
  labelMap();

  // drawDistMatrix();
}



void drawMap() {
  int flowerCounter = 0;
  int budCounter = 0;
  int noChangeCounter = 0;
  int excessCounter = 0;
  for (int i = 0; i < bloomDateChange.length; i++) {
    if (latitude[i] < 50 && longitude[i] > -130) {

      // float size = map(bloomDateChange[i], -34, 14.5, -height/50, height/100);
      float size = abs(bloomDateChange[i])*3 + 6;
      float longi = map(longitude[i], -130, -67, 0, width);
      float lat = map(latitude[i], 50, 25.9, 0, height);

      // circle(longi, lat, size);
      // lilacFlower.resize(int(size), int(size));

      if (bloomDateChange[i] < -1) {
        pushMatrix();
        // rotate(random(60));


        if (bloomDateChange[i] < -10) {
          image(lilacFlower, longi, lat, int(size), int(size));
          excessCounter++;
        } else {
          fill(blueLilac);
          rect(longi, lat, int(size), int(size));
        }

        popMatrix();
        flowerCounter++;
      } else if (bloomDateChange[i] > 1) {
        fill(#908745);
        image(lilacBud, longi, lat, int(size), int(size));
        // rect(longi, lat, int(size), int(size));
        budCounter++;
      } else {
        noChangeCounter++;
        noStroke();
        fill(#756C6B);
        rect(longi, lat, iconSize*0.1, iconSize*0.03);
      }
    }
  }
  print(">10days state:" + excessCounter);
  // print("flower " + flowerCounter);
  // print("bud " + budCounter);
  // println("no chnage  " + noChangeCounter);
  // //flower 785; bud 311; no change  154
}

void drawMapLeaf() {
  for (int i = 0; i < leafDateChange.length; i++) {
    if (latitudeLeaf[i] < 50 && longitudeLeaf[i] > -130) {
      float size = abs(leafDateChange[i])*3 + 6;
      float longi = map(longitudeLeaf[i], -130, -67, 0, width);
      float lat = map(latitudeLeaf[i], 50, 25.9, 0, height);
      if (leafDateChange[i] < 0) {
        image(leafImg, longi, lat, int(size*0.9), int(size));
        
      } else {
        fill(brown);
        rect(longi, lat, int(size), int(size));
      }
    }
  }
}

void labelMap() {
  textFont(abcHelvesti);
  for (int i = 0; i < statesName.length; i++) {
    fill(0);
    float longi = map(statesLong[i], -130, -67, 0, width);
    float lat = map(statesLat[i], 50, 25.9, 0, height);

    text(statesName[i], longi, lat);
    fill(#E3BD3E);
    // rect(longi, lat+(height/170), height/55, height/200);
  }
}


void drawDistMatrix() {
  translate(width/12, height/200);
  int matrixCounter = 0;
  int gap = height/10;

  for (int y = 0; y < 10; y++) {
    for (int x = 0; x < 10; x++) {
      if (matrixCounter <= 25) {
        image(lilacBud, x*gap, y*gap, iconSize, iconSize);
      } else if (matrixCounter <= 37) {
        fill(#756C6B);
        rect(x*gap + 0.2*gap, y*gap + 0.5*gap, iconSize*0.5, iconSize/6);
      } else {
        image(lilacFlower, x*gap, y*gap, iconSize, iconSize);
      }
      matrixCounter++;
    }
  }
}

