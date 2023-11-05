/**
 * Genera un movimiento aleatorio entre las jugadas disponibles en el tablero.
 *
 * @param board El tablero de juego actual.
 * @return Un movimiento aleatorio válido o null si no hay movimientos disponibles.
 */
Move randomMove(Board board) {
  List<Move> moves = board.getAllPossibleMoves();
  if(moves.isEmpty()) return null;
  int index = floor(random(moves.size()));
  return moves.get(index);
}
