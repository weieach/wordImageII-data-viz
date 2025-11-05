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

void setup(){
    tableLeafBloom = loadTable("data.csv", "header");
    tableWildfire = loadTable("fig2-Wildfire Extent in the United States, 1983–2022.csv", "header");

    rungli = createFont("Rungli-Regular_MP_Pinyin.subset.otf", fontSize);
    rungliItalics = createFont("sketch/data/Rungli_Italic_MP.subset.otf", fontSize);


    size(1200, 900);
    stroke(40);
    background(245);
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

void draw(){
    translate(0, height/2);
    fill(0);
    rect(0, 0, width, 2);
    textFont(rungli);

    float gridSizeLB = width / yearsLB.length;

    
    for(int i = 0; i < yearsLB.length; i++){
        pushMatrix();
        translate(gridSizeLB * i, 0);
        stroke(0);
        float mappedH = map(leafY[i], -10, 10, -150, 150);
        drawBranch(mappedH);
        
        popMatrix();
    }

    for(int i = 0; i < yearsLB.length; i++){
        pushMatrix();
        fill(#BE3900);
        
        float mappedH = map(leafY[i], -10, 10, -150, 150);
        translate(gridSizeLB * i, mappedH);
        if(-leafY[i] > 3){
            text(int(leafY[i]) + " days", 0, 0);
        }
        
        fill(#68763F);
        translate(0, -20);
        text(yearsLB[i], 0, 0);
        popMatrix();
    }

}


void drawBranch(float len) {
  float absLen = abs(len);
  if (absLen < 4) return;

  
  strokeWeight(map(absLen, 4, 150, 1, 10));
  int flipFactor = -1;
  if(len < 0){
    stroke(#A1AED1);
    flipFactor = 1;
    //negative value (later first leaf): blue
    //flipFactor = -1 -> right way up
  }

  scale(0.7, 1);
  line(0, 0, 0, flipFactor * absLen);
  translate(0, flipFactor * absLen);

  pushMatrix();
  rotate(angle);
  drawBranch(len * decay);
  popMatrix();

  pushMatrix();
  rotate(-angle);
  drawBranch(len * decay);
  popMatrix();
}
