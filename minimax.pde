/**
 * Evalúa la puntuación de una línea específica en el tablero para un jugador dado.
 *
 * @param board  El tablero de juego actual.
 * @param player El jugador para el que se evalúa la línea.
 * @return Un valor que representa la puntuación de la línea para el jugador.
 */
int evaluateLine(Board board, Cell player) {
  int score = 0;
  int multiple = 0;
  for(Move[] line : WINNING_LINES) {
    Move l1 = line[0];
    Move l2 = line[1];
    Move l3 = line[2];
    Move l4 = line[3];
    Move l5 = line[4];
  
    int subScore = 0;
    if(board.cells[l1.row][l1.col] == player) subScore++;
    if(board.cells[l2.row][l2.col] == player) subScore++;
    if(board.cells[l3.row][l3.col] == player) subScore++;
    if(board.cells[l4.row][l4.col] == player) subScore++;
    if(board.cells[l5.row][l5.col] == player) subScore++;
    if(subScore >= 3) multiple++;
    subScore *= 3;
    if(board.cells[l1.row][l1.col] == Cell.EMPTY) subScore++;
    if(board.cells[l2.row][l2.col] == Cell.EMPTY) subScore++;
    if(board.cells[l3.row][l3.col] == Cell.EMPTY) subScore++;
    if(board.cells[l4.row][l4.col] == Cell.EMPTY) subScore++;
    if(board.cells[l5.row][l5.col] == Cell.EMPTY) subScore++;
    score = max(score, subScore);
  }
  multiple *= 2;
  
  return score+multiple;
}

/**
 * Algoritmo Minimax con poda alfa-beta para determinar la mejor jugada para el jugador actual.
 *
 * @param board        El tablero de juego actual.
 * @param depth        La profundidad máxima de búsqueda en el árbol de juego.
 * @param alpha        El mejor valor hasta el momento para el jugador maximizador.
 * @param beta         El mejor valor hasta el momento para el jugador minimizador.
 * @param isMaximizing Indica si el jugador actual está maximizando su puntuación.
 * @return El valor de la mejor jugada considerando el estado actual del tablero y la estrategia.
 */
int minimax(Board board, int depth, int alpha, int beta, boolean isMaximizing) {
  Cell currentCell = board.getCurrentCell();
  Cell oponentCell = currentCell == Cell.X? Cell.O : Cell.X;
  Cell winner = board.getWinner();
  
  if (winner == currentCell) return 20;
  if (winner == oponentCell) return -20;
  if (board.isFull()) return 0;
  if (depth <= 0) {
    int maxScore = evaluateLine(board, currentCell);
    int minScore = evaluateLine(board, oponentCell);
    
    return maxScore - minScore;
  }

  int bestScore;
  if (isMaximizing) {
    bestScore = Integer.MIN_VALUE;
    for (Move move : board.getAllPossibleMoves()) {
      board.play(move);
      int score = minimax(board, depth - 1, alpha, beta, false);
      board.undo();
      bestScore = max(bestScore, score);
      alpha = max(alpha, bestScore);
      if (beta <= alpha) break;
    }
  } else {
    bestScore = Integer.MAX_VALUE;
    for (Move move : board.getAllPossibleMoves()) {
      board.play(move);
      int score = minimax(board, depth - 1, alpha, beta, true);
      board.undo();
      bestScore = min(bestScore, score);
      beta = min(beta, bestScore);
      if (beta <= alpha) break;
    }
  }
  return bestScore;
}

/**
 * Encuentra la mejor jugada para el jugador actual utilizando el algoritmo Minimax.
 *
 * @param board El tablero de juego actual.
 * @param depth La profundidad máxima de búsqueda en el árbol de juego.
 * @return La mejor jugada disponible para el jugador actual.
 */
Move findBestMove(Board board, int depth) {
  Move bestMove = null;
  int bestScore = Integer.MIN_VALUE;
  int alpha = Integer.MIN_VALUE;
  int beta = Integer.MAX_VALUE;

  for (Move move : board.getAllPossibleMoves()) {
    board.play(move);
    int score = minimax(board, depth, alpha, beta, false);
    board.undo();
    if (score > bestScore) {
      bestScore = score;
      bestMove = move;
    }
    alpha = max(alpha, bestScore);
  }
  return bestMove;
}
