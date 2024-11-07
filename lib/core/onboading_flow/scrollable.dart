import 'package:flutter/material.dart';

class HorizontalScrollPage extends StatelessWidget {
  final List<Map<String, String>> items = [
    {
      'photoUrl': 'https://via.placeholder.com/150',
      'name': 'Item 1',
      'description': 'This is a description for Item 1.',
    },
    {
      'photoUrl': 'https://via.placeholder.com/150',
      'name': 'Item 2',
      'description': 'This is a description for Item 2.',
    },
    {
      'photoUrl': 'https://via.placeholder.com/150',
      'name': 'Item 3',
      'description': 'This is a description for Item 3.',
    },
    // Add more items as needed
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Constrained ListView Example'),
      ),
      body: Column(
        children: [
          // Other widgets can go here, like headers, etc.
          Expanded(
            child: ListView.builder(
              itemCount: 20, // Replace with your item count
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('Item $index'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: Text('Horizontal Scroll List'),
  //     ),
  //     body: Padding(
  //       padding: const EdgeInsets.all(8.0),
  //       child: SizedBox(
  //         height: 200, // Set a height for the ListView
  //         child: ListView.builder(
  //           scrollDirection: Axis.horizontal,
  //           itemCount: items.length,
  //           itemBuilder: (context, index) {
  //             final item = items[index];
  //             return Container(
  //               width: 200, // Adjust as needed
  //               margin: const EdgeInsets.only(right: 12.0),
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   Image.network(
  //                     item['photoUrl']!,
  //                     height: 120,
  //                     width: double.infinity,
  //                     fit: BoxFit.cover,
  //                   ),
  //                   const SizedBox(height: 8),
  //                   Text(
  //                     item['name']!,
  //                     style: TextStyle(
  //                       fontSize: 16,
  //                       fontWeight: FontWeight.bold,
  //                     ),
  //                   ),
  //                   const SizedBox(height: 4),
  //                   Text(
  //                     item['description']!,
  //                     style: TextStyle(
  //                       fontSize: 14,
  //                       color: Colors.grey[600],
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             );
  //           },
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
