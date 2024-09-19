import 'package:dictionary/pages/catatan/components.dart';
import 'package:dictionary/pages/catatan/models/task.dart';
import 'package:flutter/material.dart';

class EditTask extends StatefulWidget {
  const EditTask(
      {super.key,
      required this.idx,
      required this.task,
      required this.editedTask});

  final int idx;
  final Task task;
  final Function(Task task) editedTask;

  @override
  State<EditTask> createState() => _EditTaskState();
}

class _EditTaskState extends State<EditTask> {
  late TextEditingController _editTitleController;
  late TextEditingController _editDescriptionController;
  late double _currentProgress;
  late bool _newIsDone;

  @override
  void initState() {
    super.initState();
    _editTitleController = TextEditingController(text: widget.task.title);
    _editDescriptionController =
        TextEditingController(text: widget.task.description);
    _currentProgress = widget.task.progress.toDouble();
  }

  @override
  void dispose() {
    _editTitleController.dispose();
    _editDescriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
            color: Color(0xff5038BC),
          ),
          child: Column(
            children: [
              const SizedBox(height: 60),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    backButton(),
                    Text(
                      "Edit tugas",
                      style: TextStyle(
                          color: Colors.white,
                          decoration: TextDecoration.none,
                          fontSize: 30),
                    ),
                    // supaya text edit task ditengah
                    SizedBox(
                      height: 30,
                      width: 30,
                    )
                  ],
                ),
              ),
              const SizedBox(height: 50),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(
                    left: 30, top: 50, bottom: 50, right: 30),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TitleInput(controller: _editTitleController),
                    const SizedBox(
                      height: 40,
                    ),
                    const Text(
                      "Kategori",
                      style: TextStyle(
                        color: Color(0xff5038BC),
                        decoration: TextDecoration.none,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                        width: double.infinity,
                        height: 40,
                        decoration: BoxDecoration(
                            color: const Color(0xff5038BC),
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                            child: widget.task.isPriority
                                ? const Text(
                                    "Kosakata",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  )
                                : const Text(
                                    "Catatan",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ))),
                    widget.task.isPriority ? progressSection() : Container(),
                    const SizedBox(height: 40),
                    DescriptionInput(controller: _editDescriptionController),
                    const SizedBox(
                      height: 40,
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: ElevatedButton(
                          onPressed: () {
                            if (_editTitleController.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  backgroundColor: Colors.redAccent,
                                  content: Text("Tolong isi judul"),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            } else {
                              _newIsDone =
                                  _currentProgress == 100 ? true : false;
                              widget.editedTask(Task(
                                id: widget.task.id,
                                title: _editTitleController.text,
                                description: _editDescriptionController.text,
                                isPriority: widget.task.isPriority,
                                isDone: _newIsDone,
                                progress: _currentProgress,
                              ));
                              Navigator.pop(context);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xff5038BC),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              )),
                          child: const Text(
                            "Simpan perubahan",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          )),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Column progressSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 40,
        ),
        const Text(
          "Progress",
          style: TextStyle(
            color: Color(0xff5038BC),
            decoration: TextDecoration.none,
            fontSize: 20,
          ),
        ),
        const SizedBox(height: 10),
        Slider(
            value: _currentProgress,
            min: 0,
            max: 100,
            divisions: 100,
            label: _currentProgress.round().toString(),
            onChanged: (double value) {
              setState(() {
                _currentProgress = value;
              });
            }),
      ],
    );
  }
}
