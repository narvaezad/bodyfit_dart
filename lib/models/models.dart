import 'package:flutter/material.dart';

/// Producto del catálogo de BodyFit.
class Producto {
  final String nombre;
  final String categoria;
  final double precio;
  final IconData icono;
  const Producto(this.nombre, this.categoria, this.precio, this.icono);
}

const List<String> categorias = ['Camisetas', 'Pantalones', 'Shorts', 'Accesorios'];

const List<Producto> catalogo = [
  Producto('Camiseta deportiva BodyFit', 'Camisetas', 89900, Icons.checkroom),
  Producto('Camiseta Dry-Fit Pro', 'Camisetas', 74900, Icons.checkroom),
  Producto('Jogger Essential', 'Pantalones', 129900, Icons.directions_run),
  Producto('Licra Training', 'Pantalones', 99900, Icons.directions_run),
  Producto('Short Running', 'Shorts', 59900, Icons.sports_gymnastics),
  Producto('Short Gym Flex', 'Shorts', 64900, Icons.sports_gymnastics),
  Producto('Straps de levantamiento', 'Accesorios', 29900, Icons.fitness_center),
  Producto('Shaker 700 ml', 'Accesorios', 24900, Icons.local_drink),
  Producto('Bolso deportivo', 'Accesorios', 119900, Icons.backpack),
];

/// Línea del pedido: producto + talla + cantidad.
class ItemPedido {
  final Producto producto;
  final String talla;
  final int cantidad;
  const ItemPedido(this.producto, this.talla, this.cantidad);
  double get subtotal => producto.precio * cantidad;
}

/// Estado del pedido en memoria (sin base de datos ni persistencia).
class Pedido {
  static String cliente = '';
  static String direccion = '';
  static bool express = false;
  static final List<ItemPedido> items = [];

  static int get unidades => items.fold(0, (s, i) => s + i.cantidad);
  static double get subtotal => items.fold(0.0, (s, i) => s + i.subtotal);

  /// Descuento por volumen: 10% desde 3 unidades, 15% desde 5.
  static double get porcentajeDescuento =>
      unidades >= 5 ? 0.15 : (unidades >= 3 ? 0.10 : 0.0);
  static double get descuento => subtotal * porcentajeDescuento;

  /// Envío gratis si el subtotal con descuento supera $200.000.
  static double get envio {
    if (items.isEmpty) return 0;
    final base = (subtotal - descuento) >= 200000 ? 0.0 : 8000.0;
    return base + (express ? 7000.0 : 0.0);
  }

  static double get total => subtotal - descuento + envio;

  static void limpiar() {
    items.clear();
    express = false;
  }
}

/// Formatea un valor como pesos colombianos: $89.900
String formatoCOP(double v) {
  final s = v.round().toString();
  final conPuntos =
      s.replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => '.');
  return '\$$conPuntos';
}
