import 'dart:convert';

const serverAddress = "http://192.168.2.4:8000/";
const apiItems = "items/";
const apiRoot = "root/";
const apiFolders = "folders/";
const apiDownload = "download/";
const apiFiles = "files/";

String authToken = "";

String getAuthTokenFromUsernameAndPwd(String username, String pwd) {
  String token = 'Basic ${base64Encode(utf8.encode('$username:$pwd'))}';
  return token;
}

Map<String, String> headers = {
  'content-type': 'application/json',
  'accept': 'application/json',
  'authorization': authToken
};
