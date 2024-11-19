import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:runconnect/models/app_user.dart';
import 'package:runconnect/providers/profile_provider.dart';
import 'package:runconnect/screens/profile/profile_details.dart';
import 'package:runconnect/shared/shared_styles.dart';
import 'package:runconnect/shared/styled_text.dart';
import 'package:runconnect/theme.dart';

class EditProfile extends ConsumerStatefulWidget {
  const EditProfile({super.key});

  @override
  ConsumerState<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends ConsumerState<EditProfile> {
  final _formGlobalKey = GlobalKey<FormState>();
  TextEditingController locationInput = TextEditingController();

  // form field values
  String _newFullName = "";
  String _newUsername = "";
  String _newLocation = "";

  // used when fetching the current location of the user
  String? _currentAddress;
  Position? _currentPosition;
  bool _gettingCurrentPosition = false;

  @override
  Widget build(BuildContext context) {
    final appUser = ref.watch(profileNotifierProvider);
    AppUser? user;

    if (appUser.isNotEmpty) {
      user = appUser.first;
    }

    // get address methods TODO: refactor this so that it's in one file and it's not repeated

    // get user's permission to get their location
    Future<bool> _handleLocationPermission() async {
      bool serviceEnabled;
      LocationPermission permission;

      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
                'Location services are disabled. Please turn on location.')));
        setState(() {
          _gettingCurrentPosition = false;
        });
        return false;
      }
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Location permissions are denied')));
          return false;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
                'Location permissions are permanently denied, we cannot request permissions.')));
        return false;
      }
      return true;
    }

    // get the address from the langitude and longitude positionsFuture<void> _getAddressFromLatLng(Position position) async {
    Future<void> _getAddressFromLatLng(Position position) async {
      await placemarkFromCoordinates(
              _currentPosition!.latitude, _currentPosition!.longitude)
          .then((List<Placemark> placemarks) {
        Placemark place = placemarks[0];
        setState(() {
          _currentAddress = "${place.locality}, ${place.subAdministrativeArea}";
          locationInput.text = _currentAddress!;
        });
      }).catchError((e) {
        debugPrint(e);
      });
    }

    // get current position of the user (latitude and longitude)
    Future<void> _getCurrentPosition() async {
      setState(() {
        _gettingCurrentPosition = true;
      });

      final hasPermission = await _handleLocationPermission();
      if (!hasPermission) return;
      await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high)
          .then((Position position) {
        setState(() => _currentPosition = position);
        _getAddressFromLatLng(_currentPosition!);
      }).catchError((e) {
        debugPrint(e);
      });

      setState(() {
        _gettingCurrentPosition = false;
      });
    }

    return Scaffold(
        appBar: AppBar(
          title: const StyledTitleMedium("Edit profile"),
          backgroundColor: AppColors.primaryColor,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ProfileDetails(),
              TextButton(
                  onPressed: () {}, child: const StyledText("Change photo")),
              const SizedBox(
                height: 30,
              ),
              Form(
                  key: _formGlobalKey,
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: InputDecoration(
                            label: const StyledText("Full name"),
                            border: textFieldBorder,
                            focusedBorder: textFieldFocusedBorder),
                        onSaved: (value) {
                          if (value != null) {
                            _newFullName = value;
                          }
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),

                      // username
                      TextFormField(
                        initialValue:
                            user != null ? user.username : _newUsername,
                        decoration: InputDecoration(
                            label: const StyledText("Username"),
                            border: textFieldBorder,
                            focusedBorder: textFieldFocusedBorder),
                        onSaved: (value) {
                          if (value != null) {
                            _newUsername = value;
                          }
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),

                      // location input
                      TextFormField(
                        controller: locationInput,
                        decoration: InputDecoration(
                          suffix: _gettingCurrentPosition
                              ? const CircularProgressIndicator()
                              : null,
                          label:
                              const StyledText("Tap to get current location"),
                          border: textFieldBorder,
                          focusedBorder: textFieldFocusedBorder,
                        ),
                        readOnly: true,
                        onTap: _getCurrentPosition,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "You must enter the location of this event.";
                          } else {
                            return null;
                          }
                        },
                      ),
                    ],
                  ))
            ],
          ),
        ));
  }
}
