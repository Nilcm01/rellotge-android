import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:timer_builder/timer_builder.dart';
import 'package:relative_scale/relative_scale.dart';
import 'package:http/http.dart' as http;
import 'package:wakelock/wakelock.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // Make app full screen
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

    // TODO RELEASE: Enable landscape lock
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    /**/

    Wakelock.enable();

    return MaterialApp(
      title: 'Rellotge',
      home: MyHomePage(title: 'Rellotge digital'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double temperature = 0;
  double feelsLike = 0;
  int humidity = 0;
  double maxTemp = 0;
  double minTemp = 0;

  int framesElapsed = 0;

  int testCounter = 0;

  String weatherIconURL = '';

  DateTime now = DateTime.now();

  // List of colors to use for the text
  List<Color> textColors = [
    Colors.white, // 0 - Time
    Colors.white, // 1 - Temperature
    Colors.white, // 2 - Feels like & Humidity
    Colors.white, // 3 - Date
  ];

  // List of colors to use for the background
  List<Color> backgroundColors = [
    Colors.black, // 0 - Color 1
    Colors.black, // 1 - Color 2
  ];

  _MyHomePageState() {
    updateWeather();
  }

  updateWeather() async {
    // make request
    var url = Uri.parse(
        "https://api.openweathermap.org/data/2.5/weather?lat=41.403916690465074&lon=2.196790194958459&appid=482a0b104341224f90a04309467adb98&units=metric");
    dynamic response = await http.get(url);

    // sample info available in response
    //int statusCode = response.statusCode;
    Map<String, dynamic> data = jsonDecode(response.body);
    temperature = data["main"]["temp"] ?? 0;
    feelsLike = data["main"]["feels_like"] ?? 0;
    humidity = data["main"]["humidity"] ?? 0;
    maxTemp = data["main"]["temp_max"] ?? 0;
    minTemp = data["main"]["temp_min"] ?? 0;
    var weatherIcon = data["weather"][0]["icon"] ?? '';
    weatherIconURL = "https://openweathermap.org/img/w/$weatherIcon.png";
  }

  String getSystemTime() {
    now = DateTime.now();
    return DateFormat("HH:mm").format(now);
  }

  String getSystemDate() {
    initializeDateFormatting();
    now = DateTime.now();
    return DateFormat("yMMMMEEEEd", 'ca').format(now);
  }

  updateColors() {
    // TODO RELEASE: Enable color change based on the current hour
    switch (now.hour) {
    // switch (testCounter) {

      case 0: // 22-06h > Nit
      case 1:
      case 2:
      case 3:
      case 4:
      case 5:
      case 6:
        backgroundColors[0] = Colors.black;
        backgroundColors[1] = Colors.black;
        textColors[0] = Colors.white30;
        textColors[1] = Colors.white30;
        textColors[2] = Colors.white30;
        textColors[3] = Colors.white30;
        break;

      case 7: // 07h > Albada fosca
        backgroundColors[0] = const Color.fromARGB(210, 115, 64, 75);
        backgroundColors[1] = const Color.fromARGB(255, 253, 96, 81);
        textColors[0] = Colors.white54;
        textColors[1] = Colors.white54;
        textColors[2] = Colors.white54;
        textColors[3] = Colors.white54;
        break;

      case 8: // 08h > Albada clara
        backgroundColors[0] = const Color.fromARGB(255, 255, 229, 119);
        backgroundColors[1] = const Color.fromARGB(255, 253, 96, 81);
        textColors[0] = Colors.black;
        textColors[1] = Colors.black;
        textColors[2] = Colors.black;
        textColors[3] = Colors.black;
        break;

      case 9: // 09h > Primera hora
        backgroundColors[0] = const Color.fromARGB(255, 255, 229, 119);
        backgroundColors[1] = const Color.fromARGB(255, 136, 198, 252);
        textColors[0] = Colors.black;
        textColors[1] = Colors.black;
        textColors[2] = Colors.black;
        textColors[3] = Colors.black;
        break;

      case 10: // 10-11h > Matí
      case 11:
        backgroundColors[0] = const Color.fromARGB(255, 86, 157, 238);
        backgroundColors[1] = const Color.fromARGB(255, 136, 198, 252);
        textColors[0] = Colors.black;
        textColors[1] = Colors.black;
        textColors[2] = Colors.black;
        textColors[3] = Colors.black;
        break;

      case 12: // 12-13h > Migdia
      case 13:
        backgroundColors[0] = const Color.fromARGB(255, 25, 158, 243);
        backgroundColors[1] = const Color.fromARGB(255, 136, 198, 252);
        textColors[0] = Colors.black;
        textColors[1] = Colors.black;
        textColors[2] = Colors.black;
        textColors[3] = Colors.black;
        break;

      case 14: // 14-15h > Inici de la tarda
      case 15:
        backgroundColors[0] = const Color.fromARGB(255, 255, 229, 119);
        backgroundColors[1] = const Color.fromARGB(255, 136, 198, 252);
        textColors[0] = Colors.black;
        textColors[1] = Colors.black;
        textColors[2] = Colors.black;
        textColors[3] = Colors.black;
        break;

      case 16: // 16-17h > Mitja tarda
      case 17:
        backgroundColors[0] = const Color.fromARGB(255, 254, 192, 81);
        backgroundColors[1] = const Color.fromARGB(255, 253, 96, 81);
        textColors[0] = Colors.black;
        textColors[1] = Colors.black;
        textColors[2] = Colors.black;
        textColors[3] = Colors.black;
        break;

      case 18: // 20h > Vespre
        backgroundColors[0] = const Color.fromARGB(210, 115, 64, 75);
        backgroundColors[1] = const Color.fromARGB(255, 253, 96, 81);
        textColors[0] = Colors.white;
        textColors[1] = Colors.white;
        textColors[2] = Colors.white;
        textColors[3] = Colors.white;
        break;

      case 19: // 20h > Capvespre
        backgroundColors[0] = const Color.fromARGB(210, 115, 64, 75);
        backgroundColors[1] = const Color.fromARGB(255, 57, 32, 51);
        textColors[0] = Colors.white;
        textColors[1] = Colors.white;
        textColors[2] = Colors.white;
        textColors[3] = Colors.white;
        break;

      case 20:  // 20h > Inici de la nit (opacitat: 70%)
        backgroundColors[0] = Colors.black;
        backgroundColors[1] = Colors.black;
        textColors[0] = Colors.white70;
        textColors[1] = Colors.white70;
        textColors[2] = Colors.white70;
        textColors[3] = Colors.white70;
        break;


      case 21: // 21h > Nit (opacitat: 54%)
        backgroundColors[0] = Colors.black;
        backgroundColors[1] = Colors.black;
        textColors[0] = Colors.white54;
        textColors[1] = Colors.white54;
        textColors[2] = Colors.white54;
        textColors[3] = Colors.white54;
        break;

      case 22: // 22h > Nit (opacitat: 38%)
        backgroundColors[0] = Colors.black;
        backgroundColors[1] = Colors.black;
        textColors[0] = Colors.white38;
        textColors[1] = Colors.white38;
        textColors[2] = Colors.white38;
        textColors[3] = Colors.white38;
        break;

      case 23: // 23-06h > Nit (opacitat: 30%)
        backgroundColors[0] = Colors.black;
        backgroundColors[1] = Colors.black;
        textColors[0] = Colors.white30;
        textColors[1] = Colors.white30;
        textColors[2] = Colors.white30;
        textColors[3] = Colors.white30;
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return TimerBuilder.periodic(const Duration(milliseconds: 500),
        builder: (context) {
      if (framesElapsed >= 120) {
        updateWeather();
        framesElapsed = 0;
      } else {
        framesElapsed++;
      }

      updateColors();

      return RelativeBuilder(builder: (context, height, width, sy, sx) {
        return Scaffold(
          backgroundColor: Colors.black,
          body: Center(
            child: Container(
              width: sx(1000),
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  backgroundColors[0],
                  backgroundColors[1],
                ],
              )),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      // Time
                      Text(
                        getSystemTime(),
                        style: TextStyle(
                          color: textColors[0],
                          fontFamily: 'Helvetica',
                          fontSize: sx(180),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      // Weather icon
                      Image.network(weatherIconURL,
                          width: sx(65), fit: BoxFit.fitWidth),

                      // Temperature
                      Text(
                        "\t$temperature ºC".replaceAll('.', ','),
                        style: TextStyle(
                          color: textColors[1],
                          fontFamily: 'Helvetica',
                          fontSize: sx(60),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      // Feels like and Humidity
                      Text(
                        "S: $feelsLikeºC \t H: $humidity% \t ↑ $maxTempºC \t ↓ $minTempºC".replaceAll('.', ','),
                        style: TextStyle(
                          color: textColors[2],
                          fontFamily: 'Helvetica',
                          fontSize: sx(25),
                        ),
                      ),
                    ],
                  ),

                  // Blank space
                  SizedBox(
                    height: sy(40),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      // Date
                      Text(
                        getSystemDate(),
                        style: TextStyle(
                          color: textColors[3],
                          fontFamily: 'Helvetica',
                          fontSize: sx(25),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),


          // // Button to increment of the counter
          // // TODO RELEASE: Disable button
          // floatingActionButton: FloatingActionButton(
          //   onPressed: () {
          //     setState(() {
          //       if (testCounter < 23) {
          //         testCounter++;
          //       } else {
          //         testCounter = 0;
          //       }
          //     });
          //   },
          //   tooltip: 'Increment',
          //   child: Text(
          //     testCounter.toString(),
          //     style: TextStyle(
          //       color: Colors.white,
          //       fontFamily: 'Helvetica',
          //       fontSize: sx(20),
          //     ),
          //   ),
          // ),
        );
      });
    });
  }
}
