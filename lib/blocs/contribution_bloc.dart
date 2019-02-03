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
  //Stream<List<Contribution>> _moderatorCommentsStream = Stream.empty();

  // Holds a filtered list of contributions derived from the original streams above.
  Observable<List<Contribution>> _filteredPendingReviewStream =
      Observable.empty();
  Observable<List<Contribution>> _filteredPendingUpvoteStream =
      Observable.empty();
  //Observable<List<Contribution>> _filteredModeratorCommentsStream = Observable.empty();

  BehaviorSubject<String> _pendingReviewName =
      BehaviorSubject<String>(seedValue: 'unreviewed');
  BehaviorSubject<String> _pendingUpvoteName =
      BehaviorSubject<String>(seedValue: 'pending');
  /*  BehaviorSubject<String> _pageName =
      BehaviorSubject<String>(seedValue: 'unreviewed'); */

  // Category filter
  BehaviorSubject<String> _filter = BehaviorSubject<String>(seedValue: 'all');

  // Getters
  Stream<List<Contribution>> get pendingReviewStream =>
      _filteredPendingReviewStream;
  Stream<List<Contribution>> get pendingUpvoteStream =>
      _filteredPendingUpvoteStream;
  //Stream<List<Contribution>> get moderatorCommentsStream => _moderatorCommentsStream;

  Sink<String> get filter => _filter;
  Stream<String> get filterStream => _filter.stream;

  ContributionBloc(this.rocksApi) {
    _pendingReviewStream = _pendingReviewName
        .asyncMap((page) => rocksApi.getContributions(pageName: page))
        .asBroadcastStream();

    _pendingUpvoteStream = _pendingUpvoteName
        .asyncMap((page) => rocksApi.getContributions(pageName: page))
        .asBroadcastStream();

    /* _pendingModeratorCommentsStream = _pendingModeratorCommentsName
        .asyncMap((page) => rocksApi.getContributions(pageName: page))
        .asBroadcastStream(); */

    _filteredPendingReviewStream =
        Observable.combineLatest2(_filter, _pendingReviewStream, applyFilter);

    _filteredPendingUpvoteStream =
        Observable.combineLatest2(_filter, _pendingUpvoteStream, applyFilter);

    /* _filteredModeratorCommentsStream = 
        Observable.combineLatest2(_filter, _pendingModeratorCommentsStream, applyFilter); */
  }

  void dispose() {
    _filter.close();
    print('Contribution Bloc disposed');
  }
}
