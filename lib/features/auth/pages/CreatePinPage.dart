import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';

class CreatePinPage extends StatefulWidget {
  final bool isRecovery;

  const CreatePinPage({super.key, required this.isRecovery});

  @override
  State<CreatePinPage> createState() => _CreatePinPageState();
}

class _CreatePinPageState extends State<CreatePinPage> {
  String pin = "";
  String confirmPin = "";

  Future<void> validatePin() async {
    if (pin == confirmPin && pin.length == 6) {
      // NOTE: save PIN via AuthController when ready
      AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        animType: AnimType.topSlide,
        title: "Correcto",
        desc: "Su PIN de 6 dígitos fue registrado exitosamente!",
        btnOkOnPress: () {
          context.pushReplacement("/login");
        },
        btnOkIcon: Icons.check_circle,
        btnOkColor: Colors.green,
      ).show();
    } else {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.leftSlide,
        title: 'Error',
        desc: 'Los PIN ingresados no coinciden o no tienen 6 dígitos.',
        btnOkOnPress: () {},
        btnOkColor: Colors.red,
      ).show();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 50),
                  SizedBox(
                    height: 150,
                    child: Image.asset(
                      'lib/assets/imagenes/logoTienda.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    "Crea un PIN de 6 dígitos para asegurar tu cuenta",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Pinput(
                    length: 6,
                    onChanged: (value) => pin = value,
                    obscureText: true,
                    defaultPinTheme: PinTheme(
                      width: 40,
                      height: 75,
                      textStyle: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                            color: const Color.fromARGB(255, 87, 31, 192)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Vuelve a ingresar el PIN para confirmar",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Pinput(
                    length: 6,
                    onChanged: (value) => confirmPin = value,
                    obscureText: true,
                    defaultPinTheme: PinTheme(
                      width: 40,
                      height: 75,
                      textStyle: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                            color: const Color.fromARGB(255, 87, 31, 192)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 35),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: validatePin,
                    child: const Text(
                      "Confirmar PIN",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
