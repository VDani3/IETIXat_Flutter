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
          child: appData.url == "" ? Expanded(child: Text("hola", style: TextStyle(),)) : chat_column(controller: controller),
        ));
  }
}



