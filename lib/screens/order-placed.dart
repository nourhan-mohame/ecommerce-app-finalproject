import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';

class OrderPlacementPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Delivery Timeline'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 16),
        child: DeliveryTimeline(),
      ),
    );
  }
}

class DeliveryTimeline extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        CustomTimelineTile(
          title: 'Order Placed',
          description: 'Your order was placed successfully.',
          isFirst: true,
        ),
        CustomTimelineTile(
          title: 'Order Processing',
          description: 'Your order is being processed.',
        ),
        CustomTimelineTile(
          title: 'Out for Delivery',
          description: 'Your order is on its way to you.',
        ),
        CustomTimelineTile(
          title: 'Delivered',
          description: 'Your order has been delivered.',
          isLast: true,
        ),
      ],
    );
  }
}

class CustomTimelineTile extends StatelessWidget {
  final String title;
  final String description;
  final bool isFirst;
  final bool isLast;

  const CustomTimelineTile({
    required this.title,
    required this.description,
    this.isFirst = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return TimelineTile(
      alignment: TimelineAlign.manual,
      lineXY: 0.1,
      isFirst: isFirst,
      isLast: isLast,
      indicatorStyle: IndicatorStyle(
        width: 20,
        color: Colors.blue,
        padding: EdgeInsets.all(8),
      ),
      endChild: Container(
        constraints: const BoxConstraints(
          minHeight: 80,
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
      startChild: Container(
        constraints: const BoxConstraints(
          minHeight: 80,
        ),
        padding: const EdgeInsets.all(16),
        child: Container(), // Empty container to create a vertical line
      ),
    );
  }
}
