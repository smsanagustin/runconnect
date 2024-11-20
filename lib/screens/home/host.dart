import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:runconnect/models/app_user.dart';
import 'package:runconnect/models/event_visibility.dart';
import 'package:runconnect/models/run_event.dart';
import 'package:runconnect/models/run_type.dart';
import 'package:runconnect/providers/profile_provider.dart';
import 'package:runconnect/services/event_firestore.dart';
import 'package:runconnect/shared/shared_styles.dart';
import 'package:runconnect/shared/styled_text.dart';
import 'package:runconnect/theme.dart';
import 'package:uuid/uuid.dart';

class HostScreen extends ConsumerStatefulWidget {
  const HostScreen({super.key});

  @override
  ConsumerState<HostScreen> createState() => _HostScreenState();
}

class _HostScreenState extends ConsumerState<HostScreen> {
  // where form values are saved to create an instance of the object
  String _eventTitle = "";
  String _eventMeetupPlace = "";
  int _distance = 0;
  int _numberOfParticipants = 0;

  // stores the date and time picked by the user so we can output it on the form
  TextEditingController dateInput = TextEditingController();
  TextEditingController timeInput = TextEditingController();
  TextEditingController locationInput = TextEditingController();
  String _selectedRunType = RunTypes.shortRun.title;
  String _selectedVisibility = EventVisibility.public.visibility;

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
    // snackbar that shows after run is saved
    const snackBar = SnackBar(
      content: Text('Run created!'),
    );

    // get logged in user
    final appUser = ref.watch(profileNotifierProvider);
    AppUser? user;

    // set app user
    if (appUser.isNotEmpty) {
      user = appUser.first;
    }

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
                    if (_formGlobalKey.currentState!.validate()) {
                      _formGlobalKey.currentState!.save();

                      // create new RunEvent object then save to user profile and to firestore                     RunEvent newEvent = RunEvent(
                      if (user != null) {
                        String newEventId = const Uuid().v4();
                        RunEvent newEvent = RunEvent(
                            id: newEventId,
                            creatorId: user.uid,
                            title: _eventTitle,
                            location: locationInput.text,
                            meetupPlace: _eventMeetupPlace,
                            time: timeInput.text,
                            date: dateInput.text,
                            runType: _selectedRunType,
                            visibility: _selectedVisibility,
                            distance: _distance,
                            numberOfParticipants: _numberOfParticipants);

                        // save to user and firestore
                        user.addCreatedEventId(newEventId);
                        ref
                            .read(profileNotifierProvider.notifier)
                            .updateUser(user);

                        EventFirestoreService.addEvent(newEvent);
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        _formGlobalKey.currentState!.reset();

                        // TODO: redirect the user to the screen of this event; pop for now
                      }
                    }
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
                    const StyledTitleMedium("Details"),
                    const SizedBox(
                      height: 10,
                    ),
                    // title
                    TextFormField(
                      style: TextStyle(
                          fontFamily: "Cabin", color: AppColors.textColor),
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
                      },
                      onSaved: (value) {
                        if (value != null) {
                          _eventTitle = value;
                        }
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      style: TextStyle(
                          fontFamily: "Cabin", color: AppColors.textColor),
                      controller: dateInput,
                      decoration: InputDecoration(
                        icon: const Icon(Icons.calendar_today),
                        label: const StyledText("Enter date"),
                        border: textFieldBorder,
                        focusedBorder: textFieldFocusedBorder,
                      ),

                      // stores value to dateInput.text
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
                      height: 10,
                    ),

                    // stores value to timeInput.text
                    TextFormField(
                      style: TextStyle(
                          fontFamily: "Cabin", color: AppColors.textColor),
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
                      height: 10,
                    ),

                    // stores value to locationInput.text
                    TextFormField(
                      style: TextStyle(
                          fontFamily: "Cabin", color: AppColors.textColor),
                      controller: locationInput,
                      decoration: InputDecoration(
                        icon: _gettingCurrentPosition
                            ? const CircularProgressIndicator()
                            : const Icon(Icons.location_on),
                        label: const StyledText("Tap to get current location"),
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
                      height: 10,
                    ),

                    TextFormField(
                      style: TextStyle(
                          fontFamily: "Cabin", color: AppColors.textColor),
                      decoration: InputDecoration(
                        icon: const Icon(Icons.location_on),
                        label: const StyledText("Meetup place"),
                        border: textFieldBorder,
                        focusedBorder: textFieldFocusedBorder,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "You must add a meetup place.";
                        }
                        return null;
                      },
                      onSaved: (value) {
                        if (value != null) {
                          _eventMeetupPlace = value;
                        }
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const StyledTitleMedium("Distance"),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      style: TextStyle(
                          fontFamily: "Cabin", color: AppColors.textColor),
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
                      },
                      onSaved: (value) {
                        if (value != null) {
                          _distance = int.parse(value);
                        }
                      },
                    ),

                    const SizedBox(
                      height: 10,
                    ),

                    // type of run (dropdown)
                    // stored in _selectedRunType
                    DropdownButtonFormField(
                      value: _selectedRunType,
                      decoration: InputDecoration(
                        icon: const Icon(Icons.edit_attributes),
                        label: const StyledText("Select run type"),
                        border: textFieldBorder,
                        focusedBorder: textFieldFocusedBorder,
                      ),
                      items: RunTypes.values.map((runType) {
                        return DropdownMenuItem(
                          value: runType.title,
                          child: StyledText(runType.title),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _selectedRunType = value;
                          });
                        }
                      },
                    ),

                    const SizedBox(
                      height: 20,
                    ),
                    const StyledTitleMedium("Participants"),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      style: TextStyle(
                          fontFamily: "Cabin", color: AppColors.textColor),
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        icon: const Icon(Icons.groups),
                        label: const StyledText("How many can join? (1-100)"),
                        border: textFieldBorder,
                        focusedBorder: textFieldFocusedBorder,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "You must input a value";
                        }
                        final numberOfParticipants = int.tryParse(value);
                        if (numberOfParticipants! < 1 ||
                            numberOfParticipants > 100) {
                          return "Only 1-100 particpants for each run is allowed";
                        }
                        return null;
                      },
                      onSaved: (value) {
                        if (value != null) {
                          _numberOfParticipants = int.parse(value);
                        }
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),

                    // type of run (dropdown)
                    // stored in selectedVisibility
                    DropdownButtonFormField(
                      value: _selectedVisibility,
                      decoration: InputDecoration(
                        icon: _selectedVisibility ==
                                EventVisibility.public.visibility
                            ? const Icon(Icons.public)
                            : const Icon(Icons.lock),
                        label: const StyledText("Who can see?"),
                        border: textFieldBorder,
                        focusedBorder: textFieldFocusedBorder,
                      ),
                      items: EventVisibility.values.map((eventVisibility) {
                        return DropdownMenuItem(
                          value: eventVisibility.visibility,
                          child: StyledText(eventVisibility.visibility),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _selectedVisibility = value;
                          });
                        }
                      },
                    ),
                  ],
                ),
              )),
        ));
  }
}

// REFERENCE: https://mobikul.com/date-picker-in-flutter/#:~:text=DatePicker%20is%20a%20material%20widget,by%20calling%20flutter's%20inbuilt%20function.
// REFERENCE: https://fernandoptr.medium.com/how-to-get-users-current-location-address-in-flutter-geolocator-geocoding-be563ad6f66a#1cb3
