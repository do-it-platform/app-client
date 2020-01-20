import 'package:doit_app_client/loading_widget.dart';
import 'package:doit_app_client/search_api_client.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class JobMap extends StatefulWidget {
  @override
  State<JobMap> createState() => JobMapState();
}

class JobMapState extends State<JobMap> {
  final Geolocator _geolocator = Geolocator();
  final SearchApiClient _searchApiClient = SearchApiClient();

  GoogleMapController mapController;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Future<SearchResult> _searchJobsForCurrentPos() async {
    final Position pos = await _geolocator.getCurrentPosition();
    final List<Job> nearByJobs =
        await _searchApiClient.findNearByJobs(pos.latitude, pos.longitude);

    return SearchResult(pos, nearByJobs);
  }

  Set<Marker> _buildMarkers(List<Job> jobs) {
    return jobs
        .map((j) => Marker(
            markerId: MarkerId(j.id),
            position: LatLng(j.latitude, j.longitude),
            infoWindow: InfoWindow(title: j.title)))
        .toSet();
  }

  @override
  Widget build(BuildContext context) {
    return dataLoadingWidget<SearchResult>(
        dataLoadingFn: this._searchJobsForCurrentPos(),
        widgetBuildFn: (searchResult) {
          final currentPos = searchResult.pos;
          return GoogleMap(
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: LatLng(currentPos.latitude, currentPos.longitude),
              zoom: 11.0,
            ),
            markers: this._buildMarkers(searchResult.jobs),
          );
        });
  }
}

class SearchResult {
  final Position pos;
  final List<Job> jobs;

  SearchResult(this.pos, this.jobs);
}
