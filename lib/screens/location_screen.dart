import 'package:flutter/material.dart';
import 'package:weather_app/screens/city_screen.dart';
import 'package:weather_app/services/weather.dart';
import 'package:weather_app/utils/text_styles.dart';

class LocationScreen extends StatefulWidget {
  LocationScreen({@required this.locationWeather});

  final locationWeather;

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  WeatherModel _mWeatherModel = WeatherModel();
  String _mCityName;
  String _mDescription;
  String _mWeatherIcon;
  int _mTemperature;

  @override
  void initState() {
    super.initState();
    updateUI(widget.locationWeather);
  }

  void updateUI(dynamic weatherData) {
    setState(() {
      if (weatherData == null) {
        _mCityName = '';
        _mDescription = 'Unable to get weather data';
        _mWeatherIcon = 'Error';
        _mTemperature = 0;
        return;
      }
      _mCityName = weatherData['name'];
      var _mCondition = weatherData['weather'][0]['id'];
      double temperature;
      try {
        temperature = weatherData['main']['temp'];
        _mTemperature = temperature.toInt();
      } catch(e) {
        _mTemperature = weatherData['main']['temp'];
      }
      _mWeatherIcon = _mWeatherModel.getWeatherIcon(_mCondition);
      _mDescription = _mWeatherModel.getMessage(temperature.toInt());
    });
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  MaterialButton(
                    onPressed: () async {
                      var newData = await _mWeatherModel.getLocationData();
                      updateUI(newData);
                    },
                    child: Icon(
                      Icons.near_me,
                      size: 50.0,
                    ),
                  ),
                  MaterialButton(
                    onPressed: () async {
                      var typedName = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return CityScreen();
                          },
                        ),
                      );
                      if(typedName != null) {
                        print(typedName);
                        updateUI(await _mWeatherModel.getCityWeather(cityName: typedName));
                      }
                    },
                    child: Icon(
                      Icons.location_city,
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
                      '$_mTemperature°',
                      style: kTempTextStyle,
                    ),
                    Text(
                      _mWeatherIcon,
                      style: kConditionTextStyle,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 15.0),
                child: Text(
                  "$_mDescription in $_mCityName!",
                  textAlign: TextAlign.right,
                  style: kMessageTextStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
