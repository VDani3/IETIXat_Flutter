import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart' show kReleaseMode;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';

class AppData with ChangeNotifier {
  // Access appData globaly with:
  // AppData appData = Provider.of<AppData>(context);
  // AppData appData = Provider.of<AppData>(context, listen: false)

  bool loadingGet = false;
  bool loadingPost = false;
  bool loadingFile = false;
  bool canSendMessage = true;

  List<String> responses = [];

  dynamic dataGet;
  dynamic dataPost;
  dynamic dataFile;

  void addTextToList(String text) {
    responses.add(text);
    notifyListeners();
  }

  void clearMessages() {
    responses.clear();
    notifyListeners();
  }

  // Funció per fer crides tipus 'GET' i agafar la informació a mida que es va rebent
  Future<void> loadHttpGetByChunks(String url) async {
    var httpClient = HttpClient();
    var completer = Completer<void>();

    try {
      var request = await httpClient.getUrl(Uri.parse(url));
      var response = await request.close();

      dataGet = "";

      // Listen to each chunk of data
      response.transform(utf8.decoder).listen(
        (data) {
          // Aquí rep cada un dels troços de dades que envia el servidor amb 'res.write'
          dataGet += data;
          notifyListeners();
        },
        onDone: () {
          completer.complete();
        },
        onError: (error) {
          completer.completeError(
              "Error del servidor (appData/loadHttpGetByChunks): $error");
        },
      );
    } catch (e) {
      completer.completeError("Excepció (appData/loadHttpGetByChunks): $e");
    }

    return completer.future;
  }

  // Funció per fer crides tipus 'POST' amb un arxiu adjunt,
  //i agafar la informació a mida que es va rebent
  Future<void> loadHttpPostByChunks(String url, String data) async {
    bool loadingPost = true;
    var completer = Completer<void>();
    var request = http.MultipartRequest('POST', Uri.parse(url));

    // Add JSON data as part of the form
    request.fields['type'] = 'conversa';
    request.fields['text'] = data;

    try {
      var response = await request.send();

      var dataPost = "";

      // Listen to each chunk of data
      response.stream.transform(utf8.decoder).listen(
        (data) {
          // Update dataPost with the latest data
          dataPost += data;
        },
        onDone: () {
          if (response.statusCode == 200) {
            // La solicitud ha sido exitosa
            print(dataPost);
            canSendMessage = true;
            completer.complete();
          } else {
            // La solicitud ha fallado
            completer.completeError(
                "Error del servidor (appData/loadHttpPostByChunks): ${response.reasonPhrase}");
          }
        },
        onError: (error) {
          completer.completeError(
              "Error del servidor (appData/loadHttpPostByChunks): $error");
        },
      );
    } catch (e) {
      completer.completeError("Excepción (appData/loadHttpPostByChunks): $e");
    }

    return completer.future;
  }

  Future<String> loadFotoHttpPostByChunks(String url, String msn) async {
    final imagePicker =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    
    if (imagePicker == null) {
      throw Exception("Error");
    }
    
    File image = File(imagePicker!.path);
    
    var headers = {
      'Content-Type': 'application/json',
    };

    var body = {'type': 'image', 'text': msn, 'img': image};

    var response = await http.post(Uri.parse(url),
        headers: headers, body: jsonEncode(body));

    if (response.statusCode == 200) {
      // La solicitud ha sido exitosa
      print(response.body);
      addTextToList(response.body);
      return response.body;
    } else {
      // La solicitud ha fallado
      throw Exception(
          "Error del servidor (appData/loadHttpPostByChunks): ${response.reasonPhrase}");
    }
  }

  // Funció per fer carregar dades d'un arxiu json de la carpeta 'assets'
  Future<dynamic> readJsonAsset(String filePath) async {
    // If development, wait 1 second to simulate a delay
    if (!kReleaseMode) {
      await Future.delayed(const Duration(seconds: 1));
    }

    try {
      var jsonString = await rootBundle.loadString(filePath);
      final jsonData = json.decode(jsonString);
      return jsonData;
    } catch (e) {
      throw Exception("Excepció (appData/readJsonAsset): $e");
    }
  }
}
