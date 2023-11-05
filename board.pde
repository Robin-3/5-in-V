// Matriz que contiene las posibles líneas ganadoras.
final Move[][] WINNING_LINES = {
  {new Move(0, 0), new Move(1, 1), new Move(2, 2), new Move(2, 3), new Move(2, 4)},
  {new Move(1, 0), new Move(2, 1), new Move(3, 1), new Move(3, 2), new Move(3, 3)},
  {new Move(2, 0), new Move(3, 0), new Move(4, 0), new Move(4, 1), new Move(4, 2)},
  {new Move(0, 2), new Move(1, 2), new Move(2, 2), new Move(2, 1), new Move(2, 0)},
  {new Move(1, 3), new Move(2, 3), new Move(3, 2), new Move(3, 1), new Move(3, 0)},
  {new Move(2, 4), new Move(3, 3), new Move(4, 2), new Move(4, 1), new Move(4, 0)},
  {new Move(0, 2), new Move(1, 2), new Move(2, 2), new Move(3, 2), new Move(4, 2)},
  {new Move(0, 1), new Move(1, 1), new Move(2, 1), new Move(3, 1), new Move(4, 1)},
  {new Move(0, 0), new Move(1, 0), new Move(2, 0), new Move(3, 0), new Move(4, 0)},
  {new Move(2, 4), new Move(2, 3), new Move(2, 2), new Move(3, 1), new Move(4, 0)},
  {new Move(1, 3), new Move(1, 2), new Move(1, 1), new Move(2, 1), new Move(3, 0)},
  {new Move(0, 2), new Move(0, 1), new Move(0, 0), new Move(1, 0), new Move(2, 0)},
  {new Move(4, 2), new Move(3, 2), new Move(2, 2), new Move(2, 1), new Move(2, 0)},
  {new Move(3, 3), new Move(2, 3), new Move(1, 2), new Move(1, 1), new Move(1, 0)},
  {new Move(2, 4), new Move(1, 3), new Move(0, 2), new Move(0, 1), new Move(0, 0)},
  {new Move(4, 0), new Move(3, 1), new Move(2, 2), new Move(1, 1), new Move(0, 0)},
  {new Move(4, 1), new Move(3, 2), new Move(2, 3), new Move(1, 2), new Move(0, 1)},
  {new Move(4, 2), new Move(3, 3), new Move(2, 4), new Move(1, 3), new Move(0, 2)}
};

/**
 * Clase que representa un tablero de juego.
 */
class Board {
  boolean firstPlayer;            // Indica el turno del primer jugador.
  Move[] winningLine;             // Línea ganadora (si existe).
  
  final Cell[][] cells;           // Matriz que almacena las celdas del tablero.
  final Stack<Move> history;      // Historial de movimientos.

  /**
   * Constructor de la clase Board. Inicializa el tablero con celdas vacías y otras variables (jugador inicial, historial y línea ganadora).
   */
  Board() {
    this.cells = new Cell[iSize][];
    for (int i = 0; i < iSize; i++) {
      int offsetW = abs(BOARD_SIZE - 1 - i);
      int jSize = iSize-abs(offsetW);
      this.cells[i] = new Cell[jSize];
      for (int j = 0; j < jSize; j++)
        this.cells[i][j] = Cell.EMPTY;
    }

    this.firstPlayer = true;
    this.history = new Stack<>();
    this.winningLine = null;
  }
  
  /**
   * Obtiene una copia del historial de jugadas.
   *
   * @return Una copia del historial de jugadas como una pila.
   */
  Stack getMoveHistory() {
    return (Stack) this.history.clone();
  }
  
  /**
   * Obtiene el jugador actual (el que tiene el turno).
   *
   * @return El jugador actual, Cell.X (X) o Cell.O (O).
   */
  Cell getCurrentCell() {
    return this.firstPlayer? Cell.X : Cell.O;
  }

  /**
   * Cambia el turno de los jugadores alternando entre ellos.
   */
  void switchPlayers() {
    this.firstPlayer = !this.firstPlayer;
  }

  /**
   * Intenta realizar una jugada en las coordenadas dadas en el tablero.
   * Actualiza el tablero y el historial de movimientos, y cambia el turno del jugador.
   *
   * @param move El movimiento que especifica la fila y columna de la celda.
   */
  void play(Move move) {
    if (this.cells[move.row][move.col] == Cell.EMPTY) {
      this.cells[move.row][move.col] = this.getCurrentCell();
      this.history.push(move);
      this.switchPlayers();
    }
  }

  /**
   * Deshace la última jugada realizada en el tablero y actualiza el historial.
   * Cambia el turno del jugador de nuevo.
   */
  void undo() {
    if (!history.isEmpty()) {
      this.winningLine = null;
      Move lastMove = this.history.pop();
      this.cells[lastMove.row][lastMove.col] = Cell.EMPTY;
      this.switchPlayers();
    }
  }

  /**
   * Determina si hay un ganador en el juego.
   *
   * @return El jugador ganador o null si no hay un ganador todavía.
   */
  Cell getWinner() {
    for (Move[] line : WINNING_LINES) {
      Move l1 = line[0];
      Move l2 = line[1];
      Move l3 = line[2];
      Move l4 = line[3];
      Move l5 = line[4];

      if(this.cells[l1.row][l1.col] != Cell.EMPTY &&
         this.cells[l1.row][l1.col] == this.cells[l2.row][l2.col] &&
         this.cells[l1.row][l1.col] == this.cells[l3.row][l3.col] &&
         this.cells[l1.row][l1.col] == this.cells[l4.row][l4.col] &&
         this.cells[l1.row][l1.col] == this.cells[l5.row][l5.col]
      ) {
        this.winningLine = line;
        return this.cells[l1.row][l1.col];
      }
    }

    return null;
  }

  /**
   * Verifica si el tablero está lleno, es decir, no hay más celdas vacías disponibles para realizar movimientos.
   *
   * @return true si todas las celdas del tablero están ocupadas, false en caso contrario.
   */
  boolean isFull() {
    for (int i = 0; i < this.cells.length; i++)
      for (int j = 0; j < this.cells[i].length; j++)
        if (this.cells[i][j] == Cell.EMPTY)
          return false;
    return true;
  }
  
  /**
   * Verifica si un movimiento dado aparece en la línea ganadora actual.
   *
   * @param move El movimiento a verificar.
   * @return true si el movimiento está en la línea ganadora, false en caso contrario.
   */
  boolean appearsInWinningLine(Move move) {
    if(this.winningLine == null)
      return false;
    for(Move line : this.winningLine)
      if(line.row == move.row && line.col == move.col)
        return true;
    return false;
  }
  
  /**
   * Obtiene un historial de jugadas en formato de cadena.
   *
   * @return Una cadena que representa el historial de jugadas.
   */
  String getHistory() {
    String history = "";
    Stack moves = this.getMoveHistory();
    while(!moves.isEmpty()) {
      Move move = (Move) moves.pop();
      history = "\nMove #"+(moves.size()+1)+": "+move.toString() + history;
    }
    return history;
  }
  
  /**
   * Obtiene una lista de todos los movimientos posibles en el tablero en su estado actual.
   *
   * @return Una lista de objetos Move que representan los movimientos posibles.
   */
  List<Move> getAllPossibleMoves() {
    List<Move> possibleMoves = new ArrayList<>();
    for (int i = 0; i < this.cells.length; i++)
      for (int j = 0; j < this.cells[i].length; j++)
        if (this.cells[i][j] == Cell.EMPTY)
          possibleMoves.add(new Move(i, j));
    return possibleMoves;
  }
}
