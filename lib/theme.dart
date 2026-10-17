import 'package:flutter/material.dart';

/// Palet warna ReuseMart yang dipakai bersama oleh seluruh layar.
/// Selaras dengan tema teal/hijau pada versi web.
class ReuseColors {
  ReuseColors._();

  static const Color primary = Color(0xFF1E5B5A);
  static const Color primaryDark = Color(0xFF143F3E);
  static const Color primarySoft = Color(0xFFDFF0EE);
  static const Color accent = Color(0xFFF2994A);
  static const Color accentSoft = Color(0xFFFDEEDD);
  static const Color ink = Color(0xFF1C2B29);
  static const Color muted = Color(0xFF5C6E6A);
  static const Color line = Color(0xFFDFE9E7);
  static const Color background = Color(0xFFF1F7F6);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color success = Color(0xFF186B4A);
  static const Color danger = Color(0xFFC0392B);

  static const double radius = 16;
  static const double radiusSmall = 12;
  static const double radiusPill = 999;

  static const BorderRadius border =
      BorderRadius.all(Radius.circular(radius));
  static const BorderRadius borderSmall =
      BorderRadius.all(Radius.circular(radiusSmall));
  static const BorderRadius borderPill =
      BorderRadius.all(Radius.circular(radiusPill));
  static const BorderRadius borderTop =
      BorderRadius.vertical(top: Radius.circular(radius));
  static const BorderRadius borderBottom =
      BorderRadius.vertical(bottom: Radius.circular(radius));

  /// Satu-satunya gradient dekoratif, dipakai tipis di halaman pembuka.
  static const LinearGradient softGradient = LinearGradient(
    colors: [primarySoft, background, background],
    stops: [0.0, 0.45, 1.0],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  /// Bayangan halus untuk kartu, tanpa efek berlebihan.
  static const List<BoxShadow> cardShadow = [
    BoxShadow(color: Color(0x14143F3E), blurRadius: 16, offset: Offset(0, 6)),
  ];

  static const List<BoxShadow> softShadow = [
    BoxShadow(color: Color(0x0D143F3E), blurRadius: 8, offset: Offset(0, 3)),
  ];
}

/// Tipografi bersama supaya ukuran dan warna teks konsisten antar layar.
class ReuseText {
  ReuseText._();

  static const TextStyle display = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.w700,
    color: ReuseColors.primary,
    letterSpacing: 0.4,
  );

  static const TextStyle title = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: ReuseColors.ink,
  );

  static const TextStyle section = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: ReuseColors.primary,
    letterSpacing: 0.3,
  );

  static const TextStyle cardTitle = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w700,
    color: ReuseColors.ink,
  );

  static const TextStyle body = TextStyle(
    fontSize: 14,
    color: ReuseColors.ink,
    height: 1.4,
  );

  static const TextStyle label = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: ReuseColors.muted,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 12,
    color: ReuseColors.muted,
  );

  static const TextStyle price = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: ReuseColors.primary,
  );

  static const TextStyle slogan = TextStyle(
    fontSize: 15,
    color: ReuseColors.muted,
    fontStyle: FontStyle.italic,
    height: 1.5,
  );

  static const TextStyle button = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.2,
  );
}

/// Helper style yang dipakai ulang: tombol, bidang isian, dan dekorasi kartu.
class ReuseStyles {
  ReuseStyles._();

  static final ButtonStyle primaryButton = ElevatedButton.styleFrom(
    backgroundColor: ReuseColors.primary,
    foregroundColor: ReuseColors.surface,
    disabledBackgroundColor: ReuseColors.line,
    disabledForegroundColor: ReuseColors.muted,
    elevation: 0,
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
    textStyle: ReuseText.button,
    shape: const RoundedRectangleBorder(borderRadius: ReuseColors.border),
  );

