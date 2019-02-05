void drawStart(){
 
 // Dessine le labyrinthe et le message "READY!"
 drawBoard();
 
 image(readyImg, 595, 415);
 if(millis() > (time+4000)){
   sequence = isGame; // au bout de 4s, la séquence passe de start a game
   indexDePhaseDeJeu=0;
   time=millis()+phaseDeJeu[0];   // Première phase Scatter durera 7 secondes
   ghostVelocity=100.0;
   // Le fantôme rouge démarre immédiatement ("dotCounter" inutile)
   redGhost.direction=goingLeft;
   redGhost.nextDirection=goingLeft;
   redGhost.isMoving=true;
   redGhost.itsSprite.setVelXY(-ghostVelocity, 0.0);
   redGhost.inHouse=false;
   redGhost.mode=scatterMode;
   //
   pinkGhost.direction=goingUp;
   pinkGhost.nextDirection=goingUp;
   pinkGhost.isMoving=true;
   pinkGhost.itsSprite.setVelXY(0.0, -ghostVelocity);
   pinkGhost.dotCounter=0;  // Sortie immédiate dès le début de la partie
   pinkGhost.inHouse=true;
   pinkGhost.mode=scatterMode;
   // Le fantôme bleu sortira après 30 pastilles mangées
   blueGhost.direction=goingRight;
   blueGhost.nextDirection=goingRight;
   blueGhost.isMoving=false;
   blueGhost.itsSprite.setVelXY(0.0, 0.0);
   blueGhost.dotCounter=30;
   blueGhost.inHouse=true;
   blueGhost.mode=scatterMode;
   // Le fantôme orange sortira après 60 pastilles supplémentaires mangées
   orangeGhost.direction=goingLeft;
   orangeGhost.nextDirection=goingLeft;
   orangeGhost.isMoving=false;
   orangeGhost.itsSprite.setVelXY(0.0, 0.0);
   orangeGhost.dotCounter=90;
   orangeGhost.inHouse=true;
   orangeGhost.mode=scatterMode;
 }
   
 // Anime les sprites
 //
 S4P.drawSprites();
 }