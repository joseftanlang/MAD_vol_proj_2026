import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LocationRecord {
  final String id;
  final double lat;
  final double lng;
  final DateTime timestamp;

  LocationRecord({
    required this.id,
    required this.lat,
    required this.lng,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() => {
        "lat": lat,
        "lng": lng,
        "timestamp": Timestamp.fromDate(timestamp),
      };

  static LocationRecord fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return LocationRecord(
      id: doc.id,
      lat: (data["lat"] as num).toDouble(),
      lng: (data["lng"] as num).toDouble(),
      timestamp:
          (data["timestamp"] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}

class LocationDataService {
  static final _col =
      FirebaseFirestore.instance.collection("location_records");

  static Future<void> addAndUpload(LocationRecord record) async {
    await _col.doc(record.id).set(record.toMap());
  }

  static Future<List<LocationRecord>> fetchLatest({int limit = 50}) async {
    final snap = await _col
        .orderBy("timestamp", descending: true)
        .limit(limit)
        .get();

    return snap.docs.map(LocationRecord.fromDoc).toList();
  }
}


class LocationPage extends StatefulWidget {
  const LocationPage({super.key});

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  GoogleMapController? _mapCtrl;
  final Set<Marker> _markers = {};
  bool _busy = false;

  static const CameraPosition _defaultCam = CameraPosition(
    target: LatLng(1.3521, 103.8198), // Singapore
    zoom: 12,
  );

  Future<Position> _getPositionWithPermission() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      throw Exception("Location services disabled");
    }

    var perm = await Geolocator.checkPermission();
    if (perm == LocationPermission.denied) {
      perm = await Geolocator.requestPermission();
    }
    if (perm == LocationPermission.deniedForever ||
        perm == LocationPermission.denied) {
      throw Exception("Location permission denied");
    }

    return Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  Future<void> _markLocation() async {
    setState(() => _busy = true);

    try {
      final pos = await _getPositionWithPermission();
      final now = DateTime.now();
      final id = now.millisecondsSinceEpoch.toString();
      final latLng = LatLng(pos.latitude, pos.longitude);

      setState(() {
        _markers.add(
          Marker(
            markerId: MarkerId(id),
            position: latLng,
            infoWindow: const InfoWindow(title: "Recorded"),
          ),
        );
      });

      await LocationDataService.addAndUpload(
        LocationRecord(
          id: id,
          lat: pos.latitude,
          lng: pos.longitude,
          timestamp: now,
        ),
      );

      await _mapCtrl?.animateCamera(
        CameraUpdate.newLatLngZoom(latLng, 17),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Location recorded")),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Error: $e")));
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  String _fmtDT(DateTime dt) {
    String two(int n) => n.toString().padLeft(2, "0");
    return "${two(dt.day)}/${two(dt.month)}/${dt.year} "
        "${two(dt.hour)}:${two(dt.minute)}:${two(dt.second)}";
  }

  Future<void> _showRecordsDialog() async {
    final items = await LocationDataService.fetchLatest();

    if (!mounted) return;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Recorded Locations (${items.length})"),
        content: SizedBox(
          width: double.maxFinite,
          child: items.isEmpty
              ? const Text("No records yet")
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: items.length,
                  itemBuilder: (_, i) {
                    final r = items[i];
                    return ListTile(
                      title: Text(
                          "Lat: ${r.lat.toStringAsFixed(6)}, Lng: ${r.lng.toStringAsFixed(6)}"),
                      subtitle: Text(_fmtDT(r.timestamp)),
                      onTap: () async {
                        Navigator.pop(context);
                        await _mapCtrl?.animateCamera(
                          CameraUpdate.newLatLngZoom(
                              LatLng(r.lat, r.lng), 17),
                        );
                      },
                    );
                  },
                ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Close"))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Location Tracker")),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: GoogleMap(
              initialCameraPosition: _defaultCam,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              markers: _markers,
              onMapCreated: (c) => _mapCtrl = c,
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _busy ? null : _markLocation,
                      child:
                          Text(_busy ? "Recording..." : "Mark Location"),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: OutlinedButton(
                      onPressed: _showRecordsDialog,
                      child: const Text("Show Recorded Locations"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}