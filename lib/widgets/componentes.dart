import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/models.dart';

const verdeBodyFit = Color(0xFFE5FF35);
const panelBodyFit = Color(0xFF191A1D);
const grisBodyFit = Color(0xFF96979C);

class TituloSeccion extends StatelessWidget {
  final String titulo;

  const TituloSeccion(this.titulo, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        titulo.toUpperCase(),
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w900,
          letterSpacing: 1,
        ),
      ),
    );
  }
}

class BotonBodyFit extends StatelessWidget {
  final String texto;
  final VoidCallback onPressed;
  final IconData? icono;
  final bool verde;

  const BotonBodyFit({
    super.key,
    required this.texto,
    required this.onPressed,
    this.icono,
    this.verde = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icono ?? Icons.arrow_forward),
        label: Text(
          texto,
          style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: verde ? verdeBodyFit : Colors.white,
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 0,
        ),
      ),
    );
  }
}

class ImagenProducto extends StatelessWidget {
  final Producto producto;
  final double tamano;

  const ImagenProducto({super.key, required this.producto, this.tamano = 80});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: tamano,
      height: tamano,
      decoration: BoxDecoration(
        color: const Color(0xFFE8E5DB),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.asset(
          producto.imagen,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) => Icon(
            producto.icono,
            size: tamano * 0.53,
            color: const Color(0xFF252525),
          ),
        ),
      ),
    );
  }
}

class TarjetaProducto extends StatelessWidget {
  final Producto producto;
  final VoidCallback onTap;

  const TarjetaProducto({
    super.key,
    required this.producto,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: panelBodyFit,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final tamano =
                            constraints.maxWidth < constraints.maxHeight
                            ? constraints.maxWidth
                            : constraints.maxHeight;

                        return Center(
                          child: ImagenProducto(
                            producto: producto,
                            tamano: tamano,
                          ),
                        );
                      },
                    ),
                  ),
                  const Positioned(
                    right: 0,
                    top: 0,
                    child: Icon(
                      Icons.favorite_border,
                      size: 21,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Text(
              producto.nombre,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 5),
            Text(
              precioCOP(producto.precio),
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900),
            ),
          ],
        ),
      ),
    );
  }
}

class CampoTextoBodyFit extends StatelessWidget {
  final String label;
  final IconData icono;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final TextInputType teclado;
  final List<TextInputFormatter>? formatos;

  const CampoTextoBodyFit({
    super.key,
    required this.label,
    required this.icono,
    required this.controller,
    this.validator,
    this.teclado = TextInputType.text,
    this.formatos,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        keyboardType: teclado,
        inputFormatters: formatos,
        validator: validator,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: label,
          hintStyle: const TextStyle(color: grisBodyFit),
          prefixIcon: Icon(icono, color: grisBodyFit),
          filled: true,
          fillColor: panelBodyFit,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: verdeBodyFit),
          ),
        ),
      ),
    );
  }
}
