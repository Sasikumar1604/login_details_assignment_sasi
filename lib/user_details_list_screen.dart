
import 'package:flutter/material.dart';
import 'package:login_details_assignment_sasi/register_screen.dart';
import 'package:login_details_assignment_sasi/user_model.dart';
import 'db_helper.dart';
import 'main.dart';

class DirectorListScreen extends StatefulWidget {
  final String userName;

  const DirectorListScreen({super.key, required this.userName});

  @override
  State<DirectorListScreen> createState() => _DirectorListScreenState();
}

class _DirectorListScreenState extends State<DirectorListScreen> {
  late List<UserDetailsModel> _userDetailsList;

  @override
  void initState() {
    super.initState();
    getAllDirectorDetails();
  }

  getAllDirectorDetails() async {
    _userDetailsList = <UserDetailsModel>[];
    var userDetailRecords =
    await dbHelper.queryAllRows(DatabaseHelper.registerTable);
    //queryAllRows means Retreive All Rows from DB

    userDetailRecords.forEach((userDetail) {
      setState(() {
        print(userDetail['_id']);
        print(userDetail['_userName']);
        print(userDetail['_password']);
        print(userDetail['_email']);
        print(userDetail['_mobileNo']);
        print(userDetail['_dob']);

        var userDetailsModel = UserDetailsModel(
          userDetail['_id'],
          userDetail['_userName'],
          userDetail['_password'],
          userDetail['_email'],
          userDetail['_mobileNo'],
          userDetail['_dob'],
        );
        print(widget.userName);
        print(userDetail['_userName']);
if(widget.userName ==  userDetail['_userName']) {

          _userDetailsList.add(userDetailsModel);
          }
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text('User Details',
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
        ),
      ),
        body: Container(
    child: ListView.builder(
    itemCount: _userDetailsList.length,
    itemBuilder: (BuildContext context, int index) {
    return InkWell(
    onTap: () {
    print('---------->Edit or Deleted Invoked : Send Data');
    print(_userDetailsList[index].id);
    print(_userDetailsList[index].userName);
    print(_userDetailsList[index].password);
    print(_userDetailsList[index].email);
    print(_userDetailsList[index].mobileNo);
    print(_userDetailsList[index].dob);

    Navigator.of(context).push(MaterialPageRoute(
    builder: (context) => RegisterScreen(),
    settings: RouteSettings(
    arguments: _userDetailsList[index],
    ),
    ));
    },
    child: ListTile(
    title: Text(_userDetailsList[index].userName),
    subtitle: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('DOB: ${_userDetailsList[index].dob}'),
    Text('Email: ${_userDetailsList[index].email}'),
    Text('Mobile No: ${_userDetailsList[index].mobileNo}'),
    ],
    ),
      ),
    );
  }),
    ),
    floatingActionButton: FloatingActionButton(
    onPressed: () {
      print('------> Launch Director Details Form Screen');
      Navigator.of(context).push(MaterialPageRoute(
    builder: (context) => RegisterScreen()));
    },
    child: Icon(Icons.add),
    ),
    );
    }
  }
