import 'package:flutter/material.dart';
import 'package:flutter_jueguito/games/juego_4.dart';
import 'package:flutter_jueguito/games/juego_6.dart';
import 'package:flutter_jueguito/mensaje/celebracion.dart';
import 'juego_4.dart'; // ⚠️ Asegúrate de que este archivo exista

// Importaciones iguales que antes...

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
      if (respuestasUsuario[i] != imagenes[i]['respuesta']) {
        todoCorrecto = false;
        break;
      }
    }

    setState(() {
      desbloqueado = todoCorrecto;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(todoCorrecto
            ? '¡Todas las respuestas son correctas! 🎉'
            : 'Hay respuestas incorrectas ❌'),
      ),
    );

    if (todoCorrecto) {
      Future.delayed(Duration(milliseconds: 500), () {
        Celebracion.mostrar(context);
      });
    }
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
      appBar: AppBar(
        title: Text('Juego: Arrastra el número correcto'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(child: buildImageColumn(imagenes.sublist(0, 3), 0)),
                  Expanded(child: buildOpciones()),
                  Expanded(child: buildImageColumn(imagenes.sublist(3), 3)),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: verificarRespuestas,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 162, 141, 198),
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text('Verificar respuestas', style: TextStyle(fontSize: 18)),
            ),
            const SizedBox(height: 10),
            desbloqueado
                ? ElevatedButton(
                    onPressed: irAlSiguienteJuego,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text('Siguiente juego', style: TextStyle(fontSize: 18)),
                  )
                : Opacity(
                    opacity: 0.4,
                    child: IgnorePointer(
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: Icon(Icons.lock),
                        label: Text('Siguiente juego'),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget buildImageColumn(List<Map<String, dynamic>> lista, int offset) {
    return Column(
      children: lista.asMap().entries.map((entry) {
        int index = offset + entry.key;
        return buildImagen(index, entry.value['path']);
      }).toList(),
    );
  }

  Widget buildImagen(int index, String path) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        children: [
          Container(
            width: 100,
            height: 100,
            margin: EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(2, 2)),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(path, fit: BoxFit.contain),
            ),
          ),
          DragTarget<int>(
            onAccept: (numero) {
              setState(() {
                respuestasUsuario[index] = numero;
              });
            },
            builder: (context, candidateData, rejectedData) {
              return AnimatedContainer(
                duration: Duration(milliseconds: 300),
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  border: Border.all(color: Colors.blue, width: 2),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: respuestasUsuario[index] != null
                    ? Text(
                        respuestasUsuario[index].toString(),
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      )
                    : Text("?", style: TextStyle(fontSize: 20, color: Colors.grey)),
              );
            },
          )
        ],
      ),
    );
  }

  Widget buildOpciones() {
    return SingleChildScrollView(
      child: Column(
        children: opciones.map((op) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
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
    );
  }

  Widget numeroTexto(int numero, String texto) {
    return Row(
      children: [
        numeroEnCirculo(numero),
        const SizedBox(width: 12),
        Expanded(child: Text(texto, style: TextStyle(fontSize: 16))),
      ],
    );
  }

  Widget numeroEnCirculo(int numero, {bool dragging = false}) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: dragging ? Colors.blue[300] : Colors.blue[100],
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
