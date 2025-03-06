import 'package:ca_app/blocs/auth/auth_bloc.dart';
import 'package:ca_app/blocs/auth/auth_event.dart';
import 'package:ca_app/blocs/auth/auth_state.dart';
import 'package:ca_app/utils/constanst/colors.dart';
import 'package:ca_app/utils/constanst/text_style.dart';
import 'package:ca_app/widgets/common_button_widget.dart';
import 'package:ca_app/widgets/textformfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ActiveDeactiveWidget extends StatefulWidget {
  final String action;
  final String actionUponId;
  const ActiveDeactiveWidget(
      {super.key, required this.action, required this.actionUponId});

  @override
  State<ActiveDeactiveWidget> createState() => _ActiveDeactiveWidgetState();
}

class _ActiveDeactiveWidgetState extends State<ActiveDeactiveWidget> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _reasonController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
                onPressed: () {
                  context.pop();
                },
                icon: Icon(
                  Icons.close,
                  color: ColorConstants.darkRedColor,
                )),
          ),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text.rich(TextSpan(children: [
                TextSpan(text: 'Note : ', style: AppTextStyle().cardLableText),
                TextSpan(
                    text: 'Are you sure you want to ',
                    style: AppTextStyle().cardValueText),
                TextSpan(
                    text:
                        widget.action == 'Deactive' ? 'Deactive ?' : 'Active ?',
                    style: widget.action == 'Deactive'
                        ? AppTextStyle().getredText
                        : AppTextStyle().getgreenText)
              ]))),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: TextformfieldWidget(
              maxLines: 3,
              minLines: 3,
              controller: _reasonController,
              hintText: 'Reason...',
              validator: (p0) {
                if (p0 == null || p0.isEmpty) {
                  return 'Please enter reason';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: BlocConsumer<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is DeactiveUserSucess) {
                  context
                      .read<AuthBloc>()
                      .add(GetUserByIdEvent(userId: widget.actionUponId));
                  context.pop();
                  _reasonController.clear();
                }
              },
              builder: (context, state) {
                return CommonButtonWidget(
                  buttonTitle:
                      widget.action == 'Deactive' ? 'De-Active' : "Active",
                  loader: state is DeactiveLoading,
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      context.read<AuthBloc>().add(DeactiveUserEvent(
                          actionUponId: widget.actionUponId,
                          reason: _reasonController.text,
                          action: widget.action == 'Deactive'
                              ? 'DEACTIVATE'
                              : "ACTIVATE"));
                    }
                  },
                );
              },
            ),
          ),
          SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }
}
