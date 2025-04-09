import 'package:flutter/material.dart';

class JuegoSilabas extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Juego: Completa las sílabas')),
      body: Center(
        child: Text(
          'Aquí va el juego de sílabas 🚀',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
