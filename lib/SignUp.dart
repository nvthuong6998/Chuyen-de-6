import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'Login.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  navigateBack() async {
    Navigator.pushReplacementNamed(context, 'Login');
  }

  String _email, _password, _name;

  checkAuthentification() async {
    _auth.authStateChanges().listen((user) async {
      if (user != null) {
        Navigator.pushReplacementNamed(context, "/");
      }
    });
  }

  @override
  void initState() {
    super.initState();
    this.checkAuthentification();
  }

  signUp() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState..save();
      try {
        UserCredential user = await _auth.createUserWithEmailAndPassword(
            email: _email, password: _password);

        if (user != null) {
          // UserUpdateInfo updateuser = UserUpdateInfo();
          // updateuser.displayName = _name;
          // user.updateProfile(updateuser);

          await _auth.currentUser.updateProfile(displayName: _name);
        }
      } catch (e) {
        showError(e.message);
      }
    }
  }

  showError(String errormessage) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text(errormessage),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("OK")),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Sign Up"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: navigateBack,
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                Container(
                  height: 400,
                  child: Image(
                    image: AssetImage("images/doremon.png"),
                    fit: BoxFit.contain,
                  ),
                ),
                Container(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        Container(
                          child: TextFormField(
                              validator: (input) {
                                if (input.isEmpty) return 'Enter Name';
                              },
                              decoration: InputDecoration(
                                labelText: 'Name',
                                prefixIcon: Icon(Icons.person),
                              ),
                              onSaved: (input) => _name = input),
                        ),
                        Container(
                          child: TextFormField(
                              validator: (input) {
                                if (input.isEmpty) return 'Enter Email';
                              },
                              decoration: InputDecoration(
                                  labelText: 'Email',
                                  prefixIcon: Icon(Icons.email)),
                              onSaved: (input) => _email = input),
                        ),
                        Container(
                          child: TextFormField(
                              validator: (input) {
                                if (input.length < 6)
                                  return 'Provide Minimum 6 Character';
                              },
                              decoration: InputDecoration(
                                labelText: 'Password',
                                prefixIcon: Icon(Icons.lock),
                              ),
                              obscureText: true,
                              onSaved: (input) => _password = input),
                        ),
                        SizedBox(height: 20),
                        RaisedButton(
                          padding: EdgeInsets.fromLTRB(70, 10, 70, 10),
                          onPressed: signUp,
                          child: Text('SignUp',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold)),
                          color: Colors.orange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
