import 'package:flutter/material.dart';
import 'componentes.dart';
import 'models.dart';

/// PANTALLA 2: formulario para registrar productos del pedido.
class RegistroScreen extends StatefulWidget {
  const RegistroScreen({super.key});

  @override
  State<RegistroScreen> createState() => _RegistroScreenState();
}

class _RegistroScreenState extends State<RegistroScreen> {
  final _form = GlobalKey<FormState>();
  final _nombre = TextEditingController(text: Pedido.cliente);
  final _direccion = TextEditingController(text: Pedido.direccion);
  Producto? _producto;
  String? _talla;
  double _cantidad = 1;
  bool _express = Pedido.express;
  bool _argsLeidos = false;

  List<String> get _tallas => _producto?.categoria == 'Accesorios'
      ? ['Única']
      : ['XS', 'S', 'M', 'L', 'XL'];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_argsLeidos) {
      final arg = ModalRoute.of(context)?.settings.arguments;
      if (arg is Producto) _producto = arg;
      _argsLeidos = true;
    }
  }

  @override
  void dispose() {
    _nombre.dispose();
    _direccion.dispose();
    super.dispose();
  }

  void _mensaje(String texto, {bool error = false}) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text(texto),
        backgroundColor: error ? Colors.red.shade700 : Colors.green.shade700,
      ));
  }

  void _agregar() {
    if (!_form.currentState!.validate()) {
      _mensaje('Revisa los campos marcados en rojo', error: true);
      return;
    }
    if (_talla == null) {
      _mensaje('Selecciona una talla', error: true);
      return;
    }
    Pedido.cliente = _nombre.text.trim();
    Pedido.direccion = _direccion.text.trim();
    Pedido.express = _express;
    Pedido.items.add(ItemPedido(_producto!, _talla!, _cantidad.round()));
    setState(() {
      _talla = null;
      _cantidad = 1;
    });
    _mensaje('Producto agregado al pedido (${Pedido.unidades} unidades)');
  }

  void _irAlResumen() {
    if (Pedido.items.isEmpty) {
      _mensaje('Aún no has agregado productos', error: true);
      return;
    }
    Pedido.express = _express;
    Navigator.pushNamed(context, '/resumen');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registrar pedido')),
      body: Form(
        key: _form,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            CampoFormulario(
              etiqueta: 'Nombre completo',
              icono: Icons.person_outline,
              controlador: _nombre,
              validador: (v) {
                final t = v?.trim() ?? '';
                if (t.isEmpty) return 'Ingresa tu nombre';
                if (t.length < 3) return 'Mínimo 3 caracteres';
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<Producto>(
              initialValue: _producto,
              isExpanded: true,
              decoration: InputDecoration(
                labelText: 'Producto',
                prefixIcon: const Icon(Icons.shopping_bag_outlined),
                filled: true,
                fillColor: const Color(0xFF1A1A1A),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              items: [
                for (final p in catalogo)
                  DropdownMenuItem(
                    value: p,
                    child: Text('${p.nombre} · ${formatoCOP(p.precio)}',
                        overflow: TextOverflow.ellipsis),
                  ),
              ],
              validator: (v) => v == null ? 'Selecciona un producto' : null,
              onChanged: (p) => setState(() {
                _producto = p;
                _talla = null;
              }),
            ),
            const SizedBox(height: 16),
            const Text('Talla', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                for (final t in _tallas)
                  ChoiceChip(
                    label: Text(t),
                    selected: _talla == t,
                    onSelected: (_) => setState(() => _talla = t),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Text('Cantidad: ${_cantidad.round()}',
                style: const TextStyle(fontWeight: FontWeight.w600)),
            Slider(
              value: _cantidad,
              min: 1,
              max: 10,
              divisions: 9,
              label: '${_cantidad.round()}',
              onChanged: (v) => setState(() => _cantidad = v),
            ),
            const Text('Descuento: 10% desde 3 unidades, 15% desde 5.',
                style: TextStyle(color: Colors.white54, fontSize: 12)),
            const SizedBox(height: 16),
            CampoFormulario(
              etiqueta: 'Dirección de entrega',
              icono: Icons.location_on_outlined,
              controlador: _direccion,
              lineas: 2,
              validador: (v) {
                final t = v?.trim() ?? '';
                if (t.isEmpty) return 'Ingresa la dirección';
                if (t.length < 8) return 'Escribe una dirección más completa';
                return null;
              },
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Envío express (+\$7.000)'),
              value: _express,
              onChanged: (v) => setState(() => _express = v),
            ),
            const SizedBox(height: 8),
            FilledButton.icon(
              onPressed: _agregar,
              icon: const Icon(Icons.add),
              label: const Text('Agregar al pedido'),
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: _irAlResumen,
              icon: const Icon(Icons.receipt_long),
              label: Text('Ver resumen (${Pedido.unidades})'),
            ),
          ],
        ),
      ),
    );
  }
}
