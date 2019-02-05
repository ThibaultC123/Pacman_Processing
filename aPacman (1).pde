// L'objet pacman
// terminer pacman_chomp

class aPacman {
  int mode; // 0 = mourant / 1 = vivant
  int counter; // Compteur pour différentes choses...
  int posX, posY; // position dans map[][]
  int direction; // goingRight, goingLeft, goingUp, goingDown
  int nextDirection; // shallStop pour s'arrêter à la case suivante
  boolean isMoving; // true = pacman bouge / false = pacman immobile
  Sprite itsSprite;

  // Constructeur pour créer une instance et commencer à initialiser ses variables
  //
  aPacman(int aMode, int aPosX, int aPosY, int aDirection, Sprite aSprite){
    mode = aMode;
    posX = aPosX;
    posY = aPosY;
    direction = aDirection;
    isMoving = false;
    itsSprite = aSprite;
  }
  
  void initPacmanDeath(){
     redGhost.itsSprite.setVisible(false);
     blueGhost.itsSprite.setVisible(false);
     pinkGhost.itsSprite.setVisible(false);
     orangeGhost.itsSprite.setVisible(false);
     thePacman.counter=1;
     thePacman.itsSprite.setVelXY(0.0, 0.0);
     thePacman.itsSprite.setFrameSequence(5, 12, 0.2f);
     thePacman.itsSprite.setRot(pacmanRotUp);
     pacman_death.play();
     sequence = isDeath;
  }
  
  void pacmanChomp(int x, int y){
  int timerLocal;
    switch(Map[y][x]){
      case 1 :
        score = score + 10;
        pacman_chomp.play();
        Map[y][x] = 0;
        //
        if (blueGhost.dotCounter>0) { blueGhost.dotCounter--; }
        //
        if (orangeGhost.dotCounter>0) { orangeGhost.dotCounter--; }
        break;
      case 2 :
        score = score + 50;
        pacman_chomp.play();
        Map[y][x] = 0;
        // Les fantômes passent en mode Frightened et les sprites sont modifiés
        // et la direction est inversée (seulement pour ceux qui sont sortis de la maison)
        //
        timerLocal=millis()+frightTable[level-1];
        redGhost.mode=frightenedMode;
        redGhost.itsSprite.setFrameSequence(4, 7, 0.1f);
        if (redGhost.inHouse==false) { redGhost.reverseDirection(); }
        redGhost.timer=timerLocal;
        //
        blueGhost.mode=frightenedMode;
        blueGhost.itsSprite.setFrameSequence(4, 7, 0.1f);
        if (blueGhost.inHouse==false) { blueGhost.reverseDirection(); }
        blueGhost.timer=timerLocal;
        //
        pinkGhost.mode=frightenedMode;
        pinkGhost.itsSprite.setFrameSequence(4, 7, 0.1f);
        if (pinkGhost.inHouse==false) { pinkGhost.reverseDirection(); }
        pinkGhost.timer=timerLocal;
        //
        orangeGhost.mode=frightenedMode;
        orangeGhost.itsSprite.setFrameSequence(4, 7, 0.1f);
        if (orangeGhost.inHouse==false) { orangeGhost.reverseDirection(); }
        orangeGhost.timer=timerLocal;
        break;
      }
  }
  
  // Arrête Pacman quelle que soit la direction dans laquelle il allait
  //
  void stopPacman(){
    isMoving=false;
    nextDirection=shallStop;
    itsSprite.setXY(topLeftSpriteX+(posX-1)*halfSpriteWidth, topLeftSpriteY+(posY-1)*halfSpriteHeight);
    itsSprite.setVelXY(0, 0);
  }
  
  // Les 4 méthodes suivantes vérifient que Pacman (immobile) peut aller dans la direction indiquée
  // et commence son déplacement dans cette direction
  //
  void initPacmanRight(){ // S'il y a un mur à droite, j'ignore la demande
    if (isThereAWall(posX, posY, goingRight)==false){
      isMoving=true;
      direction=goingRight;
      nextDirection=goingRight;
      itsSprite.setRot(pacmanRotRight);
      itsSprite.setVelXY(100.0, 0.0);
      itsSprite.setY(topLeftSpriteY+(posY-1)*halfSpriteHeight);
    }
  }
  
  void initPacmanLeft(){ // S'il y a un mur à gauche, j'ignore la demande
    if (isThereAWall(posX, posY, goingLeft)==false){
      isMoving=true;
      direction=goingLeft;
      nextDirection=goingLeft;
      itsSprite.setRot(pacmanRotLeft);
      itsSprite.setVelXY(-100.0, 0.0);
      itsSprite.setY(topLeftSpriteY+(posY-1)*halfSpriteHeight);
    }
  }
  
