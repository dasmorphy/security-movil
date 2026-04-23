class GraphLogbook {
  List<Categoria> categorias;
  List<Categoria> categoriasCantidad;
  int totalEntrada;
  int totalSalida;

  GraphLogbook({
    required this.categorias,
    required this.categoriasCantidad,
    required this.totalEntrada,
    required this.totalSalida,
  });

  factory GraphLogbook.fromJson(Map<String, dynamic> json) => GraphLogbook(
    categorias: List<Categoria>.from(
      json["categorias"].map((x) => Categoria.fromJson(x)),
    ),
    categoriasCantidad: List<Categoria>.from(
      json["categorias_cantidad"].map((x) => Categoria.fromJson(x)),
    ),
    totalEntrada: json["total_entrada"],
    totalSalida: json["total_salida"],
  );

  Map<String, dynamic> toJson() => {
    "categorias": List<dynamic>.from(categorias.map((x) => x.toJson())),
    "categorias_cantidad": List<dynamic>.from(
      categoriasCantidad.map((x) => x.toJson()),
    ),
    "total_entrada": totalEntrada,
    "total_salida": totalSalida,
  };
}

class Categoria {
  String categoria;
  int entrada;
  int salida;
  int total;

  Categoria({
    required this.categoria,
    required this.entrada,
    required this.salida,
    required this.total,
  });

  factory Categoria.fromJson(Map<String, dynamic> json) => Categoria(
    categoria: json["categoria"],
    entrada: json["entrada"],
    salida: json["salida"],
    total: json["total"],
  );

  Map<String, dynamic> toJson() => {
    "categoria": categoria,
    "entrada": entrada,
    "salida": salida,
    "total": total,
  };
}
