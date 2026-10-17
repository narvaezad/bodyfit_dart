
import 'package:flutter/material.dart';
import '../models/models.dart';
import '../widgets/componentes.dart';
import 'inicio.dart';

class ResumenScreen extends StatefulWidget {
  const ResumenScreen({super.key});

  @override
  State<ResumenScreen> createState() => _ResumenScreenState();
}

class _ResumenScreenState extends State<ResumenScreen> {
  final _formKey = GlobalKey<FormState>();
  final _direccionController = TextEditingController();

  String metodoPago = 'Tarjeta débito/crédito';

  @override
  void dispose() {
    _direccionController.dispose();
    super.dispose();
  }

  void confirmarPedido() {
    if (CarritoBodyFit.articulos.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Agrega al menos un producto al carrito.'),
        ),
      );
      return;
    }

    if (!_formKey.currentState!.validate()) {
      return;
    }

    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: panelBodyFit,
        icon: const Icon(
          Icons.check_circle,
          color: verdeBodyFit,
          size: 52,
        ),
        title: const Text(
          '¡Pedido confirmado!',
          textAlign: TextAlign.center,
        ),
        content: Text(
          'Tu pedido por ${precioCOP(CarritoBodyFit.total)} '
          'se registró correctamente en la demostración.\n\n'
          'Método de pago: $metodoPago\n'
          'Dirección: ${_direccionController.text.trim()}\n\n'
          'No se realizó ningún cobro real.',
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              CarritoBodyFit.vaciar();

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (_) => const InicioScreen(),
                ),
                (route) => false,
              );
            },
            child: const Text(
              'Volver al inicio',
              style: TextStyle(
                color: verdeBodyFit,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final articulos = CarritoBodyFit.articulos;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text(
          'Carrito de compras',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w900,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => setState(() => CarritoBodyFit.vaciar()),
            child: const Text(
              'Vaciar',
              style: TextStyle(
                color: verdeBodyFit,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: articulos.isEmpty
            ? _carritoVacio(context)
            : Column(
                children: [
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(16, 10, 16, 18),
                      children: [
                        Row(
                          children: [
                            const Expanded(
                              child: Text(
                                'Tus productos',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                            Text(
                              '${CarritoBodyFit.cantidadTotal} artículo(s)',
                              style: const TextStyle(
                                color: grisBodyFit,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Artículos y botón para eliminarlos.
                        ...List.generate(articulos.length, (index) {
                          final articulo = articulos[index];

                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: panelBodyFit,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Row(
                              children: [
                                ImagenProducto(
                                  producto: articulo.producto,
                                  tamano: 76,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        articulo.producto.nombre,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        'Talla: ${articulo.talla} · '
                                        'Cantidad: ${articulo.cantidad}',
                                        style: const TextStyle(
                                          color: grisBodyFit,
                                          fontSize: 11,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        precioCOP(articulo.subtotal),
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  tooltip: 'Eliminar producto',
                                  onPressed: () {
                                    setState(() {
                                      CarritoBodyFit.eliminar(index);
                                    });

                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Producto eliminado del carrito.',
                                        ),
                                      ),
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.delete_outline,
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),

                        const SizedBox(height: 12),
                        const TituloSeccion('Entrega'),

                        Form(
                          key: _formKey,
                          child: TextFormField(
                            controller: _direccionController,
                            textCapitalization:
                                TextCapitalization.sentences,
                            decoration: const InputDecoration(
                              labelText: 'Dirección de entrega',
                              hintText: 'Ej. Calle 45 #12-30, Barranquilla',
                              prefixIcon: Icon(
                                Icons.location_on_outlined,
                              ),
                            ),
                            validator: (valor) {
                              if (valor == null ||
                                  valor.trim().length < 5) {
                                return 'Ingresa una dirección válida.';
                              }
                              return null;
                            },
                          ),
                        ),

                        const SizedBox(height: 20),
                        const TituloSeccion('Método de pago'),

                        Container(
                          decoration: BoxDecoration(
                            color: panelBodyFit,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              RadioListTile<String>(
                                value: 'Tarjeta débito/crédito',
                                groupValue: metodoPago,
                                activeColor: verdeBodyFit,
                                contentPadding:
                                    const EdgeInsets.symmetric(
                                  horizontal: 8,
                                ),
                                secondary: const Icon(Icons.credit_card),
                                title: const Text(
                                  'Tarjeta débito/crédito',
                                  style: TextStyle(fontSize: 12),
                                ),
                                onChanged: (valor) {
                                  if (valor != null) {
                                    setState(() => metodoPago = valor);
                                  }
                                },
                              ),
                              RadioListTile<String>(
                                value: 'Pago contra entrega',
                                groupValue: metodoPago,
                                activeColor: verdeBodyFit,
                                contentPadding:
                                    const EdgeInsets.symmetric(
                                  horizontal: 8,
                                ),
                                secondary: const Icon(
                                  Icons.local_shipping_outlined,
                                ),
                                title: const Text(
                                  'Pago contra entrega',
                                  style: TextStyle(fontSize: 12),
                                ),
                                onChanged: (valor) {
                                  if (valor != null) {
                                    setState(() => metodoPago = valor);
                                  }
                                },
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 22),
                        const TituloSeccion('Resumen de compra'),

                        _fila(
                          'Subtotal',
                          precioCOP(CarritoBodyFit.subtotal),
                        ),
                        const SizedBox(height: 10),
                        _fila(
                          'Envío',
                          CarritoBodyFit.envio == 0
                              ? 'GRATIS'
                              : precioCOP(CarritoBodyFit.envio),
                          verde: CarritoBodyFit.envio == 0,
                        ),
                        const Divider(
                          height: 28,
                          color: Color(0xFF292A2D),
                        ),
                        _fila(
                          'Total a pagar',
                          precioCOP(CarritoBodyFit.total),
                          grande: true,
                          verde: true,
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Envío gratis por compras desde \$150.000. '
                          'Precios de demostración en pesos colombianos.',
                          style: TextStyle(
                            color: grisBodyFit,
                            fontSize: 11,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Botón fijo en la parte inferior.
                  Container(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                    decoration: const BoxDecoration(
                      color: Color(0xFF101113),
                      border: Border(
                        top: BorderSide(color: Color(0xFF242529)),
                      ),
                    ),
                    child: BotonBodyFit(
                      texto: 'PAGAR AHORA',
                      icono: Icons.lock_outline,
                      onPressed: confirmarPedido,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _fila(
    String titulo,
    String valor, {
    bool grande = false,
    bool verde = false,
  }) {
    return Row(
      children: [
        Expanded(
          child: Text(
            titulo,
            style: TextStyle(
              fontSize: grande ? 15 : 13,
              fontWeight: grande ? FontWeight.w900 : FontWeight.normal,
              color: grande ? Colors.white : grisBodyFit,
            ),
          ),
        ),
        Text(
          valor,
          style: TextStyle(
            fontSize: grande ? 19 : 13,
            fontWeight: FontWeight.w900,
            color: verde ? verdeBodyFit : Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _carritoVacio(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.shopping_bag_outlined,
              size: 75,
              color: verdeBodyFit,
            ),
            const SizedBox(height: 20),
            const Text(
              'Tu carrito está vacío',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Agrega productos desde el catálogo para '
              'ver aquí tu resumen de compra.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: grisBodyFit,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            BotonBodyFit(
              texto: 'VOLVER A LA TIENDA',
              icono: Icons.storefront_outlined,
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const InicioScreen(),
                  ),
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
