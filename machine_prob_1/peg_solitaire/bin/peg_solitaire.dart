// Global variables.
List<int> finalHole = [-1, -1];
const int rows = 7;
const int columns = 7;
const String emptyHole = '.';
const String pegHole = 'o';
const String invalidHole = 'x';
const String withoutPegFinalHole = 'E';
const String withPegFinalHole = 'O';

// Dynamic variables.
List<List<String>> boardState = [];
List<List<int>> pegCoordinates = [];
int noOfPegs = 0;

void main() {
  const List<String> input = [
    'xx...xx',
    'xxo..xx',
    '..o....',
    '..oO...',
    '.......',
    'xx...xx',
    'xx...xx',
  ];

  // Fetch and decode input String.
  for (int r = 0; r < rows; r++) {
    List<String> tempRow = [];
    for (int c = 0; c < columns; c++) {
      tempRow.add(input[r][c]);

      // Add the hole coordinate to the pegCoordinates list
      // if it is a peg (i.e., 'o' or 'O').
      if ((tempRow[c] == pegHole) || (tempRow[c] == withPegFinalHole)) {
        pegCoordinates.add([r, c]);
        noOfPegs++;

        // Determine if it is a final hole with a peg.
        if (tempRow[c] == withPegFinalHole) {
          tempRow[c] = 'o';
          finalHole = [r, c];
        }

        continue;
      }

      // Determine if it is a final hole without a peg.
      if (tempRow[c] == withoutPegFinalHole) {
        tempRow[c] = '.';
        finalHole = [r, c];
      }
    }

    boardState.add(tempRow); // Build the initial boardState;
  }

  print('boardState: $boardState');
  print('finalHole: $finalHole');
  print('pegCoordinates: $pegCoordinates');
  print('noOfPegs: $noOfPegs');
  print('\n');

  noOfPegs = deleteElem(
    list: pegCoordinates,
    index: 2,
    noOfPegs: noOfPegs,
  );

  print('boardState: $boardState');
  print('finalHole: $finalHole');
  print('pegCoordinates: $pegCoordinates');
  print('noOfPegs: $noOfPegs');
  print('\n');

  solve(
    boardState: boardState,
    pegCoordinates: pegCoordinates,
    noOfPegs: noOfPegs,
  );
}

bool solve({
  required List<List<String>> boardState,
  required List<List<int>> pegCoordinates,
  required int noOfPegs,
}) {
  // Base case/s.
  // Case 1: There are no pegs to be moved.
  if (noOfPegs == 0) return false;

  // Case 2: One peg is remaining. Check if its coordinate is equal
  // to the finalHole coordinate.
  if (noOfPegs == 1) {
    final int row = pegCoordinates[0][0];
    final int column = pegCoordinates[0][1];

    if ((row == finalHole[0]) && (column == finalHole[1])) return true;
  }

  for (int i = 0; i < noOfPegs; i++) {
    // Check if there is an adjacent peg relative to the current peg.
    // The order of peg-checking: North, East, South, and then West.
    // While doing this, check also if the hole destination is available.

    // The r and c coordinate of the current peg.
    final int currentPegRow = pegCoordinates[i][0];
    final int currentPegColumn = pegCoordinates[i][1];

    // Check North.
    if ((currentPegRow > 1) &&
        (boardState[currentPegRow - 1][currentPegColumn] == pegHole) &&
        (boardState[currentPegRow - 2][currentPegColumn] == emptyHole)) {
      // Perform deep copy on the list parameters.
      List<List<String>> newBoardState = deepCopy2DList<String>(boardState);
      List<List<int>> newPegCoordinates = deepCopy2DList<int>(pegCoordinates);

      // Update the boardState.
      // Make the coordinate of the jumping peg empty.
      newBoardState[currentPegRow][currentPegColumn] = emptyHole;
      // Delete the jumped-over hole.
      newBoardState[currentPegRow - 1][currentPegColumn] = emptyHole;
      // Put the peg on the new coordinate.
      newBoardState[currentPegRow - 2][currentPegColumn] = pegHole;

      // Update the pegCoordinates.
      // Set the coordinate of the jumping peg to its destination peg coordinate.
      newPegCoordinates[i] = [currentPegRow - 2, currentPegColumn];
      // Delete the coordinate of the jumped-over peg.

      bool returnValue = solve(
        boardState: newBoardState,
        pegCoordinates: newPegCoordinates,
        noOfPegs: noOfPegs - 1,
      );
    }

    // Check East.

    // Check South.

    // Check West.
  }

  // The peg solitaire is unsolvable.
  return false;
}

int deleteElem({
  required List<Object> list,
  required int index,
  required int noOfPegs,
}) {
  for (int i = index; i < (noOfPegs - 1); i++) {
    list[i] = list[i + 1];
    list[i + 1] = [-1, -1]; // Optional to code in MIPS.
  }

  noOfPegs--;
  return noOfPegs;
}

// This explicit implementation will not be coded in MIPS.
List<List<Type>> deepCopy2DList<Type>(List<List<Type>> list) {
  List<List<Type>> newList = [];

  for (int r = 0; r < list.length; r++) {
    newList.add([...list[r]]);
  }

  return newList;
}
