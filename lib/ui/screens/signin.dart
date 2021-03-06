import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../providers/accounts.dart';
import '../../utils.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();
  final Map<String, String> _formValues = {};

  final String createToken = '''
    mutation CreateCustomerToken(\$email: String!, \$pass: String!) {
      generateCustomerToken(
        email: \$email
        password: \$pass
      ) {
        token
      }
    }
  ''';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldState,
      appBar: AppBar(
        title: Text('Sign In'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(36),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Company Logo'),
              SizedBox(
                height: 45.0,
              ),
              TextFormField(
                obscureText: false,
                decoration: InputDecoration(
                  hintText: 'Email',
                  labelText: 'Enter your email address',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(32.0),
                  ),
                ),
                validator: (String value) {
                  if (value.isEmpty) {
                    return 'Please enter your email address';
                  }
                  return null;
                },
                onSaved: (String value) {
                  _formValues['email'] = value;
                },
              ),
              SizedBox(height: 25.0),
              TextFormField(
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Password',
                  labelText: 'Enter your password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(32.0),
                  ),
                ),
                validator: (newValue) {
                  if (newValue.isEmpty) {
                    return 'Please enter password';
                  }
                  return null;
                },
                onSaved: (newValue) {
                  _formValues['password'] = newValue;
                },
              ),
              SizedBox(
                height: 35.0,
              ),
              Mutation(
                options: MutationOptions(
                  document: gql(createToken),
                  onCompleted: (data) async {
                    if (data == null) {
                      return;
                    }
                    final generateToken = data['generateCustomerToken'];
                    if (generateToken == null) {
                      return;
                    }
                    final token = generateToken['token'];
                    Provider.of<AccountsProvider>(context, listen: false)
                        .signIn(token);
                    var sharedPref = await SharedPreferences.getInstance();
                    await sharedPref.setString('customer', token);
                    await getCart(context);
                    Navigator.pop(context);
                  },
                  onError: (error) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(error.toString()),
                      ),
                    );
                  },
                ),
                builder: (runMutation, result) {
                  return ElevatedButton(
                    child: Text('Login'),
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        _formKey.currentState.save(); // Save our form now

                        runMutation({
                          'email': _formValues['email'],
                          'pass': _formValues['password'],
                        });
                      }
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