  void initPacmanUp(){ // S'il y a un mur en haut, j'ignore la demande
    if (isThereAWall(posX, posY, goingUp)==false){
      isMoving=true;
      direction=goingUp;
      nextDirection=goingUp;
      itsSprite.setRot(pacmanRotUp);
      itsSprite.setVelXY(0.0, -100.0);
      itsSprite.setX(topLeftSpriteX+(posX-1)*halfSpriteWidth);
    }
  }
  
  void initPacmanDown(){ // S'il y a un mur en bas, j'ignore la demande
    if (isThereAWall(posX, posY,goingDown)==false){
      isMoving=true;
      direction=goingDown;
      nextDirection=goingDown;
      itsSprite.setRot(pacmanRotDown);
      itsSprite.setVelXY(0.0, 100.0);
      itsSprite.setX(topLeftSpriteX+(posX-1)*halfSpriteWidth);
    }
  }
  
  // Cette méthode exécute le déplacement de pacman dans la direction donnée OU
  // le fait aller dans la "nextDirection" si possible (sinon continue sur sa lancée... si possible)
  //
  void pacmanProgress(){
  float deltaX, deltaY;
  int centreX, centreY;
  
    // Convertit la position dans le monde du centre de l'objet thePacman
    // en coordonnées dans la labyrinthe (et donc le tableau Map[][])
    //
    deltaX = (float)(((itsSprite.getX()-topLeftSpriteX)/halfSpriteWidth)+1);
    centreX = floor(deltaX); // nombre de cellules
    deltaX = abs(deltaX - centreX); // fraction de cellules
    
    deltaY = (float)(((itsSprite.getY()-topLeftSpriteY)/halfSpriteHeight)+1);
    centreY = floor(deltaY);
    deltaY = abs(deltaY - centreY);
    
    // Si pacman change de case alors vérifier qu'il n'y a pas de pastille
    // ou d'energizer
    //
    if((posX != centreX) || (posY != centreY)){
      posX = centreX;
      posY = centreY;
      pacmanChomp(posX, posY);
    }
    // Sinon pacman s'est déplacé tout en restant dans la même cellule
    // Selon la direction suivie il y aura 2 cas de figure : 
    //   dans la zone de virage possible je vois si je peux tourner
    //   au delà je continue sur ma lancée, sinon je m'arrête
    //
    else switch(direction){
      case goingRight :
        if (deltaX>0.47) // Pacman a dépassé le point de non-retour dans cette direction: STOP si mur et que le joueur voulait quand même continuer
          { if (isThereAWall(centreX, centreY, goingRight)==true)
            { switch(nextDirection) {
                case goingUp:
                    initPacmanUp();
                    break;
                  case goingDown:
                    initPacmanDown();
                    break;
                  case goingLeft:
                    initPacmanLeft();
                    break;
                  case goingRight:
                    stopPacman();
                    break;
              }
            }
          } else if (deltaX>0.30) {
              switch(nextDirection){
                case goingLeft :
                  initPacmanLeft();
                  break;
                case goingUp :
                  initPacmanUp();
                  break;
                case goingDown :
                  initPacmanDown();
                  break;
              }
          }    
        break;
      case goingLeft :
        if (deltaX < 0.53){
            if ((nextDirection==goingLeft) && (isThereAWall(centreX, centreY, goingLeft)==true)) {
              stopPacman();
            }
        } else if (deltaX < 0.70) {
                switch(nextDirection){
                  case goingRight :
                    initPacmanRight();
                    break;
                  case goingUp :
                    initPacmanUp();
                    break;
                  case goingDown :
                    initPacmanDown();
                    break;
                }
              }
        break;
      case goingUp :
          if (deltaY > 0.47){
            if ((nextDirection==goingUp) && (isThereAWall(centreX, centreY, goingUp)==true)) {
              stopPacman();
            } 
          } else if (deltaY > 0.30) {
                switch(nextDirection){
                  case goingLeft :
                    initPacmanLeft();
                    break;
                  case goingRight :
                    initPacmanRight();
                    break;
                  case goingDown :
                    initPacmanDown();
                    break;
                }
              }
        break;
      case goingDown :
          if (deltaY < 0.53){
              if ((nextDirection==goingDown) && (isThereAWall(centreX, centreY, goingDown)==true)) {
                stopPacman();
              }
          } else if (deltaY < 0.70) {
                  switch(nextDirection){
                    case goingRight :
                      initPacmanRight();
                      break;
                    case goingUp :
                      initPacmanUp();
                      break;
                    case goingLeft :
                      initPacmanLeft();
                      break;
                  }
                }
        break;
      }
  }
  
  // Autres méthodes de l'objet
  //
}