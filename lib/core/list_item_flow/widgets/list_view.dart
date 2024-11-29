import 'package:flutter/material.dart';

import '../usecases/item.dart';

class ReusableListView extends StatelessWidget {
  final List<Item> items;
  final void Function(String detailsUrl)? onDetailsTap;

  const ReusableListView({
    Key? key,
    required this.items,
    this.onDetailsTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Card(
          margin: const EdgeInsets.all(8),
          child: ListTile(
            leading: Image.network(item.imageUrls.first,
                width: 50, height: 50, fit: BoxFit.cover),
            title: Text(item.title),
            trailing: TextButton(
              onPressed: () => onDetailsTap?.call(item.id),
              child: const Text(
                'See Details',
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ),
        );
      },
    );
  }
}

class MyAppReusable extends StatelessWidget {
  const MyAppReusable({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Item> sampleItems = [
      Item(
        imageUrl: 'https://via.placeholder.com/150',
        name: 'Item 1',
        detailsUrl: 'https://example.com/details/1',
      ),
      Item(
        imageUrl: 'https://via.placeholder.com/150',
        name: 'Item 2',
        detailsUrl: 'https://example.com/details/2',
      ),
      Item(
        imageUrl: 'https://via.placeholder.com/150',
        name: 'Item 3',
        detailsUrl: 'https://example.com/details/3',
      ),
    ];

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Reusable ListView')),
        body:
      ),
    );
  }
}
