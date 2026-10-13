# 手机验证码登录页

将 `phone_verification_login_page.dart` 和 `assets/images/shield-check.svg`
复制到 Flutter 工程中，并在 `pubspec.yaml` 添加：

```yaml
dependencies:
  flutter_svg: ^2.0.0

flutter:
  assets:
    - assets/images/shield-check.svg
```

页面使用 Figma 中的 `Inter` 与 `Arial` 字体名称。若宿主应用打包了对应字体，
请在 `pubspec.yaml` 中沿用这两个 family 名称；未打包时 Flutter 会使用平台回退字体。

```dart
MaterialApp(
  home: PhoneVerificationLoginPage(
    onRequestCode: () {},
    onLogin: (phone, code) {},
    onUserAgreement: () {},
    onPrivacyPolicy: () {},
  ),
);
```
