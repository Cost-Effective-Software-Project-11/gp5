import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gp5/extensions/build_context_extensions.dart';
import 'package:flutter_gp5/enums/status_enum.dart';
import 'package:flutter_gp5/locale/l10n/app_locale.dart';
import 'package:flutter_gp5/routes/app_routes.dart';
import 'package:flutter_gp5/screens/auth/password/password_reset.dart';
import 'package:iconly/iconly.dart';
import '../../../repos/authentication/authentication_repository.dart';
import '../../../utils/image_utils.dart';
import '../../starting_screen/starting_screen.dart';
import 'bloc/login_bloc.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authenticationRepository =
        RepositoryProvider.of<AuthenticationRepository>(context);
    return BlocProvider(
      create: (context) =>
          LoginBloc(authenticationRepository: authenticationRepository),
      child: const _LoginScreen(),
    );
  }
}

class _LoginScreen extends StatefulWidget {
  const _LoginScreen();

  @override
  State<_LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<_LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  bool _passwordVisible = false;
  bool _isForgotPasswordVisible = false;
  bool _rememberMe = false;
  bool _isFormFilled = false;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_updateSubmitButtonState);
    _passwordController.addListener(_updateSubmitButtonState);
  }

  void _updateSubmitButtonState() {
    setState(() {
      _isFormFilled =
          _validateField(_emailController.text, 'Email') == null &&
              _validateField(_passwordController.text, 'Password') == null;
    });
  }

  @override
  void dispose() {
    _emailController.removeListener(_updateSubmitButtonState);
    _passwordController.removeListener(_updateSubmitButtonState);

    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(context.setHeight(16)),
          child: Padding(
            padding: EdgeInsets.only(top: context.setHeight(8), bottom: context.setHeight(2)),
            child: AppBar(
              leading: IconButton(
                icon: Icon(Icons.navigate_before, color: const Color(0xFF1D1B20), size: context.setWidth(8)),
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: Text(
                AppLocale.of(context)!.login,
                style: TextStyle(
                  color: const Color(0xFF1D1B20),
                  fontSize: context.setWidth(5),
                  fontWeight: FontWeight.w400,
                ),
              ),
              backgroundColor: Colors.transparent,
              surfaceTintColor: Colors.white,
              elevation: 0,
              centerTitle: true,
              actions: <Widget>[
                Opacity(
                  opacity: 0,
                  child: IconButton(
                    icon: Icon(Icons.navigate_before, size: context.setWidth(8)),
                    onPressed: null,
                  ),
                ),
              ],
            ),
          ),
        ),
        body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFFEF7FF),
                  Color(0xFFD5EAE9),
                  Color(0xFFA1D2CE)
                ],
                stops: [0.3, 0.5, 0.9],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: BlocListener<LoginBloc, LoginState>(
                listener: (context, state) {
                  if (state.status == StatusEnum.success) {
                    Navigator.pushReplacementNamed(context, AppRoutes.home);
                  } else if (state.status == StatusEnum.failure) {
                    setState(() {
                      _isForgotPasswordVisible = true;
                    });
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(
                          const SnackBar(content: Text('Login Failed')));
                  }
                },
                child: Center(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.only(top: context.setHeight(5), bottom: context.setHeight(5)),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildSignUpForm(context),
                          _forgotPasswordButton(context),
                          _rememberMeField(),
                          _buildLoginButton(),
                          _buildOrSeparator(context),
                          _buildGoogleSignUpButton(context),
                          _signupRow(context),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )));
  }

  Widget _buildSignUpForm(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.setWidth(2.5), vertical: context.setHeight(1)),
      child: Column(
        children: [
          _buildInputField(context, AppLocale.of(context)!.email, IconlyBold.message, AppLocale.of(context)!.email_placeholder, false, _emailController),
          _buildInputField(context, AppLocale.of(context)!.password, IconlyBold.lock, AppLocale.of(context)!.password_placeholder, true, _passwordController, _togglePasswordVisibility)
        ],
      ),
    );
  }

  Widget _buildInputField(
      BuildContext context,
      String label,
      IconData icon,
      String placeholder,
      bool isPassword,
      TextEditingController controller,
      [VoidCallback? toggleVisibility]
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          alignment: Alignment.centerLeft,
          children: [
            Container(
              width: context.setWidth(90),
              height: 60,
              margin: EdgeInsets.only(top: context.setHeight(1)),
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                  side: const BorderSide(color: Color(0xFF79747E)),
                ),
                color: const Color(0xFFFEF7FF),
              ),
              child: Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: context.setWidth(3)),
                    alignment: Alignment.centerLeft,
                    child: Icon(icon, color: const Color(0xFF49454F), size: context.setWidth(6)),
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: controller,
                      obscureText: isPassword && !_passwordVisible,
                      decoration: InputDecoration(
                        hintText: placeholder,
                        hintStyle: TextStyle(color: const Color(0x6649454F), fontSize: context.setWidth(4)),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: context.setHeight(2), horizontal: context.setWidth(3)),
                        suffixIcon: isPassword ? IconButton(
                          icon: Icon(
                              _passwordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                          onPressed: toggleVisibility,
                          color: const Color(0xFF49454F),
                        ) : null,
                      ),
                      textAlign: TextAlign.left,
                      validator: (value) => _validateField(value, label),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: context.setHeight(-1.2),
              left: context.setWidth(4),
              child: Container(
                padding: EdgeInsets.all(context.setWidth(1.6)),
                color: Theme.of(context).scaffoldBackgroundColor,
                child: Text(
                  label,
                  style: TextStyle(
                    color: const Color(0xFF49454F),
                    fontSize: context.setWidth(3.5),
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  ),
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(left: context.setWidth(5), top: context.setHeight(0.3)),
          child: Text(
            controller.value.text.isEmpty || _validateField(controller.value.text, label) == null ? "" : _validateField(controller.value.text, label)!,
            style: TextStyle(color: Colors.red, fontSize: context.setWidth(3.5)),
          ),
        ),
      ],
    );
  }

  void _togglePasswordVisibility() {
    setState(() {
      _passwordVisible = !_passwordVisible;
    });
  }

  String? _validateField(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName cannot be empty';
    }

    switch (fieldName) {
      case 'Email':
        final emailRegex = RegExp(r'^[a-zA-Z0-9._]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$');
        if (!emailRegex.hasMatch(value)) {
          return 'Enter a valid email address';
        }
        break;
      case 'Password':
        if (value.length < 6) {
          return 'Password must be at least 6 characters long';
        }
        break;
    }
    return null;
  }

  Widget _forgotPasswordButton(BuildContext context) {
    return Visibility(
        visible: _isForgotPasswordVisible,
        child: Container(
          margin: const EdgeInsets.only(top: 5.0),
          child: InkWell(
            onTap: () => {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const ResetPassword()))
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: SizedBox(
                width: context.setWidth(80),
                child: Text(
                  AppLocale.of(context)!.forgotPasswordText,
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    color: Color(0xFF6750A4),
                    fontSize: 14,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w500,
                    height: 0.10,
                    letterSpacing: 0.25,
                  ),
                ),
              ),
            ),
          ),
        )
    );
  }

  Widget _buildLoginButton() {
    Color buttonColor = _isFormFilled ? const Color(0xFF6750A4) : Colors.grey;

    return Container(
      width: context.setWidth(80),
      height: 60,
      margin: EdgeInsets.only(
          top: context.setHeight(2.5),
          bottom: context.setHeight(1.25)
      ),
      decoration: BoxDecoration(
        color: buttonColor,
        borderRadius: BorderRadius.circular(100),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
        ),
        onPressed: _isFormFilled ? _submitForm : null,
        child: Text(
          AppLocale.of(context)!.login,
          style: TextStyle(
            color: Colors.white,
            fontSize: context.setWidth(3.5),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildOrSeparator(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: context.setHeight(1.25)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: context.setWidth(35),
            height: 1,
            color: const Color(0x661D1B20),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: context.setWidth(2)),
            child: Text(
              AppLocale.of(context)!.or,
              style: TextStyle(
                color: const Color(0x661D1B20),
                fontSize: context.setWidth(4),
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Container(
            width: context.setWidth(35),
            height: 1,
            color: const Color(0x661D1B20),
          ),
        ],
      ),
    );
  }

  Widget _buildGoogleSignUpButton(BuildContext context) {
    return Container(
      width: context.setWidth(80),
      height: 60,
      margin: EdgeInsets.only(top: context.setHeight(1.25), bottom: context.setHeight(2.5)),
      decoration: BoxDecoration(
        color: const Color(0xFF6750A4),
        borderRadius: BorderRadius.circular(context.setHeight(6.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: context.setWidth(6),
            height: context.setHeight(3),
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(ImageUtils.googleLogo),
                fit: BoxFit.fill,
              ),
            ),
          ),
          SizedBox(width: context.setWidth(2.5)),
          Text(
            AppLocale.of(context)!.signUpWithGoogle,
            style: TextStyle(
              color: Colors.white,
              fontSize: context.setWidth(3.5),
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate() && _isFormFilled) {
      context.read<LoginBloc>().add(LoginSubmitted(
        email: _emailController.text,
        password: _passwordController.text,
      ));
    }
  }

  Row _signupRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Text("Don't have an account?"),
        TextButton(
          onPressed: () => showRegisterAsDialog(context),
          child: const Text('Sign Up'),
        ),
      ],
    );
  }

  Widget _rememberMeField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Transform.scale(
            scale: 1.2,
            child: Checkbox(
              value: _rememberMe,
              activeColor: const Color(0xFF6750A4),
              onChanged: (bool? value) {
                setState(() {
                  _rememberMe = value!;
                });
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                _rememberMe = !_rememberMe;
              });
            },
            child: Text(
              AppLocale.of(context)!.remember_me,
              style: const TextStyle(
                color: Color(0xFF1D1B20),
                fontSize: 16,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w400,
                height: 1.4,
                letterSpacing: 0.25,
              ),
            ),
          ),
        ],
      ),
    );
  }
}