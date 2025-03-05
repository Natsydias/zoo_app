class Usuario {
  int? id;
  String nombre;
  String email;
  String password;

  Usuario({this.id, required this.nombre, required this.email, required this.password});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'email': email,
      'password': password,
    };
  }

  factory Usuario.fromMap(Map<String, dynamic> map) {
    return Usuario(
      id: map['id'],
      nombre: map['nombre'],
      email: map['email'],
      password: map['password'],
    );
  }
}
