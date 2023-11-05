/**
 * Carga un ejemplo predefinido en el tablero para ilustrar un estado específico del juego.
 * Nota: El tablero debe estar vacío antes de llamar a esta función para que el ejemplo se represente correctamente.
 *
 * @param board El tablero de juego en el que se cargará el ejemplo.
 */
void loadExample(Board board) {
  board.play(new Move(0, 0));
  board.play(new Move(2, 4));
  board.play(new Move(2, 0));
  board.play(new Move(2, 3));
  board.play(new Move(3, 1));
  board.play(new Move(1, 3));
  board.play(new Move(4, 1));
  board.play(new Move(1, 2));
  board.play(new Move(0, 1));
  board.play(new Move(1, 1));
  board.play(new Move(3, 2));
  board.play(new Move(2, 1));
  board.play(new Move(1, 0));
  board.play(new Move(3, 0));
  winner = board.getWinner();
}
