import 'package:geolocator/geolocator.dart';

class Localizacao {
  double? latitude;
  double? longitude;

  Future<void> pegaLocalizacaoAtual() async {
    LocationPermission permissao = await Geolocator.checkPermission();

    if (permissao == LocationPermission.denied) {
      permissao = await Geolocator.requestPermission();
      if (permissao == LocationPermission.denied) {
        throw ('Permissão de localização negada');
      }
    }

    if (permissao == LocationPermission.deniedForever) {
      throw ('Permissão de localização negada permanentemente');
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low);

    latitude = position.latitude;
    longitude = position.longitude;
  }
}
