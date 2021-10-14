import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:firebase_storage/firebase_storage.dart';

class DiscrepanciesCard extends StatefulWidget {
  final String category;
  final String docId;
  final Timestamp date;
  final List location;
  final String imageId;
  const DiscrepanciesCard(
      {Key? key,
      required this.category,
      required this.date,
      required this.location,
      required this.imageId,
      required this.docId})
      : super(key: key);

  @override
  State<DiscrepanciesCard> createState() => _DiscrepanciesCardState();
}

class _DiscrepanciesCardState extends State<DiscrepanciesCard> {
  FirebaseStorage storage = FirebaseStorage.instance;
  FirebaseFirestore fbfs = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    String formattedDate =
        DateFormat('MMM-dd-yyyy').format(widget.date.toDate());
    String formattedTime = DateFormat.jm().format(widget.date.toDate());
    return InkWell(
      onLongPress: () {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("Delete?"),
                content: Text("Are you sure ?"),
                actions: [
                  TextButton.icon(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.cancel),
                    label: const Text("Cancel"),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      fbfs
                          .collection("discrepancies")
                          .doc(widget.docId)
                          .delete();
                      storage.ref(widget.imageId).delete();
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.delete),
                    label: const Text("Delete"),
                  ),
                ],
              );
            });
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          color: const Color(0xff262626),
          height: 70,
          child: Row(
            children: [
              Expanded(
                flex: 5,
                child: FutureBuilder(
                    future: storage.ref(widget.imageId).getDownloadURL(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        return CachedNetworkImage(
                          imageUrl: snapshot.data,
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) => Center(
                            child: SizedBox(
                              width: 30,
                              height: 30,
                              child: CircularProgressIndicator(
                                  value: downloadProgress.progress),
                            ),
                          ),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        );
                      }
                      return const SizedBox(
                          height: 40,
                          width: 40,
                          child: CircularProgressIndicator());
                    }),
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
                            widget.category.length > 15
                                ? '${widget.category.substring(0, 13)}...'
                                : widget.category,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                      Text(
                        formattedDate,
                        style: const TextStyle(color: Colors.white54),
                      ),
                      Text(
                        "at $formattedTime",
                        style: const TextStyle(color: Colors.white54),
                      )
                    ],
                  ),
                ),
              ),
              IconButton(
                  onPressed: () async {
                    await MapLauncher.showMarker(
                      mapType: MapType.google,
                      coords: Coords(widget.location[0], widget.location[1]),
                      title: "title",
                    );
                  },
                  icon: const Icon(
                    Icons.directions,
                    color: Color(0xffFBBC04),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
