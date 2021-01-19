import 'package:clima_flutter/services/location.dart';
import 'package:clima_flutter/services/networking.dart';
import 'package:clima_flutter/services/weather.dart';
import 'package:clima_flutter/utilities/constants.dart';
import 'package:flutter/material.dart';

import 'city_screen.dart';

class LocationScreen extends StatefulWidget {
  final dynamic weatherData;
  LocationScreen({@required this.weatherData});
  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  int temperature;
  int condition;
  String cityName;
  String weatherIcon;
  String weatherMessage;
  WeatherModel weatherModel = WeatherModel();
  void updateUi(dynamic weatherData) {
    if (weatherData == null) {
      cityName = 'City Name';
      temperature = 0;
      //condition = weatherData['weather'][0]['id'];
      weatherIcon = ' ';
      weatherMessage = 'Error';
    } else {
      cityName = weatherData['name'];
      temperature = weatherData['main']['temp'].toInt();
      condition = weatherData['weather'][0]['id'];
      weatherIcon = weatherModel.getWeatherIcon(condition);
      weatherMessage = weatherModel.getMessage(temperature);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    updateUi(widget.weatherData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/location_background.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.8), BlendMode.dstATop),
          ),
        ),
        constraints: BoxConstraints.expand(),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    FlatButton(
                      onPressed: () async {
                        var loc = Location();
                        await loc.getLocation();
                        WeatherData data = WeatherData(
                            latitude: loc.latitude, longitude: loc.longitude);
                        dynamic weatherData = await data.getWeatherData();
                        setState(() {
                          updateUi(weatherData);
                        });
                        print('finish');
                      },
                      child: Icon(
                        Icons.near_me,
                        size: 50.0,
                      ),
                    ),
                    FlatButton(
                      onPressed: () async {
                        var cityName = await Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return CityScreen();
                        }));
                        print(cityName);
                        dynamic cityWeather =
                            await WeatherData().getCityWeather(cityName);
                        setState(() {
                          updateUi(cityWeather);
                        });
                      },
                      child: Icon(
                        Icons.home_outlined,
                        size: 50.0,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(left: 15.0),
                  child: Row(
                    children: <Widget>[
                      Text(
                        '${this.temperature}°',
                        style: kTempTextStyle,
                      ),
                      Text(
                        this.weatherIcon,
                        style: kConditionTextStyle,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 15.0),
                  child: Text(
                    '${this.weatherMessage} in ${this.cityName}',
                    textAlign: TextAlign.center,
                    style: kMessageTextStyle,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
