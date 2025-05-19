/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart' as _svg;
import 'package:vector_graphics/vector_graphics.dart' as _vg;

class $AssetsFontsGen {
  const $AssetsFontsGen();

  /// File path: assets/fonts/google_sans_bold.otf
  String get googleSansBold => 'assets/fonts/google_sans_bold.otf';

  /// File path: assets/fonts/google_sans_bolditalic.otf
  String get googleSansBolditalic => 'assets/fonts/google_sans_bolditalic.otf';

  /// File path: assets/fonts/google_sans_italic.otf
  String get googleSansItalic => 'assets/fonts/google_sans_italic.otf';

  /// File path: assets/fonts/google_sans_medium.otf
  String get googleSansMedium => 'assets/fonts/google_sans_medium.otf';

  /// File path: assets/fonts/google_sans_mediumitalic.otf
  String get googleSansMediumitalic => 'assets/fonts/google_sans_mediumitalic.otf';

  /// File path: assets/fonts/google_sans_regular.otf
  String get googleSansRegular => 'assets/fonts/google_sans_regular.otf';

  /// List of all assets
  List<String> get values => [googleSansBold, googleSansBolditalic, googleSansItalic, googleSansMedium, googleSansMediumitalic, googleSansRegular];
}

class $AssetsIconsGen {
  const $AssetsIconsGen();

  /// File path: assets/icons/app_icon.png
  AssetGenImage get appIcon => const AssetGenImage('assets/icons/app_icon.png');

  /// File path: assets/icons/ic_card.svg
  SvgGenImage get icCard => const SvgGenImage('assets/icons/ic_card.svg');

  /// File path: assets/icons/ic_logo_gtel.svg
  SvgGenImage get icLogoGtel => const SvgGenImage('assets/icons/ic_logo_gtel.svg');

  /// File path: assets/icons/ic_nfc.svg
  SvgGenImage get icNfc => const SvgGenImage('assets/icons/ic_nfc.svg');

  /// File path: assets/icons/ic_note.svg
  SvgGenImage get icNote => const SvgGenImage('assets/icons/ic_note.svg');

  /// File path: assets/icons/ic_ocr.svg
  SvgGenImage get icOcr => const SvgGenImage('assets/icons/ic_ocr.svg');

  /// File path: assets/icons/ic_peoplescan.svg
  SvgGenImage get icPeoplescan => const SvgGenImage('assets/icons/ic_peoplescan.svg');

  /// File path: assets/icons/ic_productscan.svg
  SvgGenImage get icProductscan => const SvgGenImage('assets/icons/ic_productscan.svg');

  /// File path: assets/icons/image_frame.png
  AssetGenImage get imageFrame => const AssetGenImage('assets/icons/image_frame.png');

  /// File path: assets/icons/img_otp.svg
  SvgGenImage get imgOtp => const SvgGenImage('assets/icons/img_otp.svg');

  /// File path: assets/icons/img_splash_eid.svg
  SvgGenImage get imgSplashEid => const SvgGenImage('assets/icons/img_splash_eid.svg');

  /// List of all assets
  List<dynamic> get values => [appIcon, icCard, icLogoGtel, icNfc, icNote, icOcr, icPeoplescan, icProductscan, imageFrame, imgOtp, imgSplashEid];
}

class $AssetsRawGen {
  const $AssetsRawGen();

  /// File path: assets/raw/anim_scan_id.json
  String get animScanId => 'assets/raw/anim_scan_id.json';

  /// File path: assets/raw/animation_loading.json
  String get animationLoading => 'assets/raw/animation_loading.json';

  /// File path: assets/raw/face_id_loader.json
  String get faceIdLoader => 'assets/raw/face_id_loader.json';

  /// File path: assets/raw/nfc_animation.json
  String get nfcAnimation => 'assets/raw/nfc_animation.json';

  /// File path: assets/raw/sound_beep.wav
  String get soundBeep => 'assets/raw/sound_beep.wav';

  /// List of all assets
  List<String> get values => [animScanId, animationLoading, faceIdLoader, nfcAnimation, soundBeep];
}

class Assets {
  const Assets._();

  static const String aEnv = '.env';
 // static const String aEnv = '.env.test';
  static const $AssetsFontsGen fonts = $AssetsFontsGen();
  static const $AssetsIconsGen icons = $AssetsIconsGen();
  static const $AssetsRawGen raw = $AssetsRawGen();

  /// List of all assets
  static List<String> get values => [aEnv, aEnv];
}

class AssetGenImage {
  const AssetGenImage(this._assetName, {this.size, this.flavors = const {}});

  final String _assetName;

  final Size? size;
  final Set<String> flavors;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = true,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.medium,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({AssetBundle? bundle, String? package}) {
    return AssetImage(_assetName, bundle: bundle, package: package);
  }

  String get path => _assetName;

  String get keyName => _assetName;
}

class SvgGenImage {
  const SvgGenImage(this._assetName, {this.size, this.flavors = const {}}) : _isVecFormat = false;

  const SvgGenImage.vec(this._assetName, {this.size, this.flavors = const {}}) : _isVecFormat = true;

  final String _assetName;
  final Size? size;
  final Set<String> flavors;
  final bool _isVecFormat;

  _svg.SvgPicture svg({
    Key? key,
    bool matchTextDirection = false,
    AssetBundle? bundle,
    String? package,
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    AlignmentGeometry alignment = Alignment.center,
    bool allowDrawingOutsideViewBox = false,
    WidgetBuilder? placeholderBuilder,
    String? semanticsLabel,
    bool excludeFromSemantics = false,
    _svg.SvgTheme? theme,
    ColorFilter? colorFilter,
    Clip clipBehavior = Clip.hardEdge,
    @deprecated Color? color,
    @deprecated BlendMode colorBlendMode = BlendMode.srcIn,
    @deprecated bool cacheColorFilter = false,
  }) {
    final _svg.BytesLoader loader;
    if (_isVecFormat) {
      loader = _vg.AssetBytesLoader(_assetName, assetBundle: bundle, packageName: package);
    } else {
      loader = _svg.SvgAssetLoader(_assetName, assetBundle: bundle, packageName: package, theme: theme);
    }
    return _svg.SvgPicture(
      loader,
      key: key,
      matchTextDirection: matchTextDirection,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      allowDrawingOutsideViewBox: allowDrawingOutsideViewBox,
      placeholderBuilder: placeholderBuilder,
      semanticsLabel: semanticsLabel,
      excludeFromSemantics: excludeFromSemantics,
      colorFilter: colorFilter ?? (color == null ? null : ColorFilter.mode(color, colorBlendMode)),
      clipBehavior: clipBehavior,
      cacheColorFilter: cacheColorFilter,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
