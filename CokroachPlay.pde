import java.util.ArrayList;
import processing.sound.*;

ArrayList<Cokroach> coks;
PImage img, imgPemukul, ground;
PImage gameTitle;
SoundFile soundFX, backSound;
int lastSpawnTime;
float pemukulWidth = 88;
float pemukulHeight = 110;
boolean gameStarted = false;
boolean hardMode = false; 

void setup() {
  size(800, 800);
  coks = new ArrayList<Cokroach>();
  img = loadImage("kecoa.png");
  imgPemukul = loadImage("pemukul.png");
  ground = loadImage("ground.png");
  gameTitle = loadImage("gameTitle.png");
  soundFX = new SoundFile(this, "soundFX.mp3");
  backSound = new SoundFile(this, "back.mp3");
  backSound.loop();
  lastSpawnTime = millis();
  cursor();
}

void draw() {
  if (!gameStarted) {
    showStartScreen();
  } else {
    noCursor();
    imageMode(CORNER);
    image(ground, 0, 0, width, height);

    if (millis() - lastSpawnTime > 5000) {
      float x = random(width);
      float y = random(height);
      int spawnCount = hardMode ? 2 : 1; 
      for (int i = 0; i < spawnCount; i++) {
        coks.add(new Cokroach(img, x, y));
      }
      lastSpawnTime = millis();
    }

    for (int i = coks.size() - 1; i >= 0; i--) {
      Cokroach c = coks.get(i);
      c.live();

      if (!c.isAlive()) {
        coks.remove(i);
      }
    }

    fill(51);
    textSize(16);
    text("nums: " + coks.size(), 50, 750);

    imageMode(CENTER);
    image(imgPemukul, mouseX, mouseY, pemukulWidth, pemukulHeight);

    float pemukulTipX = mouseX;
    float pemukulTipY = mouseY + pemukulHeight / 2 - 75;
    noFill();
    noStroke();
    ellipse(pemukulTipX, pemukulTipY, 80, 80);
  }
}

void mouseClicked() {
  if (!gameStarted) {
    // Posisi dan ukuran tombol
    float easyX = width / 2 - 50;
    float easyY = height / 2 + 100;
    float easyWidth = 100;
    float easyHeight = 40;

    float hardX = width / 2 - 50;
    float hardY = height / 2 + 150;
    float hardWidth = 100;
    float hardHeight = 40;

    // Cek klik di dalam area tombol "Mudah"
    if (mouseX > easyX && mouseX < easyX + easyWidth &&
        mouseY > easyY && mouseY < easyY + easyHeight) {
      hardMode = false; 
      gameStarted = true; 
      println("Mode Mudah dipilih"); 
    } 
    else if (mouseX > hardX && mouseX < hardX + hardWidth &&
             mouseY > hardY && mouseY < hardY + hardHeight) {
      hardMode = true; 
      gameStarted = true; 
      println("Mode Susah dipilih"); 
    }
  } else {
    boolean hit = false;
    float pemukulTipX = mouseX;
    float pemukulTipY = mouseY + pemukulHeight / 2 - 75;

    for (int i = coks.size() - 1; i >= 0; i--) {
      Cokroach c = coks.get(i);
      if (dist(pemukulTipX, pemukulTipY, c.getX(), c.getY()) < 30) { 
        c.die();
        hit = true;
      }
    }

    if (hit) {
      soundFX.play();
    }
  }
}

void showStartScreen() {
  imageMode(CORNER);
  image(ground, 0, 0, width, height);

  imageMode(CENTER);
  image(gameTitle, width / 2, height / 2 - 50);

  fill(34, 139, 34); 
  rectMode(CENTER);
  rect(width / 2, height / 2 + 100, 120, 60);

  fill(178, 34, 34);
  rect(width / 2, height / 2 + 150, 120, 60);

  fill(255); 
  textSize(32);
  textAlign(CENTER);
  textFont(createFont("Arial-Bold", 32));
  text("Mudah", width / 2, height / 2 + 108);
  text("Susah", width / 2, height / 2 + 158); 
}
