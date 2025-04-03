import 'package:ca_app/blocs/document/document_bloc.dart';
import 'package:ca_app/blocs/raise_request/raise_request_bloc.dart';
import 'package:ca_app/utils/constanst/colors.dart';
import 'package:ca_app/utils/constanst/text_style.dart';
import 'package:ca_app/utils/constanst/validator.dart';
import 'package:ca_app/widgets/common_button_widget.dart';
import 'package:ca_app/widgets/custom_appbar.dart';
import 'package:ca_app/widgets/custom_layout.dart';
import 'package:ca_app/widgets/textformfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RequestDetailsScreen extends StatefulWidget {
  final int requestId;
  const RequestDetailsScreen({super.key, required this.requestId});

  @override
  State<RequestDetailsScreen> createState() => _RequestDetailsScreenState();
}

class _RequestDetailsScreenState extends State<RequestDetailsScreen> {
  @override
  void initState() {
    super.initState();
    context
        .read<RaiseRequestBloc>()
        .add(GetRequestDetailsEvent(requestId: widget.requestId));
  }

  @override
  Widget build(BuildContext context) {
    return CustomLayoutPage(
        appBar: CustomAppbar(
          title: 'Request Details',
          backIconVisible: true,
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: BlocBuilder<RaiseRequestBloc, RaiseRequestState>(
            builder: (context, state) {
              if (state is GetRequestDetailsLoading) {
                return Center(
                  child: CircularProgressIndicator(
                    color: ColorConstants.buttonColor,
                  ),
                );
              } else if (state is GetRequestDetailsSuccess) {
                var data = state.getDocumentByRequestIdData.data;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _textItem(
                              lable: 'Id',
                              value: '#${data?.requestResponse?.requestId}'),
                        ),
                        Expanded(
                          child: _textItem(
                              lable: 'Created Date',
                              value: dateFormate(
                                  data?.requestResponse?.createdDate)),
                        )
                      ],
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        Expanded(
                          child: _textItem(
                              lable: 'CA(Sender)',
                              value:
                                  '${data?.requestResponse?.senderName}(#${data?.requestResponse?.senderId})'),
                        ),
                        Expanded(
                          child: _textItem(
                              lable: 'CLIENT(Receiver)',
                              value:
                                  '${data?.requestResponse?.receiverName}(#${data?.requestResponse?.receiverId})'),
                        )
                      ],
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Desciption : ',
                      style: AppTextStyle().hintText,
                    ),
                    SizedBox(height: 5),
                    TextformfieldWidget(
                        readOnly: true,
                        maxLines: 3,
                        minLines: 3,
                        controller: TextEditingController(
                            text: '${data?.requestResponse?.text}'),
                        hintText: 'Description'),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Text(
                          'Documents',
                          style: AppTextStyle().labletext,
                        ),
                        SizedBox(width: 5),
                        Container(
                          decoration: BoxDecoration(
                              color: ColorConstants.buttonColor,
                              shape: BoxShape.circle),
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text(
                              '${data?.requestDocuments?.length}',
                              style: AppTextStyle().smallbuttontext,
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 10),
                    ...List.generate(
                      data?.requestDocuments?.length ?? 0,
                      (index) {
                        return Container(
                          padding: EdgeInsets.all(4),
                          margin: EdgeInsets.only(bottom: 10),
                          height: 225,
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: ColorConstants.darkGray),
                              borderRadius: BorderRadius.circular(5)),
                          width: double.infinity,
                          child: Column(
                            children: [
                              SizedBox(
                                height: 160,
                                width: double.infinity,
                                child: Image.network(
                                  data?.requestDocuments?[index].docUrl ?? '',
                                  fit: BoxFit.fill,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 5),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        data?.requestDocuments?[index]
                                                .docName ??
                                            '',
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: AppTextStyle().labletext,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    CommonButtonWidget(
                                      buttonWidth: 70,
                                      buttonheight: 45,
                                      buttonColor: ColorConstants.white,
                                      buttonIconVisible: true,
                                      buttonIcon: Icon(
                                        Icons.cloud_download_outlined,
                                        color: ColorConstants.black,
                                      ),
                                      buttonTitle: '',
                                      onTap: () {
                                        context
                                            .read<DownloadDocumentBloc>()
                                            .add(DownloadDocumentFileEvent(
                                                docUrl: data
                                                        ?.requestDocuments?[
                                                            index]
                                                        .docUrl ??
                                                    '',
                                                docName: data
                                                        ?.requestDocuments?[
                                                            index]
                                                        .docName ??
                                                    ''));
                                      },
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    )
                    // CommonButtonWidget(
                    //     buttonTitle: 'Upload Document',
                    //     onTap: () {
                    //       context.push('/customer_dashboard/upload_document');
                    //     })
                  ],
                );
              }
              return Container();
            },
          ),
        ));
  }

  _textItem({required String lable, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          lable,
          style: AppTextStyle().hintText,
        ),
        Text(
          value,
          style: AppTextStyle().cardValueText,
        )
      ],
    );
  }
}
