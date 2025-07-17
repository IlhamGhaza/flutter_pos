import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_pos/data/models/request/delivery_request_model.dart';
import 'package:geocoding/geocoding.dart';

import '../../../../l10n/app_localizations.dart';

class DeliveryFormDialog extends StatefulWidget {
  final int orderId;
  final LatLng? selectedLocation;

  const DeliveryFormDialog({
    super.key,
    required this.orderId,
    this.selectedLocation,
  });

  @override
  State<DeliveryFormDialog> createState() => _DeliveryFormDialogState();
}

class _DeliveryFormDialogState extends State<DeliveryFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _recipientNameController = TextEditingController();
  final _recipientPhoneController = TextEditingController();
  final _recipientAddressController = TextEditingController();
  final _recipientCityController = TextEditingController();
  final _recipientStateController = TextEditingController();
  final _recipientPostalCodeController = TextEditingController();
  final _deliveryNotesController = TextEditingController();
  final _weightController = TextEditingController();

  final int _selectedDriverId = 1; // Default driver ID
  DateTime _scheduledDate = DateTime.now().add(const Duration(days: 1));
  TimeOfDay _scheduledTime = const TimeOfDay(hour: 14, minute: 0);
  bool _requiresSpecialHandling = false;

  @override
  void initState() {
    super.initState();
    if (widget.selectedLocation != null) {
      _setAddressFromCoordinates(widget.selectedLocation!);
    }
  }

  Future<void> _setAddressFromCoordinates(LatLng latLng) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latLng.latitude, latLng.longitude);
      if (placemarks.isNotEmpty) {
        final placemark = placemarks.first;
        String address = '';
        if (placemark.street != null && placemark.street!.isNotEmpty) {
          address += placemark.street!;
        }
        if (placemark.subLocality != null &&
            placemark.subLocality!.isNotEmpty) {
          address += ', ${placemark.subLocality!}';
        }
        if (placemark.locality != null && placemark.locality!.isNotEmpty) {
          address += ', ${placemark.locality!}';
        }
        if (placemark.administrativeArea != null &&
            placemark.administrativeArea!.isNotEmpty) {
          address += ', ${placemark.administrativeArea!}';
        }
        if (placemark.postalCode != null && placemark.postalCode!.isNotEmpty) {
          address += ', ${placemark.postalCode!}';
        }
        if (placemark.country != null && placemark.country!.isNotEmpty) {
          address += ', ${placemark.country!}';
        }
        _recipientAddressController.text = address;
      } else {
        _recipientAddressController.text =
            '${latLng.latitude}, ${latLng.longitude}';
      }
    } catch (e) {
      _recipientAddressController.text =
          '${latLng.latitude}, ${latLng.longitude}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context)!.deliveryForm),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _recipientNameController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.recipientName,
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context)!.recipientName;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _recipientPhoneController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.recipientPhone,
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context)!.recipientPhone;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _recipientAddressController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.recipientAddress,
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context)!.recipientAddress;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _recipientCityController,
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.recipientCity,
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppLocalizations.of(context)!.recipientCity;
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      controller: _recipientStateController,
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.recipientState,
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppLocalizations.of(context)!.recipientState;
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _recipientPostalCodeController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.recipientPostalCode,
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context)!.recipientPostalCode;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _weightController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.totalWeight,
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context)!.totalWeight;
                  }
                  if (double.tryParse(value) == null) {
                    return AppLocalizations.of(context)!.weightWarning;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ListTile(
                      title: Text(AppLocalizations.of(context)!.scheduledDate),
                      subtitle: Text(
                          '${_scheduledDate.day}/${_scheduledDate.month}/${_scheduledDate.year}'),
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: _scheduledDate,
                          firstDate: DateTime.now(),
                          lastDate:
                              DateTime.now().add(const Duration(days: 30)),
                        );
                        if (date != null) {
                          setState(() {
                            _scheduledDate = date;
                          });
                        }
                      },
                    ),
                  ),
                  Expanded(
                    child: ListTile(
                      title: Text(AppLocalizations.of(context)!.scheduledTime),
                      subtitle: Text(
                          '${_scheduledTime.hour}:${_scheduledTime.minute.toString().padLeft(2, '0')}'),
                      onTap: () async {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: _scheduledTime,
                        );
                        if (time != null) {
                          setState(() {
                            _scheduledTime = time;
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              CheckboxListTile(
                title: Text(AppLocalizations.of(context)!.specialHandling),
                value: _requiresSpecialHandling,
                onChanged: (value) {
                  setState(() {
                    _requiresSpecialHandling = value ?? false;
                  });
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _deliveryNotesController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.deliveryNotes,
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(AppLocalizations.of(context)!.cancel),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final scheduledDateTime = DateTime(
                _scheduledDate.year,
                _scheduledDate.month,
                _scheduledDate.day,
                _scheduledTime.hour,
                _scheduledTime.minute,
              );

              final deliveryRequest = DeliveryRequestModel(
                orderId: widget.orderId,
                driverId: _selectedDriverId,
                recipientName: _recipientNameController.text,
                recipientPhone: _recipientPhoneController.text,
                recipientAddress: _recipientAddressController.text,
                recipientCity: _recipientCityController.text,
                recipientState: _recipientStateController.text,
                recipientPostalCode: _recipientPostalCodeController.text,
                scheduledDeliveryDatetime: scheduledDateTime.toIso8601String(),
                totalWeight: double.parse(_weightController.text),
                requiresSpecialHandling: _requiresSpecialHandling,
                deliveryNotesCustomer: _deliveryNotesController.text.isEmpty
                    ? null
                    : _deliveryNotesController.text,
              );

              Navigator.pop(context, deliveryRequest);
            }
          },
          child: Text(AppLocalizations.of(context)!.confirm),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _recipientNameController.dispose();
    _recipientPhoneController.dispose();
    _recipientAddressController.dispose();
    _recipientCityController.dispose();
    _recipientStateController.dispose();
    _recipientPostalCodeController.dispose();
    _deliveryNotesController.dispose();
    _weightController.dispose();
    super.dispose();
  }
}
