import 'package:flutter/material.dart';
import 'package:yopp/helper/app_color/color_helper.dart';
import 'package:yopp/widgets/buttons/gradient_check_button.dart';

class ChatInputField extends StatefulWidget {
  final Function(String message) onTrailingAction;
  final Function(bool) setIsTyping;
  final Function onLeadingAction;

  const ChatInputField({
    Key key,
    this.onTrailingAction,
    this.onLeadingAction,
    @required this.setIsTyping,
  }) : super(key: key);
  @override
  _ChatInputFieldState createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField> {
  TextEditingController controller = TextEditingController();
  bool isTyping;

  @override
  void initState() {
    isTyping = false;
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Container(
            width: double.infinity,
            decoration: new BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                // new IconButton(
                //   icon: CircleAvatar(
                //     backgroundColor: Hexcolor("#222222"),
                //     child: Icon(
                //       Icons.add,
                //       color: Colors.white,
                //     ),
                //   ),
                //   onPressed: () {},
                // ),
                Expanded(
                  child: Container(
                    child: TextFormField(
                      controller: controller,
                      keyboardType: TextInputType.multiline,
                      textCapitalization: TextCapitalization.sentences,
                      enableSuggestions: true,
                      minLines: 1,
                      maxLines: 4,
                      onChanged: (value) {
                        if (value.isEmpty && isTyping == true) {
                          isTyping = false;
                          widget.setIsTyping(isTyping);
                        }
                        if (value.isNotEmpty && isTyping == false) {
                          isTyping = true;
                          widget.setIsTyping(isTyping);
                        }
                      },
                      style: TextStyle(
                          color: Hexcolor("#222222"),
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                        fillColor: Colors.red,
                        border: InputBorder.none,
                        hintText: 'Type your message...',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        ChatSendButton(onPressed: () {
          if (controller.text.isNotEmpty) {
            final text = controller.text;
            controller.clear();
            isTyping = false;
            widget.setIsTyping(isTyping);
            widget.onTrailingAction(text);
          }
        }),
      ],
    ));
  }
}
