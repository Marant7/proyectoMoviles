import 'package:flutter/material.dart';
import 'juego_3.dart';
import '../mensaje/celebracion.dart';

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

class JuegoDragDrop2 extends StatefulWidget {
  @override
  _JuegoDragDropState2 createState() => _JuegoDragDropState2();
}

class _JuegoDragDropState2 extends State<JuegoDragDrop2> {
  final List<Question> questions = [
    Question(
      imagePath: 'assets/images/lampara.png',
      options: ['combate', 'campana', 'lámpara'],
      answer: 'lámpara',
    ),
    Question(
      imagePath: 'assets/images/bombero.png',
      options: ['bombero', 'ampoya', 'tumba'],
      answer: 'bombero',
    ),
    Question(
      imagePath: 'assets/images/tambor.png',
      options: ['compás', 'tambor', 'bombón'],
      answer: 'tambor',
    ),
    Question(
      imagePath: 'assets/images/embudo.png',
      options: ['estampa', 'embudo', 'empaste'],
      answer: 'embudo',
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

    if (allCorrect) {
      Celebracion.mostrar(context);
    }
  }

  void goToNextGame() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => JuegoDragDrop3()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color.fromARGB(255, 126, 168, 247), Color(0xFF8EC5FC)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  'Juego: Arrastra la palabra correcta',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 26, 1, 104),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                ...List.generate(questions.length, (index) {
                  final q = questions[index];
                  final isImageLeft = index % 2 == 0;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 6,
                            offset: Offset(2, 4),
                          ),
                        ],
                      ),
                      padding: EdgeInsets.all(12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
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
                    ),
                  );
                }),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: checkAnswers,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 8, 10, 156),
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    'Verificar respuestas',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // <-- el color
                    ),
                  ),
                ),
                SizedBox(height: 20),
                if (isUnlocked)
                  ElevatedButton(
                    onPressed: goToNextGame,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 41, 134, 255),
                      padding: EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      'Siguiente juego',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                else
                  Opacity(
                    opacity: 0.5,
                    child: IgnorePointer(
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: Icon(Icons.lock),
                        label: Text(
                          'Siguiente juego',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(
                            255,
                            255,
                            255,
                            255,
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget imageBox(String imagePath) {
    return Container(
      width: 90,
      height: 90,
      margin: EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.grey.shade100,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Image.asset(imagePath, fit: BoxFit.cover),
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
          margin: EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.deepPurple[50],
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.deepPurple),
          ),
          alignment: Alignment.center,
          child: Text(
            answer ?? 'Arrastra aquí',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple[700],
            ),
          ),
        );
      },
    );
  }

  Widget wordChip(String word, {bool isDragging = false}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 25, vertical: 8),
      decoration: BoxDecoration(
        color: isDragging ? Colors.orange[300] : Colors.orange[100],
        borderRadius: BorderRadius.circular(30),
        boxShadow:
            isDragging
                ? [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 6,
                    offset: Offset(2, 4),
                  ),
                ]
                : [],
      ),
      child: Text(
        word,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }
}
