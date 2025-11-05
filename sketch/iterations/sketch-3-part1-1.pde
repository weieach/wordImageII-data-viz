Table tableLeafBloom;
Table tableWildfire;
float angle = radians(25);
float decay = 0.67;

PFont rungli;
PFont rungliItalics;

int fontSize = 12;

int[] yearsLB;
float[] leafY;
float[] bloomY;

int[] yearsF;
float[] fireY;

color orangeRed = #BE3900;
color bgcolor = 245;
color paleBlue = #A1AED1;
color guidelineColor = 100;


void setup() {
    size(1300, 700);
  smooth(8);
  tableLeafBloom = loadTable("data.csv", "header");
  tableWildfire = loadTable("fig2-Wildfire Extent in the United States, 1983–2022.csv", "header");

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
  
  int startingYear = 65;
  float marginInline = width/20;

  translate(marginInline, height/2);
  textFont(rungli);

  float gridSizeLB = (width-marginInline) / (yearsLB.length - startingYear);

  //draw guideline
  int guidelineNum = 10;
  float guidelineH = height/2/guidelineNum - height*0.005;

  //guidelines (cool)
  for (int i=1; i < guidelineNum; i++) {
    pushMatrix();
    translate(0, i*guidelineH);
    
    fill(100);
    
    text(-i + " days", -width/30, height*0.005);
    stroke(paleBlue);
    float leftToRight = 0;
    while (leftToRight < width - marginInline) {
      pushMatrix();
      translate(leftToRight, 0);
      line(leftToRight, 0, leftToRight + width*0.002, 0);
      leftToRight += width*0.005;
      popMatrix();
    }
    popMatrix();
  }

  //guidelines (warm)
  for (int i=1; i < guidelineNum; i++) {
    pushMatrix();
    translate(0, -i*guidelineH);
    color indexBasedColor = color(208, 205 - i*15, 0);
    fill(indexBasedColor);
    
    text(i + " days", -width/30, height*0.005);
    stroke(indexBasedColor);
    float leftToRight = 0;
    while (leftToRight < width - marginInline) {
      pushMatrix();
      translate(leftToRight, 0);
      line(leftToRight, 0, leftToRight + width*0.002, 0);
      leftToRight += width*0.005;
      popMatrix();
    }
    popMatrix();
  }


  for (int i = startingYear; i < yearsLB.length; i++) {
    pushMatrix();
    translate(gridSizeLB * (i-startingYear), 0);
    stroke(0);
    float mappedH = map(leafY[i], -10, 10, -height * 0.167, height * 0.167);
    drawBranch(mappedH, 0, 0, 0);

    popMatrix();
  }

  
  fill(0);
  
  //thick baseline
  rect(-marginInline, -height/80, width, height * 0.015);


  //marking years
  for (int i = 0; i < yearsLB.length; i++) {
    pushMatrix();
    noStroke();

    // float mappedH = map(leafY[i], -10, 10, -400, 400);
    translate(gridSizeLB * (i-startingYear), 0);
    // if(leafY[i] < -3){
    //     String leafText = int(leafY[i]) + " days earlier";
    //     fill(245);
    //     rect(- width * 0.005, -mappedH - height/60, textWidth(leafText) * 1.1, height/40);
    //     fill(orangeRed);
    //     text(leafText, 0, -mappedH);
    // }
    if (yearsLB[i] % 5 == 0) {
      fill(bgcolor);
      
      text(yearsLB[i], 0, 0);
    }
    //  else {
    //   rectMode(CENTER);
    //   fill(bgcolor);
    //   rect())
    // }


    popMatrix();
  }
}





void drawBranch(float len, int g, int r, int i) {
  float absLen = abs(len);

  color branchColor = color(r, g, 0);
  if (absLen < 4) return;


  strokeWeight(map(absLen, 4, 150, 1, 10));
  int flipFactor = 1;
  stroke(paleBlue);
  if (len < 0) {
    stroke(branchColor);
    flipFactor = -1;
    //negative value (later first leaf): blue
    //flipFactor = -1 -> right way up
  }

  scale(0.7, 1);
  line(0, 0, 0, flipFactor * absLen);
  translate(0, flipFactor * absLen);


  pushMatrix();
  rotate(angle);
  drawBranch(len * decay, g+7*i, r+10, i + 1);
  popMatrix();

  pushMatrix();
  rotate(-angle);
  drawBranch(len * decay, g+7*i, r+10, i + 1);
  popMatrix();
}

