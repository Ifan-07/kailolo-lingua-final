import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ignore: camel_case_types
class backButton extends StatelessWidget {
  const backButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        height: 35,
        width: 35,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(7)),
        ),
        child: const Icon(Icons.arrow_back),
      ),
    );
  }
}

class TitleInput extends StatelessWidget {
  const TitleInput({super.key, required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Judul",
          style: TextStyle(
            color: Color(0xff5038BC),
            decoration: TextDecoration.none,
            fontSize: 20,
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: controller,
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(color: Color(0xff5038BC)),
            ),
            hintText: "Masukkan judul (max 25 karakter)",
          ),
          inputFormatters: [
            LengthLimitingTextInputFormatter(25),
          ],
        ),
      ],
    );
  }
}

class CategoryButton extends StatelessWidget {
  const CategoryButton(
      {super.key,
      required this.index,
      required this.text,
      required this.selectedIndex,
      required this.onSelected});

  final int index;
  final String text;
  final int selectedIndex;
  final Function(int) onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      height: 50,
      child: ElevatedButton(
          onPressed: () => onSelected(index),
          style: ElevatedButton.styleFrom(
              backgroundColor: selectedIndex == index
                  ? const Color(0xff5038BC)
                  : Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              )),
          child: Text(
            text,
            style: TextStyle(
              color: selectedIndex == index
                  ? Colors.white
                  : const Color(0xff5038BC),
            ),
          )),
    );
  }
}

class DescriptionInput extends StatelessWidget {
  const DescriptionInput({super.key, required this.controller});

  final TextEditingController controller;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Deskripsi",
          style: TextStyle(
            color: Color(0xff5038BC),
            decoration: TextDecoration.none,
            fontSize: 20,
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: controller,
          maxLines: 5,
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(color: Colors.grey)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(color: Color(0xff5038BC))),
          ),
        ),
      ],
    );
  }
}
