import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/archived_tasks_screen.dart';
import 'package:todo/done_tasks_screen.dart';
import 'package:todo/new_tasks_screen.dart';
import 'package:todo/shared/cubit/states.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;
  bool isBottomSheetDown = false;
  IconData fabIcon = Icons.edit;

  List<Widget> screens = [
    NewTasksScreen(),
    DoneTasksScreen(),
    ArchivedTasksScreen(),
  ];

  List<String> title = [
    "New Task",
    "Done Task",
    "Archived Task",
  ];

  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archiveTasks = [];

  late Database database;

  void changeIndex(int index) {
    currentIndex = index;
    emit(AppChangeBottomNavBarState());
  }

  void createDatabase() {
    openDatabase(
      'todo.db',
      version: 1,
      onCreate: (database, version) {
        print('Database created');
        database
            .execute(
                'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)')
            .then((value) {
          print('table created');
        }).catchError((error) {
          print("Error while creating table ${error.toString()}");
        });
      },
      onOpen: (database) {
        getDataFormDatabase(database);
        print('database opened');
      },
    ).then((value) {
      database = value;
      emit(AppCreateDatabaseState());
    });
  }

  Future insertIntoDatabase(String title, String date, String time) async {
    return await database.transaction((txn) async{
      txn
          .rawInsert(
              'INSERT INTO tasks (title, date, time, status) VALUES ("$title", "$time", "$date", "new")')
          .then((value) {
        print("$value inserted successfully");
        emit(AppInsertDatabaseState());
        getDataFormDatabase(database);
      }).catchError((error) {
        print("Error while inserting record ${error.toString()}");
      });
      return null;
    });
  }

  void getDataFormDatabase(database) async {
    newTasks = [];
    doneTasks = [];
    archiveTasks = [];
    emit(AppGetDatabaseLoadingState());
    database.rawQuery('SELECT * FROM tasks').then((value) {
      value.forEach((element) {
        if (element['status'] == 'new')
          newTasks.add(element);
        else if (element['status'] == 'done')
          doneTasks.add(element);
        else
          archiveTasks.add(element);
      });
      emit(AppGetDatabaseState());
    });
  }

  void updateFromDatabase(String status, int id) {
    database.rawUpdate('UPDATE tasks SET status = ? WHERE id = ?',
        ['$status', id]).then((value) {
      getDataFormDatabase(database);
      emit(AppUpdateDatabaseState());
      print("Update Completed");
    });
  }

  void deleteFromDatabase(int id) {
    database.rawDelete('DELETE FROM tasks WHERE id = ?', [id]).then((value) {
      getDataFormDatabase(database);
      emit(AppDeleteDatabaseState());
      print("Delete Completed");
    });
  }

  void changeBottomSheet(bool isClosed, IconData icon) {
    isBottomSheetDown = isClosed;
    fabIcon = icon;
    emit(AppChangeBottomSheetBarState());
  }
}
