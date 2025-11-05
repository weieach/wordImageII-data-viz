// Table tableLeafBloom;
// Table tableWildfire;
// float angle = radians(25);
// float decay = 0.67;

// PFont rungli;
// PFont rungliItalics;

// int fontSize = 16;

// int[] yearsLB;
// float[] leafY;
// float[] bloomY;

// int[] yearsF;
// float[] fireY;

// PShape leaf;
// PShape honeysuckle;

// color orangeRed = #BE3900;
// color bgcolor = 245;
// color paleBlue = #A1AED1;
// color guidelineColor = 100;
// color dotColor = #064189;


// void setup() {
//   size(1400, 800);
//   smooth(8);
//   tableLeafBloom = loadTable("data.csv", "header");
//   tableWildfire = loadTable("fig2-Wildfire Extent in the United States, 1983–2022.csv", "header");

//   leaf = loadShape("leaf-fill.svg");
//   honeysuckle = loadShape("honeysuckle.svg");


//   rungli = createFont("Rungli-Regular_MP_Pinyin.subset.otf", fontSize);
//   // rungliItalics = createFont("sketch/data/Rungli_Italic_MP.subset.otf", fontSize);



//   stroke(40);
//   background(bgcolor);
//   pixelDensity(2);


//   int n = tableLeafBloom.getRowCount();
//   yearsLB = new int[n];
//   leafY = new float[n];
//   bloomY = new float[n];

//   int i = 0;
//   for (TableRow row : tableLeafBloom.rows()) {
//     yearsLB[i] = row.getInt("year");
//     leafY[i] = row.getFloat("Leaf Mean");
//     bloomY[i] = row.getFloat("Bloom Mean");
//     i++;
//   }

//   int n2 = tableWildfire.getRowCount();
//   yearsF = new int[n2];
//   fireY = new float[n2];

//   int i2 = 0;
//   for (TableRow row : tableWildfire.rows()) {
//     yearsF[i2] = row.getInt("Year");
//     fireY[i2] = row.getFloat("National Interagency Fire Center");
//     i2++;
//   }
// }



// void draw() {
//   textFont(rungli);
//   float gridSizeLB = height / (yearsLB.length/10 + 2);

    // for (int i = startingYear; i < yearsLB.length; i++) {
    // }
  
// }