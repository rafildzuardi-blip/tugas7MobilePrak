import 'package:flutter/material.dart';
import 'card_model.dart'; // import relatif, tidak tergantung nama proyek
import 'package:provider/provider.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => CartModel(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AnomaliStore',
      debugShowCheckedModeBanner: false,
      home: ProductPage(),
    );
  }
}

// Halaman Produk
class ProductPage extends StatelessWidget {
  ProductPage({super.key});

  final products = [
    Product('Beras 1 Ton'),
    Product('Minyak 1 Drum'),
    Product('Telur Dinosaurus'),
    Product('Lemineral 1000 L'),
    Product('Cacing'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Anomali Store'),
        backgroundColor: Colors.orange,
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Consumer<CartModel>(
              builder: (context, cart, child) {
                return Badge(
                  label: Text('${cart.totalItems}'),
                  isLabelVisible: cart.totalItems > 0,
                  child: IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const CartPage()),
                      );
                    },
                    icon: const Icon(Icons.shopping_cart, color: Colors.white),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return ListTile(
            title: Text(product.nama),
            shape: const RoundedRectangleBorder(
              side: BorderSide(color: Colors.black),
            ),
            trailing: IconButton(
              onPressed: () {
                Provider.of<CartModel>(context, listen: false).add(product);
              },
              icon: const Icon(Icons.shopping_cart_checkout),
            ),
          );
        },
      ),
    );
  }
}

// Halaman Keranjang
class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Keranjang'),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
        backgroundColor: Colors.orange,
      ),
      body: Consumer<CartModel>(
        builder: (context, cart, child) {
          if (cart.items.isEmpty) {
            return const Center(child: Text('Keranjang Kosong'));
          }
          return ListView.builder(
            itemCount: cart.items.length,
            itemBuilder: (context, index) {
              final item = cart.items[index];
              return ListTile(
                title: Text(item.nama),
                trailing: ElevatedButton.icon(
                  onPressed: () {
                    cart.remove(item);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${item.nama} dihapus')),
                    );
                  },
                  icon: const Icon(Icons.delete),
                  label: const Text('Hapus'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}