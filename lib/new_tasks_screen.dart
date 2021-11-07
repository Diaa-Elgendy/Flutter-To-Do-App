import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/shared/components/components.dart';
import 'shared/cubit/cubit.dart';
import 'shared/cubit/states.dart';
import 'package:flutter_conditional_rendering/flutter_conditional_rendering.dart';

class NewTasksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(

      listener: (context, state) {},
      builder: (context, state) {
        var tasks = AppCubit.get(context).newTasks;

        return Conditional.single(
          context: context,
          conditionBuilder:(context) =>  tasks.length > 0,
          widgetBuilder: (context) => ListView.separated(
              itemBuilder: (context, index) => buildTaskItem(tasks[index], context),
              separatorBuilder: (context, index) => Padding(
                padding: const EdgeInsetsDirectional.only(start: 20, end: 20),
                child: Container(
                  width: double.infinity,
                  height: 1,
                  color: Colors.grey[300],
                ),
              ),
              itemCount: tasks.length),
          fallbackBuilder: (context) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.menu, size: 150, color: Colors.black45,),
                Text("No active tasks", style: TextStyle(fontSize: 40, color: Colors.black54),)
              ],
            ),
          ),
        );
      }
    );
  }
}
