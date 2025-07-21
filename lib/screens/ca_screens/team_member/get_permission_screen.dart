import 'package:ca_app/blocs/auth/auth_bloc.dart';
import 'package:ca_app/blocs/auth/auth_event.dart';
import 'package:ca_app/blocs/auth/auth_state.dart';
import 'package:ca_app/blocs/team_member/team_member_bloc.dart';
import 'package:ca_app/data/models/get_permission_model.dart';
import 'package:ca_app/utils/constanst/colors.dart';
import 'package:ca_app/utils/utils.dart';
import 'package:ca_app/widgets/common_button_widget.dart';
import 'package:ca_app/widgets/custom_appbar.dart';
import 'package:ca_app/widgets/custom_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class GetPermissionScreen extends StatefulWidget {
  final int subCaId;
  final List<String> selectedPermissionNamesList;
  final List<int> selectedPermissionIdsList;

  const GetPermissionScreen(
      {super.key,
      required this.selectedPermissionNamesList,
      required this.selectedPermissionIdsList,
      required this.subCaId});

  @override
  State<GetPermissionScreen> createState() => _GetPermissionScreenState();
}

class _GetPermissionScreenState extends State<GetPermissionScreen> {
  late Map<String, List<ClientActivityData>> permissionMap;
  List<String> selectedPermissionNames = [];
  List<int> selectedPermissionIds = [];
  List<bool> selectedItems = [];
  bool isSelectAll = false;

  @override
  void initState() {
    super.initState();
    // _initializeSelectedPermissions();
    selectedPermissionNames = widget.selectedPermissionNamesList;
    selectedPermissionIds = widget.selectedPermissionIdsList;
    context.read<GetPermissionBloc>().add(GetPermissionEvent());
  }

  // void _initializeSelectedPermissions() {
   
  // }

  

  void _toggleItemSelection(
      bool? value, String permissionName, int permissionId) {
    setState(() {
      if (value == true) {
        if (!selectedPermissionNames.contains(permissionName)) {
        selectedPermissionNames.add(permissionName);
        }
        if (!selectedPermissionIds.contains(permissionId)) {
        selectedPermissionIds.add(permissionId);
        }
      } else {
        selectedPermissionNames.remove(permissionName);
        selectedPermissionIds.remove(permissionId);
      }
    });

    debugPrint('Selected Names: $selectedPermissionNames');
    debugPrint('Selected IDs: $selectedPermissionIds');
  }
  @override
  Widget build(BuildContext context) {
    debugPrint(
        'sdsvxvcxvc selected items $selectedPermissionNames $selectedPermissionIds');
    return CustomLayoutPage(
      appBar: CustomAppbar(title: 'Get Permission', backIconVisible: true),
      child: BlocBuilder<GetPermissionBloc, TeamMemberState>(
        builder: (context, state) {
          if (state is TeamMemberLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is GetPermissionListSuccess) {
            final permissionList = state.getPermissionList;

         
            permissionMap = {
              if (permissionList?.clientActivities != null)
                "Client Activities": permissionList?.clientActivities ?? [],
              if (permissionList?.documentActivities != null)
                "Document Activities": permissionList?.documentActivities ?? [],
              if (permissionList?.general != null)
                "General": permissionList?.general ?? [],
              if (permissionList?.taskActivities != null)
                "Task Activities": permissionList?.taskActivities ?? [],
            };
            return ListView(padding: const EdgeInsets.all(16), children: [
              ...permissionMap.entries.map((entry) {
                final category = entry.key;
                final subPermissions = entry.value;

                final allChecked = subPermissions
                    .every((e) => selectedPermissionIds.contains(e.id));

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CheckboxListTile(
                      activeColor: ColorConstants.buttonColor,
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.leading,
                      title: Text(category,
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      value: allChecked,
                      // value: false,
                      onChanged: (bool? value) {
                        setState(() {
                          for (var perm in subPermissions) {
                            perm.isSelected = value ?? false;
                            _toggleItemSelection(
                                value, perm.permissionName ?? '', perm.id ?? 0);
                          }
                          // categorySelected[category] = value ?? false;
                        });
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 32),
                      child: Column(
                        children: subPermissions.map((perm) {
                          // final index = entry.key;
                          // final perm = entry.value;
                          return CheckboxListTile(
                            contentPadding: EdgeInsets.zero,
                            activeColor: ColorConstants.buttonColor,
                            dense: true,
                            controlAffinity: ListTileControlAffinity.leading,
                            title: Text(perm.permissionName ?? ''),
                            value: selectedPermissionIds.contains(perm.id),
                            // value: perm.isSelected ?? false,
                            onChanged: (bool? value) {
                              setState(() {
                                perm.isSelected = value ?? false;
                                _toggleItemSelection(value,
                                    perm.permissionName ?? '', perm.id ?? 0);
                                // categorySelected[category] =
                                //     subPermissions.every((e) => e.isSelected);
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(height: 8),
                  ],
                );
              }),
              SizedBox(
                height: 20,
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
            ]
            );

          
          }
          return Container();
        },
      ),
    );
  }
}
