// //current version
// import 'package:flutter/material.dart';
// import 'package:latlong2/latlong.dart';
// import 'field_verification_page.dart';

// class LocationDetailsPage extends StatelessWidget {
//   final String name;
//   final LatLng coordinates;
//   final String address;
//   final List<String> imageUrls;
//   final String technicianComments;

//   const LocationDetailsPage({
//     super.key,
//     required this.name,
//     required this.coordinates,
//     required this.address,
//     required this.imageUrls,
//     required this.technicianComments,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Details of Location'),
//         backgroundColor: Colors.green[600],
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: ListView(
//           children: [
//             Text(name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//             const SizedBox(height: 12),
//             Text('Coordinates:', style: const TextStyle(fontWeight: FontWeight.bold)),
//             Text('${coordinates.latitude.toStringAsFixed(5)}, ${coordinates.longitude.toStringAsFixed(5)}'),
//             const SizedBox(height: 12),
//             Text('Address:', style: const TextStyle(fontWeight: FontWeight.bold)),
//             Text(address),
//             const SizedBox(height: 20),
//             Text('Satellite Images', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
//             const SizedBox(height: 8),
//             imageUrls.isEmpty
//                 ? Container(
//                     padding: const EdgeInsets.symmetric(vertical: 20),
//                     alignment: Alignment.center,
//                     child: Text('No satellite images available', style: TextStyle(color: Colors.grey[700])),
//                   )
//                 : SizedBox(
//                     height: 120,
//                     child: ListView.separated(
//                       scrollDirection: Axis.horizontal,
//                       itemCount: imageUrls.length,
//                       separatorBuilder: (_, __) => const SizedBox(width: 8),
//                       itemBuilder: (context, i) => GestureDetector(
//                         onTap: () => showDialog(
//                           context: context,
//                           builder: (_) => Dialog(child: Image.network(imageUrls[i])),
//                         ),
//                         child: Image.network(imageUrls[i], width: 160, height: 120, fit: BoxFit.cover),
//                       ),
//                     ),
//                   ),
//             const SizedBox(height: 20),
//             Text('Technician Comments', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
//             const SizedBox(height: 8),
//             Container(
//               padding: const EdgeInsets.all(12),
//               decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Colors.grey[100]),
//               child: Text(technicianComments),
//             ),
//             const SizedBox(height: 32),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(backgroundColor: Colors.green[600], padding: const EdgeInsets.symmetric(vertical: 14)),
//                 onPressed: () {
//                   // Proceed to field verification
//                   Navigator.of(context).push(
//                     MaterialPageRoute(builder: (_) => FieldVerificationPage(locationName: name)),
//                   );
//                 },
//                 child: const Text('Proceed to Visit', style: TextStyle(color: Colors.white)),
//               ),
//             ),
//             const SizedBox(height: 12),
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text('Back to Map', style: TextStyle(color: Colors.green)),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }








import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'field_verification_page.dart';

class LocationDetailsPage extends StatelessWidget {
  final String name;
  final LatLng coordinates;
  final String address;
  final String? year1Url;
  final String? year2Url;
  final String? changeMapUrl;
  final String technicianComments;

  const LocationDetailsPage({
    super.key,
    required this.name,
    required this.coordinates,
    required this.address,
    this.year1Url,
    this.year2Url,
    this.changeMapUrl,
    required this.technicianComments,
  });

  Widget _imageCard(String label, String? url) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey[200],
              image: url != null ? DecorationImage(image: NetworkImage(url), fit: BoxFit.cover) : null,
            ),
            alignment: Alignment.center,
            child: url == null ? Text(label) : null,
          ),
          const SizedBox(height: 6),
          Text(label, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Details of Location'),
        backgroundColor: Colors.green[600],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Text(name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Text('Coordinates:', style: const TextStyle(fontWeight: FontWeight.bold)),
            Text('${coordinates.latitude.toStringAsFixed(5)}, ${coordinates.longitude.toStringAsFixed(5)}'),
            const SizedBox(height: 12),
            Text('Address:', style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(address),
            const SizedBox(height: 20),
            const Text('Comparison Images', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            Row(
              children: [
                _imageCard('Year 1', year1Url),
                const SizedBox(width: 8),
                _imageCard('Year 2', year2Url),
              ],
            ),
            const SizedBox(height: 16),
            const Text('Change Map', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            Container(
              height: 180,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey[200],
                image: changeMapUrl != null ? DecorationImage(image: NetworkImage(changeMapUrl!), fit: BoxFit.cover) : null,
              ),
              alignment: Alignment.center,
              child: changeMapUrl == null ? const Text('No change map') : null,
            ),
            const SizedBox(height: 20),
            const Text('Technician Comments', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Colors.grey[100]),
              child: Text(technicianComments),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green[600], padding: const EdgeInsets.symmetric(vertical: 14)),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => FieldVerificationPage(locationName: name)));
                },
                child: const Text('Proceed to Visit', style: TextStyle(color: Colors.white)),
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Back to Map', style: TextStyle(color: Colors.green)),
            ),
          ],
        ),
      ),
    );
  }
}