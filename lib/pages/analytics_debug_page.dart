import 'package:flutter/material.dart';
import '../core/analytics/analytics_service.dart';

class AnalyticsDebugPage extends StatefulWidget {
  const AnalyticsDebugPage({super.key});

  @override
  State<AnalyticsDebugPage> createState() => _AnalyticsDebugPageState();
}

class _AnalyticsDebugPageState extends State<AnalyticsDebugPage> {
  final _analytics = AnalyticsService();
  List<Map> events = [];

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  void _loadEvents() {
    setState(() {
      events = _analytics.getAllEvents();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics Debug'),
        actions: [
          IconButton(
            onPressed: _loadEvents,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Total Events: ${events.length}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          Expanded(
            child: events.isEmpty
                ? const Center(child: Text('No events logged yet'))
                : ListView.builder(
                    itemCount: events.length,
                    itemBuilder: (context, index) {
                      final event = events[index];
                      return ListTile(
                        title: Text('Song: ${event['songId']}'),
                        subtitle: Text(
                          'Position: ${event['position']}s\n'
                          'Time: ${event['timestamp']}',
                        ),
                        isThreeLine: true,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}