import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart' show kReleaseMode;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;

class AppData with ChangeNotifier {
  // Access appData globaly with:
  // AppData appData = Provider.of<AppData>(context);
  // AppData appData = Provider.of<AppData>(context, listen: false)

  bool loadingGet = false;
  bool loadingPost = false;
  bool loadingFile = false;
  bool canSendMessage = true;

  List<String> responses = [];

  String url = "http://192.168.18.115:3000/data";

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
          addErrorMessage();
          completer.completeError(
              "Error del servidor (appData/loadHttpGetByChunks): $error");
        },
      );
    } catch (e) {
      addErrorMessage();
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
    request.fields['data'] = '{"type":"conversa","text":"$data"}';

    try {
      var response = await request.send();
      addTextToList("...");

      // Listen to each chunk of data
      response.stream.transform(utf8.decoder).listen(
        (data) {
          if (responses[responses.length - 1] == "...") {
            responses[responses.length - 1] = "";
          }
          responses[responses.length - 1] += data;
        },
        onDone: () {
          if (response.statusCode == 200) {
            // La solicitud ha sido exitosa
            print(dataPost);
            canSendMessage = true;
            completer.complete();
          } else {
            addErrorMessage();
            // La solicitud ha fallado
            completer.completeError(
                "Error del servidor (appData/loadHttpPostByChunks): ${response.reasonPhrase}");
          }
        },
        onError: (error) {
          addErrorMessage();
          completer.completeError(
              "Error del servidor (appData/loadHttpPostByChunks): $error");
        },
      );
    } catch (e) {
      addErrorMessage();
      completer.completeError("Excepción (appData/loadHttpPostByChunks): $e");
    }

    if (responses.length %2 == 0) {
        addErrorMessage();
    }
    canSendMessage = true;
    loadingPost = false;
    return completer.future;
  }

  //Send Image
  Future<void> loadFotoHttpPostByChunks(String url, String msn) async {
    bool loadingPost = true;
    var completer = Completer<void>();
    var request = http.MultipartRequest('POST', Uri.parse(url));
    String _selectedImageString = "";

    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final Uint8List bytes = await pickedFile.readAsBytes();
      final img.Image image = img.decodeImage(Uint8List.fromList(bytes))!;
      final String base64String =
          base64Encode(Uint8List.fromList(img.encodePng(image)));
      _selectedImageString = base64String;

      request.fields['data'] =
          '{"type":"image","text":"$msn", "image":"$_selectedImageString"}';

      try {
        var response = await request.send();
        addTextToList("...");

        // Listen to each chunk of data
        response.stream.transform(utf8.decoder).listen(
          (data) {
            if (responses[responses.length - 1] == "...") {
              responses[responses.length - 1] = "";
            }
            responses[responses.length - 1] += data;
          },
          onDone: () {
            if (response.statusCode == 200) {
              // La solicitud ha sido exitosa
              print(dataPost);
              canSendMessage = true;
              completer.complete();
              loadingPost = false;
            } else {
              addErrorMessage();
              // La solicitud ha fallado
              completer.completeError(
                  "Error del servidor (appData/loadHttpPostByChunks): ${response.reasonPhrase}");
            }
          },
          onError: (error) {
            addErrorMessage();
            completer.completeError(
                "Error del servidor (appData/loadHttpPostByChunks): $error");
          },
        );
      } catch (e) {
        addErrorMessage();
        completer.completeError("Excepción (appData/loadHttpPostByChunks): $e");
      }

      if (responses.length %2 == 0) {
        addErrorMessage();
      }
      canSendMessage = true;
      loadingPost = false;
      return completer.future;
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

  //Funcio per dir error
  void addErrorMessage() {
    responses[responses.length - 1] = "Error";
  }
}
