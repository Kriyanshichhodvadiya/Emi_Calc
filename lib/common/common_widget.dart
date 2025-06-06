import 'package:emi_calc/config/color.dart';
import 'package:emi_calc/config/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

extension NumExtensions on num {
  //sixedbox
  Widget get height => SizedBox(height: toDouble());
  Widget get width => SizedBox(width: toDouble());
  //mediaquery
  double wp(BuildContext context) =>
      this * MediaQuery.of(context).size.width / 100;
  double hp(BuildContext context) =>
      this * MediaQuery.of(context).size.height / 100;
  //padding edgeinsets
  EdgeInsets get symmetric =>
      EdgeInsets.symmetric(horizontal: toDouble(), vertical: toDouble());
  EdgeInsets get horizontal => EdgeInsets.symmetric(horizontal: toDouble());
  EdgeInsets get vertical => EdgeInsets.symmetric(vertical: toDouble());
  EdgeInsets get onlyLeft => EdgeInsets.only(left: toDouble());
  EdgeInsets get onlyRight => EdgeInsets.only(right: toDouble());
  EdgeInsets get onlyTop => EdgeInsets.only(top: toDouble());
  EdgeInsets get onlyBottom => EdgeInsets.only(bottom: toDouble());
}

Widget commontext() {
  return Text(
    "data",
    style: TextStyle(color: AppColors.primarycolor),
  );
}

TextStyle style(
    {Color color = Colors.black,
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.w400}) {
  return TextStyle(
    color: color,
    fontSize: fontSize,
    fontWeight: fontWeight,
  );
}

Widget primarybutton(
    {required String text,
    Color? backgroundColor,
    Color? color,
    double height = 50,
    double width = double.maxFinite,
    required void Function()? onPressed,
    BorderRadiusGeometry borderRadius =
        const BorderRadius.all(Radius.circular(10))}) {
  return Builder(builder: (context) {
    return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(borderRadius: borderRadius),
            minimumSize: Size(width, height),
            backgroundColor: backgroundColor ?? AppColors.primarycolor),
        child: Text(
          text,
          style: TextStyle(
            color: color ?? AppColors.white,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ));
  });
}

AppBar commonappbar({
  IconData? icon,
  required String text,
  void Function()? onPressed,
  void Function()? addOnTap,
}) {
  return AppBar(
    leading: IconButton(
      onPressed:onPressed==null? () {
        Get.back();
      }:onPressed,
      icon: Icon(
        Icons.arrow_back_ios,
        color: AppColors.white,
      ),
    ),
    actions: [
      IconButton(
        onPressed: addOnTap,
        icon: Icon(
          icon, // Replace with your desired icon
          color: AppColors.white,
        ),
      ),
    ],
    shadowColor: AppColors.black.withOpacity(0.5),
    backgroundColor: AppColors.primarycolor,
    elevation: 0,
    centerTitle: true,
    title: Text(
      text,
      style: style(
        color: AppColors.white,
        fontWeight: FontWeight.w500,
        fontSize: 17,
      ),
    ),
    automaticallyImplyLeading: false,
  );
}

Widget commonTextField({
  required String text,
  required String label,
  List<TextInputFormatter>? inputFormatters,
  TextEditingController? controller,
  void Function(String)? onChanged,
  TextInputType keyboardType = TextInputType.number,
  int maxLines = 1,
  String? Function(String?)? validator,
  required String img,
  // Widget? suffix,
}) {
  return TextFormField(
    cursorColor: AppColors.black,
    inputFormatters: inputFormatters,
    controller: controller,
    onChanged: onChanged,
    keyboardType: keyboardType,
    maxLines: maxLines,
    validator: validator,
    decoration: InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      hintText: text,
      labelText: label,
      labelStyle: style(
        color: AppColors.black.withOpacity(0.6),
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      hintStyle: style(
          fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.greytext),
      contentPadding: const EdgeInsets.symmetric(vertical: 1, horizontal: 10),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.black.withOpacity(0.2)),
        borderRadius: BorderRadius.circular(5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.black.withOpacity(0.2)),
        borderRadius: BorderRadius.circular(5),
      ),
      enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.black.withOpacity(0.2)),
          borderRadius: BorderRadius.circular(5)),
      focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.black),
          borderRadius: BorderRadius.circular(5)),
      // suffix: suffix,
      suffixIcon: Transform.scale(
        scale: 0.3,
        child: SvgPicture.asset(
          height: 5,
          width: 5,
          img,
          color: Colors.grey,
        ),
      ),
    ),
  );
}

Widget textField({
  required String text,
  required String label,
  List<TextInputFormatter>? inputFormatters,
  TextEditingController? controller,
  void Function(String)? onChanged,
  TextInputType keyboardType = TextInputType.number,
  int maxLines = 1,
  String? Function(String?)? validator,
}) {
  return TextFormField(
    cursorColor: AppColors.black,
    inputFormatters: inputFormatters,
    controller: controller,
    onChanged: onChanged,
    keyboardType: keyboardType,
    maxLines: maxLines,
    validator: validator,
    decoration: InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      hintText: text,
      labelText: label,
      labelStyle: style(
        color: AppColors.black.withOpacity(0.6),
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      hintStyle: style(
          fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.greytext),
      contentPadding: const EdgeInsets.symmetric(vertical: 1, horizontal: 10),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.black.withOpacity(0.2)),
        borderRadius: BorderRadius.circular(5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.black.withOpacity(0.2)),
        borderRadius: BorderRadius.circular(5),
      ),
      enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.black.withOpacity(0.2)),
          borderRadius: BorderRadius.circular(5)),
      focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.black),
          borderRadius: BorderRadius.circular(5)),
    ),
  );
}

Widget textFieldSwitch({
  required String text,
  required String label,
  Widget? suffixIcon,
  List<TextInputFormatter>? inputFormatters,
  TextEditingController? controller,
  void Function(String)? onChanged,
  TextInputType keyboardType = TextInputType.number,
  int maxLines = 1,
  String? Function(String?)? validator,
}) {
  return TextFormField(
    inputFormatters: inputFormatters,
    cursorColor: AppColors.black,
    controller: controller,
    onChanged: onChanged,
    keyboardType: keyboardType,
    validator: validator,
    decoration: InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      hintText: text,
      labelText: label,
      labelStyle: style(
        color: AppColors.black.withOpacity(0.6),
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      hintStyle: style(
          fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.greytext),
      contentPadding: const EdgeInsets.symmetric(vertical: 1, horizontal: 10),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.black.withOpacity(0.2)),
        borderRadius: BorderRadius.circular(5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.black.withOpacity(0.2)),
        borderRadius: BorderRadius.circular(5),
      ),
      enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.black.withOpacity(0.2)),
          borderRadius: BorderRadius.circular(5)),
      focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.black),
          borderRadius: BorderRadius.circular(5)),
      suffixIcon: suffixIcon,
      // suffixIcon: Icon(Icons.currency_rupee, color: Colors.grey),
    ),
  );
}

Widget drawerListTile({
  IconData? icon,
  required String text,
  void Function()? onTap,
}) {
  return ListTile(
    leading: Icon(
      icon,
      color: AppColors.white,
    ),
    title: Text(
      text,
      style: style(color: AppColors.white, fontWeight: FontWeight.w500),
    ),
    onTap: onTap,
  );
}

Widget homeDrawer() {
  return Container(
    color: AppColors.primarycolor,
    child: Padding(
      padding: 30.onlyLeft,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SvgPicture.asset(
            AppImages.lumpsum,
            height: 50,
          ),
          10.width,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'EMI Calculator',
                style: style(
                  color: AppColors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                'Loan Planner',
                style: style(
                  color: AppColors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

class MySeparator extends StatelessWidget {
  const MySeparator({Key? key, this.height = 1, this.color = Colors.black})
      : super(key: key);
  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        const dashWidth = 5.0;
        final dashHeight = height;
        final dashCount = (boxWidth / (2 * dashWidth)).floor();
        return Flex(
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: dashHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(color: color),
              ),
            );
          }),
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
        );
      },
    );
  }
}

Future<void> appExitDialog(BuildContext context,
    {required title,
      required content,
      required void Function()? cancelOnTap,
      required void Function()? confirmOnTap}) async {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      backgroundColor: AppColors.bgcolor, // Custom background color
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0), // Rounded corners
      ),
      title: Center(
        child: Text(
          title,
          style: style(
            fontSize: 20,
            fontWeight: FontWeight.w400,
            color: AppColors.black,
          ),
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: 10.horizontal,
            child: Text(
              content,
              textAlign: TextAlign.center,
              style: style(
                fontSize: 13,
                fontWeight: FontWeight.w300,
                color: AppColors.grey,
              ),
            ),
          ),
          13.height,
          Row(
            children: [
              Expanded(
                child: primarybutton(
                    onPressed: cancelOnTap,
                    text: 'No',
                    color: AppColors.red),
              ),
              10.width,
              Expanded(
                child: primarybutton(
                    onPressed: confirmOnTap,
                    text: 'Yes',
                    color: AppColors.primarycolor.withOpacity(0.2)),
              ),
            ],
          )
        ],
      ),
    ),
  );
}

Widget FixedText({
  required String label,
  required String text,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        label,
        style: style(
          color: AppColors.black,
          fontWeight: FontWeight.w600,
        ),
      ),
      Text(
        text,
        style: style(
          color: AppColors.black,
          fontWeight: FontWeight.w500,
        ),
      )
    ],
  );
}


Widget commonChartDetail({required color, required label}) {
  return Expanded(
    child: Builder(
        builder: (context) {
          return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 4.hp(context),width: 4.wp(context),
                decoration: BoxDecoration( color: Colors.transparent,
                  border: Border.all(
                    width: 2,
                    color: color,
                  ),
                  shape: BoxShape.circle,
                ),
              ),5.width,
              Flexible(
                child: Text(
                  label,
                  maxLines: 2,textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: style(
                      fontSize: 12, color: AppColors.grey, fontWeight: FontWeight.w400),
                ),
              ),
            ],
          );
        }
    ),
  );
}

Future<bool?> primaryToast({required msg}){
  return Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: AppColors.black,
      textColor: AppColors.white,
      fontSize: 16.0
  );
}


Decoration commonDecoration(){
  return BoxDecoration( borderRadius: BorderRadius.circular(10),
    color: AppColors.white,boxShadow: [BoxShadow(color: AppColors.grey.withOpacity(0.2),blurRadius: 3,spreadRadius: -1)]);
}