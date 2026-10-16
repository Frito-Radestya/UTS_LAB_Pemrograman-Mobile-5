import 'package:flutter/material.dart';

import '../state/app_scope.dart';
import '../theme/app_theme.dart';
import '../widgets/bolt_widgets.dart';
import '../widgets/player_name_dialog.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirmation = TextEditingController();
  bool _register = false;
  bool _obscure = true;
  bool _obscureConfirmation = true;
  bool _accepted = false;
  bool _busy = false;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _confirmation.dispose();
    super.dispose();
  }

  void _switchMode() {
    _formKey.currentState?.reset();
    setState(() {
      _register = !_register;
      _accepted = false;
    });
  }

  void _information({bool privacy = false}) => showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(privacy ? 'Privasi & penggunaan' : 'Tentang akun lokal'),
      content: Text(
        privacy
            ? 'BoltQuiz adalah aplikasi pembelajaran lokal. Nama, email, jawaban, dan hasil kuis disimpan di perangkat ini menggunakan penyimpanan preferensi, bukan penyimpanan terenkripsi. Tidak ada data yang dikirim ke server. Keluar akun akan menghapus sesi dan riwayat. Jangan gunakan kata sandi akun asli.'
            : 'Ini adalah demo akun lokal, bukan autentikasi server. Nama dan email digunakan untuk identitas skor. Kata sandi hanya divalidasi pada formulir dan tidak disimpan atau diverifikasi. Google Sign-In dan pemulihan kata sandi belum dihubungkan ke layanan akun.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Mengerti'),
        ),
      ],
    ),
  );

  Future<void> _submit() async {
    if (_busy || !_formKey.currentState!.validate()) return;
    if (_register && !_accepted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Setujui kebijakan penggunaan terlebih dahulu.'),
        ),
      );
      return;
    }
    final state = AppScope.of(context);
    setState(() => _busy = true);
    try {
      await state.signIn(_name.text, _email.text);
      if (!mounted) return;
      Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profil belum dapat disimpan. Silakan coba lagi.'),
        ),
      );
      setState(() => _busy = false);
    }
  }

  Future<void> _guest() async {
    if (_busy) return;
    final name = await showDialog<String>(
      context: context,
      builder: (_) => PlayerNameDialog(initialName: _name.text),
    );
    if (!mounted || name == null) return;
    final state = AppScope.of(context);
    setState(() => _busy = true);
    try {
      await state.signIn(name, 'tamu@boltquiz.local');
      if (!mounted) return;
      Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
    } catch (_) {
      if (!mounted) return;
      setState(() => _busy = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profil tamu belum dapat disimpan. Coba lagi.'),
        ),
      );
    }
  }

  Widget _label(String label) => Padding(
    padding: EdgeInsets.only(bottom: context.space * .5),
    child: Text(
      label,
      style: context.text.labelMedium?.copyWith(fontWeight: FontWeight.w800),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final space = context.space;
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, viewport) => SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: space * 1.25,
              vertical: space,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: 440,
                  minHeight: (viewport.maxHeight - space * 2).clamp(
                    0,
                    double.infinity,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        if (_register)
                          IconButton(
                            onPressed: _busy ? null : _switchMode,
                            tooltip: 'Kembali ke masuk',
                            icon: const Icon(Icons.arrow_back_rounded),
                          )
                        else
                          const BoltLogo(compact: true),
                        const Spacer(),
                        TextButton.icon(
                          onPressed: () async {
                            try {
                              await state.setDarkMode(!state.isDarkMode);
                            } catch (_) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Tema belum tersimpan.'),
                                  ),
                                );
                              }
                            }
                          },
                          icon: Icon(
                            state.isDarkMode
                                ? Icons.light_mode_rounded
                                : Icons.dark_mode_rounded,
                            size: 16,
                          ),
                          label: Text(
                            state.isDarkMode ? 'LIGHT MODE' : 'DARK MODE',
                            style: context.text.labelSmall,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: space * 1.5),
                    if (!_register) ...[
                      Container(
                        padding: EdgeInsets.symmetric(
                          vertical: space * 1.8,
                          horizontal: space,
                        ),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0xFFFFE43B),
                              AppColors.yellow,
                              Color(0xFFEAC700),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(space * 1.5),
                        ),
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.all(space * .65),
                              decoration: const BoxDecoration(
                                color: Color(0xFF111211),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.bolt_rounded,
                                size: space * 2.25,
                                color: AppColors.yellow,
                              ),
                            ),
                            SizedBox(height: space * .6),
                            Text(
                              'BoltQuiz',
                              style: context.text.headlineSmall?.copyWith(
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              'ARENA KUIS CEPAT',
                              style: context.text.labelSmall?.copyWith(
                                color: Colors.black87,
                                letterSpacing: 2,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: space * 1.7),
                    ] else ...[
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: BoltLogo(),
                      ),
                      SizedBox(height: space * 1.5),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: StatusPill(
                          label: 'PENDAFTARAN CEPAT',
                          icon: Icons.bolt_rounded,
                        ),
                      ),
                      SizedBox(height: space),
                    ],
                    Text(
                      _register ? 'Buat Akun Baru' : 'Selamat Datang Kembali',
                      style: context.text.headlineSmall,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      _register
                          ? 'Mulai perjalanan kuis kilatmu sekarang.'
                          : 'Masuk untuk melanjutkan kuismu.',
                      style: context.text.bodyMedium?.copyWith(
                        color: context.colors.onSurfaceVariant,
                      ),
                    ),
                    SizedBox(height: space * 1.5),
                    Form(
                      key: _formKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _label('Nama Lengkap'),
                          TextFormField(
                            key: const ValueKey('name-field'),
                            controller: _name,
                            maxLength: 40,
                            buildCounter: (
                              _, {
                              required currentLength,
                              required isFocused,
                              required maxLength,
                            }) => null,
                            textCapitalization: TextCapitalization.words,
                            textInputAction: TextInputAction.next,
                            autofillHints: const [AutofillHints.name],
                            decoration: const InputDecoration(
                              hintText: 'cth. Rizky Ramadhan',
                              prefixIcon: Icon(Icons.person_outline_rounded),
                            ),
                            validator: (v) => (v ?? '').trim().isEmpty
                                ? 'Nama wajib diisi untuk hasil kuis.'
                                : null,
                          ),
                          SizedBox(height: space),
                          _label('Email'),
                          TextFormField(
                            key: const ValueKey('email-field'),
                            controller: _email,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            autofillHints: const [AutofillHints.email],
                            decoration: const InputDecoration(
                              hintText: 'nama@email.com',
                              prefixIcon: Icon(Icons.mail_outline_rounded),
                            ),
                            validator: (v) =>
                                RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$')
                                    .hasMatch((v ?? '').trim())
                                ? null
                                : 'Masukkan alamat email yang valid.',
                          ),
                          SizedBox(height: space),
                          Row(
                            children: [
                              Expanded(child: _label('Kata Sandi')),
                              if (!_register)
                                TextButton(
                                  onPressed: _information,
                                  child: const Text(
                                    'Lupa Password?',
                                    style: TextStyle(fontSize: 11),
                                  ),
                                ),
                            ],
                          ),
                          TextFormField(
                            key: const ValueKey('password-field'),
                            controller: _password,
                            obscureText: _obscure,
                            textInputAction: _register
                                ? TextInputAction.next
                                : TextInputAction.done,
                            onFieldSubmitted: (_) {
                              if (!_register) _submit();
                            },
                            decoration: InputDecoration(
                              hintText: 'Minimal 8 karakter · demo lokal',
                              prefixIcon: const Icon(
                                Icons.lock_outline_rounded,
                              ),
                              suffixIcon: IconButton(
                                tooltip: _obscure
                                    ? 'Tampilkan kata sandi'
                                    : 'Sembunyikan kata sandi',
                                onPressed: () =>
                                    setState(() => _obscure = !_obscure),
                                icon: Icon(
                                  _obscure
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  size: 20,
                                ),
                              ),
                            ),
                            validator: (v) => (v ?? '').length < 8
                                ? 'Gunakan minimal 8 karakter, bukan sandi asli.'
                                : null,
                            onChanged: (_) => setState(() {}),
                          ),
                          if (_register) ...[
                            SizedBox(height: space * .65),
                            Row(
                              children: List.generate(
                                4,
                                (i) => Expanded(
                                  child: Container(
                                    margin: EdgeInsets.only(
                                      right: i == 3 ? 0 : 5,
                                    ),
                                    height: 4,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color:
                                          _password.text.length >= (i + 1) * 3
                                          ? context.colors.primary
                                          : context.colors.outlineVariant,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: space),
                            _label('Konfirmasi Kata Sandi'),
                            TextFormField(
                              controller: _confirmation,
                              obscureText: _obscureConfirmation,
                              textInputAction: TextInputAction.done,
                              onFieldSubmitted: (_) => _submit(),
                              decoration: InputDecoration(
                                hintText: 'Ulangi kata sandi',
                                prefixIcon: const Icon(
                                  Icons.lock_reset_rounded,
                                ),
                                suffixIcon: IconButton(
                                  tooltip: 'Tampilkan/sembunyikan konfirmasi',
                                  onPressed: () => setState(
                                    () => _obscureConfirmation =
                                        !_obscureConfirmation,
                                  ),
                                  icon: Icon(
                                    _obscureConfirmation
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                    size: 20,
                                  ),
                                ),
                              ),
                              validator: (v) => v != _password.text
                                  ? 'Konfirmasi kata sandi tidak cocok.'
                                  : null,
                            ),
                            SizedBox(height: space * .5),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Checkbox(
                                  value: _accepted,
                                  onChanged: (v) =>
                                      setState(() => _accepted = v ?? false),
                                ),
                                Expanded(
                                  child: TextButton(
                                    onPressed: () =>
                                        _information(privacy: true),
                                    child: const Text(
                                      'Saya setuju dengan syarat penggunaan & kebijakan privasi BoltQuiz.',
                                      style: TextStyle(fontSize: 11),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                          SizedBox(height: space * 1.4),
                          BoltButton(
                            label: _busy
                                ? 'Menyiapkan profil…'
                                : _register
                                ? 'Daftar Akun'
                                : 'Masuk',
                            icon: Icons.arrow_forward_rounded,
                            onPressed: _busy ? null : _submit,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: space),
                    Row(
                      children: [
                        const Expanded(child: Divider()),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: space),
                          child: Text(
                            'ATAU',
                            style: context.text.labelSmall?.copyWith(
                              color: context.colors.onSurfaceVariant,
                            ),
                          ),
                        ),
                        const Expanded(child: Divider()),
                      ],
                    ),
                    SizedBox(height: space),
                    BoltButton(
                      label: 'Coba sebagai tamu',
                      icon: Icons.person_outline_rounded,
                      secondary: true,
                      onPressed: _busy ? null : _guest,
                    ),
                    SizedBox(height: space),
                    Wrap(
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          _register ? 'Sudah punya akun?' : 'Belum punya akun?',
                          style: context.text.bodySmall,
                        ),
                        TextButton(
                          onPressed: _busy ? null : _switchMode,
                          child: Text(
                            _register ? 'Masuk' : 'Daftar',
                            style: const TextStyle(fontWeight: FontWeight.w800),
                          ),
                        ),
                      ],
                    ),
                    TextButton(
                      onPressed: _information,
                      child: Text(
                        'Demo lokal • tanpa server • jangan gunakan sandi asli',
                        style: context.text.labelSmall?.copyWith(
                          color: context.colors.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
