class ApiConstants {
  static const String baseUrl = 'https://jsonplaceholder.typecode.com';
  static const String apiVersion = '/v1';
  static const String fullBaseUrl = '$baseUrl$apiVersion';

  // Endpoints
  static const String users = '/users';
  static const String api2 = '/endpoint2';
  static const String api3 = '/endpoint3';

  //Headers
  static const String contentType = "application/json";
  static const String authorization = "Authorization";
  static const String acceptLanguage = "Accept-Language";

  // TimeOuts
  static const int connectTimerOutMs = 15000;
  static const int receiveTimerOutMs = 15000;
  static const int sendTimerOutMs = 15000;
}
