import 'dart:math';
import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';

class Celebracion {
  static void mostrar(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return _CelebracionDialog();
      },
    );
  }
}

class _CelebracionDialog extends StatefulWidget {
  @override
  State<_CelebracionDialog> createState() => _CelebracionDialogState();
}

class _CelebracionDialogState extends State<_CelebracionDialog> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 5),
    );
    _confettiController.play();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Confetti detrás del Dialog
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              blastDirection: pi / 2,
              emissionFrequency: 0.1,
              numberOfParticles: 10,
              maxBlastForce: 10,
              minBlastForce: 5,
              gravity: 0.3,
              colors: const [
                Colors.pinkAccent,
                Colors.blueAccent,
                const Color.fromARGB(255, 2, 197, 83),
                const Color.fromARGB(255, 250, 150, 0),
              ],
            ),
          ),
        ),
        // Diálogo principal encima del confeti
        Center(
          child: Dialog(
            backgroundColor: Colors.deepPurple.shade100.withOpacity(0.95),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            elevation: 10,
            child: Padding(
              padding: const EdgeInsets.all(25),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.emoji_events_rounded,
                    color: Colors.amber,
                    size: 80,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    '¡Felicidades!',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple.shade800,
                      shadows: [
                        Shadow(
                          blurRadius: 10,
                          color: Colors.deepPurple.withOpacity(0.4),
                          offset: const Offset(2, 2),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    'Has completado todas las relaciones correctamente.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).pop(); // Solo cerramos
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurpleAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 14,
                      ),
                      elevation: 5,
                    ),
                    icon: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 20,
                      color: Colors.white,
                    ),
                    label: const Text(
                      'Continuar',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
