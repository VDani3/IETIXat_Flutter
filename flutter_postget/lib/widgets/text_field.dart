import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xatieti_jd/other/app_data.dart';
import 'package:xatieti_jd/widgets/app_bar.dart';






class text_field extends StatelessWidget {
  const text_field({
    super.key,
    required this.controller,
  });

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    AppData appData = Provider.of<AppData>(context);
    
    return Container(
      margin: EdgeInsets.all(8),
      width: MediaQuery.of(context).size.width - 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            child: Container(
              child: Icon(
                Icons.add_box_outlined,
                size: 32,
              ),
            ),
            onTap: () {
              if (appData.canSendMessage) {
                String value = controller.text;
                if (value == ""){
                  value = "Can you describe this image ";
                }
                controller.text = "";
                appData.canSendMessage = false;
                appData.addTextToList(value);
                appData.loadFotoHttpPostByChunks(appData.url, value);               
              }
            },
          ),
          Spacer(),
          Container(
            width: MediaQuery.of(context).size.width - 200,
            child: TextField(
                decoration: InputDecoration(hintText: "Message..."),
                controller: controller,
                onSubmitted: (String value) {
                  if (appData.canSendMessage) {
                    appData.canSendMessage = false;
                    appData.addTextToList(value);
                    appData.loadHttpPostByChunks(appData.url, value);
                    controller.text = "";
                  }
                  
                }),
          ),
          Spacer(),
          GestureDetector(
            child: Container(
              child: Icon(
              Icons.send,
              size: 32,
            ),
            decoration: BoxDecoration(color: Colors.transparent),
            ),
            onTap: () {
              if (appData.canSendMessage && controller.text != "") {
                String value = controller.text;
                controller.text = "";
                appData.canSendMessage = false;
                appData.addTextToList(value);
                appData.loadHttpPostByChunks(appData.url, value);               
              }
            },
          )
        ],
      ),
      padding: EdgeInsets.only(top: 8, bottom: 8, left: 16, right: 16),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(width: 2, color: Colors.black26)),
    );
  }
}