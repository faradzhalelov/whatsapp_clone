import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsup/colors.dart';
import 'package:whatsup/common/widgets/custom_button.dart';
import 'package:whatsup/features/auth/controller/auth_controller.dart';

class LoginScreen extends ConsumerStatefulWidget {
  static const String routeName = '/login-screen';
  const LoginScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _phoneController = TextEditingController();
  final _snackBar = SnackBar(
    content: const Text(
        'Fill out all the fields',
      style: TextStyle(color: Colors.black),
    ),
    action: SnackBarAction(
      label: 'OK',
      onPressed: () {},
    ),);
  Country? country;

  @override
  void dispose() {
    super.dispose();
    _phoneController.dispose();
  }

  void pickCountry() {
    showCountryPicker(context: context, onSelect: (Country country) {
      setState(() {
        this.country = country;
      });
    });
  }

  void sendPhoneNumber() {
    String phoneNumber = _phoneController.text.trim();
    if (country != null && phoneNumber.isNotEmpty) {
      ref
          .read(authControllerProvider)
          .signInWithPhone(context, '+${country!.phoneCode}$phoneNumber');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(_snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter your phone number'),
        elevation: 0,
        backgroundColor: backgroundColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const Text('WhatsApp will need to verify your phone number'),
              const SizedBox(height: 10,),
              TextButton(
                  onPressed: pickCountry,
                  child: const Text('Pick country')),
              const SizedBox(height: 10,),
              Row(
                children: [
                  if (country != null)
                    Text('+${country!.phoneCode}'),
                  const SizedBox(width: 10,),
                  SizedBox(
                    width: size.width * 0.7,
                    child: TextField(
                      controller: _phoneController,
                      decoration: const InputDecoration(
                        hintText: 'phone number',
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: size.height * 0.6,),
              SizedBox(
                width: size.width * 0.75,
                child: CustomButton(
                  onPressed: sendPhoneNumber,
                  text: 'NEXT',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
