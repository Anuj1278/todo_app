import 'package:flutter/material.dart';

import '../models/task_model.dart';
import '../widgets/task_item.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final TextEditingController _taskController =
      TextEditingController();

  final List<Task> _tasks = [];

  void _addTask() {
    final taskTitle = _taskController.text.trim();

    if (taskTitle.isEmpty) {
      return;
    }

    setState(() {
      _tasks.add(
        Task(
          title: taskTitle,
        ),
      );
    });

    _taskController.clear();
  }

  void _toggleTask(Task task) {
    setState(() {
      task.isCompleted = !task.isCompleted;
    });
  }

  void _deleteTask(Task task) {
    setState(() {
      _tasks.remove(task);
    });
  }

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pendingTasks = _tasks
        .where((task) => !task.isCompleted)
        .toList();

    final completedTasks = _tasks
        .where((task) => task.isCompleted)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My To-Do List',
        ),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _taskController,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _addTask(),
                    decoration: InputDecoration(
                      hintText: 'Enter a task...',
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                SizedBox(
                  height: 55,
                  width: 55,
                  child: ElevatedButton(
                    onPressed: _addTask,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(15),
                      ),
                    ),
                    child: const Icon(Icons.add),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 25),

            Expanded(
              child: _tasks.isEmpty
                  ? _buildEmptyState()
                  : ListView(
                      children: [
                        if (pendingTasks.isNotEmpty) ...[
                          _buildSectionTitle(
                            'Pending',
                            pendingTasks.length,
                          ),

                          const SizedBox(height: 10),

                          ...pendingTasks.map(
                            (task) => TaskItem(
                              task: task,
                              onToggle: () {
                                _toggleTask(task);
                              },
                              onDelete: () {
                                _deleteTask(task);
                              },
                            ),
                          ),
                        ],

                        if (completedTasks.isNotEmpty) ...[
                          const SizedBox(height: 20),

                          _buildSectionTitle(
                            'Completed',
                            completedTasks.length,
                          ),

                          const SizedBox(height: 10),

                          ...completedTasks.map(
                            (task) => TaskItem(
                              task: task,
                              onToggle: () {
                                _toggleTask(task);
                              },
                              onDelete: () {
                                _deleteTask(task);
                              },
                            ),
                          ),
                        ],
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(
    String title,
    int count,
  ){
    return Row(
      children: [
        Text(
          title,
          style:const TextStyle(
            fontSize:20,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(width:8),

        Container(
          padding: const EdgeInsets.symmetric(
            horizontal:8,
            vertical:3,
          ),
          decoration: BoxDecoration(
            color:Colors.deepPurple.shade100,
            borderRadius:BorderRadius.circular(10),
          ),
          child: Text(
            '$count',
            style:TextStyle(
              color:Colors.deepPurple.shade700,
              fontWeight:FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildEmptyState(){
    return Center(
      child:Column(
        mainAxisAlignment:MainAxisAlignment.center,
        children:[
          Icon(
            Icons.check_circle_outline,
            size:80,
            color:Colors.grey.shade400,
          ),

          const SizedBox(height:15),

          Text(
            'No tasks yet',
            style:TextStyle(
              fontSize:22,
              fontWeight:FontWeight.bold,
              color:Colors.grey.shade600,
            ),
          ),

          const SizedBox(height:8),

          Text(
            'Add a task to get started,',
            style:TextStyle(
              color:Colors.grey.shade500,
           ),
          ),
        ],
      ),
    );
  }
}