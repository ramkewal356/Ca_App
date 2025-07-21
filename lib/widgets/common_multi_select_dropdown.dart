import 'package:ca_app/utils/constanst/colors.dart';
import 'package:ca_app/utils/constanst/text_style.dart';
import 'package:flutter/material.dart';

class CommonMultiSelectDropdown extends StatefulWidget {
  final List<String> options;
  final Map<String, String>? initialSelected;
  final void Function(Map<String, String> value)? onChanged;
  final String hint;
  const CommonMultiSelectDropdown({
    super.key,
    required this.options,
    this.initialSelected,
    this.onChanged,
    this.hint = 'Select qualification(s)',
  });

  @override
  State<CommonMultiSelectDropdown> createState() =>
      _CommonMultiSelectDropdownState();
}

class _CommonMultiSelectDropdownState extends State<CommonMultiSelectDropdown> {
  final List<String> _selected = []; // qualifications
  final Map<String, TextEditingController> _controllers = {}; // uni inputs
  @override
  void initState() {
    super.initState();

    // ── preload existing values ───────────────────────────────
    if (widget.initialSelected != null) {
      widget.initialSelected!.forEach((deg, uni) {
        _selected.add(deg);
        _controllers[deg] = TextEditingController(text: uni);
      });
    }
  }

  @override
  void dispose() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── 1. field that OPENS the picker ───────────────────────────────
        TextField(
          readOnly: true,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            border: const OutlineInputBorder(),
            hintText: widget.hint,
            hintStyle: AppTextStyle().hintText,
            suffixIcon: Icon(
              Icons.keyboard_arrow_down_outlined,
              color: ColorConstants.darkGray,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(
                color: ColorConstants.darkGray,
                // width: 2.0,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(
                color: ColorConstants.darkGray,
                // width: 2.0,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(
                color: ColorConstants.darkGray,
                // width: 2.0,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(
                color: ColorConstants.darkGray,
                // width: 2.0,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(
                color: ColorConstants.darkGray,
                // color: redColor,
                // width: 2.0,
              ),
            ),
          ),
          onTap: _openQualificationDialog,
        ),
        // InkWell(
        //   borderRadius: BorderRadius.circular(6),
        //   onTap: _openQualificationDialog,
        //   child: InputDecorator(
        //     decoration: InputDecoration(
        //       contentPadding:
        //           EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        //       border: const OutlineInputBorder(),
        //       hintText: widget.hint,
        //     ),
        //     child: Text(widget.hint),
        //     // child: Text(
        //     //   _selected.isEmpty ? ' ' : _selected.join(', '),
        //     //   style: TextStyle(
        //     //     color: _selected.isEmpty ? Theme.of(context).hintColor : null,
        //     //   ),
        //     // ),
        //   ),
        // ),

        _selected.isEmpty ? SizedBox.shrink() : const SizedBox(height: 10),

        // ── 2. dynamic list of "qualification + university" rows ─────────
        ..._selected.map((q) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  // badge with qualification name
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                              child: Text(
                            q,
                            overflow: TextOverflow.ellipsis,
                          )),
                          const SizedBox(width: 4),
                          // delete / untick button
                          GestureDetector(
                            onTap: () => _toggleQualification(q),
                            child: const Icon(Icons.close, size: 16),
                          )
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(width: 8),

                  // matching university input
                  Expanded(
                    child: TextField(
                      controller: _controllers[q],
                      decoration: const InputDecoration(
                        hintText: 'University',
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                      onChanged: (_) => _emit(),
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }

  void _openQualificationDialog() {
    showDialog(
      context: context,
      builder: (ctx) {
        // use StatefulBuilder to update checkboxes live inside the dialog
        return StatefulBuilder(
          builder: (ctx, setStateDialog) {
            return AlertDialog(
              insetPadding: EdgeInsets.all(20),
              backgroundColor: ColorConstants.white,
              title: Text(widget.hint),
              content: SizedBox(
                width: double.maxFinite,
                height: 400,
                child: ListView(
                  children: widget.options
                      .map((q) => CheckboxListTile(
                            controlAffinity: ListTileControlAffinity.leading,
                            visualDensity:
                                VisualDensity(horizontal: -4, vertical: -4),
                            dense: true,
                            contentPadding: EdgeInsets.zero,
                            value: _selected.contains(q),
                            activeColor: ColorConstants.buttonColor,
                            title: Text(q),
                            onChanged: (_) {
                              // keep dialog UI in sync + real widget state
                              setStateDialog(() => _toggleQualification(q));
                            },
                          ))
                      .toList(),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: Navigator.of(ctx).pop,
                  child: const Text('Done'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // ──────────────────────────────────────────────────────────────────────────
  // HELPERS
  // ──────────────────────────────────────────────────────────────────────────
  void _toggleQualification(String q) {
    setState(() {
      if (_selected.contains(q)) {
        _selected.remove(q);
        _controllers.remove(q)?.dispose();
      } else {
        _selected.add(q);
        _controllers[q] = TextEditingController();
      }
      _emit();
    });
  }

  void _emit() {
    if (widget.onChanged == null) return;
    final map = {
      for (final q in _selected) q: _controllers[q]!.text,
    };
    widget.onChanged!(map);
  }
}
