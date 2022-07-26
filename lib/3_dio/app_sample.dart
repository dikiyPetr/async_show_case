import 'dart:async';

import 'package:async_show_case/3_dio/network/api.dart';
import 'package:flutter/material.dart';

import 'model/near_earth_object_model.dart';
import 'network/dio_factory.dart';

main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final _dio = DioFactory.create();
  late final _api = Api(_dio);
  late Future<List<NearEarthObjectModel>> _nearEarthObjectsFuture;
  StreamController<int>? _currentBytesReceivedStreamController;

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  void _loadItems() {
    _currentBytesReceivedStreamController?.close();
    final streamController = StreamController<int>();
    _nearEarthObjectsFuture = _api.getNearEarthObject(
      progressCallback: (current, total) {
        //total всегда -1, тк этот запрос не возвращает header Content-Length
        streamController.add(current);
      },
    );
    _currentBytesReceivedStreamController = streamController;
  }

  Future<void> _refresh() {
    _loadItems();
    setState(() {});
    return _nearEarthObjectsFuture;
  }

  @override
  void dispose() {
    _dio.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: FutureBuilder<List<NearEarthObjectModel>>(
          future: _nearEarthObjectsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    StreamBuilder<int>(
                      stream: _currentBytesReceivedStreamController?.stream,
                      builder: (context, snapshot) {
                        final value = snapshot.data ?? 0;
                        return Text('$value\n');
                      },
                    ),
                    const Text('bytes received'),
                  ],
                ),
              );
            } else if (snapshot.hasData) {
              final items = snapshot.requireData;
              return ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, i) {
                  final item = items[i];
                  return ListTile(title: Text(item.name));
                },
              );
            } else {
              return const Center(child: Icon(Icons.warning));
            }
          },
        ),
      ),
    );
  }
}
