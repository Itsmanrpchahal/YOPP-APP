import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yopp/helper/app_color/color_helper.dart';
import 'package:yopp/modules/_common/bloc/base_state.dart';
import 'package:yopp/modules/_common/report/report_bloc.dart';
import 'package:yopp/modules/_common/report/report_event.dart';
import 'package:yopp/modules/_common/report/report_service.dart';
import 'package:yopp/modules/bottom_navigation/preference_setting/preference_service.dart';
import 'package:yopp/routing/transitions.dart';
import 'package:yopp/widgets/app_bar/white_background_appBar_with_trailing.dart';
import 'package:yopp/widgets/app_bar/white_background_appbar.dart';

import 'package:yopp/widgets/progress_hud/progress_hud.dart';

enum ReportOptions {
  nudity,
  violence,
  harrasment,
  suicde,
  spam,
  hate,
  terrorism,
  somethingElse
}

extension optionName on ReportOptions {
  String get name {
    String result;
    switch (this) {
      case ReportOptions.nudity:
        result = "Nudity";
        break;
      case ReportOptions.violence:
        result = "Violence";
        break;
      case ReportOptions.harrasment:
        result = "Harrasment";
        break;
      case ReportOptions.suicde:
        result = "Self-Injury or Sucide";
        break;
      case ReportOptions.spam:
        result = "Spam";
        break;
      case ReportOptions.hate:
        result = "Hate Speech";
        break;
      case ReportOptions.terrorism:
        result = "Terrorism";
        break;
      case ReportOptions.somethingElse:
        result = "Something Else";
        break;
    }
    return result;
  }
}

class ReportScreen extends StatefulWidget {
  static Route route({
    @required String reportTo,
    @required String title,
  }) =>
      SlideRoute(
          builder: (_) => BlocProvider<ReportBloc>(
                create: (context) =>
                    ReportBloc(ApiReportService(), SharedPreferenceService()),
                child: ReportScreen(
                  reportTo: reportTo,
                  title: title,
                ),
              ));

  final String reportTo;
  final String title;

  const ReportScreen({
    Key key,
    this.reportTo,
    this.title,
  }) : super(key: key);

  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  ReportOptions selectedOption;

  GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  TextEditingController textEditingController = TextEditingController();

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ProgressHud(
      child: Scaffold(
        appBar: selectedOption == null
            ? WhiteBackgroundAppBar(
                context: context,
                titleText: "Report",
              )
            : WhiteBackgroundAppBarWithAction(
                context: context,
                titleText: "Report",
                onPressed: () => _sendReport(context)),
        backgroundColor: Hexcolor("#F2F2F2"),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            shrinkWrap: true,
            children: [
              SizedBox(
                height: 1,
                width: double.infinity,
                child: Container(
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 16),
              Text(
                "Select a problem to proceed.",
              ),
              SizedBox(height: 16),
              _buildReportOptions(context),
              SizedBox(height: 16),
              selectedOption != null
                  ? Padding(
                      padding: EdgeInsets.only(bottom: 16),
                      child: Form(
                          key: _formkey,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          child: TextFormField(
                            controller: textEditingController,
                            textCapitalization: TextCapitalization.sentences,
                            maxLines: 4,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(16),
                              hintStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black.withOpacity(1)),
                              errorStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                              focusedBorder: new OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                                borderSide: BorderSide(
                                  width: 2,
                                  color: Colors.black,
                                  style: BorderStyle.solid,
                                ),
                              ),
                              border: new OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                                borderSide: BorderSide(
                                  width: 0,
                                  style: BorderStyle.none,
                                ),
                              ),
                              hintText: "Description",
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                              alignLabelWithHint: true,
                              filled: true,
                              counterText: "",
                            ),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 14),
                            keyboardType: TextInputType.text,
                            validator: (value) {
                              return value.isNotEmpty
                                  ? null
                                  : "Please, Enter the description.";
                            },
                          )),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }

  _buildReportOptions(BuildContext context) {
    return BlocListener<ReportBloc, BaseState>(
      listener: (context, state) async {
        switch (state.status) {
          case ServiceStatus.initial:
            break;
          case ServiceStatus.loading:
            ProgressHud.of(context).showLoading(text: state.message);
            break;
          case ServiceStatus.success:
            await ProgressHud.of(context)
                .showSuccessAndDismiss(text: state.message);
            Navigator.of(context).pop();
            break;
          case ServiceStatus.failure:
            ProgressHud.of(context).showErrorAndDismiss(text: state.message);
            break;
        }
      },
      child: Wrap(
          children: ReportOptions.values
              .map((e) => Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                        onSelected: (value) {
                          if (value) {
                            selectedOption = e;
                          } else if (selectedOption == e) {
                            selectedOption = null;
                          }
                          setState(() {});
                        },
                        selected: e == selectedOption,
                        selectedColor: Colors.blue,
                        label: Text(
                          e?.name,
                          style: TextStyle(
                              color: e == selectedOption
                                  ? Colors.white
                                  : Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.bold),
                        )),
                  ))
              .toList()),
    );
  }

  Future<void> _sendReport(BuildContext context) async {
    if (selectedOption == null) {
      return;
    }

    BlocProvider.of<ReportBloc>(context).add(ReportEvent(
      reportTo: widget.reportTo,
      subject: selectedOption.name,
      title: widget.title,
      description: textEditingController?.text ?? "",
    ));
  }
}
