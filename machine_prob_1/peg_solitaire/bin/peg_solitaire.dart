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

// [noOfPegs, tempFinalHoleRow, tempFinalHoleColumn].
List<int> metadata = [0, -1, -1];
// List of moves for the peg solitaire solution.
List<List<int>> pegMovesSolution = [];
int pegMovesSolutionSize = 0; // Holds the size of list pegMovesSolution.

int noOfCycles = 0;
int heapMemory = 0;

// Other variable.
List<List<String>> boardState = [];

List<String> main(List<String> params) {
  // const List<String> input = [
  //   'xx...xx',
  //   'xxo..xx',
  //   '..o....',
  //   '..oO...',
  //   '.......',
  //   'xx...xx',
  //   'xx...xx',
  // ];

  final List<String> input = params;

  // Initialize the variables.
  finalHoleRow = -1;
  finalHoleColumn = -1;
  boardState = [];
  metadata = [0, -1, -1];
  pegMovesSolution = [];
  pegMovesSolutionSize = 0;
  noOfCycles = 0;

  // Fetch and decode input String.
  for (int r = 0; r < noOfRows; r++) {
    List<String> tempRow = [];
    for (int c = 0; c < nowOfColumns; c++) {
      noOfCycles++;
      tempRow.add(input[r][c]);

      // Update the noOfPegs.
      if ((tempRow[c] == pegHole) || (tempRow[c] == withPegFinalHole)) {
        metadata[0] = metadata[0] + 1;

        // Get the coordinate of the first peg.
        if (metadata[1] < 0) {
          metadata[1] = r;
          metadata[2] = c;
        }
      }

      // Determine the coordinate of the destination/final hole.
      if (finalHoleRow < 0) {
        // Determine if it is a final hole with a peg.
        if (tempRow[c] == withPegFinalHole) {
          tempRow[c] = 'o';
          finalHoleRow = r;
          finalHoleColumn = c;

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

  // When there is only one peg, identify its coordinate.

  print('\n-------------------');
  print('boardState: $boardState');
  print('finalHole: $finalHoleRow, $finalHoleColumn');
  print('metadata: $metadata');
  print('\n');

  bool isSolvable = solveSolitairePeg(boardState: boardState);

  print('pegMovesSolution: $pegMovesSolution');
  print('pegMovesSolutionSize: $pegMovesSolutionSize');
  print('noOfCycles: $noOfCycles');
  print('heapMemory: $heapMemory');
  print('\n');

  List<String> output = [];

  // Print 'YES' if it is solvable, otherwise print 'NO'
  String outputMsg = isSolvable ? 'YES' : 'NO';
  print(outputMsg);
  output.add(outputMsg);

  // Display the peg moves of the solution.
  if (isSolvable) {
    for (int i = pegMovesSolutionSize - 1; i >= 0; i--) {
      noOfCycles++;
      final List<int> tempMove = pegMovesSolution[i];
      final int r1 = tempMove[0];
      final int c1 = tempMove[1];
      final int r2 = tempMove[2];
      final int c2 = tempMove[3];

      final String outputMove = '${r1 + 1},${c1 + 1}->${r2 + 1},${c2 + 1}';
      print(outputMove);
      output.add(outputMove);
    }
    print('\n');
  }

  print(output);
  print('\n');

  return output;
}

bool solveSolitairePeg({
  required List<List<String>> boardState,
}) {
  // print('boardState: $boardState');
  // print('finalHole: $finalHoleRow, $finalHoleColumn');
  // print('metadata: $metadata');
  // print('\n');
  // print('------------------------');
  // print('heapMemory: $heapMemory');
  // print('------------------------');

  // Base case/s.
  // Case 1: There are no pegs to be moved.
  final int noOfPegs = metadata[0];
  if (noOfPegs == 0) return false;

  // Case 2: There is only 1 peg remaining. Check if its coordinate is equal
  // to the finalHole coordinate.
  final int tempFinalHoleRow = metadata[1];
  final int tempFinalHoleColumn = metadata[2];

  if (noOfPegs == 1) {
    if ((tempFinalHoleRow == finalHoleRow) &&
        (tempFinalHoleColumn == finalHoleColumn)) {
      return true;
    } else {
      return false;
    }
  }

  // Perform deep copy on the newBoardState 2D list.
  List<List<String>> newBoardState = deepCopy2DList<String>(boardState);
  heapMemory += 52;

  for (int r = 0; r < noOfRows; r++) {
    for (int c = 0; c < nowOfColumns; c++) {
      noOfCycles++;
      // Check if it is a peg.
      if (boardState[r][c] == pegHole) {
        // Check if there is an adjacent peg relative to the current peg.
        // While doing this, check also if the hole destination is available.
        // The order of peg-checking: North, East, South, and then West.

        // Check North.
        if ((r >= 2) &&
            (boardState[r - 1][c] == pegHole) &&
            (boardState[r - 2][c] == emptyHole)) {
          // Update the boardState.
          // Make the coordinate of the jumping peg empty.
          newBoardState[r][c] = emptyHole;
          // Delete the peg in the jumped-over hole.
          newBoardState[r - 1][c] = emptyHole;
          // Put the peg on the new coordinate.
          newBoardState[r - 2][c] = pegHole;

          metadata[0] = metadata[0] - 1; // Update the noOfPegs.
          // Determine the tempFinalHole coordinate.
          metadata[1] = r - 2;
          metadata[2] = c;

          bool isSolvable = solveSolitairePeg(boardState: newBoardState);

          if (isSolvable) {
            pegMovesSolution.add([r, c, r - 2, c]); // Add the move details.
            // Update the size.
            pegMovesSolutionSize++;
            heapMemory -= 52;

            return true;
          } else {
            // Revert back the previous data in the boardState.
            newBoardState[r][c] = pegHole;
            newBoardState[r - 1][c] = pegHole;
            newBoardState[r - 2][c] = emptyHole;

            // Revert back to the previous value of the metadata.
            metadata[0] = metadata[0] + 1;
            metadata[1] = tempFinalHoleRow;
            metadata[2] = tempFinalHoleColumn;
          }
        }

        // Check East.
        if ((c <= 4) &&
            (boardState[r][c + 1] == pegHole) &&
            (boardState[r][c + 2] == emptyHole)) {
          // Update the boardState.
          // Make the coordinate of the jumping peg empty.
          newBoardState[r][c] = emptyHole;
          // Delete the peg in the jumped-over hole.
          newBoardState[r][c + 1] = emptyHole;
          // Put the peg on the new coordinate.
          newBoardState[r][c + 2] = pegHole;

          metadata[0] = metadata[0] - 1; // Update the noOfPegs.
          // Determine the tempFinalHole coordinate.
          metadata[1] = r;
          metadata[2] = c + 2;

          bool isSolvable = solveSolitairePeg(boardState: newBoardState);

          if (isSolvable) {
            pegMovesSolution.add([r, c, r, c + 2]); // Add the move details.
            // Update the size.
            pegMovesSolutionSize++;
            heapMemory -= 52;

            return true;
          } else {
            // Revert back the previous data in the boardState.
            newBoardState[r][c] = pegHole;
            newBoardState[r][c + 1] = pegHole;
            newBoardState[r][c + 2] = emptyHole;

            // Revert back to the previous value of the metadata.
            metadata[0] = metadata[0] + 1;
            metadata[1] = tempFinalHoleRow;
            metadata[2] = tempFinalHoleColumn;
          }
        }

        // Check South.
        if ((r <= 4) &&
            (boardState[r + 1][c] == pegHole) &&
            (boardState[r + 2][c] == emptyHole)) {
          // Update the boardState.
          // Make the coordinate of the jumping peg empty.
          newBoardState[r][c] = emptyHole;
          // Delete the jumped-over hole.
          newBoardState[r + 1][c] = emptyHole;
          // Put the peg on the new coordinate.
          newBoardState[r + 2][c] = pegHole;

          metadata[0] = metadata[0] - 1; // Update the noOfPegs.
          // Determine the tempFinalHole coordinate.
          metadata[1] = r + 2;
          metadata[2] = c;

          bool isSolvable = solveSolitairePeg(boardState: newBoardState);

          if (isSolvable) {
            pegMovesSolution.add([r, c, r + 2, c]); // Add the move details.
            // Update the size.
            pegMovesSolutionSize++;
            heapMemory -= 52;

            return true;
          } else {
            // Revert back the previous data in the boardState.
            newBoardState[r][c] = pegHole;
            newBoardState[r + 1][c] = pegHole;
            newBoardState[r + 2][c] = emptyHole;

            // Revert back to the previous value of the metadata.
            metadata[0] = metadata[0] + 1;
            metadata[1] = tempFinalHoleRow;
            metadata[2] = tempFinalHoleColumn;
          }
        }

        // Check West.
        if ((c >= 2) &&
            (boardState[r][c - 1] == pegHole) &&
            (boardState[r][c - 2] == emptyHole)) {
          // Update the boardState.
          // Make the coordinate of the jumping peg empty.
          newBoardState[r][c] = emptyHole;
          // Delete the jumped-over hole.
          newBoardState[r][c - 1] = emptyHole;
          // Put the peg on the new coordinate.
          newBoardState[r][c - 2] = pegHole;

          metadata[0] = metadata[0] - 1; // Update the noOfPegs.
          // Determine the tempFinalHole coordinate.
          metadata[1] = r;
          metadata[2] = c - 2;

          bool isSolvable = solveSolitairePeg(boardState: newBoardState);

          if (isSolvable) {
            pegMovesSolution.add([r, c, r, c - 2]); // Add the move details.
            // Update the size.
            pegMovesSolutionSize++;
            heapMemory -= 52;

            return true;
          } else {
            // Revert back the previous data in the boardState.
            newBoardState[r][c] = pegHole;
            newBoardState[r][c - 1] = pegHole;
            newBoardState[r][c - 2] = emptyHole;

            // Revert back to the previous value of the metadata.
            metadata[0] = metadata[0] + 1;
            metadata[1] = tempFinalHoleRow;
            metadata[2] = tempFinalHoleColumn;
          }
        }
      }
    }
  }

  heapMemory -= 52;

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
