import 'dart:async';
import 'package:rxdart/rxdart.dart';

import 'package:utopian_rocks_2/utils.dart';
import 'package:utopian_rocks_2/providers/rocks_api.dart';
import 'package:utopian_rocks_2/models/contribution_model.dart';

class ContributionBloc {
  final RocksApi rocksApi;

  // Each stream holds a full list of contributions from its respective category.
  Stream<List<Contribution>> _pendingReviewStream = Stream.empty();
  Stream<List<Contribution>> _pendingUpvoteStream = Stream.empty();

  // Holds a filtered list of contributions derived from the original streams above.
  Observable<List<Contribution>> _filteredPendingReviewStream =
      Observable.empty();
  Observable<List<Contribution>> _filteredPendingUpvoteStream =
      Observable.empty();

  BehaviorSubject<String> _pendingReviewName =
      BehaviorSubject<String>(seedValue: 'unreviewed');
  BehaviorSubject<String> _pendingUpvoteName =
      BehaviorSubject<String>(seedValue: 'pending');

  // Category filter
  BehaviorSubject<List<String>> _filter =
      BehaviorSubject<List<String>>(seedValue: ['all']);

  // Getters
  Stream<List<Contribution>> get pendingReviewStream =>
      _filteredPendingReviewStream;
  Stream<List<Contribution>> get pendingUpvoteStream =>
      _filteredPendingUpvoteStream;

  //Sink<String> get filter => _filter;
  Stream<List<String>> get filterStream => _filter.stream;

  ContributionBloc(this.rocksApi) {
    _pendingReviewStream = _pendingReviewName
        .asyncMap((page) => rocksApi.getContributions(pageName: page))
        .asBroadcastStream();

    _pendingUpvoteStream = _pendingUpvoteName
        .asyncMap((page) => rocksApi.getContributions(pageName: page))
        .asBroadcastStream();

    _filteredPendingReviewStream =
        Observable.combineLatest2(_filter, _pendingReviewStream, applyFilter)
            .asBroadcastStream();

    _filteredPendingUpvoteStream =
        Observable.combineLatest2(_filter, _pendingUpvoteStream, applyFilter)
            .asBroadcastStream();

    _filter.listen((filterList) => print('Current filters $filterList'));
  }

  List<String> filterList = ['all'];

  void addFilter(String filter) {
    if (!filterList.contains(filter)) {
      filterList.add(filter);
      _filter.add(filterList);
    }
  }

  void removeFilter(String filter) {
    if (filterList.length > 1) {
      filterList.remove(filter);
    }
    _filter.add(filterList);
  }

  void dispose() {
    _filter.close();
    print('Contribution Bloc disposed');
  }
}
