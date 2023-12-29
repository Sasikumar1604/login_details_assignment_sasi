
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'db_helper.dart';
import 'main.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formField = GlobalKey<FormState>();
  var _userNameController = TextEditingController();
  final _passwordController = TextEditingController();
  var _emailController = TextEditingController();
  var _mobileNoController = TextEditingController();

  var _dobController = TextEditingController();

  bool passwordToggle = true;

  DateTime? _selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dobController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrangeAccent,
        title: Text('Register',
          style: TextStyle(
              fontWeight: FontWeight.bold
          ),
        ),
      ),
      body:SingleChildScrollView(
        child: Form(
          key: _formField,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextFormField(
                controller: _userNameController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(),
                    ),
                    labelText: 'User Name',
                    hintText: 'Enter Your UserName'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Enter user Name';
                  }
                }),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextFormField(
                controller: _dobController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(),
                  ),
                  labelText: 'Date of Birth',
                  hintText: 'Enter Your DOB',
                ),
                onTap: () => _selectDate(context),
                readOnly: true,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Enter Your Date of Birth';
                  }
                }),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                    labelText: 'Enter Password',
                    hintText: 'Enter Your Password',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(),
                    ),
                  prefixIcon: Icon(Icons.lock),
                  suffix: InkWell(
                    onTap: () {
                      setState(() {
                        passwordToggle = !passwordToggle;
                      });
                    },
                    child: Icon(passwordToggle
                    ? Icons.visibility_off
                    :Icons.visibility),
                  ),
              ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Enter Password.';
                  } else if (_passwordController.text.length < 8) {
                    return 'Password should be min 8 characters.';
                  }
                }),
            ),
            SizedBox(
              height: 20
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(),
                    ),
                    labelText: 'Email ID',
                    hintText: 'Enter Your Email ID'
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Enter Your email';
                  }
                },
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextFormField(
                controller: _mobileNoController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(),
                    ),
                    labelText: 'Enter Mobile No',
                    hintText: 'Enter Your Mobile No'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Enter Mobile Number';
                  }
                },
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrangeAccent,
              ),
              onPressed: () {
                if (_formField.currentState!.validate()) {
                  _register();ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Successfully Validated')));
                }
              },
              child: Text('Register',
              style: TextStyle(
                color: Colors.white,
              ),),
            ),
          ],
        ),
      ),
    )));
  }

  void _register() async {
    print('--------------> _save');
    print('--------------> user Name: ${_userNameController.text}');
    print('--------------> Password: ${_passwordController.text}');
    print('--------------> email: ${_emailController.text}');
    print('--------------> Mobile no: ${_mobileNoController.text}');
    print('--------------> Dob: ${_dobController.text}');

    Map<String, dynamic> row = {
      DatabaseHelper.colUserName: _userNameController.text,
      DatabaseHelper.colPassword: _passwordController.text,
      DatabaseHelper.colEmail: _emailController.text,
      DatabaseHelper.colMobileNo: _mobileNoController.text,
      DatabaseHelper.colDOB: _dobController.text,
    };

    final result = await dbHelper.insertDirectorDetails(
        row, DatabaseHelper.registerTable);

    debugPrint('----> Inserted Row Id: $result');

    if (result > 0)
      Navigator.pop(context);
      _showSuccessSnackBar(context, 'Saved');
    }
    // setState(() {
    //   Navigator.of(context).pushReplacement(
    //       MaterialPageRoute(builder: (context) => DirectorListScreen()));
    // });
  }

  void _showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(new SnackBar(content: new Text(message)));
  }
