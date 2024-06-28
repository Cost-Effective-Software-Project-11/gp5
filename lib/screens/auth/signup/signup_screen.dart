import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gp5/extensions/build_context_extensions.dart';
import '../../../enums/status_enum.dart';
import '../../../routes/app_routes.dart';
import 'bloc/signup_bloc.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authenticationRepository = RepositoryProvider.of<AuthenticationRepository>(context);
    return BlocProvider(
      create: (context) => SignupBloc(authenticationRepository: authenticationRepository),
      child: const _SignupScreen(),
    );
  }
}

class _SignupScreen extends StatefulWidget {
  const _SignupScreen({Key? key}) : super(key: key);

  @override
  State<_SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<_SignupScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final FocusNode _usernameFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _confirmPasswordFocusNode = FocusNode();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _usernameFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: BlocListener<SignupBloc, SignupState>(
          listener: (context, state) {
            if (state.status == StatusEnum.success) {
              Navigator.pushReplacementNamed(context, AppRoutes.home);
            } else if (state.status == StatusEnum.failure) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(const SnackBar(content: Text('Signup Failed')));
            }
          },
          child: Center(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: context.setHeight(2)),
                    _usernameTextFormField(),
                    SizedBox(height: context.setHeight(2)),
                    _emailTextFormField(),
                    SizedBox(height: context.setHeight(2)),
                    _passwordTextFormField(),
                    SizedBox(height: context.setHeight(2)),
                    _confirmPasswordTextFormField(),
                    SizedBox(height: context.setHeight(2)),
                    _buildSignupButton(),
                    SizedBox(height: context.setHeight(2)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _usernameTextFormField() {
    return TextFormField(
      controller: _usernameController,
      focusNode: _usernameFocusNode,
      decoration: const InputDecoration(labelText: 'Username'),
      keyboardType: TextInputType.text,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a username';
        }
        return null;
      },
    );
  }

  TextFormField _emailTextFormField() {
    return TextFormField(
      controller: _emailController,
      focusNode: _emailFocusNode,
      decoration: const InputDecoration(labelText: 'Email'),
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value == null || value.isEmpty || !value.contains('@')) {
          return 'Please enter a valid email';
        }
        return null;
      },
    );
  }

  TextFormField _passwordTextFormField() {
    return TextFormField(
      controller: _passwordController,
      focusNode: _passwordFocusNode,
      obscureText: !_isPasswordVisible,
      decoration: InputDecoration(
        labelText: 'Password',
        suffixIcon: IconButton(
          icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off),
          onPressed: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
            });
          },
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty || value.length < 6) {
          return 'Password must be at least 6 characters';
        }
        return null;
      },
    );
  }

  TextFormField _confirmPasswordTextFormField() {
    return TextFormField(
      controller: _confirmPasswordController,
      focusNode: _confirmPasswordFocusNode,
      obscureText: true,
      decoration: const InputDecoration(labelText: 'Confirm Password'),
      validator: (value) {
        if (value != _passwordController.text) {
          return 'Passwords do not match';
        }
        return null;
      },
    );
  }

  Widget _buildSignupButton() {
    return BlocBuilder<SignupBloc, SignupState>(
      builder: (context, state) {
        return StatusEnum.inProgress == state.status
            ? const CircularProgressIndicator()
            : ElevatedButton(
          onPressed: _submitForm,
          child: const Text('Signup'),
        );
      },
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      context.read<SignupBloc>().add(SignupSubmitted(
        username: _usernameController.text,
        email: _emailController.text,
        password: _passwordController.text,
      ));
    }
  }
}
