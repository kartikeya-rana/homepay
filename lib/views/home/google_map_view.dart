import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import "package:google_maps_webservice/places.dart";
import "package:google_maps_webservice/geocoding.dart";
import 'package:homepay/constants/colors_constants.dart';
import 'package:uuid/uuid.dart';

const String mapApi = "AIzaSyBCOL9oaWYV4ud5dqQ3KeC84te1apESSVg";
final places = GoogleMapsPlaces(apiKey: mapApi);
final geocoding = GoogleMapsGeocoding(apiKey: mapApi);
final uuid = Uuid();

class GoogleMapView extends StatefulWidget {
  const GoogleMapView({Key? key, required this.addressLatLng})
      : super(key: key);

  final ValueChanged<GeoPoint> addressLatLng;

  @override
  State<GoogleMapView> createState() => _GoogleMapViewState();
}

class _GoogleMapViewState extends State<GoogleMapView> {
  late GoogleMapController mapController;
  CameraPosition? cameraPosition;
  LatLng location = const LatLng(37.4207612, -122.0816848);

  late TextEditingController _textController;
  final _textFocusNode = FocusNode();
  OverlayEntry? overlayEntry;
  final layerLink = LayerLink();
  bool _showOverlay = true;
  String placeId = '';

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((_) => showPlaceOverlay([]));
    _textController = TextEditingController();

    super.initState();
  }

  void showPlaceOverlay(List<Prediction> predictions) {
    if (overlayEntry != null) {
      hidePlaceOverlay();
    }

    final rendexBox = context.findRenderObject() as RenderBox;
    final size = rendexBox.size;

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          link: layerLink,
          showWhenUnlinked: false,
          offset: Offset(0, size.height - 292),
          child: buildOverlay(predictions),
        ),
      ),
    );
    Overlay.of(context)?.insert(overlayEntry!);
  }

  void hidePlaceOverlay() {
    overlayEntry?.remove();
    overlayEntry = null;
  }

  Future<LatLng?> getLocation(String placeId) async {
    final resp = await geocoding.searchByPlaceId(placeId);
    if (resp.isOkay) {
      final lat = resp.results.first.geometry.location.lat;
      final lng = resp.results.first.geometry.location.lng;
      return LatLng(lat, lng);
    } else {
      return null;
    }
  }

  Widget buildOverlay(List<Prediction> predictions) {
    return Material(
      color: Colors.white,
      child: ListView.builder(
          padding: const EdgeInsets.all(0),
          shrinkWrap: true,
          itemCount: predictions.length,
          itemBuilder: ((context, index) {
            return ListTile(
              title: Text(predictions[index].description.toString()),
              onTap: () async {
                _textController.text =
                    predictions[index].description.toString();
                placeId = predictions[index].placeId.toString();

                hidePlaceOverlay();

                final latLng = await getLocation(placeId);
                if (latLng != null) {
                  location = latLng;
                  widget.addressLatLng(
                      GeoPoint(latLng.latitude, latLng.longitude));
                  mapController.animateCamera(CameraUpdate.newCameraPosition(
                      CameraPosition(target: location, zoom: 14)));
                }
                setState(() {});
              },
            );
          })),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: layerLink,
      child: Column(children: [
        TextField(
            focusNode: _textFocusNode,
            controller: _textController,
            decoration: const InputDecoration(
                labelText: 'Location',
                icon: Icon(
                  Icons.near_me,
                  color: Colors.white,
                ),
                labelStyle: TextStyle(color: Colors.white)),
            style: const TextStyle(color: secondaryColor),
            onTap: () {
              setState(() {
                _showOverlay = true;
              });
            },
            onChanged: _showOverlay
                ? (value) async {
                    if (value == '' && overlayEntry != null) {
                      hidePlaceOverlay();
                    }

                    final sessionToken = uuid.v4();
                    final res = await places.autocomplete(value,
                        sessionToken: sessionToken);

                    if (res.isOkay & res.predictions.isNotEmpty) {
                      showPlaceOverlay(res.predictions);
                    }
                  }
                : null),
        SizedBox(
          height: 300,
          child: GoogleMap(
            //Map widget from google_maps_flutter package
            zoomGesturesEnabled: true, //enable Zoom in, out on map
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            initialCameraPosition: CameraPosition(
              //innital position in map
              target: location, //initial position
              zoom: 13.0, //initial zoom level
            ),
            markers: {
              Marker(markerId: const MarkerId('1'), position: location)
            },
            mapType: MapType.normal,
            //map type
            onMapCreated: (controller) {
              //method called when map is created
              setState(() {
                mapController = controller;
              });
            },
          ),
        ),
      ]),
    );
  }
}
