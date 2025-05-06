import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:todo_task_umg/services/services_user.dart';

class RegistrerScreen extends StatefulWidget {
  const RegistrerScreen({super.key});

  @override
  State<RegistrerScreen> createState() => _RegistrerScreenState();
}

class _RegistrerScreenState extends State<RegistrerScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _keyForm = GlobalKey<FormState>();
  String? errorTextForm;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  Future<void> _registrerUser() async {
    try {
      final userService = Provider.of<ServicesUser>(context, listen: false);
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Dialog(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 20.0,
                children: [
                  CircularProgressIndicator(),
                  Text('Registrando usuario...'),
                ],
              ),
            ),
          );
        },
      );

      await Future.delayed(const Duration(seconds: 2));

      await userService.createUser(
        _emailController.text.trim(),
        _nameController.text.trim(),
        _passwordController.text.trim(),
      );
      print('Fallo con exito');
      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Usuario registrado con éxito.')),
        );

        context.go('/');
      }
    } catch (e) {
      print('Error: $e');

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al registrar usuario. Inténtalo de nuevo.'),
          ),
        );

        print('Error al registrar usuario: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _keyForm,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('images/logo.png', height: 300, width: 300),
                const Spacer(flex: 1),
                InputFormRegistrer(
                  nameController: _nameController,
                  errorTextForm: errorTextForm,
                  labelText: 'Nombre de Usuario',
                ),
                const Spacer(flex: 1),
                InputFormRegistrer(
                  nameController: _emailController,
                  errorTextForm: errorTextForm,
                  labelText: 'Correo Electrónico',
                  isEmail: true,
                ),
                const Spacer(flex: 1),
                InputFormRegistrer(
                  nameController: _passwordController,
                  errorTextForm: errorTextForm,
                  labelText: 'Contraseña',
                  isObscurePassword: true,
                ),
                const Spacer(flex: 3),
                ElevatedButton(
                  onPressed: () {
                    if (_keyForm.currentState!.validate()) {
                      _keyForm.currentState!.save();
                      _registrerUser();
                    }
                  },
                  child: const Text('REGISTRARSE'),
                ),
                const Spacer(flex: 3),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('¿Ya tienes una cuenta?'),
                    TextButton(
                      onPressed: () {
                        context.go('/login');
                      },
                      child: const Text('Iniciar Sesión'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class InputFormRegistrer extends StatelessWidget {
  const InputFormRegistrer({
    super.key,
    required TextEditingController nameController,
    required this.errorTextForm,
    required this.labelText,
    this.isObscurePassword = false,
    this.isEmail = false,
  }) : _nameController = nameController;

  final TextEditingController _nameController;
  final String? errorTextForm;
  final bool isObscurePassword;
  final String labelText;
  final bool isEmail;
  @override
  Widget build(BuildContext context) {
    print('presionado');
    if (isObscurePassword) {
      return Consumer<PasswordVisibilityProvider>(
        builder: (context, passwordProvider, _) {
          bool isObscure = !passwordProvider._isObscure;
          return TextFormField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: labelText,
              errorText: errorTextForm,
              suffixIcon: IconButton(
                icon: Icon(
                  !isObscure ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  passwordProvider.toggleVisibility();
                },
              ),
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Campo Requerido 😊';
              }
              return null;
            },
            obscureText: !isObscure,
            keyboardType: TextInputType.visiblePassword,
          );
        },
      );
    }
    return TextFormField(
      controller: _nameController,
      decoration: InputDecoration(
        labelText: labelText,
        errorText: errorTextForm,
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Campo Requerido 😊';
        }
        return null;
      },
      keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
      textInputAction: TextInputAction.done,
      onFieldSubmitted: (value) {
        FocusScope.of(context).unfocus();
      },
    );
  }
}

class PasswordVisibilityProvider with ChangeNotifier {
  bool _isObscure = true;

  bool get isObscure => _isObscure;

  void toggleVisibility() {
    _isObscure = !_isObscure;
    notifyListeners();
  }
}
