
import 'package:flutter/material.dart';

class Producto {
  final String id;
  final String nombre;
  final String categoria;
  final double precio;
  final String descripcion;
  final IconData icono;

  const Producto({
    required this.id,
    required this.nombre,
    required this.categoria,
    required this.precio,
    required this.descripcion,
    required this.icono,
  });
}

class ArticuloCarrito {
  final Producto producto;
  String talla;
  int cantidad;

  ArticuloCarrito({
    required this.producto,
    required this.talla,
    this.cantidad = 1,
  });

  double get subtotal => producto.precio * cantidad;
}

const productosBodyFit = <Producto>[
  Producto(
    id: 'p1',
    nombre: 'Essential Tee',
    categoria: 'Camisetas',
    precio: 89900,
    descripcion:
        'Camiseta deportiva de tejido ligero y transpirable, '
        'ideal para tus entrenamientos.',
    icono: Icons.checkroom,
  ),
  Producto(
    id: 'p2',
    nombre: 'Training Joggers',
    categoria: 'Pantalones',
    precio: 149900,
    descripcion:
        'Jogger deportivo cómodo y flexible para entrenar '
        'o usar en tu día a día.',
    icono: Icons.airline_seat_legroom_extra,
  ),
  Producto(
    id: 'p3',
    nombre: 'Performance Shorts',
    categoria: 'Shorts',
    precio: 69900,
    descripcion:
        'Short ligero que facilita el movimiento durante '
        'tus sesiones de entrenamiento.',
    icono: Icons.dry_cleaning,
  ),
  Producto(
    id: 'p4',
    nombre: 'Wrist Straps',
    categoria: 'Accesorios',
    precio: 29900,
    descripcion:
        'Accesorios de apoyo para mejorar el agarre '
        'durante determinados ejercicios de fuerza.',
    icono: Icons.fitness_center,
  ),
];

class CarritoBodyFit {
  CarritoBodyFit._();

  static final List<ArticuloCarrito> articulos = [];

  static void agregar(Producto producto, String talla, int cantidad) {
    final indice = articulos.indexWhere(
      (a) => a.producto.id == producto.id && a.talla == talla,
    );

    if (indice >= 0) {
      articulos[indice].cantidad += cantidad;
    } else {
      articulos.add(
        ArticuloCarrito(
          producto: producto,
          talla: talla,
          cantidad: cantidad,
        ),
      );
    }
  }

  static void eliminar(int indice) {
    articulos.removeAt(indice);
  }

  static double get subtotal {
    return articulos.fold(0, (suma, articulo) => suma + articulo.subtotal);
  }

  static double get envio => articulos.isEmpty || subtotal >= 150000
      ? 0
      : 8000;

  static double get total => subtotal + envio;

  static int get cantidadTotal {
    return articulos.fold(0, (suma, articulo) => suma + articulo.cantidad);
  }

  static void vaciar() {
    articulos.clear();
  }
}

String precioCOP(double valor) {
  final numero = valor.round().toString();
  final salida = StringBuffer();

  for (int i = 0; i < numero.length; i++) {
    salida.write(numero[i]);

    final restantes = numero.length - i - 1;

    if (restantes > 0 && restantes % 3 == 0) {
      salida.write('.');
    }
  }

  return '\$${salida.toString()}';
}
