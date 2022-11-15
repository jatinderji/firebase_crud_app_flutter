import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_crud_app/home_page.dart';
import 'package:firebase_crud_app/student.dart';
import 'package:flutter/material.dart';

class UpdateStudent extends StatelessWidget {
  final Student student;
  final TextEditingController rollController = TextEditingController();

  final TextEditingController nameController = TextEditingController();

  final TextEditingController marksController = TextEditingController();

  final FocusNode focusNode = FocusNode();

  UpdateStudent({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    rollController.text = '${student.rollno}';
    nameController.text = student.name;
    marksController.text = '${student.marks}';
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Student'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            getMyField(
                focusNode: focusNode,
                hintText: 'Rollno',
                textInputType: TextInputType.number,
                controller: rollController),
            getMyField(hintText: 'Name', controller: nameController),
            getMyField(
                hintText: 'Marks',
                textInputType: TextInputType.number,
                controller: marksController),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    onPressed: () {
                      //
                      // ToDO: Update a student
                      Student updatedStudent = Student(
                        id: student.id,
                        rollno: int.parse(rollController.text),
                        name: nameController.text,
                        marks: double.parse(marksController.text),
                      );
                      //
                      final collectionReference =
                          FirebaseFirestore.instance.collection('students');
                      collectionReference
                          .doc(updatedStudent.id)
                          .update(updatedStudent.toJson())
                          .whenComplete(() {
                        log('Student Updated');
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomePage(),
                            ));
                      });
                      //
                    },
                    child: const Text('Update')),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueGrey),
                    onPressed: () {
                      //
                      rollController.text = '';
                      nameController.text = '';
                      marksController.text = '';
                      focusNode.requestFocus();
                      //
                    },
                    child: const Text('Reset')),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget getMyField(
      {required String hintText,
      TextInputType textInputType = TextInputType.name,
      required TextEditingController controller,
      FocusNode? focusNode}) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextField(
        focusNode: focusNode,
        controller: controller,
        keyboardType: textInputType,
        decoration: InputDecoration(
            hintText: 'Enter $hintText',
            labelText: hintText,
            border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(5)))),
      ),
    );
  }
}
