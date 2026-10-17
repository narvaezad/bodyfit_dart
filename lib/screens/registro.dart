
import 'package:flutter/material.dart';
import '../models/models.dart';
import '../widgets/componentes.dart';
import 'resumen.dart';

class RegistroScreen extends StatefulWidget {
  final Producto producto;

  const RegistroScreen({
    super.key,
    required this.producto,
  });

  @override
  State<RegistroScreen> createState() => _RegistroScreenState();
}

class _RegistroScreenState extends State<RegistroScreen> {
  String talla = 'M';
  int cantidad = 1;

  @override
  Widget build(BuildContext context) {
    final producto = widget.producto;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text(
          'Detalle de producto',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ResumenScreen(),
                ),
              );
            },
            icon: const Icon(Icons.shopping_bag_outlined),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(18, 8, 18, 20),
                children: [
                  Container(
                    height: 290,
                    decoration: BoxDecoration(
                      color: const Color(0xFF17181A),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.asset(
                              producto.imagen,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) =>
                                  Icon(
                                producto.icono,
                                size: 170,
                                color: const Color(0xFFE7E4DB),
                              ),
                            ),
                          ),
                        ),
                        const Positioned(
                          top: 12,
                          right: 12,
                          child: Icon(
                            Icons.favorite_border,
                            size: 26,
                          ),
                        ),
                        Positioned(
                          left: 12,
                          bottom: 12,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: verdeBodyFit,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              'BODYFIT ORIGINAL',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 10,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 22),
                  Text(
                    producto.nombre,
                    style: const TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Row(
                    children: [
                      Icon(Icons.star, color: verdeBodyFit, size: 18),
                      SizedBox(width: 4),
                      Text(
                        '4.8',
                        style: TextStyle(fontWeight: FontWeight.w800),
                      ),
                      SizedBox(width: 6),
                      Text(
                        '(128 reseñas)',
                        style: TextStyle(
                          color: grisBodyFit,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    precioCOP(producto.precio),
                    style: const TextStyle(
                      fontSize: 29,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const Divider(height: 28, color: Color(0xFF292A2D)),
                  const Text(
                    'Descripción y material',
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    producto.descripcion,
                    style: const TextStyle(
                      color: grisBodyFit,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Talla',
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: ['XS', 'S', 'M', 'L', 'XL'].map((valor) {
                      final seleccionada = talla == valor;

                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 7),
                          child: SizedBox(
                            height: 48,
                            child: OutlinedButton(
                              onPressed: () {
                                setState(() => talla = valor);
                              },
                              style: OutlinedButton.styleFrom(
                                backgroundColor: seleccionada
                                    ? Colors.white
                                    : panelBodyFit,
                                foregroundColor: seleccionada
                                    ? Colors.black
                                    : Colors.white,
                                side: BorderSide(
                                  color: seleccionada
                                      ? Colors.white
                                      : const Color(0xFF292A2D),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: EdgeInsets.zero,
                              ),
                              child: Text(
                                valor,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Cantidad',
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: panelBodyFit,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: cantidad > 1
                              ? () => setState(() => cantidad--)
                              : null,
                          icon: const Icon(Icons.remove),
                        ),
                        Text(
                          '$cantidad',
                          style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 16,
                          ),
                        ),
                        IconButton(
                          onPressed: cantidad < 10
                              ? () => setState(() => cantidad++)
                              : null,
                          icon: const Icon(
                            Icons.add,
                            color: verdeBodyFit,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(18, 12, 18, 18),
              decoration: const BoxDecoration(
                color: Color(0xFF101113),
                border: Border(
                  top: BorderSide(color: Color(0xFF242529)),
                ),
              ),
              child: BotonBodyFit(
                texto: 'Agregar al carrito',
                icono: Icons.shopping_bag_outlined,
                verde: false,
                onPressed: () {
                  CarritoBodyFit.agregar(producto, talla, cantidad);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        '${producto.nombre} agregado al carrito.',
                      ),
                      action: SnackBarAction(
                        label: 'VER CARRITO',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ResumenScreen(),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
