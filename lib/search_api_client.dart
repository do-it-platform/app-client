import 'package:graphql/client.dart';

class SearchApiClient {
  final GraphQLClient _client = GraphQLClient(
      cache: InMemoryCache(),
      link: HttpLink(uri: 'http://192.168.2.115:8080/graphql'));

  static final String _JOBS_QUERY = r'''
      query Jobs($latitude: Float!, $longitude: Float!) {
        jobs(location: {latitude: $latitude, longitude: $longitude}) {
          id
          latitude
          longitude
          title
        }
      }
    ''';

  Future<List<Job>> findNearByJobs(double lat, double lon) async {
    final queryResult = await _client.query(QueryOptions(
        fetchPolicy: FetchPolicy.noCache,
        documentNode: gql(_JOBS_QUERY),
        variables: <String, dynamic>{'latitude': lat, 'longitude': lon}));

    return (queryResult.data['jobs'] as List<dynamic>)
        .map((f) => Job(f['id'], f['title'], f['latitude'], f['longitude']))
        .toList();
  }
}

class Job {
  final String id;
  final String title;
  final double latitude;
  final double longitude;

  Job(this.id, this.title, this.latitude, this.longitude);
}
