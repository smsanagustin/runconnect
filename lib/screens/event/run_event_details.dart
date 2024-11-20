import 'package:flutter/material.dart';
import 'package:runconnect/models/run_event.dart';

class RunEventDetailsScreen extends StatefulWidget {
  const RunEventDetailsScreen({super.key, required this.runEvent});

  final RunEvent runEvent;

  @override
  State<RunEventDetailsScreen> createState() => _RunEventDetailsScreenState();
}

class _RunEventDetailsScreenState extends State<RunEventDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

