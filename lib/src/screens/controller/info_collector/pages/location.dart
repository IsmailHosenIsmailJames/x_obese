import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:x_obese/src/core/location_service/location_service.dart';
import 'package:x_obese/src/screens/controller/info_collector/controller/all_info_controller.dart';
import 'package:x_obese/src/theme/colors.dart';
import 'package:x_obese/src/widgets/back_button.dart';
import 'package:x_obese/src/widgets/text_input_decoration.dart';

class LocationCollector extends StatefulWidget {
  final PageController pageController;

  const LocationCollector({super.key, required this.pageController});

  @override
  State<LocationCollector> createState() => _LocationCollectorState();
}

class _LocationCollectorState extends State<LocationCollector> {
  final AllInfoController controller = Get.find();
  Completer<GoogleMapController> _googleMapController =
      Completer<GoogleMapController>();
  @override
  void initState() {
    initialCalls();
    super.initState();
  }

  Set<Marker> markers = {};

  void initialCalls() async {
    Position? position = await LocationService.getUserLocation();
    if (position != null) {
      if (_googleMapController.isCompleted) {
        GoogleMapController controller = await _googleMapController.future;
        controller.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(position.latitude, position.longitude),
              zoom: 14,
            ),
          ),
        );
      }
      String address = LocationService.getAddressString(
        await LocationService.getAddressPlacemark(
          LatLng(position.latitude, position.longitude),
        ),
      );
      markers = {
        Marker(
          markerId: const MarkerId('location'),
          position: LatLng(position.latitude, position.longitude),
          infoWindow: const InfoWindow(title: 'Your Location'),
        ),
      };
      controller.allInfo.value.address = address;
      addressController.text = address;
      setState(() {});
    }
  }

  TextEditingController addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyAppColors.primary,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,

            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: getBackButton(context, () {
                        widget.pageController.previousPage(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeIn,
                        );
                      }),
                    ),
                    const Gap(32),
                    LinearProgressIndicator(
                      value: ((widget.pageController.page ?? 0) + 1) / 5,
                      borderRadius: BorderRadius.circular(7),
                      color: MyAppColors.third,
                    ),
                    const Gap(15),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        height: 200,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: MyAppColors.transparentGray,
                        ),
                        child: GoogleMap(
                          onMapCreated: (GoogleMapController controller) {
                            if (_googleMapController.isCompleted) {
                              _googleMapController =
                                  Completer<GoogleMapController>();
                              _googleMapController.complete(controller);
                            } else {
                              _googleMapController.complete(controller);
                            }
                          },

                          onTap: (latLng) async {
                            String address = LocationService.getAddressString(
                              await LocationService.getAddressPlacemark(latLng),
                            );
                            markers = {};
                            markers = {
                              Marker(
                                markerId: MarkerId(
                                  Random().nextInt(10000).toString(),
                                ),
                                position: latLng,
                                infoWindow: const InfoWindow(
                                  title: 'Your Location',
                                ),
                                icon: BitmapDescriptor.defaultMarkerWithHue(
                                  BitmapDescriptor.hueRed,
                                ),
                                visible: true,
                              ),
                            };
                            controller.allInfo.value.address = address;
                            addressController.text = address;
                            setState(() {});
                          },
                          markers: markers,
                          myLocationButtonEnabled: true,
                          myLocationEnabled: true,
                          zoomControlsEnabled: false,
                          mapType: MapType.normal,
                          initialCameraPosition: const CameraPosition(
                            target: LatLng(23.8041, 90.4152),
                            zoom: 12,
                          ),
                        ),
                      ),
                    ),
                    const Gap(20),
                    const Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'What’s Your Location?',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const Gap(32),
                    TextFormField(
                      controller: addressController,
                      decoration: getTextInputDecoration(
                        context,
                        hintText: 'Enter Home Address',
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              SizedBox(
                height: 51,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (controller.allInfo.value.address != null &&
                        controller.allInfo.value.address!.isNotEmpty) {
                      widget.pageController.jumpToPage(5);
                    }
                  },
                  child: const Text(
                    'Next',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
