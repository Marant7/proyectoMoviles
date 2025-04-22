import 'package:flutter/material.dart';
import 'package:flutter_jueguito/games/juego_4.dart';
import '../mensaje/celebracion.dart';

class ImagenConRespuesta {
  final String imagePath;
  final String respuestaCorrecta;
  String? respuestaUsuario;

  ImagenConRespuesta({required this.imagePath, required this.respuestaCorrecta});
}

class JuegoDragDrop3 extends StatefulWidget {
  @override
  State<JuegoDragDrop3> createState() => _JuegoDragDrop2State();
}

class _JuegoDragDrop2State extends State<JuegoDragDrop3> {
  List<ImagenConRespuesta> grupo1 = [
    ImagenConRespuesta(imagePath: 'assets/images/trompo.png', respuestaCorrecta: 'trompo'),
    ImagenConRespuesta(imagePath: 'assets/images/planta.png', respuestaCorrecta: 'planta'),
  ];

  List<ImagenConRespuesta> grupo2 = [
    ImagenConRespuesta(imagePath: 'assets/images/tractor.png', respuestaCorrecta: 'tractor'),
    ImagenConRespuesta(imagePath: 'assets/images/plancha.png', respuestaCorrecta: 'plancha'),
  ];

  List<String> opcionesGrupo1 = ['trompo', 'trampa', 'planta'];
  List<String> opcionesGrupo2 = ['blanco', 'tractor', 'plancha'];

  bool desbloqueado = false;

  void verificar() {
    bool grupo1Correcto = grupo1.every((img) => img.respuestaUsuario == img.respuestaCorrecta);
    bool grupo2Correcto = grupo2.every((img) => img.respuestaUsuario == img.respuestaCorrecta);

    bool todoBien = grupo1Correcto && grupo2Correcto;

    setState(() {
      desbloqueado = todoBien;
    });

    if (todoBien) {
      Celebracion.mostrar(context); // 🎉 Mostrar la celebración
    }
  }

  void irAlSiguienteJuego() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => Juego_2()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Juego: Arrastra debajo de la imagen'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.blue[50], // Puedes cambiar el color aquí para ajustarlo a tus preferencias
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              // El contenido del juego va aquí (por ejemplo, los grupos de imágenes y botones)
              Text('Grupo 1', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blueAccent)),
              buildGrupo(grupo1, opcionesGrupo1),

              SizedBox(height: 32),

              Text('Grupo 2', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blueAccent)),
              buildGrupo(grupo2, opcionesGrupo2),

              SizedBox(height: 30),

              ElevatedButton(
                onPressed: verificar,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrangeAccent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  padding: EdgeInsets.symmetric(vertical: 14, horizontal: 32),
                ),
                child: Text('Verificar respuestas', style: TextStyle(fontSize: 18)),
              ),

              SizedBox(height: 10),

              desbloqueado
                  ? ElevatedButton(
                      onPressed: irAlSiguienteJuego,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        padding: EdgeInsets.symmetric(vertical: 14, horizontal: 32),
                      ),
                      child: Text('Siguiente juego', style: TextStyle(fontSize: 18)),
                    )
                  : Opacity(
                      opacity: 0.4,
                      child: IgnorePointer(
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            padding: EdgeInsets.symmetric(vertical: 14, horizontal: 32),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.lock, color: Colors.white),
                              SizedBox(width: 8),
                              Text('Siguiente juego', style: TextStyle(fontSize: 18)),
                            ],
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

  Widget buildGrupo(List<ImagenConRespuesta> imagenes, List<String> opciones) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: imagenes
              .map((img) => Expanded(child: buildImagenConZona(img)))
              .toList(),
        ),
        SizedBox(height: 16),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 12,
          children: opciones
              .map((op) => Draggable<String>(
                    data: op,
                    feedback: Material(
                      color: Colors.transparent,
                      child: palabraChip(op, isDragging: true),
                    ),
                    childWhenDragging:
                        Opacity(opacity: 0.3, child: palabraChip(op)),
                    child: palabraChip(op),
                  ))
              .toList(),
        ),
      ],
    );
  }

  Widget buildImagenConZona(ImagenConRespuesta img) {
    return Column(
      children: [
        Container(
          width: 120,
          height: 120,
          margin: EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
            boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(2, 2))], // Añadí sombra a las imágenes
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(img.imagePath, fit: BoxFit.contain),
          ),
        ),
        DragTarget<String>(
          onAccept: (palabra) {
            setState(() {
              img.respuestaUsuario = palabra;
            });
          },
          builder: (context, candidateData, rejectedData) {
            return Container(
              width: 100,
              height: 50,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.green[50],
                border: Border.all(color: Colors.green),
                borderRadius: BorderRadius.circular(8),
                boxShadow: [BoxShadow(color: Colors.green, blurRadius: 5)], // Añadí sombra sutil
              ),
              child: Text(
                img.respuestaUsuario ?? 'Arrastra aquí',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              ),
            );
          },
        )
      ],
    );
  }

  Widget palabraChip(String palabra, {bool isDragging = false}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isDragging ? Colors.orange[300] : Colors.orange[100],
        borderRadius: BorderRadius.circular(20),
        boxShadow: isDragging
            ? [BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(2, 2))]
            : [],
      ),
      child: Text(palabra, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
    );
  }
}
