import 'package:flutter/material.dart';
import 'localizacao.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  Localizacao local = Localizacao();
  bool carregando = true;

  @override
  void initState() {
    super.initState();
    buscarLocalizacao();
  }

  void buscarLocalizacao() async {
    try {
      await local.pegaLocalizacaoAtual();
      setState(() {
        carregando = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        carregando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Localização')),
        body: Center(
          child: carregando
              ? const CircularProgressIndicator()
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Busca Local', style: TextStyle(fontSize: 24)),
                    const SizedBox(height: 20),
                    Text('Latitude: ${local.latitude ?? "Não disponível"}',
                        style: const TextStyle(fontSize: 18)),
                    const SizedBox(height: 10),
                    Text('Longitude: ${local.longitude ?? "Não disponível"}',
                        style: const TextStyle(fontSize: 18)),
                  ],
                ),
        ),
      ),
    );
  }
}
