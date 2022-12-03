import 'package:flutter/material.dart';

class CustomDatePicker extends StatelessWidget {
  const CustomDatePicker({
    Key? key,
    required this.child,
    required this.onChanged,
    this.getTime = false,
    this.years = 0,
    this.enabled,
  }) : super(key: key);

  final Widget child;
  final bool getTime;
  final bool? enabled;
  final int years;
  final Function(DateTime? dateTime) onChanged;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (enabled ?? true) {
          showDatePicker(
            context: context,
            initialDate: DateTime.now().subtract(Duration(days: 356 * years)),
            firstDate: DateTime(1940),
            lastDate: years == 0 ? DateTime.now().add(const Duration(days: 356 * 10)) : DateTime.now().subtract(Duration(days: 356 * years)),
            builder: (context, child) {
              return Theme(
                data: Theme.of(context).copyWith(
                  textTheme: TextTheme(
                    headline4: Theme.of(context).textTheme.subtitle1?.copyWith(
                          fontSize: 20.0,
                        ),
                  ),
                  colorScheme: ColorScheme.light(
                    primary: Theme.of(context).primaryColor, // header background color
                    onPrimary: Colors.white, // header text color
                    onSurface: Theme.of(context).primaryColor, // body text color
                  ),
                  textButtonTheme: TextButtonThemeData(
                    style: TextButton.styleFrom(
                      foregroundColor: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                child: child!,
              );
            },
          ).then((dateValue) {
            if (dateValue != null && getTime) {
              showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
                builder: (context, child) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      textTheme: TextTheme(
                        headline4: Theme.of(context).textTheme.subtitle1?.copyWith(
                              fontSize: 20.0,
                            ),
                      ),
                      colorScheme: ColorScheme.light(
                        primary: Theme.of(context).primaryColor, // header background color
                        onPrimary: Colors.white, // header text color
                        onSurface: Theme.of(context).primaryColor, // body text color
                      ),
                      textButtonTheme: TextButtonThemeData(
                        style: TextButton.styleFrom(
                          foregroundColor: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                    child: child!,
                  );
                },
              ).then((value) {
                // return null;
                if (value != null) {
                  onChanged(DateTime(dateValue.year, dateValue.month, dateValue.day, value.hour, value.minute));
                }
              });
            } else {
              onChanged(dateValue);
            }
          });
        }
      },
      child: child,
    );
  }
}
