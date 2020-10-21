import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  Button(this._text, this._color, this._action);
  final Color _color;
  final Function _action;
  final String _text;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: _color,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: _action,
          minWidth: 200.0,
          height: 42.0,
          child: Text(
            _text,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
