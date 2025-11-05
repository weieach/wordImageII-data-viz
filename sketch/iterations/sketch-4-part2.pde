Table tableLeafBloom;
Table tableWildfire;
float angle = radians(25);
float decay = 0.67;

PFont rungli;
PFont rungliItalics;

int fontSize = 16;

int[] yearsLB;
float[] leafY;
float[] bloomY;

int[] yearsF;
float[] fireY;

PShape leaf;
PShape honeysuckle;

color orangeRed = #BE3900;
color bgcolor = 245;
color paleBlue = #A1AED1;
color guidelineColor = 100;
color dotColor = #064189;


void setup() {
  size(900, 1300);
  smooth(8);
  tableLeafBloom = loadTable("data.csv", "header");
  tableWildfire = loadTable("fig2-Wildfire Extent in the United States, 1983–2022.csv", "header");

  leaf = loadShape("leaf-fill.svg");
  honeysuckle = loadShape("honeysuckle.svg");


  rungli = createFont("Rungli-Regular_MP_Pinyin.subset.otf", fontSize);
  // rungliItalics = createFont("sketch/data/Rungli_Italic_MP.subset.otf", fontSize);



  stroke(40);
  background(bgcolor);
  pixelDensity(2);


  int n = tableLeafBloom.getRowCount();
  yearsLB = new int[n];
  leafY = new float[n];
  bloomY = new float[n];

  int i = 0;
  for (TableRow row : tableLeafBloom.rows()) {
    yearsLB[i] = row.getInt("year");
    leafY[i] = row.getFloat("Leaf Mean");
    bloomY[i] = row.getFloat("Bloom Mean");
    i++;
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
}



void draw() {
  textFont(rungli);
  float gridSizeLB = height / (yearsLB.length/10 + 2);
  fill(dotColor);
  noStroke();
  ellipseMode(CENTER);
  imageMode(CENTER);
  shapeMode(CENTER);
  rectMode(CENTER);
  int counter = 0;

  //parameter
  int intervalLength = 4;

  drawIcon(gridSizeLB, counter, intervalLength, bloomY, honeysuckle, false);
  // drawIcon(gridSizeLB, counter, intervalLength, leafY, leaf, true);
}



void drawIcon(float gridSizeLB, int counter, int intervalLength, float[] arr, PShape s, boolean showYear) {
  //parameter
  int startingYear = 100;
  for (int i = startingYear; i < yearsLB.length; i++) {

    if (i %intervalLength == 0) {
      float sum = 0;
      // if (i != 120) {
      int shortenInterval = 0;
      if(i + intervalLength > yearsLB.length){
        shortenInterval = i + intervalLength - yearsLB.length;
      }
      for (int i2 = i; i2 < i + intervalLength - shortenInterval; i2++) {
        sum += arr[i2] * -1;
      }
      int radius = int(map(sum, -25, 12, gridSizeLB/5, gridSizeLB/1.5));
      int red = int(map(sum, -25, 12, 61, 255));

      pushMatrix();
      translate(width/2, gridSizeLB * counter + gridSizeLB);
      // circle(0, 0, radius);
      s.disableStyle();
      // strokeWeight(10);
      // stroke(color(red-50, 153-50, 112-50));
      fill(color(red, 153, 112));

      shape(s, 0, 0, radius, radius);

      popMatrix();
      // }

      // int currentYear = yearsLB[i]
      pushMatrix();
      translate(width/2, gridSizeLB * counter + gridSizeLB/2);
      stroke(guidelineColor);
      strokeWeight(1);
      int lineCoor = 50;
      line(-lineCoor, 0, lineCoor, 0);
      if (showYear) {
        textAlign(CENTER);
        fill(guidelineColor);
        text(yearsLB[i], -width/20, -height/200);
      }

      popMatrix();
      counter++;
    }
  }
}
