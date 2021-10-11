import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:map_launcher/map_launcher.dart';

class DiscrepanciesCard extends StatelessWidget {
  final String category;
  final Timestamp date;
  final List location;
  const DiscrepanciesCard(
      {Key? key,
      required this.category,
      required this.date,
      required this.location})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('MMM-dd-yyyy').format(date.toDate());
    String formattedTime = DateFormat.jm().format(date.toDate());
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        color: const Color(0xff262626),
        height: 70,
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
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                          category.length > 15
                              ? '${category.substring(0, 13)}...'
                              : category,
                          style:const  TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                    Text(formattedDate, style:const  TextStyle(color: Colors.white54),),
                    Text("at $formattedTime", style:const  TextStyle(color: Colors.white54),)
                    
                  ],
                ),
              ),
            ),
            IconButton(
                onPressed: () async {
                  await MapLauncher.showMarker(
                    mapType: MapType.google,
                    coords: Coords(location[0], location[1]),
                    title: "title",
                   
                  );
                },
                icon: const Icon(Icons.directions, color: Color(0xffFBBC04),))
          ],
        ),
      ),
    );
  }
}
