import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../provider/tasks.dart';
import '../models/task.dart';

class AddTaskScreen extends StatefulWidget {

  static const routeName = '/add-screen';
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {

  final _form = GlobalKey<FormState>();
  final _timeController = TextEditingController();
  final _dateController = TextEditingController();

  var _isInit = true;

  var _initValues = {
    'title' : '',
    'description' : '',
  };

  var _editTask = Task(
    id: '',
    title:  '',
    description: '',
    dueTime: '',
    dueDate: ''
  );

  @override
  void didChangeDependencies() {
    if(_isInit) {
      final tryId = ModalRoute.of(context)!.settings.arguments;
      if(tryId != null) {
        final id = tryId as String;
        _editTask = Provider.of<Tasks>(context, listen: false).findById(id);
        _initValues = {
          'title' : _editTask.title,
          'description' : _editTask.description,
        };
        _timeController.text = _editTask.dueTime;
        _dateController.text = _editTask.dueDate;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void _saveForm() {
    // final isValid = _form.currentState!.validate();
    // if(!isValid) {
    //   return ;
    // }
    _form.currentState?.save();
    if(_editTask.id != '') {
      Provider.of<Tasks>(context, listen: false).updateTask(_editTask.id, _editTask);
    }else {
      Provider.of<Tasks>(context, listen: false).addTask(_editTask);
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final localization = MaterialLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Task'),
        elevation: 0,
        actions: [
          IconButton(
              onPressed: _saveForm,
              icon: const Icon(Icons.save),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _form,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  initialValue: _initValues['title'],
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    label: const Text('Title',),
                    hintText: 'playing',
                  ),
                  onSaved: (value) {
                    _editTask = Task(
                        id: _editTask.id,
                        title: value!,
                        description: _editTask.description,
                        dueDate: _editTask.dueDate,
                        dueTime: _editTask.dueTime,
                    );
                  },
                ),
                const SizedBox(height: 20,),
                TextFormField(
                  initialValue: _initValues['description'],
                  textInputAction: TextInputAction.newline,
                  maxLines: 3,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    label: const Text('Description',),
                  ),
                  onSaved: (value) {
                    _editTask = Task(
                      id: _editTask.id,
                      title: _editTask.title,
                      description: value!,
                      dueDate: _editTask.dueDate,
                      dueTime: _editTask.dueTime,
                    );
                  },
                ),
                const SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _timeController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          label: const Text('Due Time',),
                        ),
                        onSaved: (value) {
                          _editTask = Task(
                            id: _editTask.id,
                            title: _editTask.title,
                            description: _editTask.description,
                            dueDate: _editTask.dueDate,
                            dueTime: value!,
                          );
                        },
                      ),
                    ),
                    IconButton(
                        onPressed: () async {
                          var temTime = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                          );
                          if(temTime == null) {
                            setState(() {
                              _timeController.text = 'no time chosen';
                            });
                          } else {
                            final time = localization.formatTimeOfDay(temTime);
                            setState(() {
                              _timeController.text = time;
                            });
                          }
                        },
                        icon: const Icon(Icons.access_time_rounded),
                    )
                  ],
                ),
                const SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _dateController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          label: const Text('Due Date',),
                          hintText: 'mm/dd/yyyy',
                        ),
                        onEditingComplete:  () {setState(() {});},
                        onFieldSubmitted: (_) {
                          _saveForm();
                        },
                        onSaved: (value) {
                          _editTask = Task(
                            id: _editTask.id,
                            title: _editTask.title,
                            description: _editTask.description,
                            dueDate: value!,
                            dueTime: _editTask.dueTime,
                          );
                        },
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                      var temDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      temDate ??= DateTime.now();
                      final date = DateFormat.yMd().format(temDate);
                      setState(() {
                        _dateController.text = date;
                      });
                    },
                      icon: const Icon(Icons.calendar_month),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      )
    );
  }
}
