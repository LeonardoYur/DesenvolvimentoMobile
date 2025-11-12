import 'package:http/http.dart' as http;
import 'dart:convert';

class Clima {
  double? temperatura;
  int? umidade;
  double? velocidadeVento;

  Future<void> buscarClima(double lat, double lon) async {
    String apiKey = 'e9472c7e3dc1634310c52877e34afd1d';
    String url =
        'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$apiKey&units=metric&lang=pt_br';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        Map<String, dynamic> dados = jsonDecode(response.body);
        temperatura = dados['main']['temp'];
        umidade = dados['main']['humidity'];
        velocidadeVento = dados['wind']['speed'];
      } else {
        throw ('Erro ao buscar clima: ${response.statusCode}');
      }
    } catch (e) {
      throw ('Erro na requisição: $e');
    }
  }
}
