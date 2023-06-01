import 'package:dio/dio.dart';
import 'package:reflectable/reflectable.dart';

const kDebugMode = true;

class MyReflectable extends Reflectable {
  const MyReflectable()
      : super(
          invokingCapability,
          declarationsCapability,
          reflectedTypeCapability,
        );
}

const myReflectable = MyReflectable();

mixin APIRequest {
  /// URL de produção, necessário implementar.
  String get baseUrlProd =>
      throw UnimplementedError('Implementar URL de produção');

  /// URL de desenvolvimento, necessário implementar.
  String get baseUrlDev =>
      throw UnimplementedError('Implementar URL de desenvolvimento');

  String get baseUrl => kDebugMode ? baseUrlDev : baseUrlProd;

  late Dio dio;

  Future<T> get<T extends APIResponse>({
    required String path,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
      );

      return Activator.createInstance(
        T,
        'fromJson',
        [response.data],
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<List<T>> getList<T extends APIResponse>({
    required String path,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
      );

      return (response.data as List)
          .map((e) => Activator.createInstance(
                T,
                'fromJson',
                [e],
              ) as T)
          .toList();
    } catch (e) {
      rethrow;
    }
  }
}

@myReflectable
class APIClient with APIRequest {
  //#region Singleton
  static APIClient? _instance;

  static APIClient get instance => _instance ??= APIClient._();

  APIClient._();

  //#endregion

  FotoService? _foto;

  FotoService get foto => _foto ??= FotoService();

  UsuarioService? _usuario;

  UsuarioService get usuario => _usuario ??= UsuarioService();

  @override
  String get baseUrlProd => 'https://example.com';

  @override
  String get baseUrlDev => 'http://localhost:8000';

  Future<void> login({required String authCookies}) async {
    dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        headers: {
          'Cookie': authCookies,
        },
      ),
    );
  }
}

abstract class BaseEndpoint {
  String get path;
}

class FotoService implements BaseEndpoint {
  @override
  String get path => '/foto';

  Future<Foto> get foto async {
    try {
      return APIClient.instance.get<Foto>(
        path: path,
      );
    } catch (e) {
      rethrow;
    }
  }
}

abstract class APIResponse {
  APIResponse();

  factory APIResponse.fromJson(Map<String, dynamic> json) {
    throw UnimplementedError('Implementar factory fromJson');
  }
}

class Activator {
  static createInstance(Type type,
      [String constructor = "",
      List? arguments,
      Map<Symbol, dynamic>? namedArguments]) {
    arguments ??= const [];

    var typeMirror = myReflectable.reflectType(type);
    if (typeMirror is ClassMirror) {
      return typeMirror.newInstance(
          constructor, arguments, namedArguments ?? {});
    } else {
      throw ArgumentError("Cannot create the instance of the type '$type'.");
    }
  }
}

@myReflectable
class Foto extends APIResponse {
  Foto({
    required this.foto,
  });

  final String foto;

  factory Foto.fromJson(Map<String, dynamic> json) {
    return Foto(
      foto: json['foto'] as String,
    );
  }

  @override
  String toString() => 'Foto{foto: $foto}';
}

@myReflectable
class Usuario extends APIResponse {
  Usuario({
    required this.nome,
    required this.matricula,
    required this.email,
    required this.foto,
  });

  final String nome;
  final String matricula;
  final String email;
  final Foto foto;

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      nome: json['nome'] as String,
      matricula: json['matricula'] as String,
      email: json['email'] as String,
      foto: Foto(foto: json['foto']),
    );
  }

  @override
  String toString() {
    return 'Usuario{nome: $nome, matricula: $matricula, email: $email, foto: $foto}';
  }
}

class UsuarioService extends BaseEndpoint {
  @override
  String get path => '/usuario';

  Future<Usuario> get usuario async {
    try {
      return APIClient.instance.get<Usuario>(
        path: path,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Usuario>> get usuarios async {
    try {
      return APIClient.instance.getList<Usuario>(
        path: '/usuarios',
      );
    } catch (e) {
      rethrow;
    }
  }
}
