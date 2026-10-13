import "package:flutter/gestures.dart";
import "package:flutter/material.dart";
import "package:flutter_svg/flutter_svg.dart";

class PhoneVerificationLoginPage extends StatefulWidget {
  const PhoneVerificationLoginPage({
    super.key,
    this.onRequestCode,
    this.onLogin,
    this.onUserAgreement,
    this.onPrivacyPolicy,
    this.shieldAssetPath = "assets/images/shield-check.svg",
  });

  final VoidCallback? onRequestCode;
  final void Function(String phone, String code)? onLogin;
  final VoidCallback? onUserAgreement;
  final VoidCallback? onPrivacyPolicy;
  final String shieldAssetPath;

  @override
  State<PhoneVerificationLoginPage> createState() =>
      _PhoneVerificationLoginPageState();
}

class _PhoneVerificationLoginPageState
    extends State<PhoneVerificationLoginPage> {
  static const _ink = Color(0xFF342E36);
  static const _muted = Color(0xFF746775);
  static const _placeholder = Color(0xFF998999);
  static const _accent = Color(0xFF79536E);

  final _phoneController = TextEditingController();
  final _codeController = TextEditingController();
  late final TapGestureRecognizer _userAgreementRecognizer;
  late final TapGestureRecognizer _privacyPolicyRecognizer;

  @override
  void initState() {
    super.initState();
    _userAgreementRecognizer = TapGestureRecognizer()
      ..onTap = () => widget.onUserAgreement?.call();
    _privacyPolicyRecognizer = TapGestureRecognizer()
      ..onTap = () => widget.onPrivacyPolicy?.call();
  }

  @override
  void didUpdateWidget(covariant PhoneVerificationLoginPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    _userAgreementRecognizer.onTap = () => widget.onUserAgreement?.call();
    _privacyPolicyRecognizer.onTap = () => widget.onPrivacyPolicy?.call();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _codeController.dispose();
    _userAgreementRecognizer.dispose();
    _privacyPolicyRecognizer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        fit: StackFit.expand,
        children: [
          const CustomPaint(painter: _LoginBackgroundPainter()),
          SafeArea(
            bottom: false,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(
                                28,
                                56,
                                28,
                                0,
                              ),
                              child: Center(
                                child: ConstrainedBox(
                                  constraints:
                                      const BoxConstraints(maxWidth: 520),
                                  child: _buildLoginForm(),
                                ),
                              ),
                            ),
                          ),
                          _buildSecurityNotice(),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginForm() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildFieldGroup(
          label: "手机号",
          child: Row(
            children: [
              const Text(
                "+86",
                style: TextStyle(
                  color: _ink,
                  fontFamily: "Inter",
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Container(
                width: 1,
                height: 18,
                margin: const EdgeInsets.symmetric(horizontal: 12),
                color: const Color.fromRGBO(168, 139, 159, 0.25),
              ),
              Expanded(
                child: TextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  style: const TextStyle(
                    color: _ink,
                    fontFamily: "Arial",
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                  decoration: _inputDecoration("请输入手机号"),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _buildFieldGroup(
          label: "验证码",
          horizontalPadding: const EdgeInsets.only(left: 16, right: 8),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _codeController,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  style: const TextStyle(
                    color: _ink,
                    fontFamily: "Arial",
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                  decoration: _inputDecoration("请输入验证码"),
                  onSubmitted: (_) => _submit(),
                ),
              ),
              SizedBox(
                height: 40,
                child: TextButton(
                  onPressed: widget.onRequestCode,
                  style: TextButton.styleFrom(
                    foregroundColor: _accent,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    textStyle: const TextStyle(
                      fontFamily: "Arial",
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  child: const Text("获取验证码"),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          height: 54,
          child: FilledButton(
            onPressed: _submit,
            style: FilledButton.styleFrom(
              backgroundColor: _accent,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              textStyle: const TextStyle(
                fontFamily: "Arial",
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            child: const Text("登录"),
          ),
        ),
        const SizedBox(height: 16),
        Text.rich(
          TextSpan(
            style: const TextStyle(
              color: _muted,
              fontFamily: "Arial",
              fontSize: 11,
              fontWeight: FontWeight.w400,
              height: 1.8,
            ),
            children: [
              const TextSpan(text: "登录即表示你已阅读并同意"),
              TextSpan(
                text: "《用户协议》",
                style: const TextStyle(color: _accent),
                recognizer: _userAgreementRecognizer,
              ),
              const TextSpan(text: "与"),
              TextSpan(
                text: "《隐私政策》",
                style: const TextStyle(color: _accent),
                recognizer: _privacyPolicyRecognizer,
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildFieldGroup({
    required String label,
    required Widget child,
    EdgeInsetsGeometry horizontalPadding =
        const EdgeInsets.symmetric(horizontal: 16),
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: _muted,
            fontFamily: "Arial",
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          height: 56,
          padding: horizontalPadding,
          decoration: BoxDecoration(
            color: const Color.fromRGBO(255, 255, 255, 0.5),
            border: Border.all(
              color: const Color.fromRGBO(255, 255, 255, 0.65),
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: child,
        ),
      ],
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      isCollapsed: true,
      border: InputBorder.none,
      hintText: hint,
      hintStyle: const TextStyle(
        color: _placeholder,
        fontFamily: "Arial",
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  Widget _buildSecurityNotice() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 64, 24, 48),
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                widget.shieldAssetPath,
                width: 14,
                height: 14,
              ),
              const SizedBox(width: 6),
              const Text(
                "安全验证，安心进入校园管理",
                style: TextStyle(
                  color: _muted,
                  fontFamily: "Arial",
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            "手机号仅用于身份验证与账号登录",
            style: TextStyle(
              color: _placeholder,
              fontFamily: "Arial",
              fontSize: 11,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  void _submit() {
    widget.onLogin?.call(
      _phoneController.text.trim(),
      _codeController.text.trim(),
    );
  }
}

class _LoginBackgroundPainter extends CustomPainter {
  const _LoginBackgroundPainter();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = const Color(0xFFFCF7F8),
    );

    final width = size.width;
    final verticalScale = size.height / width;
    canvas.save();
    canvas.scale(1, verticalScale);

    final square = Rect.fromLTWH(0, 0, width, width);
    final shader = const RadialGradient(
      colors: [
        Color(0xFFF8D7E1),
        Color(0xFFF7E1E8),
        Color(0xFFFAECEA),
        Color(0xFFFCF7F8),
      ],
      stops: [0, 0.4, 0.7, 1],
      radius: 0.6,
      tileMode: TileMode.clamp,
    ).createShader(square);

    canvas.drawRect(square, Paint()..shader = shader);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
