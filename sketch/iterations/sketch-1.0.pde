Table table;
PFont neueMontreal;
PFont neueMontrealMed;
PImage skyBG; 
PImage grassBG;
PImage grassBGBlur;

int[] yearsArr;
float[] leafMeans;
float[] bloomMeans;

int fontSize = 15;

color lilacPurple = #AE8AD4;
color leafGreen = #83AD66;
color darkerGreen = #678439;
color labelColor = #FF9007;
color yellow = #F9E300;


void setup(){
    size(1200, 720);
    background(255);
    table = loadTable("data.csv", "header");
    skyBG = loadImage("sky.jpg");
    grassBG = loadImage("grass_original.jpeg");
    grassBGBlur = loadImage("grass_blurred.png");
    
    
    neueMontreal = createFont("NeueMontreal-Regular.otf", fontSize);
    neueMontrealMed = createFont("NeueMontreal-Medium.otf", fontSize);
    pixelDensity(2);

    int n = table.getRowCount();
    yearsArr = new int[n];
    leafMeans = new float[n];
    bloomMeans = new float[n];

    int i = 0;
    for (TableRow row : table.rows()) {
        yearsArr[i] = row.getInt("year");
        leafMeans[i] = row.getFloat("Leaf Mean");
        bloomMeans[i] = row.getFloat("Bloom Mean");
        i++;
    }
    ellipseMode(CENTER);
    rectMode(CENTER);
}
/*
processing-java --sketch="$(pwd)/sketch" --run
*/

void draw(){
    textFont(neueMontrealMed);
    noStroke();
    
    textAlign(CENTER,CENTER);

    skyBG.resize(0, height);
    grassBG.resize(width, 0);
    grassBGBlur.resize(width,0);
    image(grassBGBlur, 0, 0);

    fill(0);
    float gridSize = width / yearsArr.length;
    int factor = 16;
    translate(gridSize*5, 0);

    for(int i = 0; i < yearsArr.length; i++){
        float x = (i + 1) * gridSize;
        int r = 20;
        
        fill(lilacPurple);
        if(yearsArr[i] % 10 == 0){
            float decadeSumLeaf = 0;
            float decadeSumBloom = 0;
            if(yearsArr[i] != 2020){
                for(int i2 = 0; i2 < 10; i2++){
                    decadeSumLeaf += leafMeans[i + i2];
                    decadeSumBloom += bloomMeans[i + i2];
                }
            } else {
                for(int i2 = 0; i2 < 3; i2++){
                    decadeSumLeaf += leafMeans[i + i2];
                    decadeSumBloom += bloomMeans[i + i2];
                }
            }
            
            float leafAverage = decadeSumLeaf / 10;
            float bloomAverage = decadeSumBloom / 10;
            
            r = 35;
            fill(leafGreen);
            stroke(darkerGreen);
            rect(x, height - leafAverage * factor - 300, r, r);
            //rect(x-1, height - average * factor - 500, 2, (height-500)-average); //stem
            
            
            fill(labelColor);
            noStroke();
            ellipse(x, height - bloomAverage * factor - 500, r, r);
            text(yearsArr[i], x, height-20);
        } else {
            ellipse(x, height - bloomMeans[i]*factor - 500, r, r);

            fill(leafGreen);
            rect(x, height - leafMeans[i]*factor - 300, r, r);
        }
        
        
    }

    if(frameCount == 10){
        saveFrame("1.png");
    }


}