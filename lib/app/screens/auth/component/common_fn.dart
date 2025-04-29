import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:medicine_app/constant/app_assets.dart';
import 'package:medicine_app/constant/app_color.dart';
import 'package:nb_utils/nb_utils.dart';

PreferredSizeWidget commonAppBarWidget(BuildContext context,
    {bool? showLeadingIcon = true,
    Color? iconColor,
    String? title,
    bool? changeIcon,
    Widget? iconWidget1,
    Widget? iconWidget2,
    Color? appBarColor}) {
  return AppBar(
    title: Text(title!, style: boldTextStyle(color: Colors.black87, size: 20)),
    backgroundColor: appBarColor ?? context.scaffoldBackgroundColor,
    centerTitle: true,
    actions: [iconWidget1.validate(), iconWidget2.validate()],
    elevation: 0,
  );
}

Widget commonImageWidget({String? image}) {
  return Stack(
    alignment: Alignment.center,
    children: [
      Container(
        decoration: boxDecorationWithRoundedCorners(
            boxShape: BoxShape.circle, backgroundColor: AppColors.primaryColor),
        width: 150,
        height: 150,
      ),
      Positioned(
        bottom: -40,
        child: CommonCachedNetworkImage(image.validate(),
            fit: BoxFit.cover, width: 150, height: 150, color: Colors.white),
      ),
    ],
  );
}

/// rounded box decoration
Decoration boxDecorationWithRoundedCorners({
  Color backgroundColor = Colors.white,
  BorderRadius? borderRadius,
  LinearGradient? gradient,
  BoxBorder? border,
  List<BoxShadow>? boxShadow,
  DecorationImage? decorationImage,
  BoxShape boxShape = BoxShape.rectangle,
}) {
  return BoxDecoration(
    color: backgroundColor,
    borderRadius:
        boxShape == BoxShape.circle ? null : (borderRadius ?? radius()),
    gradient: gradient,
    border: border,
    boxShadow: boxShadow,
    image: decorationImage,
    shape: boxShape,
  );
}

/// returns Radius
BorderRadius radius([double? radius]) {
  return BorderRadius.all(radiusCircular(radius ?? defaultRadius));
}

/// returns Radius
Radius radiusCircular([double? radius]) {
  return Radius.circular(radius ?? defaultRadius);
}

double defaultRadius = 8.0;

Widget CommonCachedNetworkImage(
  String? url, {
  double? height,
  double? width,
  BoxFit? fit,
  AlignmentGeometry? alignment,
  bool usePlaceholderIfUrlEmpty = true,
  double? radius,
  Color? color,
}) {
  if (url!.validate().isEmpty) {
    return placeHolderWidget(
        height: height,
        width: width,
        fit: fit,
        alignment: alignment,
        radius: radius);
  } else if (url.validate().startsWith('http')) {
    return CachedNetworkImage(
      imageUrl: url,
      height: height,
      width: width,
      fit: fit,
      color: color,
      alignment: alignment as Alignment? ?? Alignment.center,
      errorWidget: (_, s, d) {
        return placeHolderWidget(
            height: height,
            width: width,
            fit: fit,
            alignment: alignment,
            radius: radius);
      },
      placeholder: (_, s) {
        if (!usePlaceholderIfUrlEmpty) return SizedBox();
        return placeHolderWidget(
            height: height,
            width: width,
            fit: fit,
            alignment: alignment,
            radius: radius);
      },
    );
  } else {
    return Image.asset(url,
            height: height,
            width: width,
            fit: fit,
            color: color,
            alignment: alignment ?? Alignment.center)
        .cornerRadiusWithClipRRect(radius ?? defaultRadius);
  }
}

Widget placeHolderWidget(
    {double? height,
    double? width,
    BoxFit? fit,
    AlignmentGeometry? alignment,
    double? radius}) {
  return Image.asset('images/app/placeholder.jpg',
          height: height,
          width: width,
          fit: fit ?? BoxFit.cover,
          alignment: alignment ?? Alignment.center)
      .cornerRadiusWithClipRRect(radius ?? defaultRadius);
}

InputDecoration inputDecoration(BuildContext context,
    {Widget? suffixIcon,
    Widget? prefixIcon,
    String? labelText,
    double? borderRadius}) {
  return InputDecoration(
    contentPadding: EdgeInsets.only(left: 12, bottom: 10, top: 10, right: 10),
    labelText: labelText,
    labelStyle: secondaryTextStyle(),
    alignLabelWithHint: true,
    prefixIcon: prefixIcon,
    border: OutlineInputBorder(
      borderRadius: radius(borderRadius ?? defaultRadius),
      borderSide: BorderSide(color: Colors.grey, width: 1),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: radius(borderRadius ?? defaultRadius),
      borderSide: BorderSide(color: Colors.grey, width: 0.0),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: radius(borderRadius ?? defaultRadius),
      borderSide: BorderSide(color: Colors.red, width: 0.0),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: radius(borderRadius ?? defaultRadius),
      borderSide: BorderSide(color: Colors.red, width: 1.0),
    ),
    errorMaxLines: 2,
    errorStyle: primaryTextStyle(color: Colors.red, size: 12),
    focusedBorder: OutlineInputBorder(
      borderRadius: radius(borderRadius ?? defaultRadius),
      borderSide: BorderSide(color: AppColors.primaryColor, width: 0.0),
    ),
    filled: false,
    fillColor: gray.withOpacity(0.1),
  );
}

Widget CommonButton(
    {String? buttonText, Function()? onTap, double? width, double? margin}) {
  return AppButton(
    onTap: onTap,
    width: width,
    shapeBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    margin: EdgeInsets.symmetric(horizontal: margin.validate()),
    child:
        Text(buttonText.validate(), style: boldTextStyle(color: Colors.white)),
    color: AppColors.primaryColor,
    padding: EdgeInsets.symmetric(vertical: 16),
  );
}

extension strEtx on String {
  Widget iconImage({double? size, Color? color, BoxFit? fit}) {
    return Image.asset(
      this,
      height: size ?? 24,
      width: size ?? 24,
      fit: fit ?? BoxFit.cover,
      color: color ?? (gray.withOpacity(0.6)),
      errorBuilder: (context, error, stackTrace) {
        return Image.asset('ic_message', height: size ?? 24, width: size ?? 24);
      },
    );
  }
}

Widget commonSocialLoginButton(BuildContext context) {
  // final authController = Get.find<AuthController>();

  return OutlinedButton(
    onPressed: () {
      // authController.signInWithGoogle(context);
    },
    style: OutlinedButton.styleFrom(
      side: BorderSide(width: 1.0, color: gray.withOpacity(0.1)),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CommonCachedNetworkImage(google_logo,
            fit: BoxFit.cover, width: 20, height: 20),
        8.width,
        Text('Continue With Google',
            style: TextStyle(color: AppColors.black87)),
      ],
    ),
  );
}
