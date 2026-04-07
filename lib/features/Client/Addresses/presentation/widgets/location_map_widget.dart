import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import '../../../../../translations.dart';

class LocationMapWidget extends StatefulWidget {
  final Function(LatLng) onLocationSelected;
  final Function(String latitude, String longitude) onCoordinatesChanged;

  const LocationMapWidget({
    super.key,
    required this.onLocationSelected,
    required this.onCoordinatesChanged,
  });

  @override
  State<LocationMapWidget> createState() => _LocationMapWidgetState();
}

class _LocationMapWidgetState extends State<LocationMapWidget> {
  GoogleMapController? _mapController;
  LatLng? _selectedLocation;
  Set<Marker> _markers = {};
  bool _mapLoaded = false;

  static const LatLng _defaultLocation = LatLng(24.7136, 46.6753);
  static const CameraPosition _defaultCameraPosition = CameraPosition(
    target: _defaultLocation,
    zoom: 15,
  );

  CameraPosition _initialPosition = _defaultCameraPosition;

  @override
  void initState() {
    super.initState();
    _initializeMap();
  }

  Future<void> _initializeMap() async {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    try {
      final location = Location();
      final hasPermission = await location.hasPermission();

      if (hasPermission == PermissionStatus.denied) {
        await location.requestPermission();
      }

      if (hasPermission == PermissionStatus.granted) {
        final userLocation = await location.getLocation();

        if (userLocation.latitude != null && userLocation.longitude != null) {
          final userLatLng = LatLng(
            userLocation.latitude!,
            userLocation.longitude!,
          );

          setState(() {
            _selectedLocation = userLatLng;
            _initialPosition = CameraPosition(target: userLatLng, zoom: 15);
            _updateMarker();
          });

          widget.onCoordinatesChanged(
            userLocation.latitude.toString(),
            userLocation.longitude.toString(),
          );

          if (_mapController != null) {
            _mapController?.animateCamera(
              CameraUpdate.newCameraPosition(_initialPosition),
            );
          }
        }
      } else {
        debugPrint('Location permission denied');
      }
    } catch (e) {
      debugPrint('Error initializing map: $e');
    }
  }

  void _updateMarker() {
    if (_selectedLocation == null) return;

    _markers = {
      Marker(
        markerId: const MarkerId('selected_location'),
        position: _selectedLocation!,
        infoWindow: const InfoWindow(title: 'Selected Location'),
      ),
    };
  }

  Future<void> _onMapTapped(LatLng position) async {
    setState(() {
      _selectedLocation = position;
      _updateMarker();
    });

    widget.onLocationSelected(position);
    widget.onCoordinatesChanged(
      position.latitude.toString(),
      position.longitude.toString(),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    setState(() {
      _mapLoaded = true;
    });

    _mapController?.animateCamera(
      CameraUpdate.newCameraPosition(_initialPosition),
    );
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      children: [
        Container(
          height: 300,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: colorScheme.outlineVariant, width: 1),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              onTap: _onMapTapped,
              initialCameraPosition: _initialPosition,
              markers: _markers,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              zoomControlsEnabled: true,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: colorScheme.primary.withOpacity(0.5)),
          ),
          child: Row(
            children: [
              Icon(Icons.info_outline, color: colorScheme.primary, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Tap on the map to set your location.'.i18n,
                  style: TextStyle(color: colorScheme.primary, fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
