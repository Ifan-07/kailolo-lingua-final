import 'package:dictionary/pages/catatan/components.dart';
import 'package:dictionary/pages/catatan/models/task.dart';
import 'package:dictionary/pages/catatan/storage_service.dart';
import 'package:flutter/material.dart';

class AddTask extends StatefulWidget {
  const AddTask({super.key, required this.addedTask});
  final Function(Task task) addedTask;
  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  int _selectedIndex = 0;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final StorageService storageService = StorageService();

  @override
  void dispose() {
    _titleController.dispose();
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
                    Expanded(
                      child: Center(
                        child: Text(
                          "Tambah tugas",
                          style: TextStyle(
                              color: Colors.white,
                              decoration: TextDecoration.none,
                              fontSize: 30),
                        ),
                      ),
                    ),
                    // supaya add text add task ada ditengah
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
                    TitleInput(controller: _titleController),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CategoryButton(
                            index: 0,
                            text: "Kosakata",
                            selectedIndex: _selectedIndex,
                            onSelected: (index) {
                              setState(() {
                                _selectedIndex = index;
                              });
                            }),
                        const SizedBox(
                          width: 20,
                        ),
                        CategoryButton(
                            index: 1,
                            text: "Catatan",
                            selectedIndex: _selectedIndex,
                            onSelected: (index) {
                              setState(() {
                                _selectedIndex = index;
                              });
                            })
                      ],
                    ),
                    const SizedBox(height: 50),
                    DescriptionInput(controller: _descriptionController),
                    const SizedBox(
                      height: 40,
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: ElevatedButton(
                          onPressed: () async {
                            if (_titleController.text.isEmpty) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                      backgroundColor: Colors.redAccent,
                                      content: Text(
                                        "Tolong isi judul",
                                      )));
                            } else {
                              Task newTask = await storageService.createTask(
                                _titleController.text,
                                _descriptionController.text,
                                _selectedIndex == 0 ? true : false,
                                false,
                                0,
                              );
                              widget.addedTask(newTask);
                              // ignore: use_build_context_synchronously
                              Navigator.pop(context);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xff5038BC),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              )),
                          child: const Text(
                            "Simpan",
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
}
