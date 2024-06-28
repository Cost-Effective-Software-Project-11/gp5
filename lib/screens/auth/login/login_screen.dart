import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gp5/enums/status_enum.dart';
import 'package:flutter_gp5/routes/app_routes.dart';
import '../../../utils/image_utils.dart';
import '../../../extensions/build_context_extensions.dart';
import 'bloc/login_bloc.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authenticationRepository = RepositoryProvider.of<AuthenticationRepository>(context);
    return BlocProvider(
      create: (context) => LoginBloc(authenticationRepository: authenticationRepository),
      child: const _LoginScreen(),
    );
  }
}

class _LoginScreen extends StatefulWidget {
  const _LoginScreen({Key? key}) : super(key: key);

  @override
  State<_LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<_LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _usernameFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _usernameFocusNode.dispose();
    _passwordFocusNode.dispose();
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
        child: BlocListener<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state.status == StatusEnum.success) {
              Navigator.pushReplacementNamed(context, AppRoutes.home);
            } else if (state.status == StatusEnum.failure) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(const SnackBar(content: Text('Login Failed')));
            }
          },
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _logoWidget(context),
                  _loginForm(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _logoWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: context.setHeight(5)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Image.asset(ImageUtils.logo, height: context.setHeight(10)),
      ),
    );
  }

  Form _loginForm() {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: context.setHeight(2)),
          _usernameTextFormField(),
          SizedBox(height: context.setHeight(2)),
          _passwordTextFormField(),
          SizedBox(height: context.setHeight(2)),
          _forgotPassword(),
          SizedBox(height: context.setHeight(2)),
          _buildLoginButton(),
          SizedBox(height: context.setHeight(2)),
          _signupRow(context),
        ],
      ),
    );
  }

  Widget _buildLoginButton() {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return state.status == StatusEnum.inProgress
            ? const CircularProgressIndicator()
            : ElevatedButton(
          key: const Key('loginForm_continue_raisedButton'),
          onPressed: _submitForm,
          child: const Text('Login'),
        );
      },
    );
  }

  TextFormField _usernameTextFormField() {
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
      onChanged: (value) {
        context.read<LoginBloc>().add(LoginUsernameChanged(value));
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
      onChanged: (value) {
        context.read<LoginBloc>().add(LoginPasswordChanged(value));
      },
    );
  }

  Widget _forgotPassword() {
    return TextButton(
      onPressed: () {},
      child: const Text('Forgot Password?'),
    );
  }

  Row _signupRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Text("Don't have an account?"),
        TextButton(
          onPressed: () {
            Navigator.pushNamed(context, AppRoutes.signup);
          },
          child: const Text('Sign Up'),
        ),
      ],
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      context.read<LoginBloc>().add(const LoginSubmitted());
    }
  }
}
