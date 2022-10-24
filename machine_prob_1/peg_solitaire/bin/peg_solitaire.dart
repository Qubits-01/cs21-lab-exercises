// Global variables.
int finalHoleRow = -1;
int finalHoleColumn = -1;
const int noOfRows = 7;
const int nowOfColumns = 7;
const String emptyHole = '.';
const String pegHole = 'o';
const String invalidHole = 'x';
const String withoutPegFinalHole = 'E';
const String withPegFinalHole = 'O';

// Dynamic variables.
List<List<String>> boardState = [];
// [noOfPegs, tempFinalHoleRow, tempFinalHoleColumn].
List<int> metadata = [0, -1, -1];
// The pegMovesSolution[0] holds the size of this said list.
List<List<int>> pegMovesSolution = [
  [0]
];

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
  for (int r = 0; r < noOfRows; r++) {
    List<String> tempRow = [];
    for (int c = 0; c < nowOfColumns; c++) {
      tempRow.add(input[r][c]);

      // Update the noOfPegs.
      if (tempRow[c] == pegHole) metadata[0] = metadata[0] + 1;

      // Determine the coordinate of the destination/final hole.
      if (finalHoleRow < 0) {
        // Determine if it is a final hole with a peg.
        if (tempRow[c] == withPegFinalHole) {
          tempRow[c] = 'o';
          finalHoleRow = r;
          finalHoleColumn = c;
          metadata[0] = metadata[0] + 1;

          continue;
        }

        // Determine if it is a final hole without a peg.
        if (tempRow[c] == withoutPegFinalHole) {
          tempRow[c] = '.';
          finalHoleRow = r;
          finalHoleColumn = c;
        }
      }
    }

    boardState.add(tempRow); // Build the initial boardState;
  }

  print('boardState: $boardState');
  print('finalHole: $finalHoleRow, $finalHoleColumn');
  print('metadata: $metadata');
  print('\n');

  bool isSolvable = solveSolitairePeg(
    boardState: boardState,
    metadata: metadata,
  );

  print('pegMovesSolution: $pegMovesSolution');
  print('\n');

  List<String> output = [];

  // Print 'YES' if it is solvable, otherwise print 'NO'
  String outputMsg = isSolvable ? 'YES' : 'NO';
  print(outputMsg);
  output.add(outputMsg);

  // Display the peg moves of the solution.
  final int pegMovesSolutionSize = pegMovesSolution[0][0];
  for (int i = pegMovesSolutionSize; i > 0; i--) {
    final List<int> tempMove = pegMovesSolution[i];
    final int r1 = tempMove[0];
    final int c1 = tempMove[1];
    final int r2 = tempMove[2];
    final int c2 = tempMove[3];

    final String outputMove = '${r1 + 1},${c1 + 1}->${r2 + 1},${c2 + 1}';
    print(outputMove);
  }
  print('\n');

  print(output);
  print('\n');
}

bool solveSolitairePeg({
  required List<List<String>> boardState,
  required List<int> metadata,
}) {
  print('boardState: $boardState');
  print('finalHole: $finalHoleRow, $finalHoleColumn');
  print('metadata: $metadata');
  print('\n');

  // Base case/s.
  // Case 1: There are no pegs to be moved.
  final int noOfPegs = metadata[0];
  if (noOfPegs == 0) return false;

  // Case 2: One peg is remaining. Check if its coordinate is equal
  // to the finalHole coordinate.
  final int tempFinalHoleRow = metadata[1];
  final int tempFinalHoleColumn = metadata[2];

  if ((noOfPegs == 1) &&
      (tempFinalHoleRow == finalHoleRow) &&
      (tempFinalHoleColumn == finalHoleColumn)) {
    return true;
  }

  for (int r = 0; r < noOfRows; r++) {
    for (int c = 0; c < nowOfColumns; c++) {
      // Check if it is a peg.
      if (boardState[r][c] == pegHole) {
        // Check if there is an adjacent peg relative to the current peg.
        // While doing this, check also if the hole destination is available.
        // The order of peg-checking: North, East, South, and then West.

        // Check North.
        if ((r >= 2) &&
            (boardState[r - 1][c] == pegHole) &&
            (boardState[r - 2][c] == emptyHole)) {
          // Perform deep copy on the list parameters.
          List<List<String>> newBoardState = deepCopy2DList<String>(boardState);
          List<int> newMetaData = [...metadata];

          // Update the boardState.
          // Make the coordinate of the jumping peg empty.
          newBoardState[r][c] = emptyHole;
          // Delete the jumped-over hole.
          newBoardState[r - 1][c] = emptyHole;
          // Put the peg on the new coordinate.
          newBoardState[r - 2][c] = pegHole;

          newMetaData[0] = newMetaData[0] - 1; // Update the noOfPegs.
          // Determine the tempFinalHole coordinate.
          newMetaData[1] = r - 2;
          newMetaData[2] = c;

          bool isSolvable = solveSolitairePeg(
            boardState: newBoardState,
            metadata: newMetaData,
          );

          if (isSolvable) {
            pegMovesSolution.add([r, c, r - 2, c]); // Add the move details.
            // Update the size.
            pegMovesSolution[0][0] = pegMovesSolution[0][0] + 1;

            return true;
          }
        }

        // Check East.
        if ((c <= 4) &&
            (boardState[r][c + 1] == pegHole) &&
            (boardState[r][c + 2] == emptyHole)) {
          // Perform deep copy on the list parameters.
          List<List<String>> newBoardState = deepCopy2DList<String>(boardState);
          List<int> newMetaData = [...metadata];

          // Update the boardState.
          // Make the coordinate of the jumping peg empty.
          newBoardState[r][c] = emptyHole;
          // Delete the jumped-over hole.
          newBoardState[r][c + 1] = emptyHole;
          // Put the peg on the new coordinate.
          newBoardState[r][c + 2] = pegHole;

          newMetaData[0] = newMetaData[0] - 1; // Update the noOfPegs.
          // Determine the tempFinalHole coordinate.
          newMetaData[1] = r;
          newMetaData[2] = c + 2;

          bool isSolvable = solveSolitairePeg(
            boardState: newBoardState,
            metadata: newMetaData,
          );

          if (isSolvable) {
            pegMovesSolution.add([r, c, r, c + 2]); // Add the move details.
            // Update the size.
            pegMovesSolution[0][0] = pegMovesSolution[0][0] + 1;

            return true;
          }
        }

        // Check South.
        if ((r <= 4) &&
            (boardState[r + 1][c] == pegHole) &&
            (boardState[r + 2][c] == emptyHole)) {
          // Perform deep copy on the list parameters.
          List<List<String>> newBoardState = deepCopy2DList<String>(boardState);
          List<int> newMetaData = [...metadata];

          // Update the boardState.
          // Make the coordinate of the jumping peg empty.
          newBoardState[r][c] = emptyHole;
          // Delete the jumped-over hole.
          newBoardState[r + 1][c] = emptyHole;
          // Put the peg on the new coordinate.
          newBoardState[r + 2][c] = pegHole;

          newMetaData[0] = newMetaData[0] - 1; // Update the noOfPegs.
          // Determine the tempFinalHole coordinate.
          newMetaData[1] = r + 2;
          newMetaData[2] = c;

          bool isSolvable = solveSolitairePeg(
            boardState: newBoardState,
            metadata: newMetaData,
          );

          if (isSolvable) {
            pegMovesSolution.add([r, c, r + 2, c]); // Add the move details.
            // Update the size.
            pegMovesSolution[0][0] = pegMovesSolution[0][0] + 1;

            return true;
          }
        }

        // Check West.
        if ((c >= 2) &&
            (boardState[r][c - 1] == pegHole) &&
            (boardState[r][c - 2] == emptyHole)) {
          // Perform deep copy on the list parameters.
          List<List<String>> newBoardState = deepCopy2DList<String>(boardState);
          List<int> newMetaData = [...metadata];

          // Update the boardState.
          // Make the coordinate of the jumping peg empty.
          newBoardState[r][c] = emptyHole;
          // Delete the jumped-over hole.
          newBoardState[r][c - 1] = emptyHole;
          // Put the peg on the new coordinate.
          newBoardState[r][c - 2] = pegHole;

          newMetaData[0] = newMetaData[0] - 1; // Update the noOfPegs.
          // Determine the tempFinalHole coordinate.
          newMetaData[1] = r;
          newMetaData[2] = c - 2;

          bool isSolvable = solveSolitairePeg(
            boardState: newBoardState,
            metadata: newMetaData,
          );

          if (isSolvable) {
            pegMovesSolution.add([r, c, r, c - 2]); // Add the move details.
            // Update the size.
            pegMovesSolution[0][0] = pegMovesSolution[0][0] + 1;

            return true;
          }
        }
      }
    }
  }

  // No solution was found for the current boardState.
  return false;
}

// This explicit implementation will not be coded in MIPS.
List<List<Type>> deepCopy2DList<Type>(List<List<Type>> list) {
  List<List<Type>> newList = [];

  for (int r = 0; r < list.length; r++) {
    newList.add([...list[r]]);
  }

  return newList;
}
