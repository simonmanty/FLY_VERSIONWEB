import 'package:flutter/material.dart';

void main() => runApp(FlyWebApp());

class FlyWebApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fly Web',
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: FlyHomePage(),
    );
  }
}

class FlyHomePage extends StatefulWidget {
  @override
  _FlyHomePageState createState() => _FlyHomePageState();
}

class _FlyHomePageState extends State<FlyHomePage> {
  String input = '';
  String prediccion = '';
  String tendencia = '';

  void procesarInput() {
    try {
      final valores = input.split(',').map((e) => double.parse(e.trim())).toList();
      final promedio = valores.reduce((a, b) => a + b) / valores.length;
      final ultimos = valores.length >= 5 ? valores.sublist(valores.length - 5) : valores;

      if (promedio < 1.8) {
        prediccion = '🔴 Baja – evitar entrada';
      } else if (promedio < 2.5) {
        prediccion = '🟡 Entrada 2x posible';
      } else {
        prediccion = '🟢 Entrada 3x probable';
      }

      final altas = ultimos.where((x) => x > 2).length;
      final bajas = ultimos.where((x) => x < 1.5).length;

      if (altas >= 4) {
        tendencia = 'Tendencia alta 📈';
      } else if (bajas >= 4) {
        tendencia = 'Tendencia baja 📉';
      } else {
        tendencia = 'Tendencia inestable ⚖️';
      }
    } catch (e) {
      prediccion = 'Error en el formato';
      tendencia = '';
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Fly Web – Predicción')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                  labelText: 'Coeficientes (separados por coma)',
                  labelStyle: TextStyle(color: Colors.white)),
              style: TextStyle(color: Colors.white),
              onChanged: (val) => input = val,
            ),
            SizedBox(height: 10),
            ElevatedButton(onPressed: procesarInput, child: Text('Predecir')),
            SizedBox(height: 20),
            Text(prediccion, style: TextStyle(fontSize: 20)),
            Text(tendencia, style: TextStyle(fontSize: 18, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
