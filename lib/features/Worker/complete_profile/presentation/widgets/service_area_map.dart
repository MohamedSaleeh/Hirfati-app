import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:reactive_forms/reactive_forms.dart';
import '../../../../../translations.dart';

class ServiceAreaMap extends StatefulWidget {
  final String latControlName;
  final String lngControlName;

  const ServiceAreaMap({
    super.key,
    required this.latControlName,
    required this.lngControlName,
  });

  @override
  State<ServiceAreaMap> createState() => _ServiceAreaMapState();
}

class _ServiceAreaMapState extends State<ServiceAreaMap> {
  // الإحداثيات الافتراضية (الجزائر)
  static const LatLng _defaultLocation = LatLng(36.7525, 3.04197);

  GoogleMapController? _mapController;
  late LatLng _initialLocation;
  LatLng? _selectedLocation;
  late FormControl<double> _latControl;
  late FormControl<double> _lngControl;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // الحصول على FormGroup من السياق
    final form = ReactiveForm.of(context) as FormGroup;

    _latControl = form.control(widget.latControlName) as FormControl<double>;
    _lngControl = form.control(widget.lngControlName) as FormControl<double>;

    if (_latControl.value != null && _lngControl.value != null) {
      _selectedLocation = LatLng(_latControl.value!, _lngControl.value!);
    } else {
      _selectedLocation = _defaultLocation;
      _updateControls(_defaultLocation);
    }

    _initialLocation =
        _selectedLocation!; // سيتم استخدامها في initialCameraPosition
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;

    // بعد إنشاء الخريطة، تحريك الكاميرا إلى الموقع الحالي إذا متاح
    if (_selectedLocation != null) {
      _mapController!.animateCamera(CameraUpdate.newLatLng(_selectedLocation!));
    }
  }

  void _onTap(LatLng location) {
    setState(() {
      _selectedLocation = location;
    });

    _updateControls(location);

    if (_mapController != null) {
      _mapController!.animateCamera(CameraUpdate.newLatLng(location));
    }
  }

  void _updateControls(LatLng location) {
    _latControl.value = location.latitude;
    _lngControl.value = location.longitude;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Service Area'.i18n,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        Text(
          'Tap on the map to set your location.'.i18n,
          style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
        ),
        const SizedBox(height: 12),
        Container(
          height: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          clipBehavior: Clip.antiAlias,
          child: GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _initialLocation,
              zoom: 12,
            ),
            onTap: _onTap,
            markers: _selectedLocation != null
                ? {
                    Marker(
                      markerId: const MarkerId('service_location'),
                      position: _selectedLocation!,
                    ),
                  }
                : {},
            zoomControlsEnabled: false,
            myLocationEnabled: false,
            myLocationButtonEnabled: false,
          ),
        ),
      ],
    );
  }
}
