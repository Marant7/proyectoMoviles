import 'package:flutter/material.dart';
import 'package:flutter_jueguito/games/juego_silabas.dart';

class JuegoSilabaFinal extends StatefulWidget {
  @override
  State<JuegoSilabaFinal> createState() => _JuegoSilabaFinalState();
}

class _JuegoSilabaFinalState extends State<JuegoSilabaFinal> {
  final List<Map<String, dynamic>> data = [
    {'imagen': 'assets/images/fuego.png', 'texto': 'fue', 'respuesta': 'go'},
    {'imagen': 'assets/images/rueda.png', 'texto': 'rue', 'respuesta': 'da'},
    {'imagen': 'assets/images/huevo.png', 'texto': 'hue', 'respuesta': 'vo'},
    {'imagen': 'assets/images/rey.png', 'texto': 're', 'respuesta': 'y'},
    {'imagen': 'assets/images/jaula.png', 'texto': 'jau', 'respuesta': 'la'},
    {'imagen': 'assets/images/auto.png', 'texto': 'au', 'respuesta': 'to'},
  ];

  final List<String> alternativas = ['go', 'da', 'vo', 'y', 'la', 'to', 'ma', 'zo'];

  Map<int, String?> respuestasUsuario = {};
  bool desbloqueado = false;

  void verificar() {
    bool todasCorrectas = true;

    for (int i = 0; i < data.length; i++) {
      if (respuestasUsuario[i] != data[i]['respuesta']) {
        todasCorrectas = false;
        break;
      }
    }

    setState(() {
      desbloqueado = todasCorrectas;
    });

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(todasCorrectas
          ? '¡Correcto! Todas las sílabas coinciden 🎉'
          : 'Hay errores, inténtalo de nuevo ❌'),
    ));
  }

  Widget buildImagen(int index) {
    final item = data[index];
    return Column(
      children: [
        Container(
          width: 100,
          height: 100,
          margin: EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Image.asset(item['imagen'], fit: BoxFit.contain),
        ),
        SizedBox(height: 4),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(item['texto'], style: TextStyle(fontSize: 18)),
            SizedBox(width: 4),
            DragTarget<String>(
              onAccept: (data) {
                setState(() {
                  respuestasUsuario[index] = data;
                });
              },
              builder: (context, candidateData, rejectedData) {
                return Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: respuestasUsuario[index] != null ? Colors.blue[100] : Colors.white,
                    border: Border.all(color: Colors.blue),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    respuestasUsuario[index] ?? '',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget buildAlternativa(String silaba) {
    return Draggable<String>(
      data: silaba,
      feedback: Material(
        color: Colors.transparent,
        child: silabaWidget(silaba, dragging: true),
      ),
      childWhenDragging: Opacity(opacity: 0.4, child: silabaWidget(silaba)),
      child: silabaWidget(silaba),
    );
  }

  Widget silabaWidget(String silaba, {bool dragging = false}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: dragging ? Colors.orange[300] : Colors.orange[100],
        border: Border.all(color: Colors.orange),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(silaba, style: TextStyle(fontSize: 16)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Juego: Completa la sílaba final')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 20,
              runSpacing: 20,
              children: List.generate(data.length, (index) => buildImagen(index)),
            ),
            SizedBox(height: 24),
            Text('Opciones:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: alternativas.map(buildAlternativa).toList(),
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: verificar,
              child: Text('Verificar respuestas'),
            ),
            SizedBox(height: 16),
            desbloqueado
                ? ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => JuegoSilabas()),
                      );
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    child: Text('Siguiente juego'),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
