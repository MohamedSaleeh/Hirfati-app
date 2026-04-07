import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:lottie/lottie.dart' hide Marker;
import 'package:permission_handler/permission_handler.dart';

import '../../../../../translations.dart';
import '../providers/profile_setup_controller.dart';

class LocationMapWidget extends ConsumerStatefulWidget {
  const LocationMapWidget({super.key});

  @override
  ConsumerState<LocationMapWidget> createState() => _LocationMapWidgetState();
}

class _LocationMapWidgetState extends ConsumerState<LocationMapWidget> {
  GoogleMapController? _mapController;
  Marker? _selectedMarker;
  bool _isMapReady = false;
  LocationData? _currentLocation;
  bool _locationPermissionGranted = false;

  static const _defaultPosition = LatLng(24.7136, 46.6753);

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
  }

  @override
  void dispose() {
    if (_isMapReady) {
      _mapController?.dispose();
    }
    super.dispose();
  }

  Future<void> _checkLocationPermission() async {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final status = await Permission.location.status;

    if (status.isGranted) {
      setState(() => _locationPermissionGranted = true);
      _getCurrentLocation();
    } else if (status.isDenied) {
      final result = await Permission.location.request();
      if (result.isGranted) {
        setState(() => _locationPermissionGranted = true);
        _getCurrentLocation();
      }
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      final location = Location();

      final serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        await location.requestService();
      }

      final locationData = await location.getLocation();

      setState(() {
        _currentLocation = locationData;
      });

      if (_mapController != null &&
          _isMapReady &&
          locationData.latitude != null) {
        _mapController!.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(locationData.latitude!, locationData.longitude!),
              zoom: 14,
            ),
          ),
        );
      }
    } catch (e) {
      debugPrint('❌ Error getting location: $e');
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    setState(() {
      _isMapReady = true;
    });

    if (_currentLocation != null && _locationPermissionGranted) {
      _mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(
              _currentLocation!.latitude!,
              _currentLocation!.longitude!,
            ),
            zoom: 14,
          ),
        ),
      );
    }
  }

  void _onMapTap(LatLng position) {
    if (!_isMapReady) return;

    setState(() {
      _selectedMarker = Marker(
        markerId: const MarkerId('selected_location'),
        position: position,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
      );
    });

    ref
        .read(profileSetupProvider.notifier)
        .setLocation(position.latitude, position.longitude);
  }

  void _goToCurrentLocation() {
    if (_currentLocation != null && _mapController != null && _isMapReady) {
      _mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(
              _currentLocation!.latitude!,
              _currentLocation!.longitude!,
            ),
            zoom: 14,
          ),
        ),
      );
    } else {
      _getCurrentLocation();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Geographic Location',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
            TextButton.icon(
              onPressed: _locationPermissionGranted
                  ? _goToCurrentLocation
                  : null,
              icon: Icon(
                Icons.my_location_rounded,
                size: 16,
                color: colorScheme.primary,
              ),
              label: Text(
                'Auto Detect'.i18n,
                style: TextStyle(fontSize: 13, color: colorScheme.primary),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Container(
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.shadow.withOpacity(0.18),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Stack(
              children: [
                GoogleMap(
                  key: const ValueKey('location_map'),
                  initialCameraPosition: CameraPosition(
                    target: _currentLocation != null
                        ? LatLng(
                            _currentLocation!.latitude!,
                            _currentLocation!.longitude!,
                          )
                        : _defaultPosition,
                    zoom: 14,
                  ),
                  onMapCreated: _onMapCreated,
                  onTap: _onMapTap,
                  markers: _selectedMarker != null
                      ? {_selectedMarker!}
                      : const {},
                  zoomControlsEnabled: false,
                  myLocationEnabled: kIsWeb
                      ? false
                      : _locationPermissionGranted,
                  myLocationButtonEnabled: false,
                ),
                if (!_isMapReady)
                  Center(
                    child: Lottie.asset(
                      'assets/animations/loading_animation.json',
                      width: 150,
                      height: 150,
                      repeat: true,
                    ),
                  ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.surface.withOpacity(0.92),
                      borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(16),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline_rounded,
                          size: 14,
                          color: colorScheme.primary,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Tap on the map to accurately change location',
                          style: TextStyle(
                            fontSize: 11,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (!_locationPermissionGranted && _isMapReady)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: colorScheme.surface,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: colorScheme.shadow.withOpacity(0.1),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.location_off,
                            size: 14,
                            color: colorScheme.error,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Location permission required',
                            style: TextStyle(
                              fontSize: 10,
                              color: colorScheme.error,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        if (_currentLocation != null && _locationPermissionGranted)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Row(
              children: [
                Icon(
                  Icons.gps_fixed,
                  size: 12,
                  color: colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 4),
                Text(
                  'Current: ${_currentLocation!.latitude!.toStringAsFixed(4)}, ${_currentLocation!.longitude!.toStringAsFixed(4)}',
                  style: TextStyle(
                    fontSize: 10,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
