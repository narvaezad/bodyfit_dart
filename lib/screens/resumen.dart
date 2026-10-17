import 'package:flutter/material.dart';
import 'models.dart';

/// PANTALLA 3: consulta del pedido y resultados (subtotal, descuento, envío, total).
class ResumenScreen extends StatefulWidget {
  const ResumenScreen({super.key});

  @override
  State<ResumenScreen> createState() => _ResumenScreenState();
}

class _ResumenScreenState extends State<ResumenScreen> {
  void _mensaje(String texto, {bool error = false}) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text(texto),
        backgroundColor: error ? Colors.red.shade700 : Colors.green.shade700,
      ));
  }

  Future<bool> _confirmar(String titulo, String detalle, String accion) async {
    final r = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(titulo),
        content: Text(detalle),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar')),
          FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(accion)),
        ],
      ),
    );
    return r ?? false;
  }

  Future<void> _vaciar() async {
    if (await _confirmar('Vaciar pedido',
        '¿Quieres eliminar todos los productos?', 'Vaciar')) {
      setState(Pedido.limpiar);
      _mensaje('Pedido vaciado', error: true);
    }
  }

  Future<void> _confirmarPedido() async {
    final ok = await _confirmar(
      'Confirmar pedido',
      'Total a pagar: ${formatoCOP(Pedido.total)}\nEntrega en: ${Pedido.direccion}',
      'Confirmar',
    );
    if (ok) {
      final nombre = Pedido.cliente;
      setState(Pedido.limpiar);
      _mensaje('¡Pedido confirmado, $nombre! Estado: realizado');
    }
  }

  Widget _fila(String etiqueta, String valor,
      {bool destacar = false, Color? color}) {
    final estilo = TextStyle(
      fontSize: destacar ? 20 : 15,
      fontWeight: destacar ? FontWeight.bold : FontWeight.normal,
      color: color,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(etiqueta, style: estilo), Text(valor, style: estilo)],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    final vacio = Pedido.items.isEmpty;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Resumen del pedido'),
        actions: [
          if (!vacio)
            IconButton(
              tooltip: 'Vaciar pedido',
              onPressed: _vaciar,
              icon: const Icon(Icons.delete_sweep_outlined),
            ),
        ],
      ),
      body: vacio
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.shopping_bag_outlined,
                      size: 72, color: Colors.white24),
                  const SizedBox(height: 12),
                  const Text('Tu pedido está vacío'),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: () => Navigator.pushNamed(context, '/registro')
                        .then((_) => setState(() {})),
                    child: const Text('Agregar productos'),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: Card(
                    child: ListTile(
                      leading: const Icon(Icons.person_outline),
                      title: Text(Pedido.cliente),
                      subtitle: Text(Pedido.direccion),
                      trailing: Pedido.express
                          ? Icon(Icons.bolt, color: color)
                          : null,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: Pedido.items.length,
                    itemBuilder: (_, i) {
                      final it = Pedido.items[i];
                      return Card(
                        child: ListTile(
                          leading: Icon(it.producto.icono, color: color),
                          title: Text(it.producto.nombre),
                          subtitle: Text(
                              'Talla ${it.talla} · ${it.cantidad} × ${formatoCOP(it.producto.precio)}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(formatoCOP(it.subtotal),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                              IconButton(
                                tooltip: 'Quitar',
                                icon: const Icon(Icons.close),
                                onPressed: () {
                                  setState(() => Pedido.items.removeAt(i));
                                  _mensaje('Producto eliminado', error: true);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Color(0xFF1A1A1A),
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  child: SafeArea(
                    top: false,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _fila('Unidades', '${Pedido.unidades}'),
                        _fila('Subtotal', formatoCOP(Pedido.subtotal)),
                        _fila(
                          'Descuento (${(Pedido.porcentajeDescuento * 100).round()}%)',
                          '-${formatoCOP(Pedido.descuento)}',
                          color: Colors.greenAccent,
                        ),
                        _fila('Envío',
                            Pedido.envio == 0 ? 'Gratis' : formatoCOP(Pedido.envio)),
                        const Divider(),
                        _fila('TOTAL', formatoCOP(Pedido.total),
                            destacar: true, color: color),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton.icon(
                            onPressed: _confirmarPedido,
                            icon: const Icon(Icons.check_circle_outline),
                            label: const Text('Confirmar pedido'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
