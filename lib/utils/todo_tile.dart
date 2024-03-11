// import 'package:flutter/material.dart';
//
// class ToDoTile extends StatelessWidget {
//   final String taskName;
//   final bool taskCompleted;
//   final Function(bool?)? onChanged;
//   final Color textColor; // Define textColor parameter
//
//   ToDoTile({
//     required this.taskName,
//     required this.taskCompleted,
//     required this.onChanged,
//     required this.textColor, // Add textColor parameter to the constructor
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: ListTile(
//         title: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Text(
//             taskName,
//             style: TextStyle(
//               color: textColor, // Use the passed textColor parameter
//               decoration:
//               taskCompleted ? TextDecoration.lineThrough : TextDecoration.none,
//             ),
//           ),
//         ),
//         leading: Checkbox(
//           value: taskCompleted,
//           onChanged: onChanged,
//           activeColor: textColor, // Set activeColor to textColor
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

class ToDoTile extends StatelessWidget {
  final String taskName;
  final bool taskCompleted;
  final Function(bool?)? onChanged;
  final Color textColor;

  ToDoTile({
    required this.taskName,
    required this.taskCompleted,
    required this.onChanged,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0,right: 25.0,top: 25.0),
      child: ListTile(
        leading: Checkbox(
            value: taskCompleted,
            onChanged: onChanged,
            activeColor: textColor,),
        title: Padding(

          padding: const EdgeInsets.all(10.0),
          child: Text(
            taskName,
            style: TextStyle(
              color: textColor,
              fontFamily: 'SourceSans3',
              decoration:
              taskCompleted ? TextDecoration.lineThrough : TextDecoration.none,
            ),
          ),
        ),

      ),
    );
  }
}
