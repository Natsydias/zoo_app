class Animal {
  int? id;
  String nombre;
  String descripcion;
  String imagen;

  Animal({this.id, required this.nombre, required this.descripcion, required this.imagen});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'descripcion': descripcion,
      'imagen': imagen,
    };
  }

  factory Animal.fromMap(Map<String, dynamic> map) {
    return Animal(
      id: map['id'],
      nombre: map['nombre'],
      descripcion: map['descripcion'],
      imagen: map['imagen'],
    );
  }
}
