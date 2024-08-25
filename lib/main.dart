import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter FastAPI App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<dynamic> items = [];
  String errorMessage = '';

  Future<void> fetchItems() async {
    try {
      final response = await http.get(Uri.parse('http://10.0.2.2:8000/items'));
      if (response.statusCode == 200) {
        setState(() {
          items = json.decode(response.body);
          errorMessage = '';
        });
      } else {
        throw Exception('Error al cargar los items');
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error al conectar con el servidor: $e';
      });
      print('Error al conectar con el servidor: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter FastAPI App'),
      ),
      body: errorMessage.isEmpty
          ? ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(items[index]['name']),
                );
              },
            )
          : Center(
              child: Text(
                errorMessage,
                style: const TextStyle(color: Colors.red),
              ),
            ),
    );
  }
}
