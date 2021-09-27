import 'package:flutter/material.dart';

class DiscrepanciesCard extends StatelessWidget {
  final String category;
  final DateTime date;

  const DiscrepanciesCard({Key? key, required this.category, required this.date})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 110,
      child: Row(
        children: [
          const Expanded(
            flex: 5,
            child: Placeholder(),
          ),
          Expanded(
            flex: 6,
            child: Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        height: 8,
                        width: 8,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xff61BF1A),
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        category.length > 15 ? '${category.substring(0, 13)}...' : category,
                        // style: TextStyles.mb16,
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 90,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding( 
                          padding: const EdgeInsets.only(top: 2.0),
                          child: Row(
                            children: const [
                              Text(""),
                              SizedBox(
                                width: 3,
                              ),
                              Text(""),
                            ],
                          ),
                        ),
                        const Text(""),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
