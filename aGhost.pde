// L'objet fantôme
//

class aGhost {
  int mode; // 0 = scatter / 1 = chase / 2 = frightenedMode / 3 = blinkMode / 4 = pointsMode / 5 = eyesMode
  int posX, posY; // position dans map[][]
  int direction; // goingRight, goingLeft, goingUp, goingDown
  int nextDirection; // shallStop pour s'arrêter à la case suivante
  boolean inHouse; // TRUE=dans la maison
  int dotCounter; // Compteur de pastilles => sort de la maison quand arrive à 0
  int timer; // Timer pour les points affichés
  boolean isMoving; // true = fantôme bouge / false = fantôme immobile
  Sprite itsSprite;

  // Constructeur pour créer une instance et commencer à initialiser ses variables
  //
  aGhost(int aMode, int aPosX, int aPosY, int aDirection, Sprite aSprite){
    mode = aMode;
    posX = aPosX;
    posY = aPosY;
    direction = aDirection;
    isMoving = false;
    itsSprite = aSprite;
  }

void goBlinkMode(){
  mode=blinkMode;
  itsSprite.setFrameSequence(8, 11, 0.1f);
  timer=millis()+1500;  // 1500 ms en mode "Blink"
}

void goScatterMode(){
  mode=scatterMode;
  itsSprite.setFrameSequence(0, 3, 0.1f);
  if (inHouse==false) { reverseDirection(); }  // Inverse la direction
  timer=0;   // Evite les problèmes...
}

void initPointsMode(){
int index;
  index=16+indexPointsForGhost;
  mode = pointsMode;
  timer= millis()+500; // Restera 500ms avant de passer à EyesMode
  itsSprite.setVelXY(0.0, 0.0);
  itsSprite.setFrameSequence(index, index, 0.1f);
}

void reverseDirection() {
  // Lorsque Pacman a mangé un energizer, les fantômes reculent mais, si impossible
  // choisissent une des directions dans cet ordre: up, left, down, and right
  //
  // On ne passe pas par "nextDirection" parce que le changement de direction est IMMEDIAT.  <------ A CORRIGER !!
  //
  switch(direction){
    case goingLeft:
      if (isThereAWall(posX+1, posY, goingRight)==false){
        direction=goingRight;
      } else {
          if (isThereAWall(posX, posY-1, goingUp)==false) {
            direction=goingUp;
          } else { direction=goingDown; }
        }
    break;
    //
    case goingRight:
      if (isThereAWall(posX-1, posY, goingLeft)==false){
        direction=goingLeft;
      } else {
          if (isThereAWall(posX, posY-1, goingUp)==false){
            direction=goingUp;
          } else { direction=goingDown; }
      }
    break;
    //
    case goingUp:
      if (isThereAWall(posX, posY-1, goingDown)==false){
        direction=goingDown;
      } else { 
          if (isThereAWall(posX-1, posY, goingLeft)==false){
            direction=goingLeft;
          } else { direction=goingRight; }
      }
    break;
    //
    case goingDown:
      if (isThereAWall(posX, posY+1, goingUp)==false){
        direction=goingUp;
      } else {
          if (isThereAWall(posX-1, posY, goingLeft)==false){
            direction=goingLeft;
          } else { direction=goingRight; }
      }
    break;
  }
  switch(direction){
    case goingUp:
      itsSprite.setVelXY(0.0, -ghostVelocity);
    break;
    case goingDown:
      itsSprite.setVelXY(0.0, ghostVelocity);
    break;
    case goingLeft:
      itsSprite.setVelXY(-ghostVelocity, 0.0);
    break;
    case goingRight:
      itsSprite.setVelXY(ghostVelocity, 0.0);
    break;
  }
}

void ghostWanders(){
  int centreX, centreY, auHasard;
  float deltaX, deltaY;
  // Convertit la position dans le monde du centre de l'objet thePacman
  // en coordonnées dans la labyrinthe (et donc le tableau Map[][])
  //
  deltaX = (float)(((itsSprite.getX()-topLeftSpriteX)/halfSpriteWidth)+1);
  centreX = floor(deltaX); // nombre de cellules
  deltaX = abs(deltaX - centreX); // fraction de cellules
  //
  deltaY = (float)(((itsSprite.getY()-topLeftSpriteY)/halfSpriteHeight)+1);
  centreY = floor(deltaY);
  deltaY = abs(deltaY - centreY);
  // Si le fantôme change de case et qu'il y aura un mur à la case suivante
  // il faut tirer au sort A L'AVANCE la direction à suivre quand le moment viendra,
  // c'est-à-dire quand il arrivera à proximité du milieu de case.
  //
  if ((posX != centreX) || (posY != centreY)){
    posX = centreX;
    posY = centreY;
    if (isThereAWall(posX, posY, direction)==true) {
      auHasard = floor(1+random(4));    // Si le fantôme doit changer de direction, sinon il poursuit
      //
      switch(auHasard){
        case goingLeft:
          if (isThereAWall(posX-1, posY, goingLeft)==false) { nextDirection=goingLeft; }
            else if (isThereAWall(posX, posY-1, goingUp)==false) { nextDirection=goingUp; }
              else if (isThereAWall(posX, posY+1, goingDown)==false) { nextDirection=goingDown; }
                else { nextDirection=goingRight; }
        break;
        //
        case goingRight:
          if (isThereAWall(posX+1, posY, goingRight)==false){ nextDirection=goingRight; } 
            else if (isThereAWall(posX, posY-1, goingUp)==false) { nextDirection=goingUp; } 
              else if (isThereAWall(posX-1, posY, goingLeft)==false){ nextDirection=goingLeft; }
                else { nextDirection=goingDown; }
        break;
        //
        case goingUp:
          if (isThereAWall(posX, posY-1, goingUp)==false){ nextDirection=goingUp; } 
            else if (isThereAWall(posX-1, posY, goingLeft)==false) { nextDirection=goingLeft; } 
              else if (isThereAWall(posX, posY+1, goingDown)==false){ nextDirection=goingDown; }
                else { nextDirection=goingRight; }
        break;
        //
        case goingDown:
          if (isThereAWall(posX, posY+1, goingDown)==false) { nextDirection=goingDown; } 
            else if (isThereAWall(posX, posY-1, goingUp)==false){ nextDirection=goingUp; }
              else if (isThereAWall(posX-1, posY, goingLeft)==false) { nextDirection=goingLeft; }
                else { nextDirection=goingRight; }
        break;
        }
      }
    }
    // En progressant sur la même case, le fantôme arrive-t-il dans la zone de virage possible?
    else {
      deltaX=abs(deltaX-0.50);
      deltaY=abs(deltaY-0.50);
      if ((deltaX<.10) && ((direction==goingLeft) || (direction==goingRight))
        || ((deltaY<.10) && ((direction==goingUp) || (direction==goingDown)))) {
          switch(nextDirection){
           case goingUp:
             itsSprite.setVelXY(0.0, -ghostVelocity);
             itsSprite.setX(topLeftSpriteX+halfSpriteWidth*(posX-1));
             direction=goingUp; // A priori, il garderait la même direction pour le coup suivant
             break;
           case goingDown:
             itsSprite.setVelXY(0.0, ghostVelocity);
             itsSprite.setX(topLeftSpriteX+halfSpriteWidth*(posX-1));
             direction=goingDown;
             break;
           case goingLeft:
             itsSprite.setVelXY(-ghostVelocity, 0.0);
             itsSprite.setY(topLeftSpriteY+halfSpriteHeight*(posY-1));
             direction=goingLeft;
             break;
           case goingRight:
             itsSprite.setVelXY(ghostVelocity, 0.0);
             itsSprite.setY(topLeftSpriteY+halfSpriteHeight*(posY-1));
             direction=goingRight;
             break;
          }
        }
    }
}

void ghostScatters(int targetX, int targetY){
  float deltaX, deltaY;
  int centreX, centreY;
  
    // Convertit la position dans le monde du centre de l'objet thePacman
    // en coordonnées dans la labyrinthe (et donc le tableau Map[][])
    //
    deltaX = (float)(((itsSprite.getX()-topLeftSpriteX)/halfSpriteWidth)+1);
    centreX = floor(deltaX); // nombre de cellules
    deltaX = abs(deltaX - centreX); // fraction de cellules
    //
    deltaY = (float)(((itsSprite.getY()-topLeftSpriteY)/halfSpriteHeight)+1);
    centreY = floor(deltaY);
    deltaY = abs(deltaY - centreY);

    // Si le fantôme change de case, il faut calculer A L'AVANCE la direction
    // à suivre quand le moment viendra, c'est-à-dire quand il arrivera à
    // proximité du milieu de case.
    //
    if ((posX != centreX) || (posY != centreY)){
      posX = centreX;
      posY = centreY;
      nextDirection = isItIntersection(posX, posY, targetX, targetY, direction);
    }
    else {
      deltaX=abs(deltaX-0.50);
      deltaY=abs(deltaY-0.50);
      if ((deltaX<.10) && ((direction==goingLeft) || (direction==goingRight))
        || ((deltaY<.10) && ((direction==goingUp) || (direction==goingDown)))) {
        switch(nextDirection){
         case goingUp:
           itsSprite.setVelXY(0.0, -ghostVelocity);
           itsSprite.setX(topLeftSpriteX+halfSpriteWidth*(posX-1));
           direction=goingUp;
           break;
         case goingDown:
           itsSprite.setVelXY(0.0, ghostVelocity);
           itsSprite.setX(topLeftSpriteX+halfSpriteWidth*(posX-1));
           direction=goingDown;
           break;
         case goingLeft:
           itsSprite.setVelXY(-ghostVelocity, 0.0);
           itsSprite.setY(topLeftSpriteY+halfSpriteHeight*(posY-1));
           direction=goingLeft;
           break;
         case goingRight:
           itsSprite.setVelXY(ghostVelocity, 0.0);
           itsSprite.setY(topLeftSpriteY+halfSpriteHeight*(posY-1));
           direction=goingRight;
           break;
        }
      }
    }
  }

int isItIntersection(int posX, int posY, int targetX, int targetY, int direction){
int nextDirection;
  nextDirection = direction; // par défaut, on continue sur la lancée
  calculDistances(posX, posY, targetX, targetY, direction); // calcule les distances dans les 4 directions à partir de la future case selon "direction"
 
  // déterminer la direction la plus courte avec règle de priorité en cas d'égalité : up, left, down, right
  switch(direction){
    //
    case goingLeft : // direction à droite interdite donc comparer up, left, down
      // 1er cas: U==L
      if (distanceUp==distanceLeft) {
        if (distanceDown<distanceUp) { nextDirection=goingDown;} // D < (U=L)
          else { nextDirection=goingUp; } // D>=(U=L), priorité à Up
        break;
      }
      // 2eme cas: U==D
      if (distanceUp==distanceDown) {
        if (distanceLeft<distanceUp) { nextDirection=goingLeft; } // L < (U==D)
          else { nextDirection=goingUp; }
        break;
      }
      // 3ème cas: L==D
      if (distanceLeft==distanceDown) {
        if (distanceUp<=distanceLeft) { nextDirection=goingUp; } // U <= (L==D)
          else { nextDirection=goingLeft; }
        break;
      }
      // Aucune égalité entre les trois directions, donc il faut commencer par les classer
      if (distanceUp<distanceLeft){
        if (distanceDown<distanceUp) { nextDirection=goingDown; }
          else { nextDirection=goingUp; }
        break;
      }
      if (distanceLeft<distanceDown){
        if (distanceUp<=distanceLeft) { nextDirection=goingUp; }
          else { nextDirection=goingLeft; }
        break;
      }
      if (distanceLeft<distanceDown) { nextDirection=goingLeft; }
        else { nextDirection=goingDown; } // U>L et L>D, donc D gagne
      break;
    //
    case goingRight: // direction à gauche interdite donc comparer up, down, right
      // 1er cas : U==D
      if(distanceUp==distanceDown){
        if(distanceRight < distanceUp) { nextDirection = goingRight; } // R < (U=D)
          else { nextDirection = goingUp; }
        break;
      }
      // 2eme cas : D==R
      if(distanceDown==distanceRight){
        if(distanceUp<=distanceDown) { nextDirection = goingUp; } // U <= (D=R)
          else { nextDirection = goingDown; }
        break;
      }
      // 3eme cas : U==R
      if(distanceUp==distanceRight){
        if(distanceDown<distanceUp) { nextDirection = goingDown; } // D < (U=R)
          else { nextDirection = goingUp; }
        break;
      }
      // 4eme cas : pas d'égalité donc comparer les trois directions
      if(distanceUp<distanceDown){
        if(distanceRight<distanceUp) { nextDirection = goingRight; }
          else { nextDirection = goingUp; }
        break;
      }
      if(distanceDown<distanceRight){
        if(distanceUp<=distanceDown) { nextDirection = goingUp; }
          else { nextDirection = goingDown; }
        break;
      }
      if(distanceUp<distanceRight) { nextDirection = goingUp; }
        else { nextDirection = goingRight; }
      break;
    //
    case goingUp : // direction en bas interdite donc comparer up, left, right
      // 1er cas : U==L
      if(distanceUp==distanceLeft){
        if(distanceRight<distanceUp){ nextDirection = goingRight; } // R < (U=L)
          else { nextDirection = goingUp; }
        break;
      }
      // 2eme cas : L==R
      if(distanceLeft==distanceRight){
        if(distanceUp<=distanceLeft) { nextDirection = goingUp; }
          else { nextDirection = goingLeft; }
        break;
      }
      // 3eme cas : U==R
      if(distanceUp==distanceRight){
        if(distanceLeft<distanceUp) { nextDirection = goingLeft; }
          else { nextDirection = goingUp; }
        break;
      }
      // 4eme cas : aucune égalité, il faut les classer
      if(distanceUp<distanceLeft){
        if(distanceRight<distanceUp) { nextDirection = goingRight; }
          else { nextDirection = goingUp; }
        break;
      }
      if(distanceLeft<distanceRight){
        if(distanceUp<=distanceLeft) { nextDirection = goingUp; }
          else { nextDirection = goingLeft; }
        break;
      }
      if(distanceUp<distanceRight){ nextDirection = goingUp; }
        else { nextDirection = goingRight; }
      break;
    //
    case goingDown : // direction en haut interdite donc comparer left, down, right
      if(distanceLeft==distanceDown){
        if(distanceRight<distanceLeft) { nextDirection = goingRight; }
          else { nextDirection = goingLeft; }
        break;
      }
      if(distanceDown==distanceRight){
        if(distanceLeft<distanceDown) { nextDirection = goingLeft; }
          else { nextDirection = goingDown; }
        break;
      }
      if(distanceLeft==distanceRight){
        if(distanceDown<distanceLeft) { nextDirection = goingDown; }
          else { nextDirection = goingLeft; }
        break;
      }
      if(distanceLeft<distanceDown){
        if(distanceRight<distanceLeft) { nextDirection = goingRight; }
          else { nextDirection = goingLeft; }
        break;
      }
      if(distanceDown<distanceRight){
        if(distanceLeft<distanceDown) { nextDirection = goingLeft; }
          else { nextDirection = goingDown; }
        break;
      }
      if(distanceLeft<distanceRight) { nextDirection = goingLeft; }
        else { nextDirection = goingRight; }
      break;
     } // switch !!
  return nextDirection;
  }

void calculDistances(int posX, int posY, int targetX, int targetY, int direction){ 
// calcul distances dans toutes les directions
// 2 conditions pour interdire le déplacement -> mur ou reculer
// je ne peux pas aller vers la gauche si mur à gauche ou si j'étais en train d'aller vers la droite

  if ((direction == goingRight) || (isThereAWall(posX, posY, goingLeft)==true)){ 
     distanceLeft = distanceEnorme; 
  }
  else distanceLeft = abs(posY-targetY) + abs(posX-1-targetX);
  
  if((direction==goingLeft)  || (isThereAWall(posX, posY, goingRight)==true)){
    distanceRight = distanceEnorme;
    }
  else distanceRight = abs(posY-targetY) + abs(posX+1-targetX);
 
  if ((direction==goingUp)    || (isThereAWall(posX, posY, goingDown)==true)){
    //print("X=",posX," & Y=",posY," ----- Tab[y+1][x]=",Map[posY+1][posX]);
    distanceDown = distanceEnorme;
    }
  else {
      distanceDown = abs(posY+1-targetY) + abs(posX-targetX);
  }
  
  if((direction==goingDown) || (isThereAWall(posX, posY, goingUp)==true)){
    distanceUp = distanceEnorme;
    }
  else {
    distanceUp = abs(posY-1-targetY) + abs(posX-targetX);
    }
  }
  
} // end of class