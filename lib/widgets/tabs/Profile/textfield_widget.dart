import 'package:flutter/material.dart';

class TextFieldWidget extends StatefulWidget {
  final String label;
  final String text;
  final ValueChanged<String> onChanged;

  const TextFieldWidget({
    Key? key,
    required this.label,
    required this.text,
    required this.onChanged,
  }) : super(key: key);

  @override
  _TextFieldWidgetState createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  late final TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.text);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            validator: (value) {
              if (widget.label == 'Full Name') {
                if (value!.isEmpty || value.length < 4) {
                  return 'Please enter atleast 4 characters.';
                }
              }
              return null;
            },
            style: const TextStyle(fontSize: 15),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onChanged: widget.onChanged,
            maxLines: null,
          ),
        ],
      );
}
