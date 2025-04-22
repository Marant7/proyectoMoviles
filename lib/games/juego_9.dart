import 'package:flutter/material.dart';
import 'package:flutter_jueguito/games/juego_10.dart';
import 'package:flutter_jueguito/games/juego_silabas.dart';
import 'package:flutter_jueguito/mensaje/celebracion.dart';

class JuegoConDosImagenes2 extends StatefulWidget {
  @override
  _JuegoConDosImagenesState createState() => _JuegoConDosImagenesState();
}

class _JuegoConDosImagenesState extends State<JuegoConDosImagenes2> {
  final List<Map<String, dynamic>> preguntas = [
    {
      'izquierda': 'assets/images/bolso.png',
      'derecha': 'assets/images/palma.png',
      'opciones': ['bolso', 'palma', 'polvo'],
      'respuestas': ['bolso', 'palma']
    },
    {
      'izquierda': 'assets/images/papel.png',
      'derecha': 'assets/images/panel.png',
      'opciones': ['papel', 'panal', 'canal'],
      'respuestas': ['papel', 'panal']
    },
    {
      'izquierda': 'assets/images/arbol.png',
      'derecha': 'assets/images/salto.png',
      'opciones': ['selva', 'árbol', 'salto'],
      'respuestas': ['árbol', 'salto']
    },
  ];

  Map<int, String?> respuestasUsuarioIzq = {};
  Map<int, String?> respuestasUsuarioDer = {};
  bool desbloqueado = false;

  void verificar() {
  bool correcto = true;

  for (int i = 0; i < preguntas.length; i++) {
    final r = preguntas[i]['respuestas'];
    if (respuestasUsuarioIzq[i] != r[0] || respuestasUsuarioDer[i] != r[1]) {
      correcto = false;
      break;
    }
  }

  setState(() => desbloqueado = correcto);

  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(correcto
        ? '¡Todas las respuestas son correctas! 🎉'
        : 'Hay respuestas incorrectas ❌'),
  ));

  // Si las respuestas son correctas, mostramos la celebración
  if (correcto) {
    Celebracion.mostrar(context);
  }
}


  void irAlSiguienteJuego() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => JuegoFrasesAImagen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Juego: Arrastra la palabra correcta')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            ...List.generate(preguntas.length, (index) {
              final p = preguntas[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    buildImagenConDrop(p['izquierda'], true, index),
                    buildCirculoDeOpciones(p['opciones']),
                    buildImagenConDrop(p['derecha'], false, index),
                  ],
                ),
              );
            }),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: verificar,
                  child: Text('Verificar respuestas'),
                ),
                SizedBox(width: 16),
                desbloqueado
                    ? ElevatedButton(
                        onPressed: irAlSiguienteJuego,
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green),
                        child: Text('Siguiente juego'),
                      )
                    : Opacity(
                        opacity: 0.4,
                        child: IgnorePointer(
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey),
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
            )
          ],
        ),
      ),
    );
  }

  Widget buildImagenConDrop(String path, bool esIzquierda, int preguntaIndex) {
    return Column(
      children: [
        Container(
          width: 100,
          height: 100,
          margin: EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
          ),
          child: Image.asset(path, fit: BoxFit.contain),
        ),
        DragTarget<String>(
          onAccept: (data) {
            setState(() {
              if (esIzquierda) {
                respuestasUsuarioIzq[preguntaIndex] = data;
              } else {
                respuestasUsuarioDer[preguntaIndex] = data;
              }
            });
          },
          builder: (context, candidateData, rejectedData) {
            final value = esIzquierda
                ? respuestasUsuarioIzq[preguntaIndex]
                : respuestasUsuarioDer[preguntaIndex];

            return Container(
              width: 100,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green),
              ),
              alignment: Alignment.center,
              child: Text(value ?? 'Arrastra aquí'),
            );
          },
        ),
      ],
    );
  }

  Widget buildCirculoDeOpciones(List<String> opciones) {
    return Container(
      width: 140,
      height: 140,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.orange[100],
        border: Border.all(color: Colors.deepOrange, width: 3),
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(2, 2))
        ],
      ),
      child: Center(
        child: Column(
  mainAxisAlignment: MainAxisAlignment.center,
  children: opciones.map((palabra) {
            return Draggable<String>(
              data: palabra,
              feedback: Material(
                color: Colors.transparent,
                child: palabraSimple(palabra, dragging: true),
              ),
              childWhenDragging:
                  Opacity(opacity: 0.3, child: palabraSimple(palabra)),
              child: palabraSimple(palabra),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget palabraSimple(String palabra, {bool dragging = false}) {
    return Text(
      palabra,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: dragging ? Colors.orange[900] : Colors.black,
      ),
    );
  }
}

// Ejemplo de la siguiente pantalla (Juego 2)
class Juego_2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Juego 2'),
      ),
      body: Center(
        child: Text(
          'Aquí va el contenido del segundo juego 🎯',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
