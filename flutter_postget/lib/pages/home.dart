import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xatieti_jd/other/app_data.dart';
import 'package:xatieti_jd/widgets/app_bar.dart';
import 'package:xatieti_jd/widgets/chat_column.dart';
import 'package:xatieti_jd/widgets/text_field.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late TextEditingController controller;
  String text = '';

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    AppData appData = Provider.of<AppData>(context);

    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: MyAppBar(),
        ),
        body: Container(
          child: appData.url == "" ? SampleText() : chat_column(controller: controller),
        ));
  }

  Container SampleText() => Container(
    
    child: Container(
      padding: EdgeInsets.only(top: 50, left: 10, right: 10),
      child: Column(
        children: [
          Text(
            "Hello, I'm Laphi, an AI powered by Ollama! \nThank you for wanting to talk to me ^·^\nI'll try to answer your questions as best as I can! \nBefore we start, specify the IP address and port you want to connect to by pressing the button in the top left corner, please.", 
            style: TextStyle(color: Color.fromARGB(255, 88, 88, 88), fontSize: 14)
          ),
          Container(
            padding: EdgeInsets.only(top: 16),
            height: MediaQuery.of(context).size.height/2.5,
            child: Image(image: AssetImage("assets/images/laphi.png"),)
          )
        ],
      ),
      alignment: Alignment.topCenter,
    )
  );
}



