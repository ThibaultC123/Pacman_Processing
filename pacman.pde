//PACMAN Thibault CACI

import processing.sound.*;
import sprites.utils.*;
import sprites.maths.*;
import sprites.*;

//*******
//**
//**   Tableau correspondant au labyrinthe:
//**        0 = case vide
//**        1 = dot        (dessiné au centre)
//**        2 = energizer  (dessiné au centre)
//**        5 = mur
//**
//*******

final int mazeWidth=27;  // Y compris colonne 0 (bordure) 0..27
final int mazeHeight=30; // Y compris ligne 0 (bordure)  0..30
final int offsetX = 323; // Abscisse du coin supérieur gauche
final int offsetY = 0;   // Ordonnée du coin supérieur gauche

byte [][] Map=new byte[mazeHeight+1][mazeWidth+1]; // labyrinthe utilisé à chaque nouvelle partie
byte Map0[][]={

//         0           4           8          12          16          20          24       27
/*  0 */ { 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5},
         { 5, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 5, 5, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 5},
/*  2 */ { 5, 1, 5, 5, 5, 5, 1, 5, 5, 5, 5, 5, 1, 5, 5, 1, 5, 5, 5, 5, 5, 1, 5, 5, 5, 5, 1, 5},
         { 5, 2, 5, 5, 5, 5, 1, 5, 5, 5, 5, 5, 1, 5, 5, 1, 5, 5, 5, 5, 5, 1, 5, 5, 5, 5, 2, 5}, /* Energizer = 3 */
/*  4 */ { 5, 1, 5, 5, 5, 5, 1, 5, 5, 5, 5, 5, 1, 5, 5, 1, 5, 5, 5, 5, 5, 1, 5, 5, 5, 5, 1, 5},
         { 5, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 5},
/*  6 */ { 5, 1, 5, 5, 5, 5, 1, 5, 5, 1, 5, 5, 5, 5, 5, 5, 5, 5, 1, 5, 5, 1, 5, 5, 5, 5, 1, 5},
         { 5, 1, 5, 5, 5, 5, 1, 5, 5, 1, 5, 5, 5, 5, 5, 5, 5, 5, 1, 5, 5, 1, 5, 5, 5, 5, 1, 5},
/*  8 */ { 5, 1, 1, 1, 1, 1, 1, 5, 5, 1, 1, 1, 1, 5, 5, 1, 1, 1, 1, 5, 5, 1, 1, 1, 1, 1, 1, 5},
         { 5, 5, 5, 5, 5, 5, 1, 5, 5, 5, 5, 5, 0, 5, 5, 0, 5, 5, 5, 5, 5, 1, 5, 5, 5, 5, 5, 5},
/* 10 */ { 0, 0, 0, 0, 0, 5, 1, 5, 5, 5, 5, 5, 0, 5, 5, 0, 5, 5, 5, 5, 5, 1, 5, 0, 0, 0, 0, 0},
         { 0, 0, 0, 0, 0, 5, 1, 5, 5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5, 5, 1, 5, 0, 0, 0, 0, 0},
/* 12 */ { 0, 0, 0, 0, 0, 5, 1, 5, 5, 0, 5, 5, 5, 5, 5, 5, 5, 5, 0, 5, 5, 1, 5, 0, 0, 0, 0, 0},  /* Sortie de la maison: 13 & 14 */
         { 5, 5, 5, 5, 5, 5, 1, 5 ,5, 0, 5, 5, 5, 5, 5, 5, 5, 5, 0, 5, 5, 1, 5, 5, 5, 5, 5, 5},  /* Toit du tunnel */
/* 14 */ { 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 5, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0},  /* Tunnel = 14 */
         { 5, 5, 5, 5, 5, 5, 1, 5, 5, 0, 5, 0, 0, 0, 0, 0, 0, 5, 0, 5, 5, 1, 5, 5, 5, 5, 5, 5},  /* Plancher du tunnel */
/* 16 */ { 0, 0, 0, 0, 0, 5, 1, 5, 5, 0, 5, 5, 5, 5, 5, 5, 5, 5, 0, 5, 5, 1, 5, 0, 0, 0, 0, 0},
         { 0, 0, 0, 0, 0, 5, 1, 5 ,5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5 ,5, 1, 5, 0, 0, 0, 0, 0},
/* 18 */ { 0, 0, 0, 0, 0, 5, 1, 5 ,5, 0, 5, 5, 5, 5, 5, 5, 5, 5, 0, 5 ,5, 1, 5, 0, 0, 0, 0, 0},
         { 5, 5, 5, 5, 5, 5, 1, 5, 5, 0, 5, 5, 5, 5, 5, 5, 5, 5, 0, 5, 5, 1, 5, 5, 5, 5, 5, 5},
/* 20 */ { 5, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 5, 5, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 5},
         { 5, 1, 5, 5, 5, 5, 1, 5, 5, 5, 5, 5, 1, 5, 5, 1, 5, 5, 5, 5, 5, 1, 5, 5, 5, 5, 1, 5},
/* 22 */ { 5, 1, 5, 5, 5, 5, 1, 5, 5, 5, 5, 5, 1, 5, 5, 1, 5, 5, 5, 5, 5, 1, 5, 5, 5, 5, 1, 5},
         { 5, 2, 1, 1, 5, 5, 1, 1, 1, 1, 1, 1, 1, 0, 0 ,1, 1, 1, 1, 1, 1, 1, 5, 5, 1, 1, 2, 5}, /* Energizer = 23 */
/* 24 */ { 5, 5, 5, 1, 5, 5, 1, 5, 5, 1, 5, 5, 5, 5, 5, 5, 5, 5, 1, 5, 5, 1, 5, 5, 1, 5, 5, 5},
         { 5, 5, 5, 1, 5, 5, 1, 5 ,5, 1, 5, 5, 5, 5, 5, 5, 5, 5, 1, 5, 5, 1, 5, 5, 1, 5, 5, 5},
/* 26 */ { 5, 1, 1, 1, 1, 1, 1, 5, 5, 1, 1, 1, 1, 5, 5, 1, 1, 1, 1, 5, 5, 1, 1, 1, 1, 1, 1, 5},
         { 5, 1, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 1, 5, 5, 1, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 1, 5},
/* 28 */ { 5, 1, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 1, 5, 5, 1, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 1, 5},
         { 5, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 5},
/* 30 */ { 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5} 
};

// Variables pour gérer le temps
//
StopWatch sw=new StopWatch(); // Pour l'animation des objets par S4P
int phaseDeJeu[]={ 7000, 20000, 7000, 20000, 5000, 20000, -1}; // 7s scatter puis 20s de chase etc.
int indexDePhaseDeJeu;
int frightTable[]={ 1500, 5000, 4000, 3000, 2000, 5000, 2000, 2000, 1000, 5000, 2000, 1000, -1}; // Première valeur devrait être 6000...

// le jeu comporte plusieur séquences qui sont appelées par pre(), draw() et keyPressed()
// Pour définir une constante, on écrit final int :

int sequence;
final int isDemo = 0;
final int isStart = 1;
final int isGame = 2;
final int isDeath = 3;
final int isWin = 4;
final int isGameOver = 5;
int time; // utilisé pour arrêter la séquence start
int level; // Niveau (indexe aussi le tableau frightTable[] jusqu'à 12-1=11)

// Les variables liées a pacman
//
Sprite sPacman;
aPacman thePacman;
final int shallStop = 0; // Immobile
final int goingRight = 1; // sens de déplacement de pacman
final int goingLeft = 2;
final int goingUp = 3;
final int goingDown = 4;
final int pacmanAlive = 1;
final int pacmanDead = 0;
final double pacmanRotRight = 0.0; // Rotation de l'image de pacman en fonction de la direction suivie
final double pacmanRotDown = 1.6;
final double pacmanRotLeft = 3.2;
final double pacmanRotUp = 4.7;
int numberOfPacmanLeft;

// Les variables liées aux fantômes
//
final int scatterMode = 0;
final int chaseMode = 1;
final int frightenedMode = 2;
final int blinkMode = 3;
final int pointsMode = 4;
final int eyesMode = 5;
Sprite sRouge, sRose, sBleu, sOrange;
aGhost redGhost, blueGhost, pinkGhost, orangeGhost;
int distanceUp, distanceLeft, distanceRight, distanceDown;
final int distanceEnorme = 1000;
float ghostVelocity;
final int pointsForGhost[]={200, 400, 800, 1600};
int indexPointsForGhost;

//
// On déclare les variables pour les images à charger
//
PImage backgroundImg, pacmanImg, dotImg, energizerImg, readyImg, gameOverImg, titleImg;
SoundFile pacman_beginning, pacman_chomp, pacman_death, pacman_eatfruit, pacman_eatghost, pacman_extrapac, pacman_intermission;
PFont pacmanFont;
final int spriteWidth = 48;
final int halfSpriteWidth = 25;
final int spriteHeight = 48;
final int halfSpriteHeight = 25;
final float topLeftSpriteX=offsetX+37.5; // 1.5*halfSpriteWidth -> Centre du sprite & Abscisse de Map[1][1]
final float topLeftSpriteY=offsetY+37.5; // 1.5*halfSpriteHeight -> Centre du sprite & Ordonnée de Map[1][1]
//
//
int highScore, score;
//
//

final int largeurEcran = 1366;
final int hauteurEcran = 768;

void setup(){

  loadEverything(); // Téléchargement des sons et des images
  
  // Initialisation de la fenêtre graphique
  //
  size(1366, 768);
  frameRate(120);
  
  // Initialisation des variables score
  //
  highScore = 0;
  score = 0;

  sequence = isDemo;
  
  // Initialisation du pacman
  //
  // Création du sprite et de l'objet pacman
  //
  sPacman = new Sprite(this, "Pacman4x3.png", "MasquePacman4x3.png", 4, 3, 1, true);
  thePacman = new aPacman(pacmanAlive, 13, 23, goingRight, sPacman);
  numberOfPacmanLeft = 2;
  
  // Initialisation des fantômes
  //
  // Création des sprites et des objets fantômes
  //
  sRouge = new Sprite(this, "FantomeRouge5x4.png", "MasqueFantome5x4.png", 4, 5, 1, true);
  redGhost = new aGhost(scatterMode, 10, 10, goingUp, sRouge);
  sRose = new Sprite(this, "FantomeRose5x4.png", "MasqueFantome5x4.png", 4, 5, 1, true);
  pinkGhost = new aGhost(scatterMode, 10, 10, goingUp, sRose);
  sBleu = new Sprite(this, "FantomeBleu5x4.png", "MasqueFantome5x4.png", 4, 5, 1, true);
  blueGhost = new aGhost(scatterMode, 10, 10, goingUp, sBleu);
  sOrange = new Sprite(this, "FantomeOrange5x4.png", "MasqueFantome5x4.png", 4, 5, 1, true);
  orangeGhost = new aGhost(scatterMode, 10, 10, goingUp, sOrange);
  
  initDemo(); // initialise la position de pacman dans le sprite (thePacman.Sprite ...)
  
  registerMethod("pre", this); // Processing va appeler pre() avant d'appeler draw()
}

