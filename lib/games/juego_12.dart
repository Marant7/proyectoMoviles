import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

import 'package:flutter_jueguito/games/juego_silabas.dart';

class JuegoMemoriaParejas extends StatefulWidget {
  @override
  _JuegoMemoriaParejasState createState() => _JuegoMemoriaParejasState();
}

class _JuegoMemoriaParejasState extends State<JuegoMemoriaParejas> {
  // ✅ Solo 6 imágenes base (6 pares)
  List<String> imagenes = [
    'assets/images/brocha.png',
    'assets/images/bruja.png',
    'assets/images/timbre.png',
    'assets/images/brazo.png',
    'assets/images/libro.png',
    'assets/images/conejo.png',
  ];

  List<_Tarjeta> tarjetas = [];
  List<int> seleccionadas = [];
  bool bloqueado = false;
  bool completado = false;

  @override
  void initState() {
    super.initState();
    iniciarJuego();
  }

  void iniciarJuego() {
    final todas = [...imagenes, ...imagenes];
    todas.shuffle(Random());

    tarjetas = List.generate(todas.length, (i) {
      return _Tarjeta(imagen: todas[i], descubierta: false, emparejada: false);
    });

    seleccionadas.clear();
    completado = false;
    setState(() {});
  }

  void seleccionarTarjeta(int index) {
    if (bloqueado || tarjetas[index].descubierta || tarjetas[index].emparejada) return;

    setState(() {
      tarjetas[index].descubierta = true;
      seleccionadas.add(index);
    });

    if (seleccionadas.length == 2) {
      bloquearTemporalmente();

      Future.delayed(Duration(milliseconds: 800), () {
        final idx1 = seleccionadas[0];
        final idx2 = seleccionadas[1];

        if (tarjetas[idx1].imagen == tarjetas[idx2].imagen) {
          tarjetas[idx1].emparejada = true;
          tarjetas[idx2].emparejada = true;
        } else {
          tarjetas[idx1].descubierta = false;
          tarjetas[idx2].descubierta = false;
        }

        seleccionadas.clear();
        desbloquear();

        if (tarjetas.every((t) => t.emparejada)) {
          setState(() => completado = true);
        }
      });
    }
  }

  void bloquearTemporalmente() => setState(() => bloqueado = true);
  void desbloquear() => setState(() => bloqueado = false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Juego de Memoria - 6 Pares')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              child: GridView.builder(
                itemCount: tarjetas.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // 3 columnas
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemBuilder: (context, index) {
                  final tarjeta = tarjetas[index];
                  return GestureDetector(
                    onTap: () => seleccionarTarjeta(index),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.grey[200],
                        border: Border.all(color: Colors.blue),
                      ),
                      child: tarjeta.descubierta || tarjeta.emparejada
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset(tarjeta.imagen, fit: BoxFit.contain),
                            )
                          : Center(child: Icon(Icons.question_mark, size: 36, color: Colors.grey)),
                    ),
                  );
                },
              ),
            ),
            if (completado)
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => JuegoSilabas()));
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: Text('Siguiente juego'),
              ),
          ],
        ),
      ),
    );
  }
}

class _Tarjeta {
  final String imagen;
  bool descubierta;
  bool emparejada;

  _Tarjeta({
    required this.imagen,
    this.descubierta = false,
    this.emparejada = false,
  });
}
