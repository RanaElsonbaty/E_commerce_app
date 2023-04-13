import 'package:ecommerce_app/layout/layout_cubit/layout_states.dart';
import 'package:ecommerce_app/shared/constants/constants.dart';
import 'package:ecommerce_app/shared/style/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../layout/layout_cubit/layout_cubit.dart';

class ChangePasswordScreen extends StatelessWidget {
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<LayoutCubit>(context);
    currentPasswordController.text = password!;
    return BlocConsumer<LayoutCubit,LayoutStates>(
        builder: (context,state){
          return Scaffold(
            appBar: AppBar(title: const Text("Change Password"),leading: const SizedBox(),
                foregroundColor: Colors.black,
                centerTitle: true,backgroundColor: thirdColor,elevation: 0),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 15),
              child: Form(
                key: formKey,
                child: Column(
                  children:
                  [
                    TextFormField(
                      controller: currentPasswordController,
                      validator: (input)
                      {
                        if( currentPasswordController.text == password )
                        {
                          return null;
                        }
                        else
                        {
                          return "Check your password, try again!";
                        }
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Current Password",
                      ),
                    ),
                    const SizedBox(height: 15,),
                    TextFormField(
                      controller: newPasswordController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "New Password",
                      ),
                    ),
                    const SizedBox(height: 15,),
                    MaterialButton(
                      onPressed: ()
                      {
                        if( formKey.currentState!.validate() )
                        {
                          cubit.changePassword(newPassword: newPasswordController.text);
                        }
                      },
                      color: mainColor,
                      textColor: Colors.white,
                      child: Text(state is ChangePasswordLoadingState ? "Loading" : "Submit"),
                    )
                  ],
                ),
              ),
            ),
          );
        },
        listener: (context,state)
        {
          if( state is ChangePasswordSuccessState ) Navigator.pop(context);
        }
    );
  }
}