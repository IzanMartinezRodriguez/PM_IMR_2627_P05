import 'package:flutter/material.dart';
import 'package:paisesgui/ui/screens/continentes_screen.dart';


// Pantalla inicial: formulario de login.
// Es un StatefulWidget porque necesitamos guardar en su estado la
// clave del formulario y los controladores de los campos de texto.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Credenciales correctas (las elegimos nosotros)
  static const String _usuarioCorrecto = "pepito@yahoo.com";
  static const String _passwordCorrecta = "1234";


  // Clave que identifica el Form y nos permite validarlo
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Controladores para leer (y escribir) el contenido de los TextFormField
  final TextEditingController _usuarioController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    // Liberamos los controladores cuando el widget se elimina del árbol
    _usuarioController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Validador del correo: no vacío y con formato de email
  String? _validaUsuario(String? valor) {
    if (valor == null || valor.trim().isEmpty) {
      return "No puede estar vacío";
    }
    final RegExp emailRegExp = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailRegExp.hasMatch(valor.trim())) {
      return "La dirección de correo no es válida";
    }
    return null; // null significa que el valor es válido
  }

  // Validador de la contraseña: no vacía
  String? _validaPassword(String? valor) {
    if (valor == null || valor.isEmpty) {
      return "No puede estar vacío";
    }
    return null;
  }

  void _iniciaSesion() {
    // Si algún validador devuelve error, se muestra bajo el campo y paramos
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_usuarioController.text.trim() == _usuarioCorrecto &&
        _passwordController.text == _passwordCorrecta) {
      // Credenciales correctas: entramos en la aplicación.
      // Usamos pushReplacement para que con el botón "atrás"
      // no se vuelva al formulario de login.
    Navigator.pushReplacement<void, void>(
    context,
    MaterialPageRoute<void>(
      builder: (BuildContext context) =>
         Scaffold(body: ContinentesScreen()),
    ),
  );
    } else {
      _muestraDialogoError();
    }
  }

  void _muestraDialogoError() {
    showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text("Error"),
          content: const Text("El usuario o la contraseña son incorrectas"),
          actions: [
            // Volver: cierra el diálogo y deja el formulario como estaba
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text("Volver"),
            ),
            // Rellenar usuario: cierra el diálogo y escribe los datos correctos
            TextButton(
              onPressed: () {
                _usuarioController.text = _usuarioCorrecto;
                _passwordController.text = _passwordCorrecta;
                Navigator.pop(dialogContext);
              },
              child: const Text("Rellenar usuario"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Card(
              margin: const EdgeInsets.all(16),
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Iniciar Sesión",
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 16),
                      // Campo del correo electrónico
                      TextFormField(
                        controller: _usuarioController,
                        keyboardType: TextInputType.emailAddress,
                        validator: _validaUsuario,
                        decoration: InputDecoration(
                          icon: const Icon(Icons.email),
                          labelText: "Correo electrónico",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Campo de la contraseña (oculta los caracteres)
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        validator: _validaPassword,
                        decoration: InputDecoration(
                          icon: const Icon(Icons.lock),
                          labelText: "Contraseña",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _iniciaSesion,
                        child: const Text("Iniciar sesión"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}