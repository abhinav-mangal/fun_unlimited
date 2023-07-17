import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../../Utils/constant.dart';
import '../../../../common_widgets/common_colors.dart';

class SearchGroupPage extends StatefulWidget {
  const SearchGroupPage({Key? key}) : super(key: key);

  @override
  State<SearchGroupPage> createState() => _SearchGroupPageState();
}

class _SearchGroupPageState extends State<SearchGroupPage> {
  final searchController = TextEditingController();
  bool isLoading = false;
  final debounce = Debouncer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          height: 40,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Expanded(
                child: Center(
                  child: TextField(
                    controller: searchController,
                    decoration: const InputDecoration(
                      hintText: 'Search',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(left: 10, bottom: 8),
                    ),
                    onChanged: (value) {
                      setState(() {
                        isLoading = true;
                      });
                      debounce.run(() {
                        log("Search Text: $value");
                        setState(() {
                          isLoading = false;
                        });
                      });
                    },
                  ),
                ),
              ),
              tapper(
                onTap: () {
                  searchController.clear();
                },
                child: const Icon(
                  Icons.clear,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance.collection('Groups').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData || isLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView.builder(
              itemCount:
                  snapshot.data!.docs.isEmpty ? 50 : snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.grey,
                  ),
                  title: const Text(
                    'Group Name',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: const Text(
                    'Group Description',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: tapper(
                    onTap: () {},
                    child: Container(
                      height: 25,
                      width: 60,
                      decoration: BoxDecoration(
                        color: purple,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Text(
                          'Join',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }),
    );
  }
}
