import 'package:flutter/material.dart';
import 'package:flutter_jueguito/games/juego_4.dart';
import 'package:flutter_jueguito/games/juego_6.dart';
import 'juego_4.dart'; // ⚠️ Asegúrate de que este archivo exista

class JuegoNumerosImagen extends StatefulWidget {
  @override
  State<JuegoNumerosImagen> createState() => _JuegoNumerosImagenState();
}

class _JuegoNumerosImagenState extends State<JuegoNumerosImagen> {
  final List<Map<String, dynamic>> imagenes = [
    {'path': 'assets/images/pared.png', 'respuesta': 3},
    {'path': 'assets/images/mitad.png', 'respuesta': 2},
    {'path': 'assets/images/red.png', 'respuesta': 8},
    {'path': 'assets/images/optica.png', 'respuesta': 4},
    {'path': 'assets/images/reptil.png', 'respuesta': 7},
    {'path': 'assets/images/reloj.png', 'respuesta': 6},
  ];

  final List<Map<String, dynamic>> opciones = [
    {'numero': 1, 'texto': 'ataúd'},
    {'numero': 2, 'texto': 'mitad'},
    {'numero': 3, 'texto': 'pared'},
    {'numero': 4, 'texto': 'óptica'},
    {'numero': 5, 'texto': 'robot'},
    {'numero': 6, 'texto': 'reloj'},
    {'numero': 7, 'texto': 'reptil'},
    {'numero': 8, 'texto': 'red'},
  ];

  Map<int, int?> respuestasUsuario = {};
  bool desbloqueado = false;

  void verificarRespuestas() {
    bool todoCorrecto = true;

    for (int i = 0; i < imagenes.length; i++) {
      final correcta = imagenes[i]['respuesta'];
      final usuario = respuestasUsuario[i];
      if (usuario != correcta) {
        todoCorrecto = false;
        break;
      }
    }

    setState(() {
      desbloqueado = todoCorrecto;
    });

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(todoCorrecto
          ? '¡Todas las respuestas son correctas! 🎉'
          : 'Hay respuestas incorrectas ❌'),
    ));
  }

  void irAlSiguienteJuego() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => JuegoArrastraNumero()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Juego: Arrastra el número correcto')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: imagenes.sublist(0, 3).asMap().entries.map((entry) {
                        return buildImagen(entry.key, entry.value['path']);
                      }).toList(),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: opciones.map((op) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Draggable<int>(
                            data: op['numero'],
                            feedback: Material(
                              color: Colors.transparent,
                              child: numeroEnCirculo(op['numero'], dragging: true),
                            ),
                            childWhenDragging: Opacity(
                              opacity: 0.3,
                              child: numeroTexto(op['numero'], op['texto']),
                            ),
                            child: numeroTexto(op['numero'], op['texto']),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: imagenes.sublist(3, 6).asMap().entries.map((entry) {
                        return buildImagen(entry.key + 3, entry.value['path']);
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: verificarRespuestas,
              child: Text('Verificar respuestas'),
            ),
            SizedBox(height: 10),
            desbloqueado
                ? ElevatedButton(
                    onPressed: irAlSiguienteJuego,
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    child: Text('Siguiente juego'),
                  )
                : Opacity(
                    opacity: 0.4,
                    child: IgnorePointer(
                      child: ElevatedButton(
                        onPressed: () {},
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

  Widget buildImagen(int index, String path) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          Container(
            width: 100,
            height: 100,
            margin: EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Image.asset(path, fit: BoxFit.contain),
          ),
          DragTarget<int>(
            onAccept: (numero) {
              setState(() {
                respuestasUsuario[index] = numero;
              });
            },
            builder: (context, candidateData, rejectedData) {
              return Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.blue, width: 2),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: respuestasUsuario[index] != null
                    ? Text(
                        respuestasUsuario[index].toString(),
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      )
                    : null,
              );
            },
          )
        ],
      ),
    );
  }

  Widget numeroTexto(int numero, String texto) {
    return Row(
      children: [
        numeroEnCirculo(numero),
        SizedBox(width: 8),
        Text(texto, style: TextStyle(fontSize: 16)),
      ],
    );
  }

  Widget numeroEnCirculo(int numero, {bool dragging = false}) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: dragging ? Colors.blue[200] : Colors.blue[100],
        shape: BoxShape.circle,
        border: Border.all(color: Colors.blue),
      ),
      alignment: Alignment.center,
      child: Text(
        numero.toString(),
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}
