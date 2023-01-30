import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class HomeView extends StatefulWidget {
  final WebSocketChannel channel = IOWebSocketChannel.connect("wss://demo.piesocket.com/v3/channel_123?api_key=VCXCEuvhGcBDP7XhiJJUDvR1e1D3eiVjgZ9VRiaV&notify_self");

  HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState(channel);
}

class _HomeViewState extends State<HomeView> {
  final WebSocketChannel channel;
  final inputController = TextEditingController();
  List<String> messageList = [];

  _HomeViewState(this.channel) {
    channel.stream.listen((data) {
      setState(() {
        print('Data: ' + data);
        messageList.add(data);
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    inputController.dispose();
    channel.sink.close();
  }

  ListView getMessageList() {
    List<Widget> listWidget = [];

    for (String message in messageList) {
      listWidget.add(
        ListTile(
          title: Container(
            padding: const EdgeInsets.all(8),
            child: Text(
              message,
              style: TextStyle(fontSize: 22),
            ),
            color: Colors.teal[50],
            height: 60,
          ),
        ),
      );
    }

    return ListView(
      children: listWidget,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Web Socket Demo'), centerTitle: true),
      body: Container(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: inputController,
                      decoration: InputDecoration(
                        labelText: 'Send Message',
                        border: OutlineInputBorder(),
                      ),
                      style: TextStyle(fontSize: 22),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: ElevatedButton(
                      onPressed: () {
                        if (inputController.text.isNotEmpty) {
                          print(inputController.text);
                          channel.sink.add(inputController.text);
                          inputController.text = '';
                        }
                      },
                      child: Text(
                        'Send',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(child: getMessageList())
          ],
        ),
      ),
    );
  }
}
