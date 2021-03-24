import 'package:country_list_pick/country_list_pick.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yopp/helper/app_color/app_colors.dart';
import 'package:yopp/modules/authentication/sign_up/bloc/register_bloc.dart';
import 'package:yopp/modules/authentication/sign_up/bloc/register_state.dart';

class CountryPicker extends StatelessWidget {
  final Function(CountryCode) onChanged;

  const CountryPicker({
    Key key,
    this.onChanged,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: Colors.white.withOpacity(0.25),
      ),
      child: BlocBuilder<RegisterBloc, RegisterState>(
        builder: (context, state) {
          return CountryListPick(
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: Text(
                'Select Country',
                style: TextStyle(color: Colors.black),
              ),
            ),
            // if you need custome picker use this
            pickerBuilder: (context, CountryCode countryCode) {
              return Row(
                children: [
                  Text(
                    countryCode.dialCode ?? "Country",
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontWeight: FontWeight.bold,
                        fontSize: 14),
                  ),
                  Icon(
                    Icons.keyboard_arrow_down,
                    color: AppColors.lightGrey,
                  )
                ],
              );
            },
            // To disable option set to false
            theme: CountryTheme(
              isShowFlag: false,
              isShowTitle: true,
              isShowCode: true,
              isDownIcon: true,
              showEnglishName: true,
            ),
            // Set default value
            initialSelection: state.countryCode,
            onChanged: onChanged,
          );
        },
      ),
    );
  }
}
