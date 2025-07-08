import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController textEditingController = TextEditingController();
  String areaName = '';
  String weather = '';
  double temperature = 0.0;
  double maxTemperature = 0.0;
  double minTemperature = 0.0;
  int humidity = 0;

  Future<void> loadWeather(String query) async {
    final response = await http.get(
      Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?appid=968bcad94a6b14a88ccf2959876a93af&lang=ja&units=metric&q=$query',
      ),
    );
    if (response.statusCode != 200) {
      return;
    }
    final body = json.decode(response.body) as Map<String, dynamic>;
    final main = (body['main'] ?? {}) as Map<String, dynamic>;
    setState(() {
      areaName = body["name"];
      weather = (body["weather"]?[0]?["description"] ?? "") as String;
      temperature = (main["temperature"] ?? 0).toDouble();
      maxTemperature = (main["temp_max"] ?? 0).toDouble();
      minTemperature = (main["temp_min"] ?? 0).toDouble();
      humidity = (main["humidity"] ?? 0) as int;
    });
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: textEditingController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: "地域を入力"),
          onChanged: (value) {
            if (value.isNotEmpty) {
              loadWeather(value);
            }
          },
        ),
      ),
      body: ListView(
        children: [
          ListTile(title: Text("地域"), subtitle: Text(areaName)),
          ListTile(title: Text("天気"), subtitle: Text(weather)),
          ListTile(title: Text("温度"), subtitle: Text(temperature.toString())),
          ListTile(
            title: Text("最高温度"),
            subtitle: Text(maxTemperature.toString()),
          ),
          ListTile(
            title: Text("最低気温"),
            subtitle: Text(minTemperature.toString()),
          ),
          ListTile(title: Text("湿度"), subtitle: Text(humidity.toString())),
        ],
      ),
    );
  }
}
