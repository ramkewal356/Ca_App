import 'package:ca_app/blocs/auth/auth_bloc.dart';
import 'package:ca_app/blocs/auth/auth_event.dart';
import 'package:ca_app/blocs/auth/auth_state.dart';
import 'package:ca_app/blocs/team_member/team_member_bloc.dart';
import 'package:ca_app/data/models/get_permission_model.dart';
import 'package:ca_app/data/models/user_model.dart';
import 'package:ca_app/utils/constanst/colors.dart';
import 'package:ca_app/utils/constanst/text_style.dart';
import 'package:ca_app/utils/utils.dart';
import 'package:ca_app/widgets/common_button_widget.dart';
import 'package:ca_app/widgets/custom_appbar.dart';
import 'package:ca_app/widgets/custom_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class GetPermissionScreen extends StatefulWidget {
  final int subCaId;
  final List<Permission> selectedPermission;

  const GetPermissionScreen(
      {super.key, required this.selectedPermission, required this.subCaId});

  @override
  State<GetPermissionScreen> createState() => _GetPermissionScreenState();
}

class _GetPermissionScreenState extends State<GetPermissionScreen> {
  List<String> selectedPermissionNames = [];
  List<int> selectedPermissionIds = [];
  List<bool> selectedItems = [];
  bool isSelectAll = false;

  @override
  void initState() {
    super.initState();
    _initializeSelectedPermissions();
    context.read<GetPermissionBloc>().add(GetPermissionEvent());
  }

  void _initializeSelectedPermissions() {
    selectedPermissionNames =
        widget.selectedPermission.map((e) => e.permissionName ?? '').toList();
    selectedPermissionIds =
        widget.selectedPermission.map((e) => e.id ?? 0).toList();
  }

  void _toggleSelectAll(bool? value, List<PermissionData> itemsList) {
    setState(() {
      isSelectAll = value ?? false;
      selectedItems = List.generate(itemsList.length, (index) => isSelectAll);
      if (isSelectAll) {
        selectedPermissionNames = List.generate(
            itemsList.length, (index) => '${itemsList[index].permissionName}');
        selectedPermissionIds = List.generate(
          itemsList.length,
          (index) => itemsList[index].id ?? 0,
        );
        debugPrint('selece>>> $selectedPermissionNames');
        debugPrint('selece>>>id $selectedPermissionIds');
      } else {
        selectedPermissionNames.clear();
        selectedPermissionIds.clear();
        debugPrint('selece>>> $selectedPermissionNames');
        debugPrint('selece>>>wid $selectedPermissionNames');
      }
    });
  }

  void _toggleItemSelection(
      int index, bool? value, String permissionName, int permissionId) {
    setState(() {
      selectedItems[index] = value ?? false;
      if (selectedItems[index]) {
        selectedPermissionNames.add(permissionName);
        selectedPermissionIds.add(permissionId);
        debugPrint('selece>>> $selectedPermissionNames');
        debugPrint('selece>>>id $selectedPermissionIds');
      } else {
        selectedPermissionNames.remove(permissionName);
        selectedPermissionIds.remove(permissionId);
        debugPrint('selece>>> $selectedPermissionNames');
        debugPrint('selece>>>id $selectedPermissionIds');
      }
      isSelectAll = selectedItems.every((element) => element);
    });
    debugPrint('selece>>> $selectedPermissionNames');
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('sdsvxvcxvcv ${widget.subCaId}');
    return CustomLayoutPage(
      appBar: CustomAppbar(title: 'Get Permission', backIconVisible: true),
      child: BlocBuilder<GetPermissionBloc, TeamMemberState>(
        builder: (context, state) {
          if (state is TeamMemberLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is GetPermissionListSuccess) {
            final permissionList = state.getPermissionList;

            // Initialize selectedItems based on already selected permissions
            if (selectedItems.isEmpty) {
              selectedItems = List.generate(permissionList.length, (index) {
                return selectedPermissionNames
                    .contains(permissionList[index].permissionName);
              });
              isSelectAll = selectedItems.every((element) => element);
            }

            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  // "Select All" Checkbox
                  CheckboxListTile(
                    activeColor: ColorConstants.buttonColor,
                    controlAffinity: ListTileControlAffinity.leading,
                    title: Text(
                      "Select All",
                      style: AppTextStyle().labletext,
                    ),
                    value: isSelectAll,
                    onChanged: (value) =>
                        _toggleSelectAll(value, permissionList),
                  ),
                  Divider(
                    height: 10,
                    thickness: 2,
                  ),
                  // List of Checkboxes
                  Expanded(
                    child: ListView.builder(
                      itemCount: permissionList.length,
                      itemBuilder: (context, index) {
                        return CheckboxListTile(
                          activeColor: ColorConstants.buttonColor,
                          dense: true,
                          controlAffinity: ListTileControlAffinity.leading,
                          title:
                              Text(permissionList[index].permissionName ?? ''),
                          value: selectedItems[index],
                          onChanged: (value) => _toggleItemSelection(
                              index,
                              value,
                              permissionList[index].permissionName ?? '',
                              permissionList[index].id ?? 0),
                        );
                      },
                    ),
                  ),
                  BlocConsumer<AuthBloc, AuthState>(
                    listener: (context, state) {
                      if (state is UpdateUserSuccess) {
                        context.pop();
                        Utils.toastSuccessMessage(
                            'GetPermission Updated Successfully');
                      }
                    },
                    builder: (context, state) {
                      return CommonButtonWidget(
                        buttonTitle: 'Submit',
                        loader: state is AuthLoading,
                        onTap: () {
                          context.read<AuthBloc>().add(UpdateUserEvent(
                              userId: widget.subCaId.toString(),
                              permissionIds: selectedPermissionIds));
                        },
                      );
                    },
                  )
                ],
              ),
            );
          }
          return Container();
        },
      ),
    );
  }
}
