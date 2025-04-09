import 'package:flutter/material.dart';
import 'package:flutter_jueguito/games/juego_silabas.dart';

class JuegoArrastraNumero extends StatefulWidget {
  @override
  State<JuegoArrastraNumero> createState() => _JuegoArrastraNumeroState();
}

class _JuegoArrastraNumeroState extends State<JuegoArrastraNumero> {
  final List<Map<String, dynamic>> data = [
    {
      'imagenIzq': 'assets/images/trompo.png',
      'numeroIzq': 1,
      'imagenDer': 'assets/images/trompo.png',
      'numeroDer': 2,
      'alternativas': ['ataúd', 'mitad', 'pared'],
      'respuestas': [1, 2], // dos números correctos
    },
    {
      'imagenIzq': 'assets/images/trompo.png',
      'numeroIzq': 3,
      'imagenDer': 'assets/images/trompo.png',
      'numeroDer': 4,
      'alternativas': ['óptica', 'robot', 'reloj'],
      'respuestas': [3, 4],
    },
    {
      'imagenIzq': 'assets/images/trompo.png',
      'numeroIzq': 5,
      'imagenDer': 'assets/images/trompo.png',
      'numeroDer': 6,
      'alternativas': ['reptil', 'red', 'agua'],
      'respuestas': [5, 6],
    },
    {
      'imagenIzq': 'assets/images/trompo.png',
      'numeroIzq': 7,
      'imagenDer': 'assets/images/trompo.png',
      'numeroDer': 8,
      'alternativas': ['campana', 'compás', 'bombón'],
      'respuestas': [7, 8],
    },
  ];

  // Las únicas palabras que deben aceptar número
  final List<String> alternativasConCirculo = [
    'ataúd',
    'mitad',
    'pared',
    'óptica',
    'reloj',
    'reptil',
    'red',
    'campana',
  ];

  Map<String, int?> respuestasUsuario = {}; // palabra -> número asignado
  bool desbloqueado = false;

  void verificar() {
    bool todoCorrecto = true;

    for (var fila in data) {
      List<int> respuestasCorrectas = List<int>.from(fila['respuestas']);
      bool alMenosUnaCoincide = fila['alternativas'].any(
        (palabra) => respuestasCorrectas.contains(respuestasUsuario[palabra]),
      );
      if (!alMenosUnaCoincide) {
        todoCorrecto = false;
        break;
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
    MaterialPageRoute(builder: (_) => JuegoSilabas()), // o el widget correspondiente
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Juego: Arrastra el número a la alternativa')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(children: data.map((fila) => buildFila(fila)).toList()),
      ),
      //boton de ayuda para boton de cel 
      bottomNavigationBar: SafeArea(
  child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: verificar,
                child: Text('Verificar respuestas'),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child:
                  desbloqueado
                      ? ElevatedButton(
                        onPressed: irAlSiguienteJuego,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                        child: Text('Siguiente juego'),
                      )
                      : Opacity(
                        opacity: 0.4,
                        child: IgnorePointer(
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey,
                            ),
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

  Widget buildFila(Map<String, dynamic> fila) {
    final numeroIzq = fila['numeroIzq'];
    final numeroDer = fila['numeroDer'];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          buildImagenConNumero(fila['imagenIzq'], numeroIzq),
          SizedBox(width: 35),
          Expanded(
            child: Center(
              child: buildAlternativas(
                fila['alternativas'],
                fila['respuestas'],
              ),
            ),
          ),
          SizedBox(width: 35),
          buildImagenConNumero(fila['imagenDer'], numeroDer),
        ],
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

  Widget buildAlternativas(
    List<String> alternativas,
    List<int> respuestasEsperadas,
  ) {
    return Column(
      children:
          alternativas.map((palabra) {
            final asignado = respuestasUsuario[palabra];
            final fueAsignado = asignado != null;
            final esCorrecta =
                fueAsignado && respuestasEsperadas.contains(asignado);

            Color? colorFondo;
            if (fueAsignado && desbloqueado) {
              colorFondo = esCorrecta ? Colors.green[100] : Colors.red[100];
            } else if (fueAsignado) {
              colorFondo = Colors.blue[100];
            }

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
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
                          child:
                              asignado != null
                                  ? Text(
                                    asignado.toString(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
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
          }).toList(),
    );
  }

  Widget circuloAlternativa(int? numero) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.blue),
        color: numero != null ? Colors.blue[100] : Colors.transparent,
      ),
      alignment: Alignment.center,
      child:
          numero != null
              ? Text(
                numero.toString(),
                style: TextStyle(fontWeight: FontWeight.bold),
              )
              : null,
    );
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
