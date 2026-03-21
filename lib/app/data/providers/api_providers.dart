import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../../core/constants/api_constants.dart';

class ApiProvider extends GetxService {
  late Dio _dio;
  final Connectivity _connectivity = Connectivity();

  static ApiProvider get to => Get.find();

  Future<ApiProvider> init() async {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.fullBaseUrl,
        connectTimeout: const Duration(
          milliseconds: ApiConstants.connectTimerOutMs,
        ),
        receiveTimeout: const Duration(
          milliseconds: ApiConstants.receiveTimerOutMs,
        ),
        sendTimeout: const Duration(milliseconds: ApiConstants.sendTimerOutMs),
        headers: {
          'Content-Type': ApiConstants.contentType,
          'Accept': 'application/json',
        },
      ),
    );

    // Add interceptors
    _addInterceptors();

    return this;
  }

  void _addInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Add auth token if needed
          return handler.next(options);
        },
        onResponse: (response, handler) {
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          if (e.response?.statusCode == 401) {
            // Handle token expiration / unauthorized
            // e.g., Get.offAllNamed(Routes.LOGIN);
          }
          return handler.next(e);
        },
      ),
    );

    // Logging Interceptor
    _dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90,
      ),
    );
  }

  // GET Request
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      if (!await _checkConnectivity()) {
        throw DioException(
          requestOptions: RequestOptions(path: path),
          error: 'No Internet Connection',
          type: DioExceptionType.connectionError,
        );
      }
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response;
    } catch (e) {
      throw _handleError(e);
    }
  }

  // POST Request
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      if (!await _checkConnectivity()) {
        throw DioException(
          requestOptions: RequestOptions(path: path),
          error: 'No Internet Connection',
          type: DioExceptionType.connectionError,
        );
      }
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response;
    } catch (e) {
      throw _handleError(e);
    }
  }

  // PUT Request
  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      if (!await _checkConnectivity()) {
        throw DioException(
          requestOptions: RequestOptions(path: path),
          error: 'No Internet Connection',
          type: DioExceptionType.connectionError,
        );
      }
      final response = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response;
    } catch (e) {
      throw _handleError(e);
    }
  }

  // DELETE Request
  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      if (!await _checkConnectivity()) {
        throw DioException(
          requestOptions: RequestOptions(path: path),
          error: 'No Internet Connection',
          type: DioExceptionType.connectionError,
        );
      }
      final response = await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response;
    } catch (e) {
      throw _handleError(e);
    }
  }

  _handleError(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
          throw Exception('Connection Timeout');
        case DioExceptionType.receiveTimeout:
          throw Exception('Receive Timeout');
        case DioExceptionType.sendTimeout:
          throw Exception('Send Timeout');
        case DioExceptionType.cancel:
          throw Exception('Request Cancelled');
        case DioExceptionType.connectionError:
          throw Exception('No Internet Connection');
        case DioExceptionType.badCertificate:
          throw Exception('Bad Certificate');
        case DioExceptionType.badResponse:
          throw Exception(_handleStatusCode(error.response?.statusCode));
        case DioExceptionType.unknown:
          throw Exception('Unknown Error');
      }
    }
  }

  _handleStatusCode(int? statusCode) {
    switch (statusCode) {
      case 400:
        return 'Bad Request';
      case 401:
        return 'Unauthorized';
      case 403:
        return 'Forbidden';
      case 404:
        return 'Not Found';
      case 405:
        return 'Method Not Allowed';
      case 408:
        return 'Request Timeout';
      case 409:
        return 'Conflict';
      case 410:
        return 'Gone';
      case 411:
        return 'Length Required';
      case 412:
        return 'Precondition Failed';
      case 413:
        return 'Payload Too Large';
      case 414:
        return 'URI Too Long';
      case 415:
        return 'Unsupported Media Type';
      case 416:
        return 'Range Not Satisfiable';
      case 417:
        return 'Expectation Failed';
      case 422:
        return 'Unprocessable Entity';
      case 425:
        return 'Too Early';
      case 426:
        return 'Upgrade Required';
      case 428:
        return 'Precondition Required';
      case 429:
        return 'Too Many Requests';
      case 431:
        return 'Request Header Fields Too Large';
      case 500:
        return 'Internal Server Error';
      case 501:
        return 'Not Implemented';
      case 502:
        return 'Bad Gateway';
      case 503:
        return 'Service Unavailable';
      case 504:
        return 'Gateway Timeout';
      case 505:
        return 'HTTP Version Not Supported';
      case 506:
        return 'Variant Also Negotiates';
      case 507:
        return 'Insufficient Storage';
      case 508:
        return 'Loop Detected';
      case 510:
        return 'Not Extended';
      case 511:
        return 'Network Authentication Required';
      default:
        return 'Unknown Error';
    }
  }

  // Connectivity Check
  Future<bool> _checkConnectivity() async {
    final connectivityResult = await _connectivity.checkConnectivity();
    // In connectivity_plus 7.0.0, checkConnectivity() returns List<ConnectivityResult>
    return !connectivityResult.contains(ConnectivityResult.none);
  }
}