  static final ButtonStyle accentButton = ElevatedButton.styleFrom(
    backgroundColor: ReuseColors.accent,
    foregroundColor: ReuseColors.ink,
    elevation: 0,
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
    textStyle: ReuseText.button,
    shape: const RoundedRectangleBorder(borderRadius: ReuseColors.border),
  );

  static final ButtonStyle dangerButton = ElevatedButton.styleFrom(
    backgroundColor: ReuseColors.danger,
    foregroundColor: ReuseColors.surface,
    elevation: 0,
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
    textStyle: ReuseText.button,
    shape: const RoundedRectangleBorder(borderRadius: ReuseColors.border),
  );

  static final ButtonStyle outlineButton = OutlinedButton.styleFrom(
    foregroundColor: ReuseColors.primary,
    side: const BorderSide(color: ReuseColors.line),
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    textStyle: ReuseText.button,
    shape: const RoundedRectangleBorder(borderRadius: ReuseColors.border),
  );

  /// Tombol pilihan (filter) dengan status aktif/non aktif.
  static ButtonStyle filterButton({required bool selected}) =>
      OutlinedButton.styleFrom(
        backgroundColor: selected ? ReuseColors.primary : ReuseColors.surface,
        foregroundColor: selected ? ReuseColors.surface : ReuseColors.primary,
        side: BorderSide(
          color: selected ? ReuseColors.primary : ReuseColors.line,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        shape: const RoundedRectangleBorder(
          borderRadius: ReuseColors.borderPill,
        ),
      );

  static InputDecoration field({
    String? hintText,
    String? labelText,
    Widget? prefixIcon,
    String? errorText,
    EdgeInsetsGeometry contentPadding =
        const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
  }) =>
      InputDecoration(
        hintText: hintText,
        labelText: labelText,
        prefixIcon: prefixIcon,
        errorText: errorText,
        filled: true,
        fillColor: ReuseColors.surface,
        hintStyle: ReuseText.label,
        labelStyle: ReuseText.label,
        errorStyle: const TextStyle(color: ReuseColors.danger, fontSize: 12),
        contentPadding: contentPadding,
        enabledBorder: const OutlineInputBorder(
          borderRadius: ReuseColors.borderSmall,
          borderSide: BorderSide(color: ReuseColors.line),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: ReuseColors.borderSmall,
          borderSide: BorderSide(color: ReuseColors.primary, width: 1.6),
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: ReuseColors.borderSmall,
          borderSide: BorderSide(color: ReuseColors.danger),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderRadius: ReuseColors.borderSmall,
          borderSide: BorderSide(color: ReuseColors.danger, width: 1.6),
        ),
      );

  static BoxDecoration card({
    Color color = ReuseColors.surface,
    double radius = ReuseColors.radius,
    bool bordered = true,
    bool shadowed = true,
  }) =>
      BoxDecoration(
        color: color,
        borderRadius: BorderRadius.all(Radius.circular(radius)),
        border: bordered ? Border.all(color: ReuseColors.line) : null,
        boxShadow: shadowed ? ReuseColors.cardShadow : null,
      );

  /// Chip kecil untuk highlight (mis. bonus atau poin).
  static BoxDecoration chip({Color color = ReuseColors.accentSoft}) =>
      BoxDecoration(
        color: color,
        borderRadius: ReuseColors.borderPill,
      );
}

/// Kartu dasar dengan border halus, radius konsisten, dan bayangan tipis.
class ReuseCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final Color color;
  final bool bordered;
  final VoidCallback? onTap;

  const ReuseCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(14),
    this.margin,
    this.color = ReuseColors.surface,
    this.bordered = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final content = Padding(padding: padding, child: child);
    return Container(
      margin: margin,
      decoration: ReuseStyles.card(color: color, bordered: bordered),
      clipBehavior: onTap == null ? Clip.none : Clip.antiAlias,
      child: Material(
        type: MaterialType.transparency,
        child: onTap == null
            ? content
            : InkWell(
                onTap: onTap,
                borderRadius: ReuseColors.border,
                child: content,
              ),
      ),
    );
  }
}
