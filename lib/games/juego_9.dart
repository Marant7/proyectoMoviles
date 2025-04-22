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
      backgroundColor: Colors.orange[50],
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: Text('Juego: Arrastra la palabra correcta'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            ...List.generate(preguntas.length, (index) {
              final p = preguntas[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    buildImagenConDrop(p['izquierda'], true, index),
                    buildCirculoDeOpciones(p['opciones']),
                    buildImagenConDrop(p['derecha'], false, index),
                  ],
                ),
              );
            }),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: verificar,
                  icon: Icon(Icons.check_circle_outline),
                  label: Text('Verificar respuestas'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 12),
                    textStyle: TextStyle(fontSize: 16),
                  ),
                ),
                SizedBox(width: 16),
                desbloqueado
                    ? ElevatedButton.icon(
                        onPressed: irAlSiguienteJuego,
                        icon: Icon(Icons.arrow_forward),
                        label: Text('Siguiente juego'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          textStyle: TextStyle(fontSize: 16),
                        ),
                      )
                    : Opacity(
                        opacity: 0.5,
                        child: IgnorePointer(
                          child: ElevatedButton.icon(
                            onPressed: () {},
                            icon: Icon(Icons.lock),
                            label: Text('Siguiente juego'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 12),
                              textStyle: TextStyle(fontSize: 16),
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
          margin: EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.orange.shade200),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.orange.withOpacity(0.2),
                blurRadius: 8,
                offset: Offset(2, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(path, fit: BoxFit.contain),
          ),
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

            return AnimatedContainer(
              duration: Duration(milliseconds: 300),
              width: 100,
              height: 40,
              decoration: BoxDecoration(
                color: value != null ? Colors.green[100] : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: value != null ? Colors.green : Colors.grey,
                  width: 2,
                ),
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
        gradient: LinearGradient(
          colors: [Colors.orange.shade200, Colors.deepOrange.shade100],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
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
                  Opacity(opacity: 0.4, child: palabraSimple(palabra)),
              child: palabraSimple(palabra),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget palabraSimple(String palabra, {bool dragging = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Text(
        palabra,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: dragging ? Colors.deepOrange : Colors.black87,
        ),
      ),
    );
  }
}
