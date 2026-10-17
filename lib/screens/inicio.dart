import 'package:flutter/material.dart';
import 'componentes.dart';
import 'models.dart';

/// PANTALLA 1: presentación de la app y acceso a las funcionalidades.
class InicioScreen extends StatefulWidget {
  const InicioScreen({super.key});

  @override
  State<InicioScreen> createState() => _InicioScreenState();
}

class _InicioScreenState extends State<InicioScreen> {
  String? _categoria; // null = todas

  Future<void> _ir(String ruta, [Object? args]) async {
    await Navigator.pushNamed(context, ruta, arguments: args);
    if (mounted) setState(() {}); // refresca el contador del carrito
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    final productos = _categoria == null
        ? catalogo
        : catalogo.where((p) => p.categoria == _categoria).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('BodyFit',
            style: TextStyle(
                fontSize: 26, fontWeight: FontWeight.w900, color: color)),
        actions: [
          IconButton(
            tooltip: 'Ver pedido',
            onPressed: () => _ir('/resumen'),
            icon: Badge(
              isLabelVisible: Pedido.unidades > 0,
              label: Text('${Pedido.unidades}'),
              child: const Icon(Icons.shopping_bag_outlined),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Todo para tu entrenamiento\nen un solo lugar',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text(
              'Arma tu pedido de ropa deportiva y accesorios sin recorrer varias tiendas.',
              style: TextStyle(color: Colors.white70)),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: () => _ir('/registro'),
                  icon: const Icon(Icons.add_shopping_cart),
                  label: const Text('Armar pedido'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _ir('/resumen'),
                  icon: const Icon(Icons.receipt_long),
                  label: const Text('Ver resumen'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text('Categorías',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              ChoiceChip(
                label: const Text('Todas'),
                selected: _categoria == null,
                onSelected: (_) => setState(() => _categoria = null),
              ),
              for (final c in categorias)
                ChoiceChip(
                  label: Text(c),
                  selected: _categoria == c,
                  onSelected: (_) => setState(() => _categoria = c),
                ),
            ],
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: productos.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.85,
            ),
            itemBuilder: (_, i) => ProductoCard(
              producto: productos[i],
              onTap: () => _ir('/registro', productos[i]),
            ),
          ),
        ],
      ),
    );
  }
}
