import 'package:flutter/material.dart';
import 'package:flutter_jueguito/games/juego_7.dart';

class JuegoArrastraNumero extends StatefulWidget {
  @override
  State<JuegoArrastraNumero> createState() => _JuegoArrastraNumeroState();
}

class _JuegoArrastraNumeroState extends State<JuegoArrastraNumero> {
  final List<Map<String, dynamic>> data = [
    {'imagen': 'assets/images/silla.png', 'numero': 1, 'palabra': 'silla'},
    {'imagen': 'assets/images/pollo.png', 'numero': 2, 'palabra': 'pollo'},
    {'imagen': 'assets/images/olla.png', 'numero': 3, 'palabra': 'olla'},
    {'imagen': 'assets/images/camello.png', 'numero': 4, 'palabra': 'camello'},
    {'imagen': 'assets/images/cepillo.png', 'numero': 5, 'palabra': 'cepillo'},
    {'imagen': 'assets/images/gallo.png', 'numero': 6, 'palabra': 'gallo'},
    {'imagen': 'assets/images/ballena.png', 'numero': 7, 'palabra': 'ballena'},
    {'imagen': 'assets/images/caballo.png', 'numero': 8, 'palabra': 'caballo'},
  ];

  final List<String> alternativas = [
    'silla',
    'pollo',
    'olla',
    'camello',
    'cepillo',
    'gallo',
    'ballena',
    'caballo',
    'embudo', // distractora
  ];

  Map<String, int?> respuestasUsuario = {};
  bool desbloqueado = false;

  void verificar() {
    bool todoCorrecto = true;

    for (var fila in data) {
      final palabraCorrecta = fila['palabra'];
      final numeroCorrecto = fila['numero'];

      if (respuestasUsuario[palabraCorrecta] != numeroCorrecto) {
        todoCorrecto = false;
        break;
      }
    }

    for (var palabra in respuestasUsuario.keys) {
      if (!data.any((d) => d['palabra'] == palabra)) {
        if (respuestasUsuario[palabra] != null) {
          todoCorrecto = false;
          break;
        }
      }
    }

    setState(() => desbloqueado = todoCorrecto);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          todoCorrecto
              ? '¡Todas las respuestas son correctas! 🎉'
              : 'Hay errores. Intenta nuevamente ❌',
        ),
      ),
    );
  }

  void irAlSiguienteJuego() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => JuegoImagenTextoNumero()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Juego: Arrastra el número a la palabra')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Wrap(
              spacing: 20,
              runSpacing: 20,
              children: data
                  .map((item) =>
                      buildImagenConNumero(item['imagen'], item['numero']))
                  .toList(),
            ),
            const SizedBox(height: 12),
            Text('Alternativas',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Wrap(
              spacing: 32,
              runSpacing: 16,
              children: buildAlternativas(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: verificar,
                  child: Text('Verificar respuestas'),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: desbloqueado
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildImagenConNumero(String path, int numero) {
    return Column(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Image.asset(path, fit: BoxFit.contain),
        ),
        SizedBox(height: 8),
        Draggable<int>(
          data: numero,
          feedback: Material(
            color: Colors.transparent,
            child: numeroCirculo(numero, dragging: true),
          ),
          childWhenDragging: Opacity(
            opacity: 0.3,
            child: numeroCirculo(numero),
          ),
          child: numeroCirculo(numero),
        ),
      ],
    );
  }

  List<Widget> buildAlternativas() {
    return alternativas.map((palabra) {
      final asignado = respuestasUsuario[palabra];

      final Map<String, dynamic>? palabraCorrecta = data.firstWhere(
        (element) => element['palabra'] == palabra,
        orElse: () => {},
      );

      final esCorrecta = palabraCorrecta != null &&
          asignado == palabraCorrecta['numero'];

      Color? colorFondo;
      if (asignado != null && desbloqueado) {
        colorFondo = esCorrecta ? Colors.green[100] : Colors.red[100];
      } else if (asignado != null) {
        colorFondo = Colors.blue[100];
      }

      return ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 160),
        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                if (asignado != null) {
                  setState(() {
                    respuestasUsuario[palabra] = null;
                  });
                }
              },
              child: DragTarget<int>(
                onAccept: (numero) {
                  setState(() {
                    respuestasUsuario[palabra] = numero;
                  });
                },
                builder: (context, candidateData, rejectedData) {
                  return Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.blue),
                      color: colorFondo ?? Colors.transparent,
                    ),
                    alignment: Alignment.center,
                    child: asignado != null
                        ? Text(
                            asignado.toString(),
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )
                        : null,
                  );
                },
              ),
            ),
            SizedBox(width: 8),
            Text(palabra, style: TextStyle(fontSize: 16)),
          ],
        ),
      );
    }).toList();
  }

  Widget numeroCirculo(int numero, {bool dragging = false}) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: dragging ? Colors.orange[300] : Colors.orange[100],
        shape: BoxShape.circle,
        border: Border.all(color: Colors.deepOrange),
      ),
      alignment: Alignment.center,
      child: Text(
        numero.toString(),
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}
