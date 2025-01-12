import 'package:flutter/material.dart';

class ScribblesCard extends StatelessWidget {
  final int index;
  final Map item;
  final Function(Map) navigateEdit;
  final Function(String) deleteById;
  const ScribblesCard({
    super.key,
    required this.index,
    required this.item,
    required this.navigateEdit,
    required this.deleteById,
  });

  @override
  Widget build(BuildContext context) {
    final id = item['_id'] as String;
    return Card(
      color: Colors.indigo.shade100,
      child: ListTile(
        leading: CircleAvatar(child: Text('${index + 1}'),
        backgroundColor: Colors.white,),
        title: Text(item['title']),
        subtitle: Text(item['description']),
        trailing: PopupMenuButton(
          onSelected: (value) {
            if (value == 'edit') {
              navigateEdit(item);
            } else if (value == 'delete') {
              deleteById(id);
            }
          },
          itemBuilder: (context) {
            return [
              PopupMenuItem(
                child: Text('Edit'),
                value: 'edit',
              ),
              PopupMenuItem(
                child: Text('Delete'),
                value: 'delete',
              ),
            ];
          },
        ),
      ),
    );
  }
}
