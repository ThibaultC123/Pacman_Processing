void drawDeath(){
  drawBoard();
  if (thePacman.counter==0) {
    // Diminuer le nombre de vie, rendre visibles les fantômes, initialiser les sprites
    numberOfPacmanLeft--;
    if (numberOfPacmanLeft<0) {
      sequence=isGameOver;
      thePacman.itsSprite.setVisible(false);
      redGhost.itsSprite.setVisible(false);
      blueGhost.itsSprite.setVisible(false);
      pinkGhost.itsSprite.setVisible(false);
      orangeGhost.itsSprite.setVisible(false);
      time=millis();  // Instant de démarrage de la séquence "Game Over" (durera 2 secondes)
    } else {
        // Pause de 1000 ms avant de passer dans la séquence START et d'initialiser
        // les objets Pacman et les 4 fantômes
        //
        delay(500);
        sequence=isStart;
        time = millis(); // Instant de démarrage de la séquence "Start Game"
        initGame();
    }
  }
  // Avant de partir, appel pour dessiner tous les sprites (seul Pacman est visible)
  //
  S4P.drawSprites();
 }