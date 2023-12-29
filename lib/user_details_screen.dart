

import 'package:flutter/material.dart';
import 'package:login_details_assignment_sasi/user_model.dart';

class UserDetailsScreen extends StatelessWidget {
  final UserDetailsModel userDetails;

  UserDetailsScreen(this.userDetails);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Details',
        style: TextStyle(
        fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('ID: $userDetails.id'),
          Text('UserName: $userDetails.userName'),
          Text('PasswordD: $userDetails.password'),
          Text('Email: $userDetails.email'),
          Text('Mobile No: $userDetails.mobileNo'),
          Text('DOB: $userDetails.dob'),
        ],
      ),
    );
  }
}
