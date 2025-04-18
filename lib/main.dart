import 'package:flutter/material.dart';
import 'package:flutter_jueguito/games/juego_3.dart';
import 'package:flutter_jueguito/games/juego_5.dart';
import 'package:flutter_jueguito/games/juego_4.dart';
import 'package:flutter_jueguito/games/juego_6.dart';
import 'package:flutter_jueguito/games/juego_7.dart';
import 'package:flutter_jueguito/games/juego_7.dart';
import 'package:flutter_jueguito/games/juego_8.dart';
import 'package:flutter_jueguito/games/juego_9.dart' hide Juego_2;
import 'package:flutter_jueguito/games/juego_10.dart';
import 'package:flutter_jueguito/games/juego_2.dart';
import 'games/juego_1.dart';

// void main() => runApp(MaterialApp(
//   home: JuegoNumeroATexto4(), // 👈 Cambia esto por el juego que estás probando
//   debugShowCheckedModeBanner: false,
// ));

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mis Juegos',
      debugShowCheckedModeBanner: false,
      home: JuegoConDosImagenes2(),
    );
  }
}

class MenuPrincipal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Menú Principal')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => JuegoDragDrop()));
              },
              child: Text('🧩 Juego Drag & Drop'),
            ),
            // Aquí puedes agregar más juegos en el futuro
          ],
        ),
      ),
    );
  }
}
