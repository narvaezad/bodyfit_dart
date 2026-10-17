import 'package:flutter/material.dart';
import '../models/models.dart';

/// COMPONENTE PERSONALIZADO 1: tarjeta de producto reutilizable.
class ProductoCard extends StatelessWidget {
  final Producto producto;
  final VoidCallback onTap;
  const ProductoCard({super.key, required this.producto, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFF262626),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(producto.icono, size: 48, color: color),
              ),
            ),
            const SizedBox(height: 10),
            Text(producto.nombre,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            Text(formatoCOP(producto.precio),
                style: TextStyle(color: color, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

/// COMPONENTE PERSONALIZADO 2: campo de formulario reutilizable con ícono.
class CampoFormulario extends StatelessWidget {
  final String etiqueta;
  final IconData icono;
  final TextEditingController controlador;
  final String? Function(String?) validador;
  final TextInputType teclado;
  final int lineas;

  const CampoFormulario({
    super.key,
    required this.etiqueta,
    required this.icono,
    required this.controlador,
    required this.validador,
    this.teclado = TextInputType.text,
    this.lineas = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controlador,
      validator: validador,
      keyboardType: teclado,
      maxLines: lineas,
      decoration: InputDecoration(
        labelText: etiqueta,
        prefixIcon: Icon(icono),
        filled: true,
        fillColor: const Color(0xFF1A1A1A),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
