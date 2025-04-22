import 'package:flutter/material.dart';
import 'package:flutter_jueguito/games/juego_silabas.dart';
import 'package:flutter_jueguito/mensaje/celebracion.dart';

class JuegoRimasImagen extends StatefulWidget {
  @override
  _JuegoRimasImagenState createState() => _JuegoRimasImagenState();
}

class _JuegoRimasImagenState extends State<JuegoRimasImagen> {
  final List<Map<String, dynamic>> imagenes = [
    {'path': 'assets/images/lata.png', 'nombre': 'lata', 'rima': 'pata'},
    {'path': 'assets/images/pala.png', 'nombre': 'pala', 'rima': 'mala'},
    {'path': 'assets/images/pino.png', 'nombre': 'pino', 'rima': 'tino'},
    {'path': 'assets/images/tapa.png', 'nombre': 'tapa', 'rima': 'papa'},
  ];

  final List<String> alternativas = [
    'nata', 'lino', 'pata',
    'mala', 'sala', 'mapa',
    'papa', 'tino'
  ];

  Map<int, List<String?>> respuestasUsuario = {
    0: [null, null],
    1: [null, null],
    2: [null, null],
    3: [null, null],
  };

  bool desbloqueado = false;

  void verificar() {
    bool correcto = true;
    for (int i = 0; i < imagenes.length; i++) {
      final rimaCorrecta = imagenes[i]['rima'];
      if (!respuestasUsuario[i]!.contains(rimaCorrecta)) {
        correcto = false;
        break;
      }
    }

    setState(() => desbloqueado = correcto);

    if (correcto) {
      // Mostrar la celebración al finalizar correctamente
      Celebracion.mostrar(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Hay errores en las rimas ❌'),
      ));
    }
  }

  Widget buildImagen(int index) {
    final img = imagenes[index];
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 100,
          height: 100,
          child: Image.asset(img['path'], fit: BoxFit.contain),
        ),
        SizedBox(height: 8),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blue),
            borderRadius: BorderRadius.circular(12),
            color: Colors.blue[50],
          ),
          child: Text(
            img['nombre'],
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(2, (pos) => buildDropZone(index, pos)),
        )
      ],
    );
  }

  Widget buildDropZone(int imgIndex, int posIndex) {
    final palabra = respuestasUsuario[imgIndex]![posIndex];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: DragTarget<String>(
        onAccept: (data) {
          setState(() {
            respuestasUsuario[imgIndex]![posIndex] = data;
          });
        },
        builder: (context, candidateData, rejectedData) {
          return Container(
            width: 70,
            height: 45,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: palabra != null ? Colors.orange[100] : Colors.white,
              border: Border.all(color: Colors.orange),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
            ),
            child: Text(
              palabra ?? '',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          );
        },
      ),
    );
  }

  Widget buildDraggable(String palabra) {
    return Draggable<String>(
      data: palabra,
      feedback: Material(
        color: Colors.transparent,
        child: palabraWidget(palabra, dragging: true),
      ),
      childWhenDragging:
          Opacity(opacity: 0.3, child: palabraWidget(palabra)),
      child: palabraWidget(palabra),
    );
  }

  Widget palabraWidget(String palabra, {bool dragging = false}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: dragging ? Colors.orange[300] : Colors.orange[100],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.orange),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
      ),
      child: Text(
        palabra,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Juego: Arrastra la rima correcta')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Cuadrícula 2x2
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  buildImagen(0),
                  buildImagen(1),
                ],
              ),
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  buildImagen(2),
                  buildImagen(3),
                ],
              ),
              SizedBox(height: 24),
              Text(
                'Rimas:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepOrange,
                ),
              ),
              SizedBox(height: 12),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                alignment: WrapAlignment.center,
                children: alternativas.map(buildDraggable).toList(),
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: verificar,
                child: Text('Verificar respuestas'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                  textStyle: TextStyle(fontSize: 18),
                  backgroundColor: Colors.orange[700],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              SizedBox(height: 12),
              if (desbloqueado)
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => JuegoSilabas()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                    textStyle: TextStyle(fontSize: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text('Siguiente juego'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
