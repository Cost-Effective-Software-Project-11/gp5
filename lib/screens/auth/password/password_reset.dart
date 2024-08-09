import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gp5/screens/auth/login/login_screen.dart';
import 'package:flutter_gp5/screens/auth/password/bloc/email_bloc.dart';
import 'package:flutter_gp5/extensions/build_context_extensions.dart';
import 'package:flutter_gp5/locale/l10n/app_locale.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final TextEditingController _emailController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _emailFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String passwordReset = AppLocale.of(context)!.password_reset;
    String passwordText1 = AppLocale.of(context)!.password_text_1;
    String passwordText2 = AppLocale.of(context)!.password_text_2;

    return BlocProvider(
      create: (context) => EmailBloc(FirebaseAuth.instance),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
          centerTitle: true,
          elevation: 0,
          title: Text(
            passwordReset,
            style: const TextStyle(
              color: Color(0xFF1D1B20),
              fontSize: 22,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w400,
              height: 1.2,
            ),
          ),
        ),
        body: Container(
          alignment: Alignment.center,
          width: context.setWidth(100),
          height: context.setHeight(100),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(0.34, -0.94),
              end: Alignment(-0.34, 0.94),
              colors: [Color(0x7FFEF7FF), Color(0xFFD5EAE9), Color(0xFFA1D2CE)],
            ),
          ),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: context.setHeight(5)),
                  SizedBox(
                    width: context.setWidth(80),
                    child: Text(
                      passwordText1,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w500,
                        height: 1.2,
                        letterSpacing: 0.15,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: context.setHeight(5)),
                  SizedBox(
                    width: context.setWidth(80),
                    child: Text(
                      passwordText2,
                      maxLines: 3,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w400,
                        height: 1.2,
                        letterSpacing: 0.25,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: context.setHeight(5)),
                  _emailTextFormField(),
                  SizedBox(height: context.setHeight(5)),
                  _buildSendButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _emailTextFormField() {
    return SizedBox(
      width: context.setWidth(80),
      child: TextFormField(
        controller: _emailController,
        focusNode: _emailFocusNode,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.email_rounded),
          hintText: AppLocale.of(context)!.email_placeholder,
          labelText: AppLocale.of(context)!.email,
          enabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20)),
              borderSide: BorderSide(color: Colors.grey)),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20)),
            borderSide: BorderSide(
              color: Colors.blue,
            ),
          ),
          errorBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
            borderSide: BorderSide(
              color: Colors.red,
            ),
          ),
          focusedErrorBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
            borderSide: BorderSide(
              color: Colors.red,
            ),
          ),
        ),
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return AppLocale.of(context)!.emailTextError;
          }
          final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
          if (!emailRegex.hasMatch(value)) {
            return AppLocale.of(context)!.emailTextError;
          }
          return null;
        },
      ),
    );
  }

  Widget _buildSendButton() {
    return BlocConsumer<EmailBloc, EmailState>(
      listener: (context, state) {
        if (state is EmailSentSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocale.of(context)!.emailSented),
              backgroundColor: Colors.green,
            ),
          );

          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const LoginScreen()));
        } else if (state is EmailSentFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is EmailSending) {
          return const CircularProgressIndicator();
        }

        return SizedBox(
          width: context.setWidth(80),
          height: context.setHeight(6),
          child: ElevatedButton(
            onPressed: () {
              if (_formKey.currentState?.validate() == true) {
                final email = _emailController.text.trim();
                context.read<EmailBloc>().add(SendEmailEvent(email));
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6750A4),
              padding: const EdgeInsets.symmetric(vertical: 15),
            ),
            child: Text(
              AppLocale.of(context)!.sendEmail,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
  }
}
