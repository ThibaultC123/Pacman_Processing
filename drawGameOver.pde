void preGameOver(){
  
}

void drawGameOver(){ 
  drawBoard();
  // Afficher "Game Over" pendant 2 secondes puis repartir sur la Démo
  //
  image(gameOverImg, 595, 415);
  if(millis() > (time+2000)){
    sequence=isDemo;
  }
  
  // Avant de partir, appel pour dessiner tous les sprites
  //
  S4P.drawSprites();
}