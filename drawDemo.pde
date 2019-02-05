// Animation de la séquence DEMONSTRATION
//
// *** reste à faire l'animation des points gagnés en mangeant un fantôme
//
void initDemo(){
  // Positionne les 4 fantômes à la poursuite de Pacman
  //
  thePacman.itsSprite.setXY(860, 450);
  thePacman.itsSprite.setVelXY(-100, 0);
  thePacman.itsSprite.setFrameSequence(0, 3, 0.1f);
  thePacman.itsSprite.setRot(pacmanRotLeft);
  //
  redGhost.itsSprite.setXY(950, 450);
  redGhost.itsSprite.setVelXY(-105, 0);
  redGhost.itsSprite.setFrameSequence(0, 3, 0.1f);
  //
  blueGhost.itsSprite.setXY(1000, 450);
  blueGhost.itsSprite.setVelXY(-105, 0);
  blueGhost.itsSprite.setFrameSequence(0, 3, 0.1f);
  //
  pinkGhost.itsSprite.setXY(1050, 450);
  pinkGhost.itsSprite.setVelXY(-105, 0);
  pinkGhost.itsSprite.setFrameSequence(0, 3, 0.1f);
  //
  orangeGhost.itsSprite.setXY(1100, 450);
  orangeGhost.itsSprite.setVelXY(-105, 0);
  orangeGhost.itsSprite.setFrameSequence(0, 3, 0.1f);
}

void preDemo(){
  if (thePacman.itsSprite.oo_collision(redGhost.itsSprite, 50.0)) { // Au moins 50% de recouvrement entre un fantôme et Pacman
    if (redGhost.mode == frightenedMode){
      redGhost.mode=pointsMode;
      redGhost.itsSprite.setFrameSequence(16, 16, 0.1f);
      pacman_eatghost.play();
    }
  }
  if (thePacman.itsSprite.oo_collision(blueGhost.itsSprite, 50.0)) { // Au moins 50% de recouvrement entre un fantôme et Pacman
    if (blueGhost.mode == frightenedMode){
      blueGhost.mode = pointsMode;
      blueGhost.itsSprite.setFrameSequence(17, 17, 0.1f);
      pacman_eatghost.play();
    }
  }
  if (thePacman.itsSprite.oo_collision(pinkGhost.itsSprite, 50.0)) { // Au moins 50% de recouvrement entre un fantôme et Pacman
    if (pinkGhost.mode == frightenedMode){
      pinkGhost.mode = pointsMode;
      pinkGhost.itsSprite.setFrameSequence(18, 18, 0.1f);
      pacman_eatghost.play();
    }
  }
  if (thePacman.itsSprite.oo_collision(orangeGhost.itsSprite, 50.0)) { // Au moins 50% de recouvrement entre un fantôme et Pacman
    if (orangeGhost.mode == frightenedMode){
      orangeGhost.mode = pointsMode;
      orangeGhost.itsSprite.setFrameSequence(19, 19, 0.1f);
      pacman_eatghost.play();
    }
  }
}

void keyDemo(int theKey){
  if (theKey==' '){
    exitDemoSequence();
  }
}

void exitDemoSequence()
{ // Pause de 1000 ms avant de passer dans la séquence START et d'initialiser
  // les objets Pacman et les 4 fantômes
  //
  delay(1000);
  sequence=isStart;
  time = millis(); // temps écoulé depuis le lancement du programme
  indexPointsForGhost=0;
  initGame();
}

void drawDemo(){
  // Dessine tout le décor de la démo
  //
  background(0,0,0);
  imageMode(CORNER);
  image(titleImg, (largeurEcran/2)-200, 10);
  textFont(pacmanFont);
  fill(255,255,255);
  text("CHARACTER   /   NICKNAME", 460, 150);
  fill(255,0,0);
  text("SHADOW", 480, 200);
  text("'BLINKY'", 725, 200);
  fill(255,102,255);
  text("SPEEDY", 480, 250);
  text("'PINKY'", 725, 250);
  fill(51,204,255);
  text("BASHFUL", 480, 300);
  text("'INKY'", 725, 300);
  fill(255,102,0);
  text("POKEY", 480, 350);
  text("'CLYDE'", 725, 350);
  image(dotImg, 630, 600);
  image(energizerImg, 630, 650);
  fill(255,255,255);
  text("10 PTS", 670, 620);
  text("50 PTS", 670, 675);
  // Lorsque Pacman atteint l'energizer, les directions s'inversent
  // et les fantômes deviennent vulnérables
  //
  if (thePacman.itsSprite.getX()<400) {
    thePacman.itsSprite.setVelXY(100, 0);
    thePacman.itsSprite.setRot(pacmanRotRight);
    //
    redGhost.itsSprite.setVelXY(60, 0);
    redGhost.itsSprite.setFrameSequence(4, 7, 0.1f);
    redGhost.mode=frightenedMode;
    blueGhost.itsSprite.setVelXY(60, 0);
    blueGhost.itsSprite.setFrameSequence(4, 7, 0.1f);
    blueGhost.mode=frightenedMode;
    pinkGhost.itsSprite.setVelXY(60, 0);
    pinkGhost.itsSprite.setFrameSequence(4, 7, 0.1f);
    pinkGhost.mode=frightenedMode;
    orangeGhost.itsSprite.setVelXY(60, 0);
    orangeGhost.itsSprite.setFrameSequence(4, 7, 0.1f);
    orangeGhost.mode=frightenedMode;
    //
    pacman_chomp.play();
    //
  } else if (thePacman.itsSprite.getRot()==pacmanRotLeft) { image(energizerImg, 400, 440); }
  // L'animation s'arrête quand Pacman est arrivé loin à droite
  //
  if (thePacman.itsSprite.getX()>1040.0) { exitDemoSequence(); }
  // Anime les sprites
  //
  S4P.drawSprites();
 }