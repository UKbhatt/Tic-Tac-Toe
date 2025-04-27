import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> board = List.filled(9, '');
  int count = 0;
  bool gameOver = false;
  late ConfettiController _confettiController;

  Map<int, List<List<int>>> moveWithWinningCombinations = {
    0: [
      [0, 1, 2],
      [0, 3, 6]
    ],
    1: [
      [0, 1, 2],
      [1, 4, 7]
    ],
    2: [
      [0, 1, 2],
      [2, 5, 8],
      [2, 4, 6]
    ],
    3: [
      [3, 4, 5],
      [3, 0, 6]
    ],
    4: [
      [3, 4, 5],
      [4, 1, 7],
      [4, 0, 8],
      [4, 2, 6]
    ],
    5: [
      [3, 4, 5],
      [5, 2, 8]
    ],
    6: [
      [6, 7, 8],
      [6, 0, 3],
      [6, 4, 2]
    ],
    7: [
      [6, 7, 8],
      [7, 1, 4]
    ],
    8: [
      [6, 7, 8],
      [8, 2, 5],
      [8, 0, 4]
    ],
  };

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 2));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void resetGame() {
    setState(() {
      board = List.filled(9, '');
      gameOver = false;
      count = 0;
    });
  }

  Future<void> checkWinner(int index) async {
    for (var i in moveWithWinningCombinations[index]!) {
      if (board[i[0]] == board[i[1]] &&
          board[i[1]] == board[i[2]] &&
          board[i[0]] != '') {
        gameOver = true;
        _confettiController.play();
        await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Game Over"),
              content: Text("${board[i[0]]} is the winner!"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    resetGame();
                  },
                  child: const Text("Play Again"),
                ),
              ],
            );
          },
        );
        return;
      }
    }

    if (count == 9 && !gameOver) {
      gameOver = true;
      await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Game Over"),
            content: const Text("It's a draw!"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  resetGame();
                },
                child: const Text("Play Again"),
              ),
            ],
          );
        },
      );
    }
  }

  void onCheck(int index) {
    if (board[index] == '' && !gameOver) {
      setState(() {
        board[index] = (count & 1) == 0 ? 'X' : 'O';
        count++;
      });
      checkWinner(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    var devHeight = MediaQuery.of(context).size.height;
    var devWidth = MediaQuery.of(context).size.width;
    final gridSize = devWidth < devHeight ? devWidth * 0.8 : devHeight * 0.6;

    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.grey[200],
          appBar: AppBar(
            title: const Text(
              "Tic Tac Toe",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
            ),
            centerTitle: true,
            backgroundColor:Colors.orange, 
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  (count & 1) == 0 ? "Player X's Turn" : "Player O's Turn",
                  style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: gridSize,
                  width: gridSize,
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3),
                    itemCount: 9,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          onCheck(index);
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.bounceInOut,
                          margin: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: board[index] == ''
                                ?  Colors.yellow[700] 
                                : (board[index] == 'X'
                                    ? Colors.red[400]
                                    : Colors.blue[500]), 
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.black, width: 2),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                spreadRadius: 1,
                                blurRadius: 5,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              board[index],
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton.icon(
                  onPressed: resetGame,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange, 
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  icon: const Icon(Icons.refresh , color: Colors.white,),
                  label: const Text(
                    "Reset Game",
                    style: TextStyle(fontSize: 18 , color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: ConfettiWidget(
            confettiController: _confettiController,
            blastDirectionality: BlastDirectionality.explosive,
            shouldLoop: false,
            numberOfParticles: 30,
            emissionFrequency: 0.05,
          ),
        ),
      ],
    );
  }
}
