import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
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
          _currentAddress =
              "${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}";
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
        body: Form(
            key: _formGlobalKey,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  // title
                  TextFormField(
                      decoration: InputDecoration(
                        icon: const Icon(Icons.title),
                        label: const StyledText("Run title"),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: AppColors.textColor)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                color: AppColors.textColor, width: 2.0)),
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
                      labelText: "Enter date",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: AppColors.textColor)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: AppColors.textColor, width: 2.0)),
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
                      labelText: "Enter time",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: AppColors.textColor)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: AppColors.textColor, width: 2.0)),
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
                  Text('LAT: ${_currentPosition?.latitude ?? ""}'),
                  Text('LNG: ${_currentPosition?.longitude ?? ""}'),
                  Text('ADDRESS: ${_currentAddress ?? ""}'),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: _getCurrentPosition,
                    child: _gettingCurrentPosition
                        ? const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: CircularProgressIndicator(),
                          )
                        : const Text("Get Current Location"),
                  )
                ],
              ),
            )));
  }
}

// REFERENCE: https://mobikul.com/date-picker-in-flutter/#:~:text=DatePicker%20is%20a%20material%20widget,by%20calling%20flutter's%20inbuilt%20function.
// REFERENCE: https://fernandoptr.medium.com/how-to-get-users-current-location-address-in-flutter-geolocator-geocoding-be563ad6f66a#1cb3
