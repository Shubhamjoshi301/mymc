import 'package:flutter/material.dart';

class CategoryDropdown extends StatefulWidget {
  String category = "Category";

  CategoryDropdown({Key? key}) : super(key: key);

  @override
  State<CategoryDropdown> createState() => _CategoryDropdownState();
}

class _CategoryDropdownState extends State<CategoryDropdown> {
  bool _isExpanded = false;
  // String category =;
  String category1 = "Category";
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isExpanded = !_isExpanded;
        });
      },
      child: AnimatedContainer(
        curve: Curves.decelerate,
        duration: const Duration(milliseconds: 500),
        margin: const EdgeInsets.symmetric(vertical: 5),
        height: _isExpanded ? 250 : 55,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.grey[200],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Text(
                    category1,
                    textAlign: TextAlign.center,
                  ),
                ),
                RotatedBox(
                  quarterTurns: _isExpanded ? 2 : 0,
                  child: const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 35,
                  ),
                ),
              ],
            ),
            if (_isExpanded)
              FutureBuilder(
                  future: Future.delayed(const Duration(milliseconds: 100)),
                  builder: (c, s) => s.connectionState == ConnectionState.done
                      ? Column(
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  widget.category = "Roads";
                                  category1 = widget.category;
                                  _isExpanded = !_isExpanded;
                                });
                              },
                              child: Row(
                                children: const [
                                  Text("Roads"),
                                ],
                              ),
                            ),
                          ],
                        )
                      : const SizedBox())
            else
              const SizedBox(),
          ],
        ),
      ),
    );
  }
}
