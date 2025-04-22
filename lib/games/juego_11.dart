import 'package:flutter/material.dart';
import 'package:flutter_jueguito/games/juego_8.dart';
import 'package:flutter_jueguito/mensaje/celebracion.dart';

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

  if (todasCorrectas) {
    // Mostrar la celebración
    Celebracion.mostrar(context);
  }
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
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.asset(imagenes[index], fit: BoxFit.cover),
        ),
      ),
      SizedBox(height: 8),
      DragTarget<String>(
        onAccept: (data) {
          setState(() => respuestas[index] = data);
        },
        builder: (context, candidateData, rejectedData) {
          return Container(
            width: 130,
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: respuestas[index] != null ? Colors.blue[100] : Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue),
            ),
            alignment: Alignment.center,
            child: Text(
              respuestas[index] ?? 'Arrastra aquí',
              style: TextStyle(
                fontWeight: FontWeight.w500,
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
    appBar: AppBar(
      title: Text('Juego: Palabra e imagen'),
      backgroundColor: Colors.deepPurple,
    ),
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Asocia cada palabra con su imagen correspondiente',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            alignment: WrapAlignment.center,
            children: List.generate(imagenes.length, buildImagenConDrop),
          ),
          Divider(height: 40),
          Text(
            'Arrastra una palabra:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
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
              ElevatedButton.icon(
                onPressed: verificar,
                icon: Icon(Icons.check),
                label: Text('Verificar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 166, 146, 201),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
              ),
              SizedBox(width: 16),
              desbloqueado
                  ? ElevatedButton.icon(
                      onPressed: irAlSiguienteJuego,
                      icon: Icon(Icons.arrow_forward),
                      label: Text('Siguiente'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      ),
                    )
                  : SizedBox.shrink(),
            ],
          ),
        ],
      ),
    ),
  );
}

}
