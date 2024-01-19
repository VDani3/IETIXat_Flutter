import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xatieti_jd/other/app_data.dart';

class MyAppBar extends StatelessWidget {
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
          Icon(
            Icons.menu,
            color: Colors.white,
            size: 30.0,
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
              if (appData.loadingGet == false && appData.loadingPost == false && appData.loadingFile == false){
                appData.canSendMessage = true;
                appData.clearMessages();
              }
            },
          ),
        ],
      ),
    );
  }
}
