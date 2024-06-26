import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserAction extends StatefulWidget {
  const UserAction({Key? key}) : super(key: key);

  @override
  _UserActionState createState() => _UserActionState();
}

class _UserActionState extends State<UserAction> {
  late List<DocumentSnapshot> _userDocuments = [];
  late List<DocumentSnapshot> _filteredUserDocuments = [];
  bool _loading = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() => _loading = true);

    final QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('User').get();

    setState(() {
      _userDocuments = querySnapshot.docs;
      _filteredUserDocuments = _userDocuments;
      _loading = false;
    });
  }

  void _filterData(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredUserDocuments = _userDocuments;
      } else {
        _filteredUserDocuments = _userDocuments.where((doc) {
          final data = doc.data() as Map<String, dynamic>;
          final name = data['Name']?.toString() ?? '';
          final email = data['Email']?.toString() ?? '';
          final gender = data['Gender']?.toString() ?? '';
          final matches = name.toLowerCase().contains(query.toLowerCase()) ||
              email.toLowerCase().contains(query.toLowerCase()) ||
              gender.toLowerCase().contains(query.toLowerCase());
          print('$name - $email - $gender - Matches: $matches');
          return matches;
        }).toList();
      }
    });
  }

  Future<void> _removeUser(DocumentSnapshot userDocument) async {
  final userId = userDocument.id;

  try {
    // Delete the user from Firestore
    await FirebaseFirestore.instance.collection('User').doc(userId).delete();

    // Delete the user from Firebase Authentication
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.delete();
    } else {
      print('No user is currently signed in.');
      return; // No need to proceed further if no user is signed in
    }

    // After deletion, refetch the data
    await _fetchData();
  } catch (e) {
    print('Error deleting user: $e');
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registered Users', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _searchController,
                    onChanged: _filterData,
                    decoration: InputDecoration(
                      labelText: 'Search',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Flexible(
                  child: ListView.builder(
                    itemCount: _filteredUserDocuments.length,
                    itemBuilder: (context, index) {
                      final data = _filteredUserDocuments[index].data()
                          as Map<String, dynamic>;
                      return ListTile(
                        title: Text(data['Name']?.toString() ?? ''),
                        subtitle: Text(data['Email']?.toString() ?? ''),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () =>
                                  _removeUser(_filteredUserDocuments[index]),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: UserAction(),
  ));
}
