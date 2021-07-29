import 'package:flutter/material.dart';
import 'package:todo/shared/cubit/cubit.dart';

Widget defaultButton(
        {Color color = Colors.blue,
        double width = double.infinity,
        required String text,
        required VoidCallback function}) =>
    Container(
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: color,
      ),
      child: MaterialButton(
        height: 50,
        child: Text(
          text,
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        onPressed: function,
      ),
    );

Widget defaultTFF({
  bool isPassword = false,
  required TextEditingController controller,
  required TextInputType type,
  required String text,
  required IconData prefix,
  bool readOnly = false,
  VoidCallback? suffixPressed,
  VoidCallback? onTap,
  IconData? suffix,
}) =>
    TextFormField(
      decoration: InputDecoration(
          labelText: text,
          prefixIcon: Icon(prefix),

          suffixIcon: suffix!=null ? IconButton(icon: Icon(suffix), onPressed: suffixPressed,) : null,
          border: OutlineInputBorder(),
          labelStyle: TextStyle(fontSize: 20)),
      keyboardType: type,
      style: TextStyle(fontSize: 20),
      controller: controller,
      obscureText: isPassword,
      onTap: onTap,
      readOnly: readOnly,
      validator: (value){
        if (value!.isEmpty) {
          return '$text must not be empty';
        }
        return null;
      },

    );

Widget buildTaskItem(Map map, BuildContext context) {
  return Dismissible(
    key: Key(map['id'].toString()),
    child: Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.blue,
            child: Text(
              "${map['time']}",
              style: TextStyle(color: Colors.white, ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${map['title']}",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  "${map['date']}",
                  style: TextStyle(
                    color: Colors.grey[800],
                    fontSize: 18,
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            width: 20,
          ),
          IconButton(
            onPressed: () {
              AppCubit.get(context).updateFromDatabase("archive", map['id']);
            },
            icon: Icon(Icons.archive),
            color: Colors.black45,
          ),
          IconButton(
            onPressed: () {
              AppCubit.get(context).updateFromDatabase("done", map['id']);
            },
            icon: Icon(Icons.check_box),
            color: Colors.green,
          ),
        ],
      ),
    ),
    onDismissed: (direction){
      AppCubit.get(context).deleteFromDatabase(map['id']);
    },
  );
}