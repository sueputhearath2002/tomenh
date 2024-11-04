import 'package:flutter/material.dart';
import 'package:tomnenh/style/assets.dart';
import 'package:tomnenh/style/colors.dart';
import 'package:tomnenh/widget/text_form_field_custom.dart';

class DropDownWidget extends StatefulWidget {
  const DropDownWidget({
    super.key,
    this.label = "",
    this.hinText = "",
    this.onTap,
    this.listItem,
  });

  final String label;
  final String hinText;
  final VoidCallback? onTap;
  final List<dynamic>? listItem;

  @override
  State<DropDownWidget> createState() => _DropDownWidgetState();
}

class _DropDownWidgetState extends State<DropDownWidget> {
  final DraggableScrollableController sheetController =
      DraggableScrollableController();

  void _showListModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          controller: sheetController,
          initialChildSize: 0.4, // Adjust for a better start size
          minChildSize: 0.2,
          maxChildSize: 0.9,
          expand: false,
          builder: (_, scrollController) => Container(
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              color: Theme.of(context).canvasColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: ListWithHeader(scrollController, widget.listItem ?? []),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextFormFieldCustom(
      titleTextField: widget.label,
      hinText: widget.hinText,
      readOnly: true,
      suffixIcon: const Icon(Icons.arrow_drop_down),
      onTap: () => _showListModal(context),
    );
  }
}

class ListWithHeader extends StatelessWidget {
  ListWithHeader(this.scrollController, this.listItem);
  List<dynamic> listItem;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Fixed Header
        Container(
          color: greenColor,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Header Text',
                style: TextStyle(
                  color: whiteColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text(
                  "Cancel",
                  style: TextStyle(color: whiteColor),
                ),
              ),
            ],
          ),
        ),
        // List Items
        Expanded(
          child: ListView.builder(
            controller: scrollController,
            itemCount: listItem.length ?? 0,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text("Item $index"),
              );
            },
          ),
        ),
      ],
    );
  }
}
