import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:runconnect/models/app_user.dart';
import 'package:runconnect/providers/profile_provider.dart';
import 'package:runconnect/screens/profile/profile_details.dart';
import 'package:runconnect/shared/shared_styles.dart';
import 'package:runconnect/shared/styled_button.dart';
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
    // for showing a snackbar after user saves profile successfully
    const snackBar = SnackBar(
      content: Text('Profile saved successfully!'),
    );

    final appUser = ref.watch(profileNotifierProvider);
    AppUser? user;

    if (appUser.isNotEmpty) {
      user = appUser.first;
    }

    // change user profile picture
    void changeProfilePicture() async {
      // choose image
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image == null) return;

      // upload to firestore if user has details had been fetched
      if (user != null) {
        final storageRef = FirebaseStorage.instance.ref();
        final imageRef = storageRef.child("${user.uid}.jpg");
        final imageBytes = await image.readAsBytes();
        await imageRef.putData(imageBytes);
      }

      // show and persist the image in the ap
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
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ProfileDetails(),
                TextButton(
                    onPressed: changeProfilePicture,
                    child: const StyledText("Change photo")),
                const SizedBox(
                  height: 30,
                ),
                Form(
                  key: _formGlobalKey,
                  child: Column(
                    children: [
                      TextFormField(
                        style: TextStyle(
                            fontFamily: "Cabin", color: AppColors.textColor),
                        initialValue:
                            user != null ? user.fullName : _newFullName,
                        decoration: InputDecoration(
                            label: const StyledText("Full name"),
                            border: textFieldBorder,
                            focusedBorder: textFieldFocusedBorder),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please input your name.";
                          }
                          return null;
                        },
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
                        style: TextStyle(
                            fontFamily: "Cabin", color: AppColors.textColor),
                        initialValue:
                            user != null ? user.username : _newUsername,
                        decoration: InputDecoration(
                            label: const StyledText("Username"),
                            border: textFieldBorder,
                            focusedBorder: textFieldFocusedBorder),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "You must input a username.";
                          }
                          if (value.trim().contains(' ')) {
                            return "Username cannot contain spaces.";
                          }
                          return null;
                        },
                        onSaved: (value) {
                          if (value != null) {
                            _newUsername = value.trim();
                          }
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),

                      // location input
                      TextFormField(
                        style: TextStyle(
                            fontFamily: "Cabin", color: AppColors.textColor),
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
                        onSaved: (value) {
                          if (value != null && value.isNotEmpty) {
                            _newLocation = value;
                          } else {
                            // if user did not input any location, keep the old value of user.location
                            if (user != null) {
                              _newLocation = user.location;
                            }
                          }
                        },
                      ),

                      const SizedBox(
                        height: 20,
                      ),
                      StyledButton(
                        text: "Save",
                        color: "blue",
                        onPressed: () {
                          if (_formGlobalKey.currentState!.validate()) {
                            _formGlobalKey.currentState!.save();

                            // update global state
                            if (user != null) {
                              user.fullName = _newFullName;
                              user.username = _newUsername;
                              user.location = _newLocation;

                              ref
                                  .read(profileNotifierProvider.notifier)
                                  .updateUser(user);

                              // show snackbar
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);

                              // go back to previous page
                              Navigator.pop(context);
                            }
                          }
                        },
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
