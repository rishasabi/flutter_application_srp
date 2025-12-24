import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'location_details_page.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final MapController _mapController = MapController();
  final TextEditingController _searchController = TextEditingController();

  // Simulated DB: replace with your real fetch from server / local DB
  final List<Map<String, dynamic>> _allLocations = [
    {
      'id': 1,
      'name': 'Thiruvananthapuram',
      'details': 'Capital city of Kerala.',
      'address': 'Thiruvananthapuram, Kerala',
      'latlng': LatLng(8.5241, 76.9366),
      'year1': 'https://via.placeholder.com/320x180.png?text=Year+1',
      'year2': 'https://via.placeholder.com/320x180.png?text=Year+2',
      'changeMap': 'https://via.placeholder.com/480x260.png?text=Change+Map',
      'technicianComments': 'No comments yet.',
    },
    {
      'id': 2,
      'name': 'Kochi',
      'details': 'Major port city.',
      'address': 'Kochi, Kerala',
      'latlng': LatLng(9.9312, 76.2673),
      'year1': 'https://via.placeholder.com/320x180.png?text=Year+1',
      'year2': 'https://via.placeholder.com/320x180.png?text=Year+2',
      'changeMap': 'https://via.placeholder.com/480x260.png?text=Change+Map',
      'technicianComments': 'Requires inspection.',
    },
    {
      'id': 3,
      'name': 'Kozhikode',
      'details': 'Historic city.',
      'address': 'Kozhikode, Kerala',
      'latlng': LatLng(11.2588, 75.7804),
      'year1': 'https://via.placeholder.com/320x180.png?text=Year+1',
      'year2': 'https://via.placeholder.com/320x180.png?text=Year+2',
      'changeMap': 'https://via.placeholder.com/480x260.png?text=Change+Map',
      'technicianComments': 'Satellite view shows changes.',
    },
  ];

  // locations currently shown on map (initially all)
  late List<Map<String, dynamic>> _locations;

  @override
  void initState() {
    super.initState();
    _locations = List.from(_allLocations);
  }

  Future<List<Map<String, dynamic>>> fetchLocationsFromDb(String query) async {
    // Replace this with real API/database call
    await Future.delayed(const Duration(milliseconds: 300));
    if (query.trim().isEmpty) return List.from(_allLocations);
    final q = query.toLowerCase();
    return _allLocations.where((loc) => (loc['name'] as String).toLowerCase().contains(q) || (loc['address'] as String).toLowerCase().contains(q)).toList();
  }

  void _onSearchSubmitted(String value) async {
    final results = await fetchLocationsFromDb(value);
    setState(() {
      _locations = results;
    });
    if (results.isNotEmpty) {
      final LatLng target = results.first['latlng'] as LatLng;
      _mapController.move(target, 12.0);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No results')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map'),
        backgroundColor: Colors.green[600],
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              center: LatLng(10.1632, 76.6413),
              zoom: 7.5,
              onTap: (_, __) {
                // hide any UI if needed
                FocusScope.of(context).unfocus();
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                subdomains: const ['a', 'b', 'c'],
              ),
              MarkerLayer(
                markers: _locations.map((loc) {
                  final LatLng pos = loc['latlng'] as LatLng;
                  return Marker(
                    width: 40,
                    height: 40,
                    point: pos,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => LocationDetailsPage(
                              name: loc['name'],
                              coordinates: pos,
                              address: loc['address'],
                              year1Url: loc['year1'],
                              year2Url: loc['year2'],
                              changeMapUrl: loc['changeMap'],
                              technicianComments: loc['technicianComments'],
                            ),
                          ),
                        );
                      },
                      child: const Icon(Icons.location_on, color: Colors.red, size: 36),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
          // Search box at top
          Positioned(
            top: 12,
            left: 12,
            right: 12,
            child: SafeArea(
              child: Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(8),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        textInputAction: TextInputAction.search,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.search),
                          hintText: 'Search Panchayat or place',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                        ),
                        onSubmitted: _onSearchSubmitted,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        _onSearchSubmitted('');
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Optional result list when search filled
          if (_searchController.text.isNotEmpty && _locations.isNotEmpty)
            Positioned(
              top: 72,
              left: 12,
              right: 12,
              child: Card(
                elevation: 6,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 200),
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: _locations.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, i) {
                      final loc = _locations[i];
                      return ListTile(
                        title: Text(loc['name']),
                        subtitle: Text(loc['address']),
                        onTap: () {
                          final LatLng target = loc['latlng'] as LatLng;
                          _mapController.move(target, 13.0);
                          FocusScope.of(context).unfocus();
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}







// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:latlong2/latlong.dart';
// import 'location_details_page.dart';

// class MapPage extends StatefulWidget {
//   const MapPage({Key? key}) : super(key: key);

//   @override
//   State<MapPage> createState() => _MapPageState();
// }

// class _MapPageState extends State<MapPage> {
//   final MapController _mapController = MapController();

//   final List<Map<String, dynamic>> _locations = [
//     {
//       'name': 'Thiruvananthapuram',
//       'details': 'Capital city of Kerala.',
//       'address': 'Thiruvananthapuram, Kerala',
//       'latlng': LatLng(8.5241, 76.9366),
//       'images': <String>[],
//       'technicianComments': 'No comments yet.',
//     },
//     {
//       'name': 'Kochi',
//       'details': 'Major port city.',
//       'address': 'Kochi, Kerala',
//       'latlng': LatLng(9.9312, 76.2673),
//       'images': <String>[],
//       'technicianComments': 'Requires inspection.',
//     },
//     {
//       'name': 'Kozhikode',
//       'details': 'Historic city.',
//       'address': 'Kozhikode, Kerala',
//       'latlng': LatLng(11.2588, 75.7804),
//       'images': <String>[],
//       'technicianComments': 'Satellite view shows changes.',
//     },
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Map'),
//         backgroundColor: Colors.green[600],
//       ),
//       body: FlutterMap(
//         mapController: _mapController,
//         options: MapOptions(
//           center: LatLng(10.1632, 76.6413),
//           zoom: 7.5,
//         ),
//         children: [
//           TileLayer(
//             urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
//             subdomains: const ['a', 'b', 'c'],
//           ),
//           MarkerLayer(
//             markers: _locations.map((loc) {
//               final LatLng pos = loc['latlng'] as LatLng;
//               return Marker(
//                 width: 40,
//                 height: 40,
//                 point: pos,
//                 // use 'child' for versions that don't have 'builder'
//                 child: GestureDetector(
//                   onTap: () {
//                     Navigator.of(context).push(
//                       MaterialPageRoute(
//                         builder: (_) => LocationDetailsPage(
//                           name: loc['name'],
//                           coordinates: pos,
//                           address: loc['address'],
//                           imageUrls: List<String>.from(loc['images']),
//                           technicianComments: loc['technicianComments'],
//                         ),
//                       ),
//                     );
//                   },
//                   child: const Icon(Icons.location_on, color: Colors.red, size: 36),
//                 ),
//               );
//             }).toList(),
//           ),
//         ],
//       ),
//     );
//   }
// }