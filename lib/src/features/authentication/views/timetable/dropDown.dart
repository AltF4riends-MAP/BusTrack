import 'package:flutter/material.dart';
import 'package:bustrack/src/features/authentication/models/stop.dart';

class DropdownChecklist extends StatefulWidget {
  final List<Stop> stopList;
  final List<Stop> selectedStops;
  final ValueChanged<List<Stop>> onChanged;

  DropdownChecklist({
    required this.stopList,
    required this.selectedStops,
    required this.onChanged,
  });

  @override
  _DropdownChecklistState createState() => _DropdownChecklistState();
}

class _DropdownChecklistState extends State<DropdownChecklist> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Stops',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Wrap(
          spacing: 10,
          children: widget.stopList.map((stop) {
            return FilterChip(
              label: Text(stop.stopName),
              selected: widget.selectedStops.contains(stop),
              onSelected: (bool selected) {
                setState(() {
                  if (selected) {
                    widget.selectedStops.add(stop);
                  } else {
                    widget.selectedStops.remove(stop);
                  }
                  widget.onChanged(widget.selectedStops);
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}
