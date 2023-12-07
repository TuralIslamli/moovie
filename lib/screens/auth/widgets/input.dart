import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomInput extends ConsumerWidget {
  final String hintText;
  final TextEditingController? controller;
  final bool autoFocus;
  final StateProvider<bool> hiddenPassword = StateProvider<bool>((ref) => true);

  CustomInput({
    this.hintText = "",
    this.autoFocus = false,
    required this.controller,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextFormField(
      controller: controller,
      autofocus: autoFocus,
      obscureText: hintText == "Password" ? ref.watch(hiddenPassword) : false,
      maxLines: hintText == "About Yourself" ? 5 : 1,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: hintText == "Search"
            ? TextStyle(
                color: Colors.grey.shade300,
              )
            : const TextStyle(),
        filled: true,
        fillColor: Colors.grey.shade300,
        prefixIcon: hintText == "Email"
            ? const Icon(Icons.email)
            : hintText == "About Yourself"
                ? const Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 98),
                    child: Icon(Icons.description),
                  )
                : hintText.toLowerCase().contains("password")
                    ? const Icon(Icons.lock)
                    : hintText == "Name"
                        ? const Icon(Icons.person)
                        : const Icon(
                            Icons.search,
                          ),
        suffixIcon: hintText.toLowerCase().contains("password")
            ? IconButton(
                onPressed: () {
                  ref.read(hiddenPassword.notifier).update((state) => !state);
                },
                icon: ref.watch(hiddenPassword)
                    ? const Icon(Icons.visibility)
                    : const Icon(Icons.visibility_off),
              )
            : null,
        enabledBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: Colors.grey.shade400, style: BorderStyle.solid),
          borderRadius: BorderRadius.circular(5.r),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: Colors.grey.shade700, style: BorderStyle.solid),
          borderRadius: BorderRadius.circular(5.r),
        ),
        border: OutlineInputBorder(
          borderSide:
              const BorderSide(color: Colors.red, style: BorderStyle.solid),
          borderRadius: BorderRadius.circular(5.r),
        ),
        errorBorder: OutlineInputBorder(
          borderSide:
              const BorderSide(color: Colors.red, style: BorderStyle.solid),
          borderRadius: BorderRadius.circular(5.r),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide:
              const BorderSide(color: Colors.red, style: BorderStyle.solid),
          borderRadius: BorderRadius.circular(5.r),
        ),
      ),
    );
  }
}
