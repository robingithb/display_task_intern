import 'dart:io';

import 'package:display_app/queryhelper.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Map<String, dynamic>> _allDetails = [];
  bool _isLoading = false;
  final TextEditingController _displayNamecontroller = TextEditingController();
  final TextEditingController _displayColorcontroller = TextEditingController();
  File? _selectedImage;

  void reloadDetaiils() async {
    final details = await Queryhelper.getAllDetails();
    setState(() {
      _allDetails = details;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    reloadDetaiils();
    super.initState();
  }

  Future addDetails() async {
    await Queryhelper.createDetail(
        _displayNamecontroller.text, _displayColorcontroller.text);
    reloadDetaiils();
  }

  void deleteall() async {
    await Queryhelper.deleteAllNotes();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("All note has been deleted"),
    ));
    reloadDetaiils();
  }

  Future pickImage() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      _selectedImage = File(returnedImage!.path);
    });
  }

  void showBottomsheetContent(int? id) async {
    showModalBottomSheet(
        elevation: 1,
        isScrollControlled: true,
        context: context,
        builder: (_) => SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.only(
                          top: 15,
                          left: 15,
                          right: 15,
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            TextField(
                              controller: _displayNamecontroller,
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: "Name"),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            TextField(
                              controller: _displayColorcontroller,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: "Colour",
                              ),
                            ),
                            // TextField(
                            //   controller: _displayImagePathcontroller,
                            //   decoration: const InputDecoration(
                            //     border: OutlineInputBorder(),
                            //     hintText: "Image Path",
                            //   ),
                            // ),
                            TextButton(
                                onPressed: () {
                                  pickImage();
                                },
                                child: const Text("pick an image")),
                            const SizedBox(
                              height: 5,
                            ),
                            Center(
                              child: OutlinedButton(
                                  onPressed: () {
                                    addDetails();
                                    _displayNamecontroller.text = '';
                                    _displayColorcontroller.text = '';

                                    Navigator.of(context).pop();
                                  },
                                  child: const Text(
                                    "Upload",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w300),
                                  )),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Display"),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                deleteall();
              },
              icon: const Icon(Icons.delete))
        ],
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemCount: _allDetails.length,
                itemBuilder: (context, index) => Card(
                    elevation: 5,
                    margin: const EdgeInsets.all(16),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            _allDetails[index]['name'],
                            style: const TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            _allDetails[index]['colour'],
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w400),
                          ),
                          _selectedImage != null
                              ? Image.file(_selectedImage!)
                              : const Text("please select an image")
                        ],
                      ),
                    )),
              ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            showBottomsheetContent(null);
          },
          child: const Icon(Icons.add)),
    );
  }
}
