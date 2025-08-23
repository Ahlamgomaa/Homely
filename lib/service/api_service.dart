import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:homely/utils/const_res.dart';
import 'package:homely/utils/url_res.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class ApiService {
  static Map<String, String> header = {
    uApiKey: ConstRes.apiKey,
  };

  static ApiService instance = ApiService();
  Completer<void>? _cancelCompleter;

  void call({
    required Function(Object response) completion,
    Function? onError,
    required String url,
    Map<String, dynamic>? param,
  }) async {
    // Initialize the cancel completer
    _cancelCompleter = Completer<void>();

    Map<String, String> params = {};
    param?.forEach((key, value) {
      params[key] = "$value";
    });
    debugPrint("❗️{URL}:  $url");
    debugPrint("❗️{PARAMETERS}:  $params");
    try {
      // Check if the request has been canceled
      if (_cancelCompleter?.isCompleted ?? false) {
        onError?.call('Request was canceled');
        return;
      }

      http.Response response = await http.post(Uri.parse(url), headers: header, body: params);

      // Check if the request has been canceled again before processing response
      if (_cancelCompleter?.isCompleted ?? false) {
        onError?.call('Request was canceled');
        return;
      }

      // debugPrint('❗️RESPONSE:  ${response.body}');
      dynamic body = jsonDecode(response.body);
      print(body);
      completion.call(body);
    } catch (e) {
      if (e is TimeoutException) {
        onError?.call('Request timed out');
      } else if (_cancelCompleter?.isCompleted ?? false) {
        onError?.call('Request was canceled');
      } else {
        debugPrint('⛔️Error in API: $e');
        onError?.call(e.toString());
      }
    }
  }

  // Function to cancel the API request
  void cancelRequest() {
    if (!(_cancelCompleter?.isCompleted ?? true)) {
      _cancelCompleter?.complete(); // Mark the completer as completed (canceled)

      debugPrint('API request has been canceled.');
    }
  }

  void multiPartCallApi(
      {required String url,
      Map<String, dynamic>? param,
      required Map<String, List<XFile?>> filesMap,
      required Function(Object response) completion}) {
    var request = http.MultipartRequest(uPost, Uri.parse(url));

    Map<String, String> params = {};
    param?.forEach((key, value) {
      if (value is List) {
        for (int i = 0; i < value.length; i++) {
          params['$key[$i]'] = value[i];
        }
      } else {
        params[key] = "$value";
      }
    });

    request.fields.addAll(params);
    request.headers.addAll(header);

    filesMap.forEach((keyName, files) {
      for (var xFile in files) {
        if (xFile != null && xFile.path.isNotEmpty) {
          File file = File(xFile.path);
          var multipartFile = http.MultipartFile(
              keyName, file.readAsBytes().asStream(), file.lengthSync(),
              filename: xFile.name);
          request.files.add(multipartFile);
        }
      }
    });
    debugPrint('Parameter ::${param.toString()}');
    debugPrint('Files :${request.files.toString()}');
    request.send().then((value) {
      debugPrint('Status Code : ${value.statusCode}');
      value.stream.bytesToString().then((respStr) {
        var response = jsonDecode(respStr);
        debugPrint('Response : $respStr');
        completion(response);
      });
    });
  }

  void pushNotification({
    String? token,
    num? deviceType,
    required String title,
    required String body,
    String? conversationId,
  }) {
    bool isIOS = deviceType == 1;

    Map<String, dynamic> messageData = {
      "apns": {
        "payload": {
          "aps": {"sound": "default"}
        }
      },
      "data": {uConversationId: conversationId, "body": body, "title": title},
    };

    if (isIOS) {
      messageData["notification"] = {"body": body, "title": title};
    }

    if (token != null) {
      messageData["token"] = token;
    } else {
      return;
    }

    Map<String, dynamic> inputData = {"message": messageData};
    http
        .post(Uri.parse(UrlRes.pushNotificationToSingleUser),
            headers: header, body: json.encode(inputData))
        .then((value) {
      debugPrint(value.body);
    });
  }
}
