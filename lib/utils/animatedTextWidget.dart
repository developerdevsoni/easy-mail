// import 'dart:nativewrappers/_internal/vm/lib/ffi_native_type_patch.dart';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

class TypingPromptField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: IgnorePointer(
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 4),
                child: AnimatedTextKit(
                  animatedTexts: [
                    TypewriterAnimatedText(
                      'Write your prompt to generate with AI...',
                      textStyle: const TextStyle(
                        fontSize: 16.0,
                        color: Colors.grey,
                      ),
                      speed: const Duration(milliseconds: 60),
                    ),
                  ],
                  repeatForever:true,
                  isRepeatingAnimation: true,
                  pause: const Duration(milliseconds: 1000),
                ),
              ),
            ),
          ),
          TextField(
            maxLines: 4,
            style: const TextStyle(color: Colors.black),
            decoration: const InputDecoration.collapsed(
              hintText: '',
            ),
          ),
        ],
      ),
    );
  }
}
