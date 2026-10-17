
import 'package:flutter/material.dart';
import '../models/models.dart';
import '../widgets/componentes.dart';
import 'registro.dart';
import 'resumen.dart';

class InicioScreen extends StatefulWidget {
  const InicioScreen({super.key});

  @override
  State<InicioScreen> createState() => _InicioScreenState();
}

class _InicioScreenState extends State<InicioScreen> {
  String busqueda = '';
  String categoria = 'Todos';

  final categorias = const [
    'Todos',
    'Camisetas',
    'Pantalones',
    'Shorts',
    'Accesorios',
  ];

  void abrirProducto(Producto producto) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RegistroScreen(producto: producto),
      ),
    ).then((_) {
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final productos = productosBodyFit.where((p) {
      final coincideCategoria =
          categoria == 'Todos' || p.categoria == categoria;
      final coincideBusqueda =
          p.nombre.toLowerCase().contains(busqueda.toLowerCase());

      return coincideCategoria && coincideBusqueda;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.bolt, color: verdeBodyFit, size: 30),
            SizedBox(width: 5),
            Text(
              'BODYFIT',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('No tienes notificaciones nuevas.'),
                ),
              );
            },
            icon: const Icon(Icons.notifications_none),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 14),
            child: CircleAvatar(
              radius: 17,
              backgroundColor: verdeBodyFit,
              child: const Icon(
                Icons.person,
                color: Colors.black,
                size: 21,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 18),
          children: [
            TextField(
              onChanged: (valor) => setState(() => busqueda = valor),
              decoration: const InputDecoration(
                hintText: 'Buscar productos, marcas...',
                prefixIcon: Icon(Icons.search),
                contentPadding: EdgeInsets.symmetric(vertical: 12),
              ),
            ),
            const SizedBox(height: 18),

            // Banner principal de la colección.
            Container(
              height: 145,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF30332B),
                    Color(0xFF101112),
                    Color(0xFF252821),
                  ],
                ),
                border: Border.all(color: const Color(0xFF35372F)),
              ),
              child: Stack(
                children: [
                  const Positioned(
                    right: -5,
                    top: 4,
                    child: Icon(
                      Icons.fitness_center,
                      size: 95,
                      color: Color(0xFF55584C),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Text(
                        'NUEVA COLECCIÓN',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Equípate para superar tus límites.',
                        style: TextStyle(
                          color: verdeBodyFit,
                          fontWeight: FontWeight.w700,
                          fontSize: 11,
                        ),
                      ),
                      const SizedBox(height: 10),
                      InkWell(
                        onTap: () => setState(() => categoria = 'Todos'),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'DESCUBRIR',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            SizedBox(width: 5),
                            Icon(
                              Icons.arrow_forward,
                              size: 14,
                              color: verdeBodyFit,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            const TituloSeccion('Categorías'),

            SizedBox(
              height: 94,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: categorias.length,
                separatorBuilder: (_, _) =>
                    const SizedBox(width: 10),
                itemBuilder: (context, index) {
                  final nombre = categorias[index];
                  final seleccionado = categoria == nombre;

                  final iconos = [
                    Icons.grid_view,
                    Icons.checkroom,
                    Icons.straighten,
                    Icons.dry_cleaning,
                    Icons.fitness_center,
                  ];

                  return InkWell(
                    onTap: () => setState(() => categoria = nombre),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: 83,
                      decoration: BoxDecoration(
                        color: seleccionado
                            ? const Color(0xFF292C20)
                            : panelBodyFit,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: seleccionado
                              ? verdeBodyFit
                              : const Color(0xFF242529),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            iconos[index],
                            color: seleccionado
                                ? verdeBodyFit
                                : Colors.white70,
                            size: 25,
                          ),
                          const SizedBox(height: 9),
                          Text(
                            nombre == 'Todos' ? 'Todo' : nombre,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 10),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 24),
            const TituloSeccion('Productos destacados'),

            if (productos.isEmpty)
              const Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'No se encontraron productos.',
                  textAlign: TextAlign.center,
                ),
              )
            else
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: productos.length,
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.72,
                ),
                itemBuilder: (context, index) {
                  return TarjetaProducto(
                    producto: productos[index],
                    onTap: () => abrirProducto(productos[index]),
                  );
                },
              ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF151619),
        currentIndex: 0,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: verdeBodyFit,
        unselectedItemColor: Colors.white54,
        onTap: (index) {
          if (index == 1) {
            setState(() => categoria = 'Todos');
            return;
          }

          if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const ResumenScreen(),
              ),
            ).then((_) {
              if (mounted) setState(() {});
            });
          }

          if (index == 3) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Perfil de usuario de demostración.'),
              ),
            );
          }
        },
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Inicio',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Buscar',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.shopping_bag_outlined),
            label: 'Carrito (${CarritoBodyFit.cantidadTotal})',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}