void initGame(){
int i, j;

  for (i=0; i<=mazeHeight; i++){
    for (j=0; j<=mazeWidth; j++){
      Map[i][j]=Map0[i][j];
    }
  }
  
  level=1;
  
  // Initialise les variables de l'objet thePacman et de son sprite associé
  // sprites.Sprite.stopImageAnim  ()  = Stop the image animation at the current frame
  //
  thePacman.mode=pacmanAlive;
  thePacman.posX=12;
  thePacman.posY=23;
  thePacman.direction=goingRight;
  thePacman.nextDirection=shallStop;
  thePacman.isMoving=false;
  thePacman.itsSprite.setDomain(0, 0, 1366, 768, Sprite.HALT); // A CORRIGER...
  thePacman.itsSprite.setDead(false);
  thePacman.itsSprite.setVisible(true);
  thePacman.itsSprite.setVelXY(0.0, 0.0);
  thePacman.itsSprite.setFrameSequence(0, 3, 0.1f);
  thePacman.itsSprite.setRot(pacmanRotRight);
  thePacman.itsSprite.setScale(1.0);
  thePacman.itsSprite.setXY(topLeftSpriteX+12.5*halfSpriteWidth, topLeftSpriteY+22*halfSpriteHeight);
  // Initialise le fantôme rouge et son objet
  //
  redGhost.mode = scatterMode;
  redGhost.itsSprite.setVisible(true);  // Parce qu'invisible après la mort de Pacman
  redGhost.itsSprite.setFrameSequence(0, 3, 0.1f);
  redGhost.isMoving=false;
  redGhost.posX=12;
  redGhost.posY=10;
  redGhost.itsSprite.setVelXY(0, 0);
  redGhost.itsSprite.setXY(topLeftSpriteX+12.5*halfSpriteWidth, topLeftSpriteY+10*halfSpriteHeight);
  // Initialise le fantôme bleu et son objet
  //
  blueGhost.mode = scatterMode;
  blueGhost.itsSprite.setVisible(true);  // Parce qu'invisible après la mort de Pacman
  blueGhost.itsSprite.setFrameSequence(0, 3, 0.1f);
  blueGhost.isMoving=false;
  blueGhost.itsSprite.setVelXY(0, 0);
  blueGhost.posX=10;
  blueGhost.posY=13;
  blueGhost.itsSprite.setXY(topLeftSpriteX+10.5*halfSpriteWidth, topLeftSpriteY+13*halfSpriteHeight);
  // Initialise le fantôme rose et son objet
  //
  pinkGhost.mode = scatterMode;
  pinkGhost.itsSprite.setVisible(true);  // Parce qu'invisible après la mort de Pacman
  pinkGhost.itsSprite.setFrameSequence(0, 3, 0.1f);
  pinkGhost.isMoving=false;
  pinkGhost.itsSprite.setVelXY(0, 0);
  pinkGhost.posX=12;
  pinkGhost.posY=13;
  pinkGhost.itsSprite.setXY(topLeftSpriteX+12.5*halfSpriteWidth, topLeftSpriteY+13*halfSpriteHeight);
  // Initialise le fantôme orange et son objet
  //
  orangeGhost.mode = scatterMode;
  orangeGhost.itsSprite.setVisible(true);  // Parce qu'invisible après la mort de Pacman
  orangeGhost.itsSprite.setFrameSequence(0, 3, 0.1f);
  orangeGhost.isMoving=false;
  orangeGhost.itsSprite.setVelXY(0, 0);
  orangeGhost.posX=14;
  orangeGhost.posY=13;
  orangeGhost.itsSprite.setXY(topLeftSpriteX+14.5*halfSpriteWidth, topLeftSpriteY+13*halfSpriteHeight);
  // Joue la musique du début de partie
  //
  pacman_beginning.play();
}

boolean isThereAWall(int x, int y, int direction){
  boolean wall;
  wall = false;
  switch(direction){
    case goingRight :
      if (x>25) { wall=true; }
        else if (Map[y][x+1] == 5) {wall = true;}  // Sauf tunnel...
      break;
    case goingLeft :
      if (x<2) { wall=true; }
        else if (Map[y][x-1] == 5) {wall = true;}   // Sauf tunnel...
      break;
    case goingUp :
      if (y<2) { wall=true; }
        else if (Map[y-1][x] == 5) {wall = true;}
           else if ((y==11 || y==23) && ((x==12 || x==15))) { wall=true; } // Forbidden RED ZONE
      break;
    case goingDown :
      if (y>28) { wall=true; }
        else if (Map[y+1][x] == 5) {wall = true;}
      break;
  }
  return wall;
}

void draw(){
  //
  switch(sequence){
   case isDemo :
     drawDemo();
     break;
   case isStart :
     drawStart();
     break;
   case isGame :
     drawGame();
     break;
   case isDeath :
     drawDeath();
     break;
   case isWin :
     drawWin();
     break;
   case isGameOver:
     drawGameOver();
     break;
  }
}

void loadEverything(){

  // Chargement des images
  //
  backgroundImg = loadImage("BackgroundPlayfield_768.png");
  pacmanImg = loadImage("Pacman_11.png");
  dotImg = loadImage("Pastille24.png");
  energizerImg = loadImage("Energizer24.png");
  readyImg = loadImage("ReadyMsg.png");
  gameOverImg = loadImage("GameOver.png");
  titleImg = loadImage("PacmanTitle.png");

  // Chargement des sons
  //
  pacman_beginning = new SoundFile(this, "pacman_beginning.mp3");
  pacman_chomp = new SoundFile(this, "pacman_chomp.mp3");
  pacman_death = new SoundFile(this, "pacman_death.mp3");
  pacman_eatfruit = new SoundFile(this, "pacman_eatfruit.mp3");
  pacman_eatghost = new SoundFile(this, "pacman_eatghost.mp3");
  pacman_extrapac = new SoundFile(this, "pacman_extrapac.mp3");
  pacman_intermission = new SoundFile(this, "pacman_intermission.mp3");
  
  // Chargement de la police
  //
  pacmanFont = loadFont("SegoeUIBlack-30.vlw");
}

