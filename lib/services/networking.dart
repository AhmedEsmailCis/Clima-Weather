import 'dart:convert';

import 'package:http/http.dart' as Http;

const apiKey = 'd582a3a2994ebdaa28a41048a5d3b990';

class WeatherData {
  double latitude;
  double longitude;
  var _dataDecoded;

  WeatherData({this.latitude, this.longitude});
  Future<dynamic> getCityWeather(String cityName) async {
    Http.Response response = await Http.get(
        'http://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$apiKey&units=metric');
    if (response.statusCode == 200) {
      _dataDecoded = jsonDecode(response.body);
      return _dataDecoded;
    } else
      return null;
  }

  Future<dynamic> getWeatherData() async {
    Http.Response response = await Http.get(
        'http://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=$apiKey&units=metric');
    if (response.statusCode == 200) {
      _dataDecoded = jsonDecode(response.body);
      return _dataDecoded;
    }
  }
}
