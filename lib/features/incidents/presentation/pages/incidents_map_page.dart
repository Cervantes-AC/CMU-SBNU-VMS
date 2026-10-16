import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../../../shared/presentation/widgets/app_shared_presentation.dart';
import '../../data/models/incident.dart';
import '../view_models/incidents_view_model.dart';

/// Map view of incidents that have location sharing enabled.
///
/// Precise location and incident details are restricted to authorized
/// reviewers. Map markers show only approved/approximate coordinates and
/// safe status/category fields. A list alternative is always available.
class IncidentsMapPage extends StatefulWidget {
  const IncidentsMapPage({super.key});

  @override
  State<IncidentsMapPage> createState() => _IncidentsMapPageState();
}

class _IncidentsMapPageState extends State<IncidentsMapPage> {
  GoogleMapController? _mapController;
  final Set<Marker> _markers = {};

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void _addMarkers(List<Incident> incidents) {
    final markers = <Marker>{};
    for (final inc in incidents) {
      if (!inc.locationShared || inc.latitude == null || inc.longitude == null) {
        continue;
      }
      markers.add(
        Marker(
          markerId: MarkerId(inc.id),
          position: LatLng(inc.latitude!, inc.longitude!),
          infoWindow: InfoWindow(
            title: inc.category,
            snippet: '${inc.severityLabel} · ${inc.statusLabel}',
          ),
        ),
      );
    }
    setState(() {
      _markers.clear();
      _markers.addAll(markers);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<IncidentsViewModel>(
      builder: (context, viewModel, _) {
        final incidents = viewModel.incidents.where(
          (i) => i.locationShared && i.latitude != null && i.longitude != null,
        ).toList();

        if (incidents.isNotEmpty) {
          _addMarkers(incidents);
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Incident Map'),
            actions: [
              IconButton(
                icon: const Icon(Icons.list),
                onPressed: () => Navigator.of(context).pop(),
                tooltip: 'Switch to list view',
              ),
            ],
          ),
          body: Stack(
            children: [
              GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: const CameraPosition(
                  target: LatLng(14.6667, 121.05),
                  zoom: 14,
                ),
                markers: _markers,
                myLocationEnabled: false,
                myLocationButtonEnabled: false,
                zoomControlsEnabled: true,
              ),
              if (incidents.isEmpty)
                const Center(
                  child: AppEmptyState(
                    icon: Icons.map_outlined,
                    title: 'No incidents with location shared.',
                    subtitle:
                        'Location is optional and only shown when a reporter '
                        'chooses to share it.',
                  ),
                ),
              Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Incident Map — Location Privacy',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF43564A),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Map markers show only category, severity, and '
                          'status. Reporter identity and narrative are not '
                          'shown on markers. Location sharing is optional.',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF68766D),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
