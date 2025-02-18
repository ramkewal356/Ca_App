import 'package:ca_app/screens/ca_screens/task_allocation/common_task_card_screen.dart';
import 'package:ca_app/widgets/custom_search_field.dart';
import 'package:flutter/material.dart';

class MyTaskListScreen extends StatefulWidget {
  const MyTaskListScreen({super.key});

  @override
  State<MyTaskListScreen> createState() => _MyTaskListScreenState();
}

class _MyTaskListScreenState extends State<MyTaskListScreen> {
  final TextEditingController _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 5),
        CustomSearchField(
            controller: _searchController, serchHintText: 'search task'),
        SizedBox(height: 10),
        Expanded(
            child: ListView.builder(
          itemCount: 6,
          itemBuilder: (context, index) {
            return CommonTaskCardScreen(
              taskId: '#1234',
              assignDate: '23/02/2025',
              taskName: 'xcvbnm',
              clientEmail: 'ram@gmail.com',
              priority: 'Heigh',
              assignTo: 'cvcbcvbcvn',
              status: 'Active',
            );
          },
        ))
      ],
    );
  }
}
