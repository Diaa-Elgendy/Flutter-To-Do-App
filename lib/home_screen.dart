import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo/shared/components/components.dart';

import 'shared/cubit/cubit.dart';
import 'shared/cubit/states.dart';


class HomeScreen extends StatelessWidget {

  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  var controller1 = TextEditingController();
  var controller2 = TextEditingController();
  var controller3 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {
          if (state is AppInsertDatabaseState)
            Navigator.pop(context);
        },
        builder: (context, state) {
          AppCubit cubit = AppCubit.get(context);

          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text(cubit.title[cubit.currentIndex]),
            ),
            body: ConditionalBuilder(
              condition: state is! AppGetDatabaseLoadingState,
              builder: (context) => cubit.screens[cubit.currentIndex],
              fallback: (context) => Center(child: CircularProgressIndicator()),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (cubit.isBottomSheetDown) {
                  if (formKey.currentState!.validate()) {
                    cubit.insertIntoDatabase(
                      controller1.text,
                      controller2.text,
                      controller3.text,
                    );
                  }
                } else {
                  scaffoldKey.currentState!
                      .showBottomSheet(
                        (context) => Container(
                          padding: EdgeInsets.all(20),
                          color: Colors.white,
                          width: double.infinity,
                          child: Form(
                            key: formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                defaultTFF(
                                  controller: controller1,
                                  type: TextInputType.text,
                                  text: "Title",
                                  prefix: Icons.title,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                defaultTFF(
                                  controller: controller2,
                                  type: TextInputType.datetime,
                                  readOnly: true,
                                  text: "Time",
                                  prefix: Icons.watch_later,
                                  onTap: () {
                                    showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now(),
                                    ).then((value) {
                                      controller2.text =
                                          value!.format(context).toString();
                                    });
                                  },
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                defaultTFF(
                                  controller: controller3,
                                  type: TextInputType.datetime,
                                  readOnly: true,
                                  text: "Date",
                                  prefix: Icons.calendar_today,
                                  onTap: () {
                                    showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime.parse("2025-12-30"),
                                    ).then((value) {
                                      controller3.text =
                                          DateFormat.yMMMd().format(value!);
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        elevation: 10,
                      )
                      .closed
                      .then((value) {
                    cubit.changeBottomSheet(false, Icons.edit);
                    // setState(() {
                    //   fabIcon = Icons.edit;
                    // });
                  });
                  cubit.changeBottomSheet(true, Icons.add);

                  // setState(() {
                  //   fabIcon = Icons.add;
                  // });
                }
              },
              child: Icon(cubit.fabIcon),
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: cubit.currentIndex,
              onTap: (index) {
                cubit.changeIndex(index);
              },
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.menu),
                  label: "Tasks",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.check_circle_outline),
                  label: "Done",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.architecture_outlined),
                  label: "Archive",
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  }
