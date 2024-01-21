import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xatieti_jd/other/app_data.dart';

class MyAppBar extends StatelessWidget {
  TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    AppData appData = Provider.of<AppData>(context);

    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.blue, // Color de fondo de la AppBar
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(20.0),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            child: Container(
              color: Colors.transparent,
              child: Icon(
                Icons.keyboard_control_outlined,
                color: Colors.white,
                size: 30.0,
              ),
            ),
            onTap: () {
              _displayDialog(context, appData);
            },
          ),
          Text(
            'Chat',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          GestureDetector(
            child: Icon(
              Icons.add_circle_outline_sharp,
              color: Colors.white,
              size: 30.0,
            ),
            onTap: () {
              if (appData.loadingGet == false && appData.loadingPost == false && appData.loadingFile == false ){
                appData.canSendMessage = true;
                appData.clearMessages();
              }
            },
          ),
        ],
      ),
    );
  }

  Future<void> _displayDialog(BuildContext context, AppData appData) async {
    return showDialog(
      context: context, 
      builder: (context) {
        return AlertDialog(
          title: Text('Specify the server IP:Port'),
          content: TextField(
            controller: _controller,
            onSubmitted: (value) {
              if (value != "") {
                appData.setUrl(value);
              }
              Navigator.pop(context);
            },
            decoration: InputDecoration(hintText: "http://192.168.x.x:3000"),
          ),
          actions: <Widget>[
            MaterialButton(
              textColor: Colors.white,
              color: Colors.blue,
              child: Text('OK'),
              onPressed: () {
                if (_controller.text != "") {
                  appData.setUrl(_controller.text);
                }
                Navigator.pop(context);
              }
            )
          ],
        );
      }
    );
  }
}

