import 'package:flutter/material.dart';

class JuegoImagenTextoNumero extends StatefulWidget {
  @override
  State<JuegoImagenTextoNumero> createState() => _JuegoImagenTextoNumeroState();
}

class _JuegoImagenTextoNumeroState extends State<JuegoImagenTextoNumero> {
  final List<String> alternativas = [
    'campana', 'tambor', 'bombilla',
    'rueda', 'lámpara', 'compás', 'lupa'
  ];

  Map<int, String?> respuestas = {}; // key: n imagen, value: palabra asignada

  bool desbloqueado = false;

  final Map<int, String> respuestasCorrectas = {
    0: 'campana',
    1: 'tambor',
    2: 'bombilla',
    3: 'rueda',
    4: 'lámpara',
    5: 'compás',
    6: 'lupa',
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
      MaterialPageRoute(builder: (_) => JuegoSiguiente()), // reemplaza con tu siguiente juego
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
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Image.asset('assets/images/trompo.png', fit: BoxFit.contain),
        ),
        DragTarget<String>(
          onAccept: (data) {
            setState(() {
              respuestas[index] = data;
            });
          },
          builder: (context, candidateData, rejectedData) {
            return Container(
              width: 60,
              height: 40,
              margin: EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.blue),
                color: respuestas[index] != null ? Colors.blue[100] : Colors.transparent,
              ),
              alignment: Alignment.center,
              child: respuestas[index] != null
                  ? Text(
                      (alternativas.indexOf(respuestas[index]!) + 1).toString(),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  : null,
            );
          },
        )
      ],
    );
  }

  Widget buildAlternativas(List<String> opciones) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: opciones.map((palabra) {
        int numero = alternativas.indexOf(palabra) + 1;
        return Draggable<String>(
          data: palabra,
          feedback: Material(
            color: Colors.transparent,
            child: palabraArrastrable(palabra, numero, dragging: true),
          ),
          childWhenDragging:
              Opacity(opacity: 0.4, child: palabraArrastrable(palabra, numero)),
          child: palabraArrastrable(palabra, numero),
        );
      }).toList(),
    );
  }

  Widget palabraArrastrable(String palabra, int numero, {bool dragging = false}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: dragging ? Colors.orange[300] : Colors.orange[100],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.orange),
      ),
      child: Text('$numero. $palabra', style: TextStyle(fontSize: 16)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Juego: Asocia número con imagen')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [buildImagenConDrop(0), buildImagenConDrop(1), buildImagenConDrop(2)],
            ),
            SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                buildImagenConDrop(3),
                Expanded(child: Center(child: buildAlternativas(alternativas.sublist(0, 3)))),
                buildImagenConDrop(4),
              ],
            ),
            SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                buildImagenConDrop(5),
                Expanded(child: Center(child: buildAlternativas(alternativas.sublist(3, 7)))),
                buildImagenConDrop(6),
              ],
            ),
            SizedBox(height: 20),
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

class JuegoSiguiente extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('¡Siguiente juego!')),
      body: Center(child: Text('Aquí comienza el siguiente juego 🎮')),
    );
  }
}