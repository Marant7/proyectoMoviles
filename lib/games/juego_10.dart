import 'package:flutter/material.dart';
import 'package:flutter_jueguito/games/juego_silabas.dart';
import 'package:flutter_jueguito/mensaje/celebracion.dart';

class JuegoFrasesAImagen extends StatefulWidget {
  @override
  State<JuegoFrasesAImagen> createState() => _JuegoFrasesAImagenState();
}

class _JuegoFrasesAImagenState extends State<JuegoFrasesAImagen> {
  final List<Map<String, dynamic>> data = [
    {
      'imagen': 'assets/images/guido.png',
      'fraseCorrecta': 'Guido repara mi juguete',
    },
    {
      'imagen': 'assets/images/guille.png',
      'fraseCorrecta': 'Guille llego de la guerra',
    },
    {
      'imagen': 'assets/images/gaby.png',
      'fraseCorrecta': 'Gaby come guiso de pollo',
    },
  ];

  final List<String> frases = [
    'Guido repara mi juguete',
    'Guille llego de la guerra',
    'Gaby come guiso de pollo',
    'German juega al futbol', // frase distractora
  ];

  Map<int, String?> respuestas = {}; // índice de imagen => frase asignada
  bool desbloqueado = false;

 void verificar() {
  bool todoBien = true;

  for (int i = 0; i < data.length; i++) {
    if (respuestas[i] != data[i]['fraseCorrecta']) {
      todoBien = false;
      break;
    }
  }

  setState(() {
    desbloqueado = todoBien;
  });

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        todoBien
            ? '¡Todas las frases son correctas! 🎉'
            : 'Hay errores. Intenta de nuevo ❌',
      ),
    ),
  );

  // Mostrar celebración si las respuestas son correctas
  if (todoBien) {
    Celebracion.mostrar(context);
  }
}

  void irAlSiguienteJuego() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => JuegoSilabas()));
  }

  Widget buildImagenConDrop(int index) {
    return Column(
      children: [
        Container(
          width: 120,
          height: 120,
          margin: EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Image.asset(data[index]['imagen'], fit: BoxFit.contain),
        ),
        DragTarget<String>(
          onAccept: (frase) {
            setState(() {
              respuestas[index] = frase;
            });
          },
          builder: (context, candidateData, rejectedData) {
            return Container(
              margin: EdgeInsets.only(bottom: 12),
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color:
                    respuestas[index] != null
                        ? Colors.blue[100]
                        : Colors.transparent,
                border: Border.all(color: Colors.blue),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                respuestas[index] ?? 'Arrastra aquí',
                style: TextStyle(fontSize: 14),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget buildFraseDraggable(String frase) {
    return Draggable<String>(
      data: frase,
      feedback: Material(
        color: Colors.transparent,
        child: fraseArrastrable(frase, dragging: true),
      ),
      childWhenDragging: Opacity(opacity: 0.4, child: fraseArrastrable(frase)),
      child: fraseArrastrable(frase),
    );
  }

  Widget fraseArrastrable(String frase, {bool dragging = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: dragging ? Colors.orange[300] : Colors.orange[100],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.orange),
      ),
      child: Text(frase, style: TextStyle(fontSize: 16)),
    );
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Arrastra la frase a la imagen'),
      backgroundColor: Colors.deepPurple,
    ),
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Relaciona cada imagen con su frase correspondiente',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Wrap(
            spacing: 20,
            runSpacing: 20,
            alignment: WrapAlignment.center,
            children: List.generate(data.length, buildImagenConDrop),
          ),
          Divider(height: 40),
          Text(
            'Frases disponibles:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          ...frases.map(buildFraseDraggable),
          SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: verificar,
                icon: Icon(Icons.check_circle),
                label: Text('Verificar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 169, 144, 211),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
              ),
              SizedBox(width: 20),
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
