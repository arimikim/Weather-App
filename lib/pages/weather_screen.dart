import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../resoulces/cardhourly.dart';
import '../secrets.dart';
import 'additioninformation.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {


  Future<Map<String, dynamic>> getWeatherForecast() async {
    try {
      final res = await http.get(Uri.parse(
          'https://api.openweathermap.org/data/2.5/forecast?q=Nairobi&APPID=$openWeatherApiKey'));
      final data = jsonDecode(res.body);
      if (data['cod'] != '200') {
        throw data['message'];
      }
      return data;
    } catch (e) {
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Weather App',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {}); // Refresh the weather data
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: FutureBuilder(
        future: getWeatherForecast(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          final data = snapshot.data;
          final currentTemp = data?['list']?[0]['main']['temp'] ?? 'N/A';
          final currentSky = data?['list']?[0]['weather']?[0]['main'] ?? 'N/A';

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Main card
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          color: Colors.white.withOpacity(0.3),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                Text(
                                  '$currentTemp °K',
                                  style: const TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Icon(
                                  currentSky == 'Clouds' || currentSky == 'Rain'
                                      ? Icons.cloud
                                      : Icons.sunny,
                                  size: 64,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  currentSky,
                                  style: const TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Weather Forecast',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),
                const SizedBox(height: 10),

                SizedBox(
                  height: 120,
                  child: ListView.builder(
                    shrinkWrap: true, // To prevent layout overflow
                    scrollDirection: Axis.horizontal,
                    itemCount: 5, // Number of items to display
                    itemBuilder: (context, index) {
                      final hourlyCast = data?['list'][index];

                      // Format time to 2:00 AM/PM
                      final time = DateTime.fromMillisecondsSinceEpoch(hourlyCast['dt'] * 1000).toLocal();
                      final formattedTime = DateFormat.j().format(time); // e.g., 2:00 AM

                      final temp = '${hourlyCast['main']['temp'] ?? 'N/A'} °K';
                      final icon = hourlyCast['weather'][0]['main'] == 'Clouds'
                          ? Icons.cloud
                          : Icons.sunny;

                      return HourlyForeCast(
                        time: formattedTime, // Pass the formatted time
                        icon: icon,
                        temp: temp,
                      );
                    },
                  ),
                ),

              const SizedBox(height: 20),
                const Text(
                  'Additional Information',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    AddtionalInformation(
                        icon: Icons.water_drop,
                        label: 'Humidity',
                        Value: '${data?['list']?[0]['main']?['humidity'] ?? 'N/A'}'),
                    AddtionalInformation(
                        icon: Icons.wind_power,
                        label: 'Wind Speed',
                        Value: '${data?['list']?[0]['wind']?['speed'] ?? 'N/A'}'),
                    AddtionalInformation(
                        icon: Icons.beach_access,
                        label: 'Pressure',
                        Value: '${data?['list']?[0]['main']?['pressure'] ?? 'N/A'}'),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
