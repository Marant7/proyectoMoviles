import 'package:flutter/material.dart';
import 'package:flutter_jueguito/games/juego_8.dart';

class Juego11 extends StatefulWidget {
  @override
  State<Juego11> createState() => _Juego11State();
}

class _Juego11State extends State<Juego11> {
  final List<String> alternativas = [
    'león', 'botón', 'betún',
    'patín', 'sillón', 'naranja', 'manzana'
  ];

  final List<String> imagenes = [
    'assets/images/leon.png',
    'assets/images/patin.png',
    'assets/images/sillon.png',
    'assets/images/naranja.png',
    'assets/images/manzana.png',
    'assets/images/boton.png',
    'assets/images/betun.png',
  ];

  Map<int, String?> respuestas = {};
  bool desbloqueado = false;

  final Map<int, String> respuestasCorrectas = {
  0: 'león',
  1: 'patín',
  2: 'sillón',
  3: 'naranja',
  4: 'manzana',
  5: 'botón',
  6: 'betún',
};

  void verificar() {
    bool todasCorrectas = true;

    for (int i = 0; i < respuestasCorrectas.length; i++) {
      if (respuestas[i] != respuestasCorrectas[i]) {
        todasCorrectas = false;
        break;
      }
    }

    setState(() {
      desbloqueado = todasCorrectas;
    });

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(todasCorrectas
          ? '¡Todas las respuestas son correctas! 🎉'
          : 'Hay errores. Intenta nuevamente ❌'),
    ));
  }

  void irAlSiguienteJuego() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => JuegoNumeroATexto()),
    );
  }

  Widget buildImagenConDrop(int index) {
    return Column(
      children: [
        Container(
          width: 90,
          height: 90,
          margin: EdgeInsets.all(8),
          decoration: BoxDecoration(
  borderRadius: BorderRadius.circular(8), // bordes redondeados
  border: Border.all(color: Colors.blue),
  color: respuestas[index] != null ? Colors.blue[100] : Colors.transparent,
),

          child: Image.asset(imagenes[index], fit: BoxFit.contain),
        ),
       DragTarget<String>(
  onAccept: (data) {
    setState(() {
      respuestas[index] = data;
    });
  },
  builder: (context, candidateData, rejectedData) {
    return Container(
      width: 100,
      height: 40,
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue),
        color: respuestas[index] != null ? Colors.blue[100] : Colors.transparent,
      ),
      alignment: Alignment.center,
      child: Text(
        respuestas[index] ?? '',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        textAlign: TextAlign.center,
      ),
    );
  },
),
      ],
    );
  }

  List<Widget> buildAlternativas(List<String> opciones) {
    return opciones.map((palabra) {
      return Draggable<String>(
        data: palabra,
        feedback: Material(
          color: Colors.transparent,
          child: palabraArrastrable(palabra, dragging: true),
        ),
        childWhenDragging:
            Opacity(opacity: 0.4, child: palabraArrastrable(palabra)),
        child: palabraArrastrable(palabra),
      );
    }).toList();
  }

  Widget palabraArrastrable(String palabra, {bool dragging = false}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: dragging ? Colors.orange[300] : Colors.orange[100],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.orange),
      ),
      child: Text(palabra, style: TextStyle(fontSize: 16)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Juego: Arrastra la palabra a la imagen')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Asocia la palabra con la imagen correcta',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            Wrap(
              spacing: 10,
              runSpacing: 5,
              alignment: WrapAlignment.center,
              children: List.generate(
                imagenes.length,
                (index) => buildImagenConDrop(index),
              ),
            ),
            SizedBox(height: 12),
            Text('Alternativas',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: buildAlternativas(alternativas),
            ),
            SizedBox(height: 32),
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
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                        child: Text('Siguiente juego'),
                      )
                    : Opacity(
                        opacity: 0.4,
                        child: IgnorePointer(
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
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
          ],
        ),
      ),
    );
  }
}
