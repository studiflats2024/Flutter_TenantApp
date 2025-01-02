import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher_string.dart';

class StaticMapWidget extends StatelessWidget {
  final double latitude;
  final double longitude;
  final double? height;
  final String locationLink;

  const StaticMapWidget(
      {super.key,
      required this.latitude,
      required this.longitude,
        required this.locationLink,
      this.height});

  @override
  Widget build(BuildContext context) {
    final CameraPosition initialPosition = CameraPosition(
      target: LatLng(latitude, longitude),
      zoom: 16.0,
    );

    return SizedBox(
      height: height ?? 160.h,
      child: InkWell(
        onTap: _openMap,
        child: AbsorbPointer(
          absorbing: true,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: GoogleMap(
              zoomGesturesEnabled: true,
              initialCameraPosition: initialPosition,
              markers: {
                Marker(
                  markerId: const MarkerId('location'),
                  position: LatLng(latitude, longitude),
                ),
              },
              mapType: MapType.satellite,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              gestureRecognizers: {
                Factory<OneSequenceGestureRecognizer>(
                    () => ScaleGestureRecognizer()),
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _openMap() async {
   // String url = "https://maps.google.com/?q=@$latitude,$longitude";
    if (await canLaunchUrlString(locationLink)) {
      await launchUrlString(locationLink, mode: LaunchMode.externalApplication);
    }
  }
}
