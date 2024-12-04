import 'package:flutter/material.dart';

class AnimatedDropdown<T> extends StatefulWidget {
  final List<T> items; // List of items
  final T? selectedItem; // Currently selected item
  final String Function(T) itemLabel; // Function to extract label text
  final ValueChanged<T?> onItemSelected; // Callback for selection
  final String placeholder; // Placeholder text
  final double itemHeight; // Height of each dropdown item
  final BoxDecoration? decoration; // Decoration for the dropdown box

  const AnimatedDropdown({
    Key? key,
    required this.items,
    required this.itemLabel,
    required this.onItemSelected,
    this.selectedItem,
    this.placeholder = "Select an item",
    this.itemHeight = 48.0,
    this.decoration,
  }) : super(key: key);

  @override
  _AnimatedDropdownState<T> createState() => _AnimatedDropdownState<T>();
}

class _AnimatedDropdownState<T> extends State<AnimatedDropdown<T>> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _isExpanded = !_isExpanded; // Toggle dropdown
            });
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            decoration: widget.decoration ??
                BoxDecoration(
                  color: Colors.grey[200],
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8.0),
                ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.selectedItem != null
                      ? widget.itemLabel(widget.selectedItem!)
                      : widget.placeholder,
                  style: TextStyle(fontSize: 16.0),
                ),
                Icon(
                  _isExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                ),
              ],
            ),
          ),
        ),
        AnimatedContainer(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          height: _isExpanded ? widget.items.length * widget.itemHeight : 0.0,
          child: _isExpanded
              ? ListView(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  children: widget.items.map((item) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          widget.onItemSelected(item);
                          _isExpanded = false; // Collapse after selection
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 12.0),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Colors.grey[300]!),
                          ),
                        ),
                        child: Text(
                          widget.itemLabel(item),
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ),
                    );
                  }).toList(),
                )
              : null,
        ),
      ],
    );
  }
}
