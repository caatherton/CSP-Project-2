import ddf.minim.analysis.*;
import ddf.minim.*;

Minim       minim;
AudioPlayer song;
FFT         fft;

int x;
int y;
float l;
float l2;
float noiseScale=2;
int size=5;
int cols, rows;
int w = 150;
int h = 150;
float c = 100;

float[][] terrain;

void setup() {
  fullScreen(P3D);
  colorMode(HSB);
  stroke(255);
  noCursor();
  frameRate(60);
  minim = new Minim(this);
  song = minim.loadFile("Passion_Pit_-_Take_a_Walk_Video[Mp3Converter.net].mp3", 1024);
  fft = new FFT( song.bufferSize(), song.sampleRate() );
  cols = w/size;
  rows = h/size;
  terrain = new float[cols][rows];
  song.play();
}
void draw() {  
  float bass = fft.calcAvg(0, 100);
  float mid = fft.calcAvg(100, 1000)*8;    
  float high = fft.calcAvg(1000, 20000)*8;
  lights();
  background(0);
  camera(0, 100, -75, -sin(l/20)*100, sin(l2/20)*300, -cos(l/20)*100, 0, -1, 0);
  translate(-(w/2), 0, -(h/2));
  l= map(mouseX, 0, 1280, 0, 360);
  l2= map(mouseY, 0, 800, 0, 180);
  noFill();
  for (float y=0; y < rows; y++) {
    beginShape(TRIANGLE_STRIP);
    for (float x=0; x < cols+1; x++) {
      bass = fft.calcAvg(0, 100);
      mid = fft.calcAvg(100, 1000)*8;    
      high = fft.calcAvg(1000, 20000)*8;
      //fill(-50-bass*10, -50-high*10-mid, -100);
      stroke(noise(100)+bass/10, noise(50)+high*10+mid, 100);//change the color
      vertex(x*size, (noise(0, x*(noiseScale/5))*20)+bass/10, (y)*size);
      vertex(x*size, (noise(0, -x*(noiseScale/5))*20)-bass/10, (y+1)*size);
      noiseScale = noiseScale-0.0000060;//to slow the rate of movement
      fft.forward( song.mix );
    }
    endShape();
  }
}