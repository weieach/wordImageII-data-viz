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
PShape s;

color orangeRed = #BE3900;
color bgcolor = 245;
color paleBlue = #A1AED1;
color guidelineColor = 100;
color dotColor = #064189;
color textColor = 0;


void setup() {
  size(1400, 800);
  smooth(8);
  tableLeafBloom = loadTable("data.csv", "header");
  tableWildfire = loadTable("fig2-Wildfire Extent in the United States, 1983–2022.csv", "header");

  leaf = loadShape("leaf-fill.svg");
  honeysuckle = loadShape("honeysuckle.svg");


  rungli = createFont("Rungli-Regular_MP_Pinyin.subset.otf", fontSize);
  // rungliItalics = createFont("sketch/data/Rungli_Italic_MP.subset.otf", fontSize);

  frameRate(10);

  stroke(40);
  background(255);
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


//fire data
  int n2 = tableWildfire.getRowCount();
  yearsF = new int[n2];
  fireY = new float[n2];

  int i2 = 0;
  for (TableRow row : tableWildfire.rows()) {
    yearsF[i2] = row.getInt("Year");
    fireY[i2] = row.getFloat("National Interagency Fire Center");
    i2++;
  }

  s = createShape();
  s.beginShape();
  //s.noStroke();

  // Exterior part of shape
  s.vertex(-50,-50);
  s.vertex(50,-50);
  s.vertex(50,50);
  s.vertex(-50,50);

  // Interior part of shape
  s.beginContour();
  s.vertex(-20,-20);
  s.vertex(-20,20);
  s.vertex(20,20);
  s.vertex(20,-20);
  s.endContour();

  // Finish off shape
  s.endShape(CLOSE);
}



void draw() {
  textFont(rungli);
  
  // background(bgcolor);
  int interval = 1;
  float gridSizeF = width / (yearsF.length/interval + 1);
  int guidelineNum = 12;

  // for(int i = 0; i <= guidelineNum; i++){
  //   push();
  //   fill(#CB9944);
  //   textAlign(LEFT);
  //   float guidelineH = (height/2) / guidelineNum;
  //   translate(0, height/1.2 - guidelineH * i);
  //   String metric = str(i); 
  //   if(i == guidelineNum){
  //     metric += " (millions of acres)";
  //   }
  //   text(metric, 4, 0);
  //   pop();
  // }

  pushMatrix();
  // translate(gridSizeF, 0);

  textAlign(CENTER);

  for (int i = 0; i < (yearsF.length/interval); i++) {
    float mappedH = map(fireY[i] / 1000000, 0, 10, 0, -height/2);
    int r = int(map(fireY[i] / 1000000, 10, 0, 153, 249));
    int g = int(map(fireY[i] / 1000000, 10, 0, 49, 249));
    int b = int(map(fireY[i] / 1000000, 10, 0, 0, 130));
    
    pushMatrix();
      translate(gridSizeF * (i+1), height/1.2);
      stroke(guidelineColor);
      s.setFill(color(r, g, b));
      s.rotate(0.01);
      
      // shape(s, 0, mappedH, gridSizeF, gridSizeF);
      if((i+1) %2 == 0){

        fill(textColor);
        
        text(yearsF[i], 0, mappedH+height * 0.09);
      }
      popMatrix();
  }
  popMatrix();
  
}