import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> board = List.filled(9, '');
  int count = 0;
  bool GameOver = false;

  List<List<int>> winningCombinations = [
    [0, 1, 2],
    [3, 4, 5],
    [6, 7, 8],
    [0, 3, 6],
    [1, 4, 7],
    [2, 5, 8],
    [0, 4, 8],
    [2, 4, 6],
  ];

  void resetGame() {
    setState(() {
      board = List.filled(9, '');
      GameOver = false;
      count = 0;
    });
  }

  Future<void> checkWinner() async {
    for (var i in winningCombinations) {
      if (board[i[0]] != '' &&
          board[i[0]] == board[i[1]] &&
          board[i[1]] == board[i[2]]) {
        GameOver = true;
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
    if (!board.contains('')) {
      GameOver = true;
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

  OnCheck(int index) {
    if (board[index] == '' && !GameOver) {
      setState(() {
        board[index] = (count & 1) == 0 ? 'X' : 'O';
      });
      count++;
      checkWinner();
    }
  }

  @override
  Widget build(BuildContext context) {
    var dev_height = MediaQuery.of(context).size.height;
    var dev_width = MediaQuery.of(context).size.width;
    final gridSize =
        dev_width < dev_height ? dev_width * 0.8 : dev_height * 0.3;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tic Tac Toe"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              (count & 1) == 0 ? "Player X's Turn" : "Player O's Turn",
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: gridSize,
              width: gridSize,
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3),
                itemCount: 9,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => OnCheck(index),
                    child: Container(
                      margin: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: board[index] == '' ?  Colors.blue : Colors.red,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.black, width: 2),
                      ),
                      child: Center(
                        child: Text(
                          board[index],
                          style: const TextStyle(
                              color: Colors.white, fontSize: 24),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
