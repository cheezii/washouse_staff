import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomTimerPicker extends StatefulWidget {
  late final TimeOfDay intiTime;
  late final TimeOfDay maxTime;

  final Function(int selectedHour, int selectedMinute) onChanged;
  CustomTimerPicker({
    Key? key,
    required this.onChanged,
    TimeOfDay? intiTimeOfDay,
    TimeOfDay? maxTimeOfDay,
  }) : super(key: key) {
    intiTime = intiTimeOfDay ?? TimeOfDay.now();
    maxTime = maxTimeOfDay ?? TimeOfDay(hour: 23, minute: 59);
  }

  @override
  State<CustomTimerPicker> createState() => _CustomTimerPickerState();
}

class _CustomTimerPickerState extends State<CustomTimerPicker> {
  late int selectedHour;
  late int selectedMinutes;

  @override
  void initState() {
    super.initState();
    selectedHour = widget.intiTime.hour;
    selectedMinutes = widget.intiTime.minute;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // hour picker
        SizedBox(
          width: kToolbarHeight,
          child: CupertinoPicker(
            // backgroundColor: Colors.cyanAccent, //bg Color
            itemExtent: 50,
            onSelectedItemChanged: (v) {
              setState(() {
                selectedHour = v + widget.intiTime.hour;
              });
              widget.onChanged(
                selectedHour,
                selectedMinutes,
              );
            },
            children: List.generate(
              widget.maxTime.hour - widget.intiTime.hour + 1,
              (index) => Center(
                child: Text(
                  "${index + widget.intiTime.hour}",
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),

        //minute Picker
        SizedBox(
          width: kToolbarHeight,
          child: selectedHour == widget.intiTime.hour // add this condition to disable minute picker
              ? CupertinoPicker(
                  itemExtent: 50,
                  onSelectedItemChanged: (v) {
                    setState(() {
                      selectedMinutes = v + widget.intiTime.minute;
                    });
                    widget.onChanged(
                      selectedHour,
                      selectedMinutes,
                    );
                  },
                  children: List.generate(
                    60 - widget.intiTime.minute,
                    (index) => Center(
                      child: Text(
                        "${index + widget.intiTime.minute}",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                )
              : ((selectedHour == widget.maxTime.hour)
                  ? CupertinoPicker(
                      itemExtent: 50,
                      onSelectedItemChanged: (v) {
                        setState(() {
                          selectedMinutes = v + 0;
                        });
                        widget.onChanged(
                          selectedHour,
                          selectedMinutes,
                        );
                      },
                      children: List.generate(
                        widget.maxTime.minute + 1,
                        (index) => Center(
                          child: Text(
                            "${index}",
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    )
                  : CupertinoPicker(
                      itemExtent: 50,
                      onSelectedItemChanged: (v) {
                        setState(() {
                          selectedMinutes = v + 0;
                        });
                        widget.onChanged(
                          selectedHour,
                          selectedMinutes,
                        );
                      },
                      children: List.generate(
                        60,
                        (index) => Center(
                          child: Text(
                            "${index}",
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    )),
        ),
      ],
    );
  }
}
