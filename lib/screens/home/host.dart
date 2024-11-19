import 'package:flutter/material.dart';
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
                ],
              ),
            )));
  }
}

// REFERENCE: https://mobikul.com/date-picker-in-flutter/#:~:text=DatePicker%20is%20a%20material%20widget,by%20calling%20flutter's%20inbuilt%20function.
