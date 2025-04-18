import 'package:flutter/material.dart';
import 'package:flutter_jueguito/games/juego_9.dart';

class JuegoNumeroATexto extends StatefulWidget {
  @override
  State<JuegoNumeroATexto> createState() => _JuegoNumeroATextoState();
}

class _JuegoNumeroATextoState extends State<JuegoNumeroATexto> {
  final List<String> alternativas = [
    'carta',
    'cerdo',
    'arco',
    'tortuga',
    'ardilla',
    'martillo',
    'compás',
    'teléfono',
  ];

  final List<String> imagenes = [
    'assets/images/carta.png',
    'assets/images/cerdo.png',
    'assets/images/arco.png',
    'assets/images/tortuga.png',
    'assets/images/ardilla.png',
    'assets/images/martillo.png',
  ];

  final Map<int, String> numerosConPalabra = {
    1: 'carta',
    2: 'cerdo',
    3: 'arco',
    4: 'tortuga',
    5: 'ardilla',
    6: 'martillo',
  };

  Map<String, int?> respuestasUsuario = {};
  bool desbloqueado = false;

  void verificar() {
    bool todasCorrectas = true;

    for (var palabra in numerosConPalabra.values) {
      int? numeroAsignado = respuestasUsuario[palabra];
      if (numeroAsignado == null ||
          numerosConPalabra[numeroAsignado] != palabra) {
        todasCorrectas = false;
        break;
      }
    }

    if (respuestasUsuario['compás'] != null ||
        respuestasUsuario['teléfono'] != null) {
      todasCorrectas = false;
    }

    setState(() => desbloqueado = todasCorrectas);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          todasCorrectas
              ? '¡Todas las respuestas son correctas! 🎉'
              : 'Hay errores. Intenta nuevamente ❌',
        ),
      ),
    );
  }

  void irAlSiguienteJuego() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => JuegoConDosImagenes2()),
    );
  }

  Widget imagenConNumero(int numero) {
    final String rutaImagen = imagenes[numero - 1];

    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 22,
        horizontal: 16,
      ), // antes era all(6)
      child: Column(
        children: [
          Stack(
            alignment: Alignment.topRight,
            children: [
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Image.asset(rutaImagen, fit: BoxFit.contain),
              ),
              Positioned(
                right: 10,
                top: 8,
                child: Draggable<int>(
                  data: numero,
                  feedback: Material(
                    color: Colors.transparent,
                    child: Text(
                      '$numero',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  childWhenDragging: Opacity(
                    opacity: 0.3,
                    child: Text(
                      '$numero',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  child: Text(
                    '$numero',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget alternativaTexto(String palabra) {
  final numeroAsignado = respuestasUsuario[palabra];

  return Container(
    width: 120, // Ancho fijo para alinear todos los ítems igual
    margin: const EdgeInsets.symmetric(vertical: 10),
    child: Row(
      children: [
        DragTarget<int>(
          onAccept: (numero) {
            setState(() {
              respuestasUsuario[palabra] = numero;
            });
          },
          builder: (context, candidateData, rejectedData) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  respuestasUsuario[palabra] = null;
                });
              },
              child: Container(
                width: 40, // Tamaño del círculo
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.blue),
                  color: numeroAsignado != null
                      ? Colors.blue[100]
                      : Colors.transparent,
                ),
                alignment: Alignment.center,
                child: numeroAsignado != null
                    ? Text(
                        numeroAsignado.toString(),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )
                    : null,
              ),
            );
          },
        ),
        SizedBox(width: 16),
        Expanded(
          child: Text(
            palabra,
            style: TextStyle(fontSize: 16),
          ),
        ),
      ],
    ),
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Juego: Arrastra el número al texto')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 3 imágenes a la izquierda
                Column(
                  children: [
                    imagenConNumero(1),
                    imagenConNumero(2),
                    imagenConNumero(3),
                  ],
                ),
                // Alternativas al centro
                Expanded(
                  child: Column(
                    children:
                        alternativas.map((e) => alternativaTexto(e)).toList(),
                  ),
                ),
                // 3 imágenes a la derecha
                Column(
                  children: [
                    imagenConNumero(4),
                    imagenConNumero(5),
                    imagenConNumero(6),
                  ],
                ),
              ],
            ),
            SizedBox(height: 30),
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
              ],
            ),
          ],
        ),
      ),
    );
  }
}
