import 'package:flutter/material.dart';
import 'package:scribbles/screens/add_screen.dart';
import 'package:scribbles/services/scribbles_service.dart';
import 'package:scribbles/utils/snackbar_helper.dart';
import 'package:scribbles/widgets/scribbles_card.dart';

class ScribblesListScreen extends StatefulWidget {
  const ScribblesListScreen({super.key});

  @override
  State<ScribblesListScreen> createState() => _ScribblesListScreenState();
}

class _ScribblesListScreenState extends State<ScribblesListScreen> {
  bool isLoading = true;
  List items = [];

  @override
  void initState() {
    super.initState();
    fetchScribbles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.indigo.shade100,
        title: Text('Scribbles'),
      ),
      body: Visibility(
        visible: isLoading,
        child: Center(child: CircularProgressIndicator()),
        replacement: RefreshIndicator(
          onRefresh: fetchScribbles,
          child: Visibility(
            visible: items.isNotEmpty,
            replacement: Center(
              child: Text(
                'No Scribbles Item',
                style: Theme.of(context).textTheme.displaySmall,
              ),
            ),
            child: ListView.builder(
                itemCount: items.length,
                padding: EdgeInsets.all(8),
                itemBuilder: (context, index) {
                  final item = items[index] as Map;
                  return ScribblesCard(
                      index: index,
                      item: item,
                      navigateEdit: navigateToEditScreen,
                      deleteById: deleteById);
                }),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: navigateToAddScreen,
        label: Icon(Icons.add),
      ),
    );
  }

  Future<void> navigateToAddScreen() async {
    final route = MaterialPageRoute(
      builder: (context) => AddScribblesScreen(),
    );
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchScribbles();
  }

  Future<void> navigateToEditScreen(Map item) async {
    final route = MaterialPageRoute(
      builder: (context) => AddScribblesScreen(scribbles: item),
    );
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchScribbles();
  }

  Future<void> deleteById(String id) async {
    final isSuccess = await ScribblesService.deleteById(id);
    if (isSuccess) {
      final filtered = items.where((element) => element['_id'] != id).toList();
      setState(() {
        items = filtered;
      });
    } else {
      showErrorMessage(context, message: 'Deleted Failed');
    }
  }

  Future<void> fetchScribbles() async {
    final response = await ScribblesService.fetchScribbles();
    if (response != null) {
      setState(() {
        items = response;
      });
    } else {
      showErrorMessage(context, message: 'Something went wrong');
    }
    setState(() {
      isLoading = false;
    });
  }
}
