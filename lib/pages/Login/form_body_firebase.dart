import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:songfinderapp/utils/secrets.dart';

import '../HomePage.dart';

class FormBodyFirebase extends StatelessWidget {
  FormBodyFirebase({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SignInScreen(
        showAuthActionSwitch: false, // disable navigate to register screen
        headerBuilder: (context, constraints, breakpoint) {
          return Center(
            child: Image.asset("assets/music.png", height: 120),
          );
        },
        providerConfigs: [
          EmailProviderConfiguration(),
          GoogleProviderConfiguration(clientId: GOOGLE_CLIENT_ID),
        ],
        footerBuilder: (context, action) {
          return Text(
            'By signing in, you agree to our terms and conditions.',
          );
        },
        actions: [
          AuthStateChangeAction<SignedIn>((context, state) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => HomePage(),
              ),
            );
          }),
        ],
      ),
    );
  }
}
