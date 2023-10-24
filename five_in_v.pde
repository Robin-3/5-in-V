import java.util.Stack;

final int BOARD_SIZE = 3;

int iSize = BOARD_SIZE * 2 - 1;
float h;
float w;
int minSize;
boolean isClicked = false;
boolean existEmptyCell = true;

Board board = new Board();
Cell winner = null;

void setup() {
  size(640, 360, P2D);
  surface.setResizable(true);
  surface.setTitle("5 in V");
  textAlign(CENTER, CENTER);
  textSize(28);
}

void draw() {
  minSize = min(width, height);
  h = minSize/(iSize+.0);
  w = minSize/(iSize+.0);
  background(0);
  stroke(255);
  
  existEmptyCell = !board.isFull();

  for(int i = 0; i < board.cells.length; i++) {
    int offsetW = BOARD_SIZE-1-i;
    float y = h*(0.5*(2-sqrt(3))*offsetW + i + 0.5);
    for(int j = 0; j < board.cells[i].length; j++) {
      noFill();
      float x = w*(abs(offsetW)/2.0 + j + 0.5);
      int edges = 6;
      Move move = new Move(i, j);
      
      float collisionHeight = h*sin(PI/3.0);
      float yy = h*(0.5*(2-sqrt(3))*offsetW + i);
      float xx = w*(abs(offsetW)/2.0 + j);
      boolean boardTileRow = mouseY >= yy+(h-collisionHeight)/2 && mouseY < yy+(h+collisionHeight)/2;
      boolean boardTileCol = mouseX >= xx && mouseX < xx+w;
      if(boardTileRow && boardTileCol && existEmptyCell && winner == null) {
        fill(0, 0, 255, 255/edges);
        if(isClicked) {
          board.play(move);
          winner = board.getWinner();
        }
      }
      
      if(winner != null)
        if(board.appearsInWinningLine(move))
          fill(255, 255, 0, 255/edges);
      
      beginShape();
      for (int k = 0; k < edges; k++) {
        float theta = PI*(4.0*k+edges)/(2.0*edges);
        float xVertex = w*sqrt(3)*cos(theta)/3.0+x;
        float yVertex = h*sqrt(3)*sin(theta)/3.0+y;
        vertex(xVertex, yVertex);
      }
      endShape(CLOSE);
      fill(255);
      
      Cell actual = board.cells[i][j];
      if(actual != Cell.EMPTY)
        text(actual.toString(), x, y);
    }
  }
  
  if(width != height) {
    PGraphics pg = minSize == width?
                   createGraphics(width, height-minSize):
                   createGraphics(width-minSize, height);
    pg.beginDraw();
    pg.background(255);
    pg.textSize(24);
    pg.stroke(0);
    pg.fill(0);
    
    String messages = board.getHistory();
    
    if(!existEmptyCell || winner != null) {
      if(winner != null)
        messages += "\n\nWinner: "+winner.toString();
      else
        messages += "\n\nDraw";
      messages += "\n\nLeft click to restart\nRight click to undo\n";
    }
    
    pg.textAlign(CENTER, BOTTOM);
    pg.text(messages, pg.width/2, pg.height);
    pg.endDraw();
    
    if(minSize == width)
      image(pg, 0, minSize);
    else
      image(pg, minSize, 0);
  }
  
  isClicked = false;
}

void mousePressed() {
  if(mouseButton == LEFT) {
    if(winner == null)
      isClicked = true;
    
    if(!existEmptyCell || winner != null) {
      board = new Board();
      winner = null;
      existEmptyCell = true;
    }
  } else if(mouseButton == RIGHT) {
    board.undo();
    winner = null;
    existEmptyCell = true;
  }
}
