import 'package:flutter/cupertino.dart';

import '../usecases/item.dart';
import 'item_card.dart';

class ItemGrid extends StatelessWidget {
  final List<Item> items;

  const ItemGrid({required this.items, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(8.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Two columns
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
        childAspectRatio: 2 / 3, // Adjust to control item shape
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return ItemCard(item: item);
      },
    );
  }
}
