import 'package:docsheli/constants/app_constants.dart';
import 'package:docsheli/modal/specialityModal.dart';
import 'package:docsheli/providers/auth.dart';
import 'package:docsheli/providers/doctor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

// form field class
// ignore: must_be_immutable
class GlobalFormField extends StatefulWidget {
  final int? textLimit;
  final bool? allow, secureText, isReadOnly;
  final String? hint, label, prefixIcon, regExp;
  final Function()? onTap;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final Function? onChange;
  final Widget? iconSuffix;
  final FocusNode? focusNode, nextNode, unFocus;
  final TextInputType? type;
  final TextStyle? textStyle;
  final TextInputAction? action;
  final TextCapitalization? capitalization;
  final List<TextInputFormatter>? inputFormatter;

  GlobalFormField(
      {this.hint,
      this.label,
      this.prefixIcon,
      required this.controller,
      this.focusNode,
      this.nextNode,
      this.unFocus,
      this.type,
      this.onTap,
      this.textStyle,
      this.action,
      this.capitalization,
      this.validator,
      this.onChange,
      this.textLimit,
      this.regExp,
      this.inputFormatter,
      this.allow = false,
      this.secureText = false,
      this.isReadOnly = false,
      this.iconSuffix});

  @override
  _GlobalFormFieldState createState() => _GlobalFormFieldState();
}

class _GlobalFormFieldState extends State<GlobalFormField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: Get.width * .05, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.label != null) ...[
            Text(
              widget.label ?? "",
              style: AppConfig.textStyle.poppins().copyWith(
                  color: AppConfig.colors.hintColor,
                  fontSize: Get.width * .035,
                  fontWeight: FontWeight.bold),
            )
          ],
          TextFormField(
            inputFormatters: widget.inputFormatter ??
                [
                  LengthLimitingTextInputFormatter(widget.textLimit),
                  FilteringTextInputFormatter(RegExp(widget.regExp ?? ""),
                      allow: widget.allow ?? false)
                ],
            readOnly: widget.isReadOnly ?? false,
            textAlign: TextAlign.start,
            controller: widget.controller,
            onTap: widget.onTap,
            focusNode: widget.focusNode,
            onFieldSubmitted: (val) {
              setState(() {
                FocusScope.of(Get.context!).requestFocus(widget.nextNode);
              });
            },
            textInputAction: widget.action,
            obscureText: widget.secureText ?? false,
            style: widget.textStyle ??
                AppConfig.textStyle.poppins().copyWith(fontSize: 13),
            decoration: InputDecoration(
                suffixIcon: widget.iconSuffix,
                floatingLabelBehavior: FloatingLabelBehavior.always,
                isDense: true,
                hintText: widget.hint,
                prefixIcon: widget.prefixIcon != null
                    ? Container(
                        margin: EdgeInsets.all(12),
                        height: 10,
                        width: 10,
                        child: Image.asset(widget.prefixIcon!),
                      )
                    : SizedBox.shrink(),
                fillColor: Colors.white,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                filled: true,
                hintStyle: AppConfig.textStyle
                    .poppins()
                    .copyWith(fontSize: 13, color: AppConfig.colors.hintColor),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(color: AppConfig.colors.iconGrey),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(color: AppConfig.colors.iconGrey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(color: AppConfig.colors.themeColor),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(color: Colors.red),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(color: Colors.red),
                ),
                errorStyle: AppConfig.textStyle
                    .poppins()
                    .copyWith(color: Colors.red, fontSize: 10)),
            textCapitalization:
                widget.capitalization ?? TextCapitalization.none,
            onChanged: (v) => widget.onChange,
            onEditingComplete: () {
              setState(() {
                widget.focusNode?.unfocus();
              });
            },
            keyboardType: widget.type,
            validator: widget.validator,
          )
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class GlobalButton extends StatefulWidget {
  Function onTap = () {};
  String buttonText;
  Color btnTextColor, btnColor;

  GlobalButton({
    required this.onTap,
    required this.buttonText,
    required this.btnTextColor,
    required this.btnColor,
  });

  @override
  _GlobalButtonState createState() => _GlobalButtonState();
}

class _GlobalButtonState extends State<GlobalButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: Get.width * .03),
      child: MaterialButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 0,
        minWidth: Get.width,
        height: 45,
        color: widget.btnColor,
        child: Center(
          child: Text(widget.buttonText,
              style: AppConfig.textStyle.poppins().copyWith(
                    fontSize: Get.width * .04,
                    color: widget.btnTextColor,
                  )),
        ),
        onPressed: () {
          widget.onTap();
        },
      ),
    );
  }
}

class BottomSheetSort extends StatefulWidget {
  @override
  _BottomSheetSortState createState() => _BottomSheetSortState();
}

class _BottomSheetSortState extends State<BottomSheetSort> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
            width: Get.width,
            height: Get.height * .75,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(26),
                  topRight: Radius.circular(26),
                )),
            child: SingleChildScrollView(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: GestureDetector(
                  onTap: () {
                    FocusScope.of(context).requestFocus(new FocusNode());
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: Get.height * 0.02),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Spacer(),
                            Text(
                              'Sort results by',
                              style: GoogleFonts.roboto(
                                fontSize: 22.0,
                                color: const Color(0xFF1C1C1C),
                                fontWeight: FontWeight.w700,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            Spacer(),
                            GestureDetector(
                                onTap: () {
                                  Get.back();
                                },
                                child: Image.asset(AppConfig.images.btm_cancel,
                                    scale: 5)),
                            SizedBox(width: Get.width * 0.02),
                          ],
                        ),
                      ),
                      Divider(
                        thickness: 2.5,
                        indent: Get.width * 0.12,
                        endIndent: Get.width * 0.12,
                      ),
                      SizedBox(height: 14),
                      radioButtonCustom(),
                    ],
                  ),
                ))));
  }

  Widget radioButtonCustom() {
    List<SpecialityModal> specialities =
        Provider.of<AuthProvider>(context, listen: false).specialities;
    return ButtonBar(
      alignment: MainAxisAlignment.center,
      children: List.generate(specialities.length + 1, (index) {
        return Container(
          height: Get.height * 0.07,
          width: Get.width,
          child: radiuoCustom(index, specialities),
        );
      }),
    );
  }

  Widget radiuoCustom(int index, List<SpecialityModal> specialities) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: Get.width * 0.84,
          child: RadioListTile(
              value: index,
              groupValue: Provider.of<DoctorProvider>(context, listen: false)
                  .selectedRadioTile,
              title: Text(
                index == 0 ? "All" : "${specialities[index - 1].speciality}",
                style: GoogleFonts.roboto(
                  fontSize: 19.0,
                  color: const Color(0xFF1C1C1C),
                ),
                textAlign: TextAlign.left,
              ),

              // subtitle: Text("Radio 1 Subtitle"),
              onChanged: (val) {
                index == 0
                    ? setSelectedRadioTile(val, null)
                    : setSelectedRadioTile(val, specialities[index - 1].id!);
              },
              activeColor: AppConfig.colors.themeColor,
              selected: true,
              secondary: null),
        )
      ],
    );
  }

  setSelectedRadioTile(dynamic val, String? id) {
    setState(() {
      Provider.of<DoctorProvider>(context, listen: false).selectedRadioTile =
          val;
      Provider.of<DoctorProvider>(context, listen: false).selectedCategoryID =
          id;
      print(
          "pressed radio tile number $val and its id is :${Provider.of<DoctorProvider>(context, listen: false).selectedCategoryID}");
    });
  }
}
