import 'package:flutter/material.dart';
import 'package:flutter_jueguito/games/juego_silabas.dart';

class JuegoSilabasPorNumero extends StatefulWidget {
  @override
  _JuegoSilabasPorNumeroState createState() => _JuegoSilabasPorNumeroState();
}

class _JuegoSilabasPorNumeroState extends State<JuegoSilabasPorNumero> {
  final List<Map<String, dynamic>> imagenes = [
    {'path': 'assets/images/gorra.png', 'palabra': ['go', 'rra']},
    {'path': 'assets/images/oruga.png', 'palabra': ['o', 'ru', 'ga']},
    {'path': 'assets/images/garra.png', 'palabra': ['ga', 'rra']},
    {'path': 'assets/images/soga.png', 'palabra': ['so', 'ga']},
    {'path': 'assets/images/gota.png', 'palabra': ['go', 'ta']},
    {'path': 'assets/images/goma.png', 'palabra': ['go', 'ma']},
    {'path': 'assets/images/gorila.png', 'palabra': ['go', 'ri', 'la']},
    {'path': 'assets/images/mago.png', 'palabra': ['ma', 'go']},
  ];

  final Map<String, int> silabaNumeros = {
    'go': 1, 'rra': 3, 'ga': 6, 'ta': 7, 'ri': 8,
    'ma': 9, 'lo': 10, 'la': 11, 'so': 12, 'o': 13, 'ru': 14
  };

  Map<int, List<int?>> respuestasUsuario = {};
  Map<int, int> silabaUsos = {};
  Map<int, int> silabaMaxUsos = {};
  bool desbloqueado = false;

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < imagenes.length; i++) {
      respuestasUsuario[i] = List.filled(imagenes[i]['palabra'].length, null);
    }
    calcularMaximos();
  }

  void calcularMaximos() {
    for (final entry in silabaNumeros.entries) {
      int valor = entry.value;
      int usos = imagenes.fold(0, (acc, item) => acc + (item['palabra'] as List<String>).where((s) => silabaNumeros[s] == valor).length);
      silabaMaxUsos[valor] = usos;
    }
  }

  void verificar() {
    bool correcto = true;
    for (int i = 0; i < imagenes.length; i++) {
      final palabra = imagenes[i]['palabra'] as List<String>;
      final respuesta = respuestasUsuario[i] as List<int?>;
      for (int j = 0; j < palabra.length; j++) {
        if (respuesta[j] != silabaNumeros[palabra[j]]) {
          correcto = false;
          break;
        }
      }
    }
    setState(() => desbloqueado = correcto);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(correcto
          ? '¡Todas las respuestas son correctas! 🎉'
          : 'Hay errores, inténtalo de nuevo ❌'),
    ));
  }

  Widget buildImagen(int index) {
    final palabra = imagenes[index]['palabra'] as List<String>;
    final nombre = palabra.join('');
    final completa = List.generate(
      palabra.length,
      (j) => respuestasUsuario[index]![j] == silabaNumeros[palabra[j]],
    );
    final esCorrecta = completa.every((e) => e);

    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          margin: EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Image.asset(imagenes[index]['path'], fit: BoxFit.contain),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(palabra.length, (j) => buildDropZone(index, j)),
        ),
        SizedBox(height: 6),
        Text(
          esCorrecta ? nombre : '',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.blueAccent,
          ),
        ),
      ],
    );
  }

  Widget buildDropZone(int index, int subIndex) {
    final palabra = imagenes[index]['palabra'] as List<String>;
    final valor = respuestasUsuario[index]![subIndex];
    final correcta = valor != null && valor == silabaNumeros[palabra[subIndex]];

    final todasCorrectas = List.generate(palabra.length, (j) {
      return respuestasUsuario[index]![j] == silabaNumeros[palabra[j]];
    }).every((e) => e);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: IgnorePointer(
        ignoring: todasCorrectas,
        child: DragTarget<int>(
          onAccept: (data) {
            setState(() {
              respuestasUsuario[index]![subIndex] = data;
              silabaUsos[data] = (silabaUsos[data] ?? 0) + 1;
            });
          },
          builder: (context, candidateData, rejectedData) {
            return Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: valor != null
                    ? (correcta ? Colors.green[200] : Colors.red[100])
                    : Colors.white,
                border: Border.all(color: Colors.blue),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                valor?.toString() ?? '',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: correcta ? Colors.black : Colors.red,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildDraggable(String silaba, int numero) {
    final usados = silabaUsos[numero] ?? 0;
    final maxUsos = silabaMaxUsos[numero] ?? 0;
    final agotado = usados >= maxUsos;

    return Column(
      children: [
        Draggable<int>(
          data: numero,
          feedback: Material(
            color: Colors.transparent,
            child: silabaBox(silaba, numero, dragging: true, agotado: agotado),
          ),
          childWhenDragging: Opacity(
            opacity: 0.3,
            child: silabaBox(silaba, numero, agotado: agotado),
          ),
          child: silabaBox(silaba, numero, agotado: agotado),
        ),
        if (!agotado)
          Text('$usados / $maxUsos', style: TextStyle(fontSize: 12))
        else
          Text('0 / $maxUsos', style: TextStyle(color: Colors.red, fontSize: 12)),
      ],
    );
  }

  Widget silabaBox(String silaba, int numero,
      {bool dragging = false, bool agotado = false}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: agotado
            ? Colors.grey[400]
            : (dragging ? Colors.orange[300] : Colors.orange[100]),
        border: Border.all(color: Colors.orange),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text('$numero', style: TextStyle(fontWeight: FontWeight.bold)),
          Text(silaba, style: TextStyle(fontSize: 14)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final silabasCentro = silabaNumeros.entries.where((e) => e.value <= 10).toList();
    final silabasAbajo = silabaNumeros.entries.where((e) => e.value > 10).toList();

    return Scaffold(
      appBar: AppBar(title: Text('Juego de Sílabas por Número')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: Column(
                      children: List.generate(4, (i) => buildImagen(i)),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: silabasCentro
                        .map((e) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              child: buildDraggable(e.key, e.value),
                            ))
                        .toList(),
                  ),
                  Expanded(
                    child: Column(
                      children: List.generate(4, (i) => buildImagen(i + 4)),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24),
              Text('Sílabas adicionales:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(height: 12),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                alignment: WrapAlignment.center,
                children:
                    silabasAbajo.map((e) => buildDraggable(e.key, e.value)).toList(),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: verificar,
                child: Text('Verificar respuestas'),
              ),
              if (desbloqueado)
                ElevatedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => JuegoSilabas()),
                  ),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: Text('Siguiente juego'),
                )
            ],
          ),
        ),
      ),
    );
  }
}