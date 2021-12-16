import '../../models/estimation.dart';
import '../../screens/form_handler.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';

import '../constant.dart';

class EstimationPage extends StatefulWidget {
  final Estimation estimation;
  final YearMonth yearMonth;
  final Function increasePageNumber;
  EstimationPage({
    Key? key,
    required this.estimation,
    required this.yearMonth,
    required this.increasePageNumber,
  }) : super(key: key);

  @override
  _EstimationPageState createState() => _EstimationPageState();
}

class _EstimationPageState extends State<EstimationPage> {
  String? month;
  String? year;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    widget.increasePageNumber(2);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Stack(
        children: [
          Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Container(
              decoration:
                  BoxDecoration(border: Border.all(color: Colors.black)),
              padding: EdgeInsets.fromLTRB(10, 30, 10, 30),
              margin: EdgeInsets.fromLTRB(10, 20, 10, 20),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(
                          padding: EdgeInsets.only(right: 10),
                          child: Text(
                            "Crop",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
                          child: TextFormField(
                            initialValue: widget.estimation.crop,
                            onChanged: (value) {
                              widget.estimation.crop = value;
                            },
                            decoration: inputDecoration,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter the crop';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(
                          padding: EdgeInsets.only(right: 10),
                          child: Text(
                            "Cause of Damage",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
                          child: TextFormField(
                            initialValue: widget.estimation.causeOfDamage,
                            onChanged: (value) {
                              widget.estimation.causeOfDamage = value;
                            },
                            decoration: inputDecoration,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter the cause of damage';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(
                          padding: EdgeInsets.only(right: 10),
                          child: Text(
                            "Incident date",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: DateTimePicker(
                          decoration: inputDecoration.copyWith(
                              suffixIcon: Icon(Icons.date_range_outlined)),
                          initialValue: widget.estimation.incidentDate,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                          dateLabelText: 'Date',
                          onChanged: (value) {
                            print(value);
                            widget.estimation.incidentDate = value;
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the date';
                            }
                            return null;
                          },
                          onSaved: (val) => print(val),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(
                          padding: EdgeInsets.only(right: 10),
                          child: Text(
                            "Expected yield prior incident",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            initialValue: widget.estimation.expectedYPI,
                            onChanged: (value) {
                              widget.estimation.expectedYPI = value;
                            },
                            decoration: inputDecoration.copyWith(
                              prefix: Text("Rs."),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'You must fill this field';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(
                          padding: EdgeInsets.only(right: 10),
                          child: Text(
                            "Yield Expected month",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: DropdownButtonFormField(
                          value: widget.yearMonth.month,
                          onChanged: (String? value) {
                            setState(() {
                              widget.yearMonth.month = value;
                              widget.estimation.yieldEM =
                                  "${widget.yearMonth.month}, ${widget.yearMonth.year}";
                              print(widget.estimation.yieldEM);
                            });
                          },
                          hint: Text("Month"),
                          decoration: inputDecoration,
                          items: monthList
                              .map((month) => DropdownMenuItem(
                                  value: month, child: Text("$month")))
                              .toList(),
                          validator: (value) {
                            if (value == null) {
                              return '*Required';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        flex: 1,
                        child: DropdownButtonFormField(
                          value: widget.yearMonth.year,
                          onChanged: (String? value) {
                            setState(() {
                              widget.yearMonth.year = value;
                              widget.estimation.yieldEM =
                                  "${widget.yearMonth.month}, ${widget.yearMonth.year}";
                            });
                          },
                          hint: Text("Year"),
                          decoration: inputDecoration,
                          items: yearList
                              .map((month) => DropdownMenuItem(
                                  value: month.toString(),
                                  child: Text("$month")))
                              .toList(),
                          validator: (value) {
                            if (value == null) {
                              return '*Required';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(
                          padding: EdgeInsets.only(right: 10),
                          child: Text(
                            "Damaged Area",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
                          child: TextFormField(
                            initialValue: widget.estimation.damagedAres,
                            onChanged: (value) {
                              widget.estimation.damagedAres = value;
                            },
                            decoration: inputDecoration,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter the damaged area';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(
                          padding: EdgeInsets.only(right: 10),
                          child: Text(
                            "Your Estimation of damage",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            initialValue: widget.estimation.yourEstDmg,
                            onChanged: (value) {
                              widget.estimation.yourEstDmg = value;
                            },
                            decoration: inputDecoration.copyWith(
                              prefix: Text("Rs."),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Enter the estimation of damage';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(
                          padding: EdgeInsets.only(right: 10),
                          child: Text(
                            "Comment",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
                          child: TextFormField(
                            initialValue: widget.estimation.comment,
                            onChanged: (value) {
                              widget.estimation.comment = value;
                            },
                            maxLines: 3,
                            decoration: inputDecoration,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 30,
            top: 12,
            child: Container(
              padding: EdgeInsets.only(bottom: 5, left: 10, right: 10),
              color: Colors.white,
              child: Text(
                'Estimation',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}