import java.util.Calendar;
import joons.JoonsRenderer;


JoonsRenderer jr;
ArrayList<Float> boxes = new ArrayList<Float> ();
MeshObj panda;

//Camera Setting.
float eyeX = 0;
float eyeY = 120;
float eyeZ = 80;
float centerX = 0;
float centerY = 0;
float centerZ = 10;
float upX = 0;
float upY = 0;
float upZ = -1;
float fov = PI / 4; 
float aspect = width/height;  
float zNear = 5;
float zFar = 10000;

float rot = 0;

void setup() {
  size(800, 800, P3D);
  jr = new JoonsRenderer(this);
  jr.setSampler("bucket"); //レンダリングモード、"ipr"または"bucket"
  jr.setSizeMultiplier(1); //.pngファイルのサイズをprocessingスケッチサイズの倍数として設定します
  jr.setAA(0, 2, 4); //アンチエイリアスを設定します, (最小, 最大, サンプル). -2 < min, max < 2, samples = 1,2,3,4..
  jr.setCaustics(20); //コースティックスを設定します。 1〜100は、ガラスを通して散乱する光の品質に影響します。
  jr.setDOF(180, 3); //カメラの被写界深度を設定します（焦点距離、レンズ半径）。半径が大きい=>ぼやけている。
  //被写界深度を有効にしないと、すべてがデフォルトでフォーカスされます。
  //bucketサンプラーを使用し、setAAのサンプルを変更してレンダリング品質を制御します。 
  //FocalDistance（焦点距離）はカsメラから測定されます。
  //lensRadius（レンズ半径）を大きくすると（0.1、0.5、1、2、5、10など）、イメージがぼやけます。
  for (int i = 0; i < 200; i++) {
    boxes.add(random(-75, 75));
    boxes.add(random(150)-75);
    boxes.add(random(150)-20);
  }
  panda = new MeshObj(loadShape("panda.obj"));
}

void draw() {
  jr.beginRecord(); //Make sure to include things you want rendered.

  jr.background(30, 30, 30);
  camera(eyeX, eyeY, eyeZ, centerX, centerY, centerZ, upX, upY, upZ);
  perspective(fov, aspect, zNear, zFar);
  
  //Lighting.
  jr.fill("light", 30, 30, 30, 64);
  int z = 50;
  beginShape(QUADS);
  vertex(-z*2, -z, 150);
  vertex(-z*2, z, 150);
  vertex(-z, z, 150);
  vertex(-z, -z, 150);
  endShape();

  rotateX(radians(20));

  //Floor.
  jr.fill("diffuse", 100, 100, 100);
  int w = 10000;
  beginShape(QUADS);
  vertex(w, -w, -30);
  vertex(-w, -w, -30);
  vertex(-w, w, -30);
  vertex(w, w, -30);
  endShape();

  //Random Spheres.
  pushMatrix();
  rotateZ(radians(rot));
  jr.fill("diffuse", 255, 255, 255); 
  for (int i = 0; i < boxes.size()/3; i++) {
    translate(boxes.get(i*3), boxes.get(i*3+1), boxes.get(i*3+2));
    box(2);
    translate(-boxes.get(i*3), -boxes.get(i*3+1), -boxes.get(i*3+2));
  }
  popMatrix();

  pushMatrix();
  translate(0, 0, 0);
  float rot = map(mouseX, 0, width, 0, 360);
  rotateZ(radians(90));
  rotateX(radians(90));
  println(rot);
  translate(-50, 10, 0);
  scale(3);
  panda.draw();
  popMatrix();

  translate(0, 0, 0);

  jr.endRecord(); //Make sure to end record.
  jr.displayRendered(true); //Display rendered image if render is completed, and the argument is true.
}

void keyReleased() {
  if (key == 's' || key == 'S')saveFrame(timestamp()+"_####.jpg");
  if (key=='r'||key=='R') jr.render(); //Press 'r' key to start rendering.
  if (key =='c' || key == 'C') {
    boxes.clear();
    for (int i = 0; i < 200; i++) {
    boxes.add(random(-75, 75));
    boxes.add(random(150)-75);
    boxes.add(random(150)-20);
  }
  }
}

String timestamp() {
  Calendar now = Calendar.getInstance();
  return String.format("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS", now);
}
