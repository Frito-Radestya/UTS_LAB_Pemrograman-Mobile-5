import 'package:flutter/material.dart';

/// Owns the controller for the full dialog lifetime, including route dismissal.
class PlayerNameDialog extends StatefulWidget {
  const PlayerNameDialog({super.key, this.initialName = ''});
  final String initialName;

  @override
  State<PlayerNameDialog> createState() => _PlayerNameDialogState();
}

class _PlayerNameDialogState extends State<PlayerNameDialog> {
  final _form = GlobalKey<FormState>();
  late final _controller = TextEditingController(text: widget.initialName);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    if (_form.currentState!.validate()) {
      Navigator.pop(context, _controller.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('Siapa nama kamu?'),
    content: Form(
      key: _form,
      child: TextFormField(
        key: const ValueKey('guest-name-field'),
        controller: _controller,
        autofocus: true,
        maxLength: 40,
        textCapitalization: TextCapitalization.words,
        textInputAction: TextInputAction.done,
        onFieldSubmitted: (_) => _submit(),
        decoration: const InputDecoration(hintText: 'Nama untuk papan hasil'),
        validator: (value) =>
            (value ?? '').trim().isEmpty ? 'Masukkan nama kamu' : null,
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Batal'),
      ),
      FilledButton(onPressed: _submit, child: const Text('Mulai belajar')),
    ],
  );
}
