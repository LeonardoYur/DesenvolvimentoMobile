import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const AppClima());
}

class AppClima extends StatelessWidget {
  const AppClima({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Clima App',
      debugShowCheckedModeBanner: false,
      home: TelaClima(),
    );
  }
}

class TelaClima extends StatefulWidget {
  @override
  State<TelaClima> createState() => _TelaClimaState();
}

class _TelaClimaState extends State<TelaClima> {
  final TextEditingController controladorCidade = TextEditingController();
  bool carregando = false;
  String mensagemErro = '';
  double? temperatura;
  double? umidade;
  double? velocidadeVento;
  String? nomeCidadeUsada;

  Future<void> buscarClima() async {
    final cidade = controladorCidade.text.trim();
    if (cidade.isEmpty) {
      setState(() => mensagemErro = 'Digite o nome de uma cidade.');
      return;
    }

    setState(() {
      carregando = true;
      mensagemErro = '';
      temperatura = null;
      umidade = null;
      velocidadeVento = null;
      nomeCidadeUsada = null;
    });

    try {
      // 1) Geocoding (open-meteo)
      final geocodingUrl = Uri.parse(
          'https://geocoding-api.open-meteo.com/v1/search?name=${Uri.encodeComponent(cidade)}&count=1&language=en&format=json');
      final geocodingResp = await http.get(geocodingUrl);

      if (geocodingResp.statusCode != 200) {
        throw Exception('Erro no geocoding: ${geocodingResp.statusCode}');
      }

      final geoJson = jsonDecode(geocodingResp.body);
      if (geoJson['results'] == null || (geoJson['results'] as List).isEmpty) {
        throw Exception('Cidade não encontrada.');
      }

      final primeiro = geoJson['results'][0];
      final lat = primeiro['latitude'];
      final lon = primeiro['longitude'];
      nomeCidadeUsada = primeiro['name'];

      // 2) Buscar clima (open-meteo) - usando forecast hourly current_weather e humidity (relativehumidity_2m)
      // open-meteo provides current_weather (temp, windspeed) but humidity in hourly fields. We'll request current_weather and hourly relativehumidity_2m for now; take most recent hour.
      final now = DateTime.now().toUtc();
      final dataInicio =
          now.subtract(const Duration(hours: 1)).toIso8601String();
      final dataFim = now.toIso8601String();

      final climaUrl = Uri.parse(
          'https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$lon&current_weather=true&hourly=relativehumidity_2m&timezone=UTC&start_date=${now.toIso8601String().split("T")[0]}&end_date=${now.toIso8601String().split("T")[0]}');

      final climaResp = await http.get(climaUrl);
      if (climaResp.statusCode != 200) throw Exception('Erro ao buscar clima.');

      final climaJson = jsonDecode(climaResp.body);

      // current_weather
      final current = climaJson['current_weather'];
      if (current != null) {
        temperatura = (current['temperature'] as num).toDouble();
        velocidadeVento = (current['windspeed'] as num).toDouble();
      }

      // humidity: pegar último valor do hourly.relativehumidity_2m (se disponível)
      if (climaJson['hourly'] != null &&
          climaJson['hourly']['relativehumidity_2m'] != null) {
        final listaHum = climaJson['hourly']['relativehumidity_2m'] as List;
        if (listaHum.isNotEmpty) {
          umidade = (listaHum.last as num).toDouble();
        }
      }

      setState(() {
        carregando = false;
      });
    } catch (e) {
      setState(() {
        carregando = false;
        mensagemErro = 'Erro: ${e.toString()}';
      });
    }
  }

  @override
  void dispose() {
    controladorCidade.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clima (open-meteo)'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: controladorCidade,
              decoration: const InputDecoration(
                labelText: 'Nome da cidade',
                hintText: 'ex: Uberaba',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: carregando ? null : buscarClima,
              child: Text(carregando ? 'Buscando...' : 'Buscar Clima'),
            ),
            const SizedBox(height: 20),
            if (mensagemErro.isNotEmpty)
              Text(mensagemErro, style: const TextStyle(color: Colors.red)),
            if (carregando) const CircularProgressIndicator(),
            if (!carregando && temperatura != null)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Cidade: ${nomeCidadeUsada ?? ''}'),
                      Text(
                          'Temperatura: ${temperatura?.toStringAsFixed(1)} °C'),
                      Text(
                          'Umidade (aprox): ${umidade != null ? umidade!.toStringAsFixed(0) + " %" : "N/D"}'),
                      Text(
                          'Velocidade do vento: ${velocidadeVento != null ? velocidadeVento!.toStringAsFixed(1) + " km/h" : "N/D"}'),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
