import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:login_details_assignment_sasi/register_screen.dart';
import 'package:login_details_assignment_sasi/user_details_list_screen.dart';
import 'db_helper.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formField = GlobalKey<FormState>();

  var _userNameController = TextEditingController();
  final _passwordController = TextEditingController();
  var _dobController = TextEditingController();

  DateTime? _selectedDate;
  bool passwordToggle = true;

  late DatabaseHelper _databaseHelper;

  Future<void> _initializeDatabase() async {
    _databaseHelper = DatabaseHelper();
    await _databaseHelper.initialization();
  }

  @override
  void initState() {
    super.initState();
    _initializeDatabase();
  }

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

  // Handler for the 'Login' button
  Future<void> _loginUser() async {
    if (_formField.currentState!.validate()) {
      if (_databaseHelper == null) {}
      // Validate the form fields
      // Assume your DatabaseHelper has a method for checking login credentials
      bool loginSuccessful = await _databaseHelper.checkLoginCredentials(
        _userNameController.text,
        _passwordController.text,
      );

      if (loginSuccessful) {
        // Navigate to the list screen or any other screen on successful login
        Navigator.of(context).pushReplacement(
          // Use pushReplacement to replace the current screen
          MaterialPageRoute(
            builder: (context) => DirectorListScreen(userName: _userNameController.text),
          ),
        );
      } else {
        // Show an error message or handle unsuccessful login
        // For example, you can show a SnackBar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Invalid Username or Password'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.deepOrangeAccent,
          title: Text(
            'Login Screen',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true),
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 50),
            child: Form(
              key: _formField,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(7),
                    child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: _userNameController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(),
                        ),
                        prefixIcon: Icon(Icons.person),
                        labelText: 'Enter User Name',
                        hintText: 'Enter Your User Name',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter Your Date of Birth';
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(7),
                    child: TextFormField(
                      controller: _dobController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide(),
                          ),
                          labelText: 'Enter Date of Birth',
                          hintText: 'Enter Your DOB'),
                      onTap: () => _selectDate(context),
                      readOnly: true,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(7),
                    child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: _passwordController,
                      obscureText: passwordToggle,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.lock),
                        suffix: InkWell(
                          onTap: () {
                            setState(() {
                              passwordToggle = !passwordToggle;
                            });
                          },
                          child: Icon(passwordToggle
                              ? Icons.visibility_off
                              : Icons.visibility),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter Password';
                        } else if (_passwordController.text.length < 8) {
                          return 'Password should be min 8 characters';
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
                      _loginUser();
                    },
                    child: Text(
                      'Login',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrangeAccent,
                    ),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => RegisterScreen(),
                      ));
                    },
                    child: Text(
                      'Register',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
