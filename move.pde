/**
 * Clase que representa una jugada en el juego.
 */
class Move {
  final int row, col;
  
  /**
   * Constructor de la clase Move.
   *
   * @param row Fila en la que se realiza el movimiento.
   * @param col Columna en la que se realiza el movimiento.
   */
  Move(int row, int col) {
    this.row = row;
    this.col = col;
  }
  
  /**
   * Convierte la jugada en una representación legible en forma de cadena.
   *
   * @return Una cadena que muestra la fila y la columna de la jugada en formato "fila, columna".
   */
  String toString() {
    return (this.row+1)+", "+(this.col+1);
  }
}
