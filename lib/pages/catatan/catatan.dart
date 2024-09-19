import 'package:dictionary/pages/catatan/edit_catatan.dart';
import 'package:dictionary/pages/catatan/models/task.dart';
import 'package:dictionary/pages/catatan/storage_service.dart';
import 'package:dictionary/pages/catatan/tambah_catatan.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class CatatanScreen extends StatefulWidget {
  const CatatanScreen({super.key});

  @override
  State<CatatanScreen> createState() => _CatatanScreenState();
}

class _CatatanScreenState extends State<CatatanScreen> {
  late List<Task> items;
  late List<Task> priorityItems;
  late List<Task> dailyItems;
  final StorageService _storageService = StorageService();

  @override
  void initState() {
    priorityItems = [];
    dailyItems = [];

    super.initState();
    _storageService.loadPriorityItems().then((loadedItems) {
      setState(() {
        priorityItems = loadedItems;
      });
    });
    _storageService.loadDailyItems().then((loadedItems) {
      setState(() {
        dailyItems = loadedItems;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text("Catatan", style: TextStyle(color: Colors.white)),
        automaticallyImplyLeading: true,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/Background.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildTopBar(),
              const SizedBox(height: 15),
              buildWelcomeText(),
              const SizedBox(
                height: 20,
              ),
              priorityItemsList(),
              const SizedBox(
                height: 15,
              ),
              Expanded(
                child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 20),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40)),
                      color: Colors.grey.shade100,
                    ),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          dailyTaskList(),
                          const SizedBox(
                            height: 25,
                          ),
                          buildAddTaskSection(),
                        ])),
              )
            ],
          ),
        ),
      ),
    );
  }

  Padding buildTopBar() {
    return const Padding(
      padding: EdgeInsets.only(left: 30, right: 30, top: 30),
      child: Row(
        children: [
          TimeDisplay(),
        ],
      ),
    );
  }

  Padding buildWelcomeText() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShaderMask(
            blendMode: BlendMode.srcIn,
            shaderCallback: (bounds) => const LinearGradient(
              colors: [
                Color(0xFF7BB6F8),
                Color(0xFF9C6DC5),
                Color(0xFF5D5C99),
              ],
              stops: [
                0.0,
                0.5,
                1.0,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
            child: const Text(
              "Selamat datang,",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const Text(
            "Semoga harimu menyenangkan!",
            style: TextStyle(
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }

  Padding priorityItemsList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Kosakata",
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 6,
          ),
          SizedBox(
            height: 150,
            child: priorityItems.isNotEmpty
                ? ReorderableListView.builder(
                    onReorder: (int oldIndex, int newIndex) {
                      setState(() {
                        if (newIndex > oldIndex) {
                          newIndex -= 1;
                        }
                        final item = priorityItems.removeAt(oldIndex);
                        priorityItems.insert(newIndex, item);
                        _storageService.savePriorityItems(priorityItems);
                      });
                    },
                    scrollDirection: Axis.horizontal,
                    itemCount: priorityItems.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        key: ValueKey(priorityItems[index].id),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      priorityItems[index].title.length > 12
                                          ? '${priorityItems[index].title.substring(0, 12)}...'
                                          : priorityItems[index].title,
                                    ),
                                    Text(
                                      "${priorityItems[index].progress.round()}% done",
                                      style: const TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                  ],
                                ),
                                content: Text(priorityItems[index].description),
                                actions: [
                                  TextButton(
                                    child: const Text("Close"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  TextButton(
                                    child: priorityItems[index].isDone == true
                                        ? const Text("Mark as not Done")
                                        : const Text("Mark as Done"),
                                    onPressed: () {
                                      setState(() {
                                        bool now = priorityItems[index].isDone;
                                        now == true
                                            ? priorityItems[index].isDone =
                                                false
                                            : priorityItems[index].isDone =
                                                true;
                                        now == true
                                            ? priorityItems[index].progress = 0
                                            : priorityItems[index].progress =
                                                100;

                                        _storageService
                                            .savePriorityItems(priorityItems);
                                        Navigator.of(context).pop();
                                      });
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        onDoubleTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditTask(
                                    idx: index,
                                    task: priorityItems[index],
                                    editedTask: (newEdittedtask) {
                                      setState(() {
                                        priorityItems[index] = newEdittedtask;
                                        _storageService
                                            .savePriorityItems(priorityItems);
                                      });
                                    })),
                          );
                        },
                        child: Dismissible(
                          direction: DismissDirection.up,
                          key: ValueKey(priorityItems[index].id),
                          onDismissed: (direction) {
                            setState(() {
                              priorityItems.removeAt(index);
                              _storageService.savePriorityItems(priorityItems);
                            });
                          },
                          background: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Center(
                                child: Icon(FontAwesomeIcons.trash)),
                          ),
                          child: Container(
                            width: 120,
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              gradient: priorityItems[index].isDone
                                  ? const LinearGradient(
                                      colors: [
                                        Color(0xff817FF7),
                                        Color(0xff817FF7),
                                      ],
                                    )
                                  : const LinearGradient(
                                      colors: [
                                        Color(0xFFBDBCFF),
                                        Color(0xFFA8D1FF),
                                      ],
                                      stops: [0.7, 1.0],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  spreadRadius: 0,
                                  blurRadius: 4,
                                  offset: const Offset(3, 4),
                                )
                              ],
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          priorityItems[index].title,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 10.0,
                                              right: 10.0,
                                              bottom: 10.0),
                                          child: SizedBox(
                                            width: double.infinity,
                                            height: 6,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: LinearProgressIndicator(
                                                backgroundColor: Colors.white,
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                            Color>(
                                                        Colors.purple.shade700),
                                                value: priorityItems[index]
                                                        .progress /
                                                    100,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const Spacer(),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  )
                : const Text(
                    "Tidak ada kosakata yang tersedia",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 18,
                    ),
                  ),
          )
        ],
      ),
    );
  }

  Expanded dailyTaskList() {
    return Expanded(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Catatan",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: 6,
        ),
        dailyItems.isNotEmpty
            ? Expanded(
                child: ReorderableListView.builder(
                    onReorder: (int oldIndex, int newIndex) {
                      setState(() {
                        if (newIndex > oldIndex) {
                          newIndex -= 1;
                        }
                        final item = dailyItems.removeAt(oldIndex);
                        dailyItems.insert(newIndex, item);
                        _storageService.saveDailyItems(dailyItems);
                      });
                    },
                    itemCount: dailyItems.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        key: ValueKey(dailyItems[index].id),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text(dailyItems[index].title),
                                content: Text(dailyItems[index].description),
                                actions: [
                                  TextButton(
                                    child: const Text("Close"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  TextButton(
                                    child: dailyItems[index].isDone == true
                                        ? const Text("Mark as not Done")
                                        : const Text("Mark as Done"),
                                    onPressed: () {
                                      setState(() {
                                        dailyItems[index].isDone == true
                                            ? dailyItems[index].isDone = false
                                            : dailyItems[index].isDone = true;
                                        _storageService
                                            .saveDailyItems(dailyItems);
                                        Navigator.of(context).pop();
                                      });
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        onDoubleTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditTask(
                                    idx: index,
                                    task: dailyItems[index],
                                    editedTask: (newEdittedtask) {
                                      setState(() {
                                        dailyItems[index] = newEdittedtask;
                                        _storageService
                                            .saveDailyItems(dailyItems);
                                      });
                                    })),
                          );
                        },
                        child: Dismissible(
                          direction: DismissDirection.endToStart,
                          key: ValueKey(dailyItems[index].id),
                          onDismissed: (direction) {
                            setState(() {
                              dailyItems.removeAt(index);
                              _storageService.saveDailyItems(dailyItems);
                            });
                          },
                          background: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Row(
                              children: [
                                Spacer(),
                                Icon(FontAwesomeIcons.trash),
                              ],
                            ),
                          ),
                          child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 6),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 15),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    dailyItems[index].title,
                                    style: TextStyle(
                                      color: dailyItems[index].isDone
                                          ? const Color(0xff5038BC)
                                          : Colors.black,
                                      decoration: dailyItems[index].isDone
                                          ? TextDecoration.lineThrough
                                          : null,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 20.0),
                                    child: Container(
                                      height: 20,
                                      width: 20,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: const Color(0xff5038BC),
                                            width: 2,
                                          ),
                                          color: dailyItems[index].isDone
                                              ? const Color(0xff5038BC)
                                              : Colors.transparent),
                                    ),
                                  )
                                ],
                              )),
                        ),
                      );
                    }),
              )
            : const Text(
                "Tidak ada catatan yang tersedia",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 18,
                ),
              )
      ],
    ));
  }

  SizedBox buildAddTaskSection() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AddTask(
                          addedTask: (newTask) {
                            setState(() {
                              if (newTask.isPriority == true) {
                                priorityItems.add(newTask);
                                _storageService
                                    .savePriorityItems(priorityItems);
                              } else {
                                dailyItems.add(newTask);
                                _storageService.saveDailyItems(dailyItems);
                              }
                            });
                          },
                        )));
          },
          style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xff5038BC),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              )),
          child: const Text(
            "Tambah kosakata atau catatan baru",
            style: TextStyle(
              color: Colors.white,
            ),
          )),
    );
  }
}

class TimeDisplay extends StatelessWidget {
  const TimeDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('EEEE, MMM d yyyy').format(now);
    return Text(
      formattedDate,
      style: const TextStyle(
        fontSize: 20,
      ),
    );
  }
}
