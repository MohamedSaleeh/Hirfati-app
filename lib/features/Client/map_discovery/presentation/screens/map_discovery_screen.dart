import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../../translations.dart';
import '../../../Home_client/domain_models/craftsman_model.dart';
import '../providers/map_providers.dart';
import '../widgets/map_category_chips.dart';
import '../widgets/map_craftsman_card.dart';
import '../widgets/map_search_bar.dart';

class MapDiscoveryScreen extends ConsumerStatefulWidget {
  const MapDiscoveryScreen({super.key});

  @override
  ConsumerState<MapDiscoveryScreen> createState() => _MapDiscoveryScreenState();
}

class _MapDiscoveryScreenState extends ConsumerState<MapDiscoveryScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  final PageController _pageController = PageController(viewportFraction: 0.85);

  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(24.7136, 46.6753),
    zoom: 12,
  );

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onMarkerTapped(String workerId, int index) {
    ref.read(selectedMarkerProvider.notifier).state = workerId;
    if (!_pageController.hasClients) return;

    unawaited(
      _pageController
          .animateToPage(
            index,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          )
          .catchError((_) {
            // The page view can detach while filters rebuild the map cards.
          }),
    );
  }

  Future<void> _onPageChanged(int index, List<CraftsmanModel> workers) async {
    try {
      if (workers.isEmpty) return;
      if (index < 0 || index >= workers.length) return;

      final worker = workers[index];
      ref.read(selectedMarkerProvider.notifier).state = worker.id;

      if (worker.latitude != null &&
          worker.longitude != null &&
          _controller.isCompleted) {
        final GoogleMapController controller = await _controller.future;
        await controller.animateCamera(
          CameraUpdate.newLatLng(LatLng(worker.latitude!, worker.longitude!)),
        );
      }
    } catch (_) {
      // The map controller can detach during fast navigation/filter changes.
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final workersAsync = ref.watch(nearbyWorkersProvider);
    final selectedWorkerId = ref.watch(selectedMarkerProvider);

    workersAsync.whenData((workers) {
      if (selectedWorkerId == null) return;
      final selectedWorkerVisible = workers.any(
        (worker) => worker.id == selectedWorkerId,
      );
      if (selectedWorkerVisible) return;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        if (ref.read(selectedMarkerProvider) == selectedWorkerId) {
          ref.read(selectedMarkerProvider.notifier).state = null;
        }
      });
    });

    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: _initialPosition,
            onMapCreated: (GoogleMapController controller) {
              if (!_controller.isCompleted) {
                _controller.complete(controller);
              }
            },
            markers: workersAsync.maybeWhen(
              data: (workers) => workers
                  .map((worker) {
                    if (worker.latitude == null || worker.longitude == null) {
                      return null;
                    }

                    final isSelected = worker.id == selectedWorkerId;

                    return Marker(
                      markerId: MarkerId(worker.id),
                      position: LatLng(worker.latitude!, worker.longitude!),
                      icon: BitmapDescriptor.defaultMarkerWithHue(
                        isSelected
                            ? BitmapDescriptor.hueBlue
                            : BitmapDescriptor.hueOrange,
                      ),
                      onTap: () {
                        final index = workers.indexOf(worker);
                        _onMarkerTapped(worker.id, index);
                      },
                    );
                  })
                  .whereType<Marker>()
                  .toSet(),
              orElse: () => <Marker>{},
            ),
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
            onTap: (_) {
              ref.read(selectedMarkerProvider.notifier).state = null;
            },
          ),

          SafeArea(
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(20, 16, 20, 16),
                  child: MapSearchBar(),
                ),
                const MapCategoryChips(),
              ],
            ),
          ),

          Positioned(
            right: 16,
            bottom: 240,
            child: FloatingActionButton(
              backgroundColor: colorScheme.surface,
              onPressed: () async {
                final GoogleMapController controller = await _controller.future;
                controller.animateCamera(
                  CameraUpdate.newCameraPosition(_initialPosition),
                );
              },
              child: Icon(Icons.my_location, color: colorScheme.onSurface),
            ),
          ),

          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SizedBox(
              height: 220,
              child: workersAsync.when(
                loading: () => const SizedBox.shrink(),
                error: (_, _) => const SizedBox.shrink(),
                data: (workers) {
                  if (workers.isEmpty) {
                    return Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.surface,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: colorScheme.shadow.withValues(alpha: 0.1),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: Text(
                          'No craftsmen found in this area'.i18n,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ),
                    );
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20, bottom: 8),
                        child: Text(
                          'Craftsmen near you'.i18n,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ),
                      Expanded(
                        child: PageView.builder(
                          controller: _pageController,
                          onPageChanged: (index) =>
                              _onPageChanged(index, workers),
                          itemCount: workers.length,
                          itemBuilder: (context, index) {
                            final worker = workers[index];
                            return MapCraftsmanCard(
                              craftsman: worker,
                              isSelected: worker.id == selectedWorkerId,
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
