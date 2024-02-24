import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
// You can change the cityName here to get weather data for a different city
  String cityName = 'Karachi';

  String apiKey = '5ec0dc9536fc74fdafa011cacc5e894f';
  late String apiUrl;
  Map<String, dynamic> apiData = {};

  Future<void> getWeatherApi() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      setState(() {
        apiData = jsonDecode(response.body);
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    apiUrl =
        'https://api.openweathermap.org/data/2.5/forecast?q=$cityName,&APPID=$apiKey';
    getWeatherApi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Weather Api Demo'),
        centerTitle: true,
      ),
      body: apiData.isEmpty
          ? const Center(
              child: CircularProgressIndicator(
              color: Colors.black,
            ))
          : FutureBuilder(
              future: getWeatherApi(),
              builder: (context, snapshot) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        cityName,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      ReUsableRow(
                        title: 'Weather Type',
                        value:
                            apiData['list'][0]['weather'][0]['main'].toString(),
                      ),
                      ReUsableRow(
                        title: 'Temperature',
                        value: '${apiData['list'][0]['main']['temp']}°F',
                      ),
                      ReUsableRow(
                        title: 'Pressure',
                        value:
                            apiData['list'][0]['main']['pressure'].toString(),
                      ),
                      ReUsableRow(
                        title: 'Humidity',
                        value:
                            apiData['list'][0]['main']['humidity'].toString(),
                      ),
                    ],
                  ),
                );
              }),
    );
  }
}

class ReUsableRow extends StatefulWidget {
  final String title, value;
  const ReUsableRow({super.key, required this.title, required this.value});

  @override
  State<ReUsableRow> createState() => _ReUsableRowState();
}

class _ReUsableRowState extends State<ReUsableRow> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [Text(widget.title), Text(widget.value)],
    );
  }
}
