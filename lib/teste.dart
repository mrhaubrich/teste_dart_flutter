import 'package:dio/dio.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:retrofit/retrofit.dart';

part 'teste.g.dart';

const kDebugMode = true;

@RestApi(baseUrl: 'http://localhost:8000')
abstract class RestClient {
  factory RestClient(Dio dio, {String baseUrl}) = _RestClient;

  @GET('/foto')
  Future<Foto> getFoto();

  @GET('/usuario')
  Future<Usuario> getUsuario();

  @GET('/usuarios')
  Future<List<Usuario>> getUsuarios();
}

abstract class BaseEndpoint {
  String get path;
}

@JsonSerializable()
class Foto {
  Foto({
    required this.url,
  });

  final String url;

  factory Foto.fromJson(Map<String, dynamic> json) => _$FotoFromJson(json);

  Map<String, dynamic> toJson() => _$FotoToJson(this);

  @override
  String toString() => 'Foto{foto: $url}';
}

@JsonSerializable()
class Usuario {
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

  factory Usuario.fromJson(Map<String, dynamic> json) =>
      _$UsuarioFromJson(json);

  Map<String, dynamic> toJson() => _$UsuarioToJson(this);

  @override
  String toString() {
    return 'Usuario{nome: $nome, matricula: $matricula, email: $email, foto: $foto}';
  }
}

class Client {
  static Client? _instance;

  static Client get instance => _instance ??= Client._();

  Client._();

  RestClient client = RestClient(Dio());
}
