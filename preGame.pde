// Dans la séquence GAME: déplacer pacman et les fantômes, puis détecter les collisions
//
void preGame(){
int chaseX, chaseY, distance;
  
  // Si pacman est en déplacement, alors mettre à jour sa nouvelle position
  //
  if (thePacman.isMoving==true) { thePacman.pacmanProgress(); }
  
  // Changer de phase de jeu (Scatter/Chase/Scatter/Chase)
  //
  if (millis()>time){
    time=millis();
    if (indexDePhaseDeJeu<7) {
      indexDePhaseDeJeu++;
      if (indexDePhaseDeJeu==7) { allGhostsGo(chaseMode);
                                  time=millis()+360000; // 1 heure = infini
                                }
        else { time=millis()+phaseDeJeu[indexDePhaseDeJeu]; }
               if (indexDePhaseDeJeu%2==0) { allGhostsGo(scatterMode); } else allGhostsGo(chaseMode);
    }
  }
  
  // ---> Animer le fantôme ROUGE
  //
  switch (redGhost.mode){
    case frightenedMode:
      if (redGhost.inHouse==false) { redGhost.ghostWanders(); }
      if (millis()>redGhost.timer) { redGhost.goBlinkMode(); }
      break;
    case blinkMode:
      if (millis()>redGhost.timer) { redGhost.goScatterMode(); }
      break;
    case scatterMode:
      redGhost.ghostScatters(25, -3);  // Vise en haut à droite du labyrinthe
      break;
    case chaseMode:
      redGhost.ghostScatters(thePacman.posX, thePacman.posY);
      break;
    case pointsMode:
      if (millis()>redGhost.timer){
        redGhost.mode=eyesMode;
        redGhost.itsSprite.setFrameSequence(12, 15, 0.1f);
      }
    case eyesMode:
      redGhost.ghostScatters(13, 14); // File à la maison !!
      break;
  }
  
  // ---> Animer le fantôme ROSE
  //
  switch (pinkGhost.mode){
    case frightenedMode:
      if (pinkGhost.inHouse==false) { pinkGhost.ghostWanders(); }
      if (millis()>pinkGhost.timer) { pinkGhost.goBlinkMode(); }
      break;
    case blinkMode:
      if (millis()>pinkGhost.timer) { pinkGhost.goScatterMode(); }
      break;
    case scatterMode:
      if (pinkGhost.inHouse==false) { pinkGhost.ghostScatters(2, -3); }  // Vise le coin H,G
        else if (pinkGhost.dotCounter==0) { // Il est à 0 par défaut, pour une sortie immédiate
          pinkGhost.itsSprite.setX(topLeftSpriteX+12.5*halfSpriteWidth);
          pinkGhost.posX=13;                  // Pour plus tard...
          if (pinkGhost.itsSprite.getY()>(topLeftSpriteY+10*halfSpriteHeight)) { pinkGhost.itsSprite.setVelXY(0.0, -100.0); }
            else { pinkGhost.inHouse=false;
                   pinkGhost.posY=11;           // Pour plus tard...
                   pinkGhost.itsSprite.setY(topLeftSpriteY+10*halfSpriteHeight);
                   pinkGhost.itsSprite.setVelXY(-100.0, 0.0); // Va à gauche en sortant de la maison...
                   pinkGhost.direction=goingLeft;
                   pinkGhost.nextDirection=goingLeft;
                 }
        }
      break;
    case chaseMode:  // Vise 4 cases en avant de Pacman dans la direction qu'il suit
      chaseX=thePacman.posX;
      chaseY=thePacman.posY;
      switch (thePacman.direction) {
        case goingRight:
          chaseX=chaseX+4;
          if (chaseX>mazeWidth) { chaseX=mazeWidth; }
          break;
        case goingLeft:
          chaseX=chaseX-4;
          if (chaseX<1) { chaseX=1; }
          break;
        case goingUp:
          chaseY=chaseY-4;
          if (chaseY<1) { chaseY=1; }
          break;
        case goingDown:
          chaseY=chaseY+4;
          if (chaseY>mazeHeight) { chaseY=mazeHeight; }
          break;
      }
      pinkGhost.ghostScatters(thePacman.posX, thePacman.posY);
      break;
  }
  
  // ---> Animer le fantôme BLEU
  // (il sort de la maison lorsque son dotCounter est nul, cf. pacmanChomp)
  //
  switch (blueGhost.mode){
    case frightenedMode:
      if (blueGhost.inHouse==false) { blueGhost.ghostWanders(); }
      if (millis()>blueGhost.timer) { blueGhost.goBlinkMode(); }
      break;
    case blinkMode:
      if (millis()>blueGhost.timer) { blueGhost.goScatterMode(); }
      break;
    case scatterMode:
      if (blueGhost.inHouse==false) { blueGhost.ghostScatters(27, 33); } // Vise le coin B,D
        else if (blueGhost.dotCounter==0) { // Je dois sortir de là MAINTENANT !
        if (blueGhost.itsSprite.getX()<(topLeftSpriteX+12.5*halfSpriteWidth)) { // Démarre à OffsetX+37+10.5*halfSpriteWidth=622.5
          blueGhost.itsSprite.setVelXY(100.0, 0.0);
        } else { blueGhost.itsSprite.setX(topLeftSpriteX+12.5*halfSpriteWidth);
                 blueGhost.posX=13;                  // Pour plus tard...
                 if (blueGhost.itsSprite.getY()>(topLeftSpriteY+10*halfSpriteHeight)) {
                   blueGhost.itsSprite.setVelXY(0.0, -100.0);
               } else { blueGhost.inHouse=false;
                        blueGhost.posY=11;           // Pour plus tard...
                        blueGhost.itsSprite.setY(topLeftSpriteY+10*halfSpriteHeight);
                        blueGhost.itsSprite.setVelXY(100.0, 0.0); // Le lancer vers la droite
                        blueGhost.direction=goingRight;
                        blueGhost.nextDirection=goingRight;
                 }
        }
      }
      break;
    case chaseMode:
      chaseX=thePacman.posX;
      chaseY=thePacman.posY;
      switch (thePacman.direction){
        case goingUp:
          chaseY=chaseY-2;
        break;
        case goingDown:
          chaseY=chaseY+2;
        break;
        case goingLeft:
          chaseX=chaseX-2;
        break;
        case goingRight:
          chaseX=chaseX+2;
        break;
      }
      if (redGhost.posX<chaseX) { chaseX=2*abs(redGhost.posX-chaseX); }
        else { chaseX=-2*abs(redGhost.posX-chaseX); }
      if (redGhost.posY<chaseY) { chaseX=2*abs(redGhost.posY-chaseY); }
        else { chaseY=-2*abs(redGhost.posX-chaseX); }
      blueGhost.ghostScatters(redGhost.posX+chaseX, redGhost.posY+chaseY);
      break;
  }
  
  // ---> Animer le fantôme ORANGE
  // (il sort de la maison lorsque son dotCounter est nul, cf. pacmanChomp)
  //
  switch (orangeGhost.mode){
    case frightenedMode:
      if (orangeGhost.inHouse==false) { orangeGhost.ghostWanders(); }
      if (millis()>orangeGhost.timer) { orangeGhost.goBlinkMode(); }
      break;
    case blinkMode:
      if (millis()>orangeGhost.timer) { orangeGhost.goScatterMode(); }
      break;
    case scatterMode:
      if (orangeGhost.inHouse==false) { orangeGhost.ghostScatters(0, 33); } // Vise le coin B,G
      else if (orangeGhost.dotCounter==0) { // Je dois sortir de là
        if (orangeGhost.itsSprite.getX()>(topLeftSpriteX+12.5*halfSpriteWidth)) { orangeGhost.itsSprite.setVelXY(-100.0, 0.0); }
          else { orangeGhost.itsSprite.setX(topLeftSpriteX+12.5*halfSpriteWidth);
                 orangeGhost.posX=12;                  // Pour plus tard...
                 if (orangeGhost.itsSprite.getY()>(topLeftSpriteY+10*halfSpriteHeight)) {
                   orangeGhost.itsSprite.setVelXY(0.0, -100.0);
               } else { orangeGhost.inHouse=false;
                        orangeGhost.posY=10;           // Pour plus tard...
                        orangeGhost.itsSprite.setY(topLeftSpriteY+10*halfSpriteHeight);
                        orangeGhost.itsSprite.setVelXY(100.0, 0.0); // Le lancer vers la gauche
                        orangeGhost.direction=goingRight;
                        orangeGhost.nextDirection=goingRight;
                 }
        }
      }
      break;
    case chaseMode:
      distance=abs(thePacman.posX-orangeGhost.posX)+abs(thePacman.posY-orangeGhost.posY);
      if (distance>8) {
        orangeGhost.ghostScatters(thePacman.posX, thePacman.posY);
      } else { orangeGhost.ghostScatters(0, 33); }
      break;
  }
  
  // analyse les éventuelles collisions :
  //      - en mode scatterMode et chaseMode, pacman meurt
  //      - en mode frightenned le fantôme meurt
  //      - dans les autres modes, on ignore
  //
  if (thePacman.itsSprite.oo_collision(redGhost.itsSprite, 80.0)) { // Au moins 80% de recouvrement entre un fantôme et Pacman
    if ((redGhost.mode == chaseMode) || (redGhost.mode == scatterMode)) { //<>//
     thePacman.initPacmanDeath(); // Passer dans la séquence pacmanDeath après avoir initialisé les variables et jouer la musique
    } else if ((redGhost.mode == frightenedMode) || (redGhost.mode==blinkMode)) {
      redGhost.initPointsMode();
      ghostEaten();
    }  
  }
  //
  if (thePacman.itsSprite.oo_collision(blueGhost.itsSprite, 80.0)) { // Au moins 80% de recouvrement entre un fantôme et Pacman
     if ((blueGhost.mode == chaseMode) || (blueGhost.mode == scatterMode)) {// Passer dans la séquence pacmanDeath après avoir initialisé les variables et jouer la musique //<>//
       thePacman.initPacmanDeath(); // Passer dans la séquence pacmanDeath après avoir initialisé les variables et jouer la musique
     } else if ((blueGhost.mode == frightenedMode) || (blueGhost.mode==blinkMode)){ //<>//
          blueGhost.initPointsMode();
          ghostEaten();
     }
  }
  //
  if (thePacman.itsSprite.oo_collision(pinkGhost.itsSprite, 80.0)) { // Au moins 80% de recouvrement entre un fantôme et Pacman
     if ((pinkGhost.mode == chaseMode) || (pinkGhost.mode == scatterMode)) {// Passer dans la séquence pacmanDeath après avoir initialisé les variables et jouer la musique //<>//
       thePacman.initPacmanDeath(); // Passer dans la séquence pacmanDeath après avoir initialisé les variables et jouer la musique
     } else if ((pinkGhost.mode == frightenedMode) || (pinkGhost.mode==blinkMode)){
          pinkGhost.initPointsMode();
          ghostEaten();
     }
  }
  //
  if (thePacman.itsSprite.oo_collision(orangeGhost.itsSprite, 80.0)) { // Au moins 80% de recouvrement entre un fantôme et Pacman
     if ((orangeGhost.mode == chaseMode) || (orangeGhost.mode == scatterMode)) {// Passer dans la séquence pacmanDeath après avoir initialisé les variables et jouer la musique //<>//
       thePacman.initPacmanDeath(); // Passer dans la séquence pacmanDeath après avoir initialisé les variables et jouer la musique
     } else if ((orangeGhost.mode == frightenedMode) || (orangeGhost.mode==blinkMode)){
          orangeGhost.initPointsMode();
          ghostEaten();
  }
  }
}