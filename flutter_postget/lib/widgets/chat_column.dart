import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xatieti_jd/other/app_data.dart';
import 'package:xatieti_jd/widgets/app_bar.dart';
import 'package:xatieti_jd/widgets/text_field.dart';

class chat_column extends StatelessWidget {
  const chat_column({
    super.key,
    required this.controller,
  });

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    AppData appData = Provider.of<AppData>(context);

    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Expanded(
        //Part Central
        child: Container(
          child: ListView.builder(
            itemCount: appData.responses.length,
            itemBuilder: (context, index) {
              return Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(18),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: index % 2 == 0
                      ? Color.fromARGB(29, 52, 52, 52)
                      : Colors.transparent,
                ),
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 16),
                      width: MediaQuery.of(context).size.width / 6,
                      child: Container(
                        height: 50,
                        child: index % 2 == 0 ? Icon(Icons.account_circle_outlined, color: Colors.black, size: 50) : Image.asset("assets/images/laphi.png", scale: 15,)),
                    ),
                    Expanded(
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding:EdgeInsets.only(bottom: 8),
                              child: index % 2 == 0 ? Text("You", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),) : Text("Laphi (XatIETI)", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18))
                            ),
                            Text(appData.responses[index]),
                            SizedBox(height: 8,),
                            Container(
                              child: appData.responseImages[index] != "" ? Image.file(File(appData.responseImages[index]), height: 200,) : Text(''),
                            )
                          ],
                        ))),
                  ],
                ),
              );
            },
          ),
        ),
      ),
      text_field(controller: controller),
    ]);
  }
}




























