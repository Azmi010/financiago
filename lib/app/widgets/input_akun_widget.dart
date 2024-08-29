import 'package:flutter/material.dart';

class InputAkunWidget extends StatefulWidget {
  final TextEditingController controller;
  final String nama;
  final String hintText;
  final IconData leadingIcon;
  final bool isPassword;
  final TextInputType keyboardType;
  final bool readOnly;
  final VoidCallback? onTap;

  const InputAkunWidget({
    Key? key,
    required this.controller,
    required this.nama,
    required this.hintText,
    required this.leadingIcon,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.readOnly = false,
    this.onTap,
  }) : super(key: key);

  @override
  _InputAkunWidgetState createState() => _InputAkunWidgetState();
}

class _InputAkunWidgetState extends State<InputAkunWidget> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    var lebar = MediaQuery.of(context).size.width * 0.1;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: lebar),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.nama,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextField(
              controller: widget.controller,
              obscureText: widget.isPassword ? _obscureText : false,
              keyboardType: widget.keyboardType,
              readOnly: widget.readOnly,
              onTap: widget.onTap,
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: TextStyle(color: Colors.grey[400]),
                prefixIcon: Icon(widget.leadingIcon, color: Colors.grey[600]),
                suffixIcon: widget.isPassword
                    ? IconButton(
                        icon: Icon(
                          _obscureText ? Icons.visibility_off : Icons.visibility,
                          color: Colors.grey[600],
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
