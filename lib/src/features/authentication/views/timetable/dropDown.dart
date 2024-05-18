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
  late List<Stop> _currentSelectedStops;

  @override
  void initState() {
    super.initState();
    // Initialize the current selected stops with the passed selected stops
    _currentSelectedStops = List.from(widget.selectedStops);
  }

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
        SizedBox(
          height: 140,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Wrap(
              spacing: 10,
              children: widget.stopList.map((stop) {
                return FilterChip(
                  label: Text(stop.stopName),
                  selected: _currentSelectedStops.contains(stop),
                  onSelected: (bool selected) {
                    setState(() {
                      if (selected) {
                        // If selected, move the stop to the beginning
                        _currentSelectedStops.remove(stop);
                        _currentSelectedStops.insert(0, stop);
                        print(_currentSelectedStops[0].stopName);
                      } else {
                        // If unselected, remove it from the list
                        _currentSelectedStops.remove(stop);
                      }
                      widget.onChanged(_currentSelectedStops);
                    });
                  },
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