void drawBoard(){
  int x, y, k;
  
  // Dessine le labyrinthe en fond d'écran
  //
  background(backgroundImg);
  imageMode(CORNER); // les coordonnées de l'image sont celles de son coin supérieur gauche
  
  // Dessine (en bas à gauche) le nombre de pacman qui restent
  //
  k = 275; 
  for(int i = 0; i < numberOfPacmanLeft; i++) {
    image(pacmanImg, k, 690);
    k = k - spriteWidth;
  }
  
  // Dessine le "highscore" et le "score"
  //
  textSize(32);
  fill(255);
  text("HIGH SCORE :", 25, 100);
  text(highScore, 25, 150);
  text("SCORE :", 25, 200);
  text(score, 25, 250);
  
  // Remplit le labyrinthe avec "dot" ou "Energizer"
  //
  y = offsetY + halfSpriteHeight;
  for(int i = 1; i < mazeHeight; i++) {
    x = offsetX + halfSpriteWidth;
    for(int j = 1; j < mazeWidth; j++){
      switch(Map[i][j]){
        case 1 :
          image(dotImg, x, y);
          break;
        case 2 :
          image(energizerImg, x, y);
          break;
      }
      x = x + halfSpriteWidth;
    }
    y = y + halfSpriteHeight;
  }
}

void allGhostsGo(int newMode){      // A TERMINER: 
  redGhost.mode   = newMode;        //   Les fantômes doivent retourner sur leurs pas
  blueGhost.mode  = newMode;        //   à chaque changement de mode: chase->scatter, chase->frightened
  pinkGhost.mode  = newMode;        //   scatter->chase et scatter->frigthened
  orangeGhost.mode= newMode;        //   *** Appeler la méthode reverseDirection()
}

// Points acquis lorsque Pacman mange un fantôme en mode Frightened
//    200 pour le premier... 1600 pour le quatrième

void ghostEaten() {
  score=score+pointsForGhost[indexPointsForGhost];
  indexPointsForGhost++;
  if (indexPointsForGhost>3) { indexPointsForGhost=0; } // Réinitialise par sécurité
}

public void pre(){
float elapsedTime=(float) sw.getElapsedTime(); // Combien de temps s'est écoulé depuis le dernier appel?

  switch(sequence){
    case isDemo :
      preDemo();
      break;
    case isStart :
      preStart();
      break;
    case isGame :
      preGame();
      break;
    case isDeath :
      preDeath();
      break;
    case isWin :
      preWin();
      break;
    case isGameOver :
      preGameOver();
      break;
  }
  S4P.updateSprites(elapsedTime);
}

void preStart(){
}

void preDeath(){
  if ((thePacman.counter==1) && (thePacman.itsSprite.getFrame()==11)) {
    thePacman.counter=0;
  }
}

void preWin(){
}

void keyPressed(){
  // Orienter selon la séquence: soit Demo, soit Game
  // (pas de gestion du clavier dans les autres séquences de jeu)
  //
  switch(sequence){
    case isDemo :
      keyDemo(key);
      break;
    case isGame :  // On ne réagit aux touches QUE si Pacman est vivant
      if (thePacman.mode==pacmanAlive) { keyGame(keyCode); }
      break;
  }
}

void keyGame(int theKeyCode){
  
  // Si pacman est immobile, on le fait démarrer SI POSSIBLE (pas de mur)
  //
  if (thePacman.isMoving==false) {
      switch (theKeyCode){
        case UP:
          thePacman.initPacmanUp();
          break;
        case DOWN:
          thePacman.initPacmanDown();
          break;
        case LEFT:
          thePacman.initPacmanLeft();
          break;
        case RIGHT:
          thePacman.initPacmanRight();
          break;
      }
  }
  
  // Mais si pacman se déplace DEJA, on anticipe son prochain virage DES QUE POSSIBLE.
  // Cela sera réglé dans la méthode thePacman.pacmanProgress()
  //
  else switch (theKeyCode){
        case UP:
          thePacman.nextDirection=goingUp;
          break;
        case DOWN:
          thePacman.nextDirection=goingDown;
          break;
        case LEFT:
          thePacman.nextDirection=goingLeft;
          break;
        case RIGHT:
          thePacman.nextDirection=goingRight;
          break;
  }
}