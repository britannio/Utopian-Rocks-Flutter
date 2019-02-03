import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' show Client;

import 'package:utopian_rocks_2/models/contribution_model.dart';

class RocksApi {
  final Client _client = Client();

  // API end point
  static const _url = 'https://utopian.rocks/api/posts?status={0}';

  Future<List<Contribution>> getContributions({
    // Default value
    String pageName = 'unreviewed',
  }) async {
    List<Contribution> items = [];

    await _client
        // modifies our url string, parses it to a uri then gets the data from that url.
        .get(Uri.parse(_url.replaceFirst('{0}', pageName)))
        // gets the response body
        .then((result) => result.body)
        // decodes the data into a json map
        .then(json.decode)
        // iterates through the json array
        .then((json) => json.forEach(
              (contrubution) {
                Contribution con = Contribution.fromJson(contrubution);
                // Prevents the additon of contributions that didn't belong on the page we chose
                if (con.status == pageName) {
                  items.add(con);
                }
              },
            ));

    return items;
  }
}
