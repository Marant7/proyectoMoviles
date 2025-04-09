import 'package:flutter/material.dart';

class JuegoNumeroATexto extends StatefulWidget {
  @override
  State<JuegoNumeroATexto> createState() => _JuegoNumeroATextoState();
}

class _JuegoNumeroATextoState extends State<JuegoNumeroATexto> {
  final List<String> alternativas = [
    'campana', 'tambor', 'lupa', 'bombilla', 'rueda', 'lámpara', 'compás', 'teléfono'
  ];

  final Map<int, String> numerosConPalabra = {
    1: 'campana',
    2: 'tambor',
    3: 'lupa',
    4: 'bombilla',
    5: 'rueda',
    6: 'lámpara'
  };

  Map<String, int?> respuestasUsuario = {};
  bool desbloqueado = false;

  void verificar() {
    bool todasCorrectas = true;
    for (var palabra in numerosConPalabra.values) {
      if (respuestasUsuario[palabra] != null &&
          numerosConPalabra[respuestasUsuario[palabra]] != palabra) {
        todasCorrectas = false;
        break;
      }
    }

    setState(() => desbloqueado = todasCorrectas);

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(todasCorrectas
          ? '¡Todas las respuestas son correctas! 🎉'
          : 'Hay errores. Intenta nuevamente ❌'),
    ));
  }

  void irAlSiguienteJuego() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => JuegoSiguiente()),
    );
  }

  Widget imagenConNumero(int numero) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.topRight,
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
            Positioned(
              right: 12,
              top: 8,
              child: Draggable<int>(
                data: numero,
                feedback: Material(
                  color: Colors.transparent,
                  child: Text('$numero',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.orange)),
                ),
                childWhenDragging: Opacity(
                  opacity: 0.3,
                  child: Text('$numero',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18)),
                ),
                child: Text('$numero',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.deepOrange)),
              ),
            )
          ],
        )
      ],
    );
  }

  Widget alternativaTexto(String palabra) {
    final numeroAsignado = respuestasUsuario[palabra];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
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
                  width: 32,
                  height: 32,
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
          SizedBox(width: 10),
          Text(palabra, style: TextStyle(fontSize: 16))
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
                Column(
                  children: [
                    imagenConNumero(1),
                    imagenConNumero(2),
                    imagenConNumero(3),
                  ],
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    children:
                        alternativas.map((e) => alternativaTexto(e)).toList(),
                  ),
                ),
                SizedBox(width: 12),
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
            )
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
      appBar: AppBar(title: Text('Siguiente juego')),
      body: Center(child: Text('Aquí va el siguiente juego ✨')),
    );
  }
}