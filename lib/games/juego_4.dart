import 'package:flutter/material.dart';
import 'package:flutter_jueguito/games/juego_5.dart';
import 'package:flutter_jueguito/games/juego_3.dart';

class Question {
  final String imagePath;
  final List<String> options;
  final String answer;

  Question({
    required this.imagePath,
    required this.options,
    required this.answer,
  });
}

class Juego_2 extends StatefulWidget {
  @override
  _JuegoDragDropState createState() => _JuegoDragDropState();
}

class _JuegoDragDropState extends State<Juego_2> {
  final List<Question> questions = [
    Question(
      imagePath: 'assets/images/globo.png',
      options: ['gloria', 'globo', 'clavel'],
      answer: 'globo',
    ),
    Question(
      imagePath: 'assets/images/iglu.png',
      options: ['jungla', 'iglú', 'esclavo'],
      answer: 'iglú',
    ),
    Question(
      imagePath: 'assets/images/reglas.png',
      options: ['ancla', 'siglo', 'regla'],
      answer: 'regla',
    ),
    Question(
      imagePath: 'assets/images/gloton.png',
      options: ['inglesa', 'glotón', 'clarín'],
      answer: 'glotón',
    ),
  ];

  Map<int, String?> userAnswers = {};
  bool isUnlocked = false;

  void checkAnswers() {
    bool allCorrect = true;
    for (int i = 0; i < questions.length; i++) {
      if (userAnswers[i] != questions[i].answer) {
        allCorrect = false;
        break;
      }
    }

    setState(() {
      isUnlocked = allCorrect;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          allCorrect
              ? '¡Todas las respuestas son correctas! 🎉'
              : 'Hay respuestas incorrectas ❌',
        ),
      ),
    );
  }

  void goToNextGame() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => JuegoNumerosImagen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Juego: Arrastra la palabra correcta')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ...List.generate(questions.length, (index) {
              final q = questions[index];
              final isImageLeft = index % 2 == 0;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:
                      isImageLeft
                          ? [
                            imageBox(q.imagePath),
                            Expanded(child: dropZone(index)),
                            wordOptions(q.options, index),
                          ]
                          : [
                            wordOptions(q.options, index),
                            Expanded(child: dropZone(index)),
                            imageBox(q.imagePath),
                          ],
                ),
              );
            }),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: checkAnswers,
              child: Text('Verificar respuestas'),
            ),
            SizedBox(height: 10),
            if (isUnlocked)
              ElevatedButton(
                onPressed: goToNextGame,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: Text('Siguiente juego'),
              )
            else
              Opacity(
                opacity: 0.4,
                child: IgnorePointer(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.lock),
                        SizedBox(width: 8),
                        Text('Siguiente juego'),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget imageBox(String imagePath) {
    return Container(
      width: 100,
      height: 100,
      margin: EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Image.asset(imagePath, fit: BoxFit.contain),
      ),
    );
  }

  Widget wordOptions(List<String> options, int questionIndex) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:
          options.map((word) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Draggable<String>(
                data: word,
                feedback: Material(
                  color: Colors.transparent,
                  child: wordChip(word, isDragging: true),
                ),
                childWhenDragging: Opacity(opacity: 0.3, child: wordChip(word)),
                child: wordChip(word),
              ),
            );
          }).toList(),
    );
  }

  Widget dropZone(int questionIndex) {
    final answer = userAnswers[questionIndex];

    return DragTarget<String>(
      onAccept: (data) {
        setState(() {
          userAnswers[questionIndex] = data;
        });
      },
      builder: (context, candidateData, rejectedData) {
        return Container(
          height: 60,
          margin: EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.green[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.green),
          ),
          alignment: Alignment.center,
          child: Text(
            answer ?? 'Arrastra aquí',
            style: TextStyle(fontSize: 18, color: Colors.black87),
          ),
        );
      },
    );
  }

  Widget wordChip(String word, {bool isDragging = false}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isDragging ? Colors.orange[300] : Colors.orange[100],
        borderRadius: BorderRadius.circular(20),
        boxShadow:
            isDragging
                ? [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4,
                    offset: Offset(2, 2),
                  ),
                ]
                : [],
      ),
      child: Text(word, style: TextStyle(fontSize: 16)),
    );
  }
}
