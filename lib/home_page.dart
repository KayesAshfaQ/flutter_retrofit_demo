import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_retrofit_demo/retrofit/api_client.dart';

import 'model/data.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Retrofit Demo'),
      ),
      body: _buildBody(context),
    );
  }

  // build list view & manage states
  FutureBuilder<ResponseData> _buildBody(BuildContext context) {
    final client = ApiClient(Dio(BaseOptions(contentType: "application/json")));
    return FutureBuilder<ResponseData>(
      future: client.getUsers(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.data != null) {
          final ResponseData? posts = snapshot.data;
          return _buildListView(context, posts!);
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  // build list view & its tile
  Widget _buildListView(BuildContext context, ResponseData posts) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return Card(
          child: ListTile(
            leading: const Icon(
              Icons.account_box,
              color: Colors.blueGrey,
              size: 50,
            ),
            title: Text(
              posts.data![index]['name'],
              style: const TextStyle(fontSize: 20),
            ),
            subtitle: Text(posts.data![index]['email']),
          ),
        );
      },
      itemCount: posts.data?.length,
    );
  }
}
