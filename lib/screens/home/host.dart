import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:runconnect/models/run_type.dart';
import 'package:runconnect/shared/shared_styles.dart';
import 'package:runconnect/shared/styled_text.dart';
import 'package:runconnect/theme.dart';

class HostScreen extends StatefulWidget {
  const HostScreen({super.key});

  @override
  State<HostScreen> createState() => _HostScreenState();
}

class _HostScreenState extends State<HostScreen> {
  // stores the date and time picked by the user
  TextEditingController dateInput = TextEditingController();
  TextEditingController timeInput = TextEditingController();
  TextEditingController locationInput = TextEditingController();

  // stores current address and position
  String? _currentAddress;
  Position? _currentPosition;
  bool _gettingCurrentPosition = false;

  @override
  void initState() {
    dateInput.text = ""; //set the initial value of text field
    timeInput.text = "";
    super.initState();
  }

  // used to control the form
  final _formGlobalKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
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
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const StyledTitleMedium("Host a new run"),
              TextButton(
                  onPressed: () {
                    _formGlobalKey.currentState!.validate();
                  },
                  child: const StyledText("Save"))
            ],
          ),
          backgroundColor: AppColors.primaryColor,
        ),
        body: SingleChildScrollView(
          child: Form(
              key: _formGlobalKey,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // title
                    TextFormField(
                        decoration: InputDecoration(
                          icon: const Icon(Icons.title),
                          label: const StyledText("Run title"),
                          border: textFieldBorder,
                          focusedBorder: textFieldFocusedBorder,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Your event must have a name.";
                          }
                          return null;
                        }),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: dateInput,
                      decoration: InputDecoration(
                        icon: const Icon(Icons.calendar_today),
                        label: const StyledText("Enter date"),
                        border: textFieldBorder,
                        focusedBorder: textFieldFocusedBorder,
                      ),
                      readOnly: true,
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate:
                                DateTime.now().add(const Duration(days: 1)),
                            firstDate:
                                DateTime.now().add(const Duration(days: 1)),
                            lastDate: DateTime(2100));
                        if (pickedDate != null) {
                          setState(() {
                            // format the date picked by the user and store it
                            dateInput.text =
                                DateFormat('yyyy-MM-dd').format(pickedDate);
                          });
                        }
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Your event must have a date.";
                        } else {
                          return null;
                        }
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: timeInput,
                      decoration: InputDecoration(
                        icon: const Icon(Icons.schedule),
                        label: const StyledText("Enter time"),
                        border: textFieldBorder,
                        focusedBorder: textFieldFocusedBorder,
                      ),
                      readOnly: true,
                      onTap: () async {
                        TimeOfDay? pickedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (pickedTime != null) {
                          setState(() {
                            // format the time picked by the user and store it
                            setState(() {
                              timeInput.text = pickedTime.format(context);
                            });
                          });
                        }
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Your event must have a time.";
                        } else {
                          return null;
                        }
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),

                    // location
                    TextFormField(
                      controller: locationInput,
                      decoration: InputDecoration(
                        icon: const Icon(Icons.location_on),
                        label: _gettingCurrentPosition
                            ? const CircularProgressIndicator()
                            : const StyledText("Tap to get current location"),
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

                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        icon: const Icon(Icons.location_on),
                        label: const StyledText("Meetup place"),
                        border: textFieldBorder,
                        focusedBorder: textFieldFocusedBorder,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const StyledTitleMedium("Distance"),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          icon: const Icon(Icons.directions_run),
                          label: const StyledText("Enter distance (in km)"),
                          border: textFieldBorder,
                          focusedBorder: textFieldFocusedBorder,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "You must specify the distance.";
                          }
                          return null;
                        }),

                    // type of run (dropdown)
                    DropdownButtonFormField(
                      decoration: InputDecoration(
                        icon: const Icon(Icons.edit_attributes),
                        label: const StyledText("Select run type"),
                        border: textFieldBorder,
                        focusedBorder: textFieldFocusedBorder,
                      ),
                      items: RunTypes.values.map((runType) {
                        return DropdownMenuItem(
                          value: runType.title,
                          child: Text(runType.title),
                        );
                      }).toList(),
                      onChanged: (value) {},
                    ),
                  ],
                ),
              )),
        ));
  }
}

// REFERENCE: https://mobikul.com/date-picker-in-flutter/#:~:text=DatePicker%20is%20a%20material%20widget,by%20calling%20flutter's%20inbuilt%20function.
// REFERENCE: https://fernandoptr.medium.com/how-to-get-users-current-location-address-in-flutter-geolocator-geocoding-be563ad6f66a#1cb3
