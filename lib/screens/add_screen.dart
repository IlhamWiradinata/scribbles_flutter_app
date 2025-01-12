import 'package:flutter/material.dart';
import 'package:scribbles/services/scribbles_service.dart';
import 'package:scribbles/utils/snackbar_helper.dart';

class AddScribblesScreen extends StatefulWidget {
  final Map? scribbles;
  const AddScribblesScreen({
    super.key,
    this.scribbles,
  });

  @override
  State<AddScribblesScreen> createState() => _AddScribblesScreenState();
}

class _AddScribblesScreenState extends State<AddScribblesScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool isEdit = false;

  @override
  void initState() {
    super.initState();
    final scribbles = widget.scribbles;
    if (scribbles != null) {
      isEdit = true;
      final title = scribbles['title'];
      final description = scribbles['description'];
      titleController.text = title;
      descriptionController.text = description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEdit ? 'Edit Scribbles' : 'Add Scribbles',
        ),
      ),
      body: ListView(
        children: [
          TextField(
            controller: titleController,
            decoration: InputDecoration(hintText: 'Title'),
          ),
          TextField(
            controller: descriptionController,
            decoration: InputDecoration(hintText: 'Description'),
            keyboardType: TextInputType.multiline,
            minLines: 5,
            maxLines: 8,
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: isEdit ? updateData : submitData,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                isEdit ? 'Update' : 'Submit',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> updateData() async {
    final scribbles = widget.scribbles;
    if (scribbles == null) {
      print('You can not call updated without scribbles Data');
      return;
    }
    final id = scribbles['_id'];

    final isSuccess = await ScribblesService.updateScribbless(id, body);

    if (isSuccess) {
      titleController.text = '';
      descriptionController.text = '';
      showSuccessMessage(context, message:'Update Success');
    } else {
      showErrorMessage(context, message:'Update Failed');
    }
  }

  Future<void> submitData() async {
    final isSuccess = await ScribblesService.addScribbles(body);

    if (isSuccess) {
      titleController.text = '';
      descriptionController.text = '';
      showSuccessMessage(context, message:'Creation Success');
    } else {
      showErrorMessage(context, message:'Creation Failed');
    }
  }

  Map get body {
  final title = titleController.text;
    final description = descriptionController.text;
    return {
      "title": title,
      "description": description,
      "is_completed": false,
    };
  }
}
