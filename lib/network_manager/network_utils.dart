import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:scrapabill/views/styles/k_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http_parser/http_parser.dart';

import 'api.dart';

class Network {
  static String noInternetMessage = "Check your connection!";

  static getRequest(String endPoint,
      {bool requireToken = true, bool noBaseUrl = false}) async {
    if (await isNetworkAvailable()) {
      Response response;
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      var accessToken = sharedPreferences.getString('token');

      var headers = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      };

      if (requireToken) {
        var header = {"Authorization": "Bearer $accessToken"};
        headers.addAll(header);
      }

      print('URL: ${API.base}$endPoint');
      print("Headers: $headers");
      if (requireToken) {
        response =
            await get(Uri.parse('${API.base}$endPoint'), headers: headers);
      } else if (noBaseUrl) {
        response = await get(Uri.parse('$endPoint'));
      } else {
        response = await get(Uri.parse('${API.base}$endPoint'));
      }

      return response;
    } else {
      throw noInternetMessage;
    }
  }

  static postRequest(String endPoint, request,
      {bool requireToken = true}) async {
    if (await isNetworkAvailable()) {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      var accessToken = sharedPreferences.getString('token');

      var headers = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      };

      if (requireToken) {
        var header = {"Authorization": "Bearer $accessToken"};
        headers.addAll(header);
      }

      print('URL: ${API.base}$endPoint');
      print("Headers: $headers");
      print('Request: $request');

      Response response = await post(Uri.parse('${API.base}' + '$endPoint'),
          body: jsonEncode(request), headers: headers);

      return response;
    } else {
      throw noInternetMessage;
    }
  }

  static multiPartRequest(
    String endPoint,
    String methodName, {
    body,
    File file,
    String filename,
    String fileFieldName,
    String type,
    String subType,
  }) async {
    if (await isNetworkAvailable()) {
      /// MultiPart request ///
      var request = MultipartRequest(
        methodName.toUpperCase(),
        Uri.parse('${API.base}' + '$endPoint'),
      );
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      var accessToken = sharedPreferences.getString('token');

      Map<String, String> headers = {
        "Authorization": "Bearer $accessToken",
      };

      if (file != null && filename != null) {
        request.files.add(
          MultipartFile(
            'file',
            file.readAsBytes().asStream(),
            file.lengthSync(),
            filename: filename,
            contentType: MediaType(type, subType),
          ),
        );
      }

      request.headers.addAll(headers);
      if (body != null) request.fields.addAll((body));

      print('Headers: ${request.headers}');
      print('Request: $request');
      StreamedResponse streamedResponse = await request.send();
      Response response = await Response.fromStream(streamedResponse);
      //print('Response: ${response.statusCode} ${response.body}');
      return response;
    } else {
      throw noInternetMessage;
    }
  }

  static handleResponse(Response response) async {
    if (!await isNetworkAvailable()) {
      throw noInternetMessage;
    }
    if (response.statusCode >= 200 && response.statusCode <= 206) {
      print('Response: ${response.statusCode}');
      print('${response.body}');
      if (response.body.isNotEmpty)
        return json.decode(response.body);
      else
        return response.body;
    } else if (response.statusCode == 401) {
      toast('Session expired! Login to continue...',
          bgColor: KColor.primaryColor);
      // NavigationService.navigateToReplacement(
      //     MaterialPageRoute(builder: (_) => LoginScreen()));
    } else {
      if (response.body.isJson()) {
        print("errorResponse: ${jsonDecode(response.body)}");
        toast('Something went wrong!', bgColor: KColor.primaryColor);
      } else {
        print("errorResponse: ${response.body}");
        toast('Something went wrong!', bgColor: KColor.primaryColor);
      }
    }
  }
}
