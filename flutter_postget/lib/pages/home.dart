import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xatieti_jd/other/app_data.dart';
import 'package:xatieti_jd/widgets/app_bar.dart';

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
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
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
                                ],
                              ))),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(8),
              width: MediaQuery.of(context).size.width - 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_box_outlined,
                    size: 32,
                  ),
                  Spacer(),
                  Container(
                    width: MediaQuery.of(context).size.width - 200,
                    child: TextField(
                        decoration: InputDecoration(hintText: "Message..."),
                        controller: controller,
                        onSubmitted: (String value) {
                          if (appData.canSendMessage) {
                            appData.addTextToList(value);
                            controller.text = "";
                            appData.canSendMessage = false;
                          }
                          
                        }),
                  ),
                  Spacer(),
                  Icon(
                    Icons.send,
                    size: 32,
                  )
                ],
              ),
              padding: EdgeInsets.only(top: 8, bottom: 8, left: 16, right: 16),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(width: 2, color: Colors.black26)),
            ),
          ]),
        ));
  }
}
