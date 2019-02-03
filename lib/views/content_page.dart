import 'package:flutter/material.dart';
import 'package:utopian_rocks_2/bloc_providers/base_provider.dart';
import 'package:utopian_rocks_2/blocs/contribution_bloc.dart';
import 'package:utopian_rocks_2/blocs/steem_bloc.dart';
import 'package:utopian_rocks_2/components/dialogs/about_dialog.dart';
import 'package:utopian_rocks_2/components/dialogs/change_theme_dialog.dart';
import 'package:utopian_rocks_2/models/contribution_model.dart';
import 'package:utopian_rocks_2/utils.dart';
import 'package:utopian_rocks_2/views/settings_page.dart';

import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ContentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // gets the bloc

    return DefaultTabController(
      length: 2,
      child: Material(
        color: Theme.of(context).colorScheme.background,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _appBar(context),
            Expanded(
              child: TabBarView(
                children: <Widget>[
                  _Page(pageName: 'unreviewed'),
                  _Page(pageName: 'pending'),
                  /* Placeholder(
                    color: Colors.white,
                  ) */
                ],
              ),
            ),
            _voteStats(context),
          ],
        ),
      ),
    );
  }

  Widget _appBar(BuildContext context) {
    List<String> options = ['About', 'Settings', 'Theme'];
    return Material(
      color: Theme.of(context).colorScheme.primaryVariant,
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 16),
                child: Text(
                  'utopian_rocks',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontFamily: 'Quantico'),
                ),
              ),
              PopupMenuButton<String>(
                tooltip: 'Options',
                icon: Icon(
                  Icons.more_vert,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
                itemBuilder: (BuildContext context) {
                  return options.map((String option) {
                    return PopupMenuItem<String>(
                      value: option,
                      child: Text(option),
                    );
                  }).toList();
                },
                onSelected: (String option) {
                  switch (option.toLowerCase()) {
                    case 'about':
                      AboutAppDialog(context);
                      break;
                    case 'settings':
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => SettingsPage(),
                        ),
                      );
                      break;
                    case 'theme':
                      // Utopian theme, Light, Dark, Dark(AMOLED)
                      ChangeThemeDialog(context);
                      break;
                  }
                },
              )
            ],
          ),
          TabBar(
            indicatorColor: Theme.of(context).colorScheme.primary,
            labelColor: Theme.of(context).colorScheme.onPrimary,
            unselectedLabelColor: Colors.grey,
            tabs: <Widget>[
              Tab(
                child: Text(
                  'Waiting for\nreview',
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  /* style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ), */
                ),
              ),
              Tab(
                child: Text(
                  'Waiting for\nupvote',
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  /* style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ), */
                ),
              ),
              /* Tab(
                child: Text(
                  'Moderator\ncomments',
                  textAlign: TextAlign.center,
                  maxLines: 2,
                ),
              ) */
            ],
          ),
          Divider(
            height: 0,
          ),
        ],
      ),
    );
  }

  Widget _voteStats(BuildContext context) {
    final steemBloc = Provider.of<SteemBloc>(context);
    return Column(
      children: <Widget>[
        Divider(
          height: 0,
        ),
        SizedBox(height: 8),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Material(
            elevation: 8,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
            color: Theme.of(context).colorScheme.surface,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      StreamBuilder(
                        stream: steemBloc.timer,
                        builder: (context, timerSnapshot) => Text(
                              'Next Vote Cycle: ${DateFormat.Hms().format(DateTime(0, 0, 0, 0, 0, timerSnapshot.data ?? 0))}',
                              style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                  fontSize: 18,
                                  fontFamily: 'Quantico'),
                            ),
                      ),
                      StreamBuilder(
                        stream: steemBloc.voteCount,
                        // toStringAsPrecision(4) converts the double to 4 s.f.
                        builder: (context, voteCountSnapshot) => Text(
                              'Vote Power: ${voteCountSnapshot.data != 100.0 || null ? voteCountSnapshot.data?.toStringAsPrecision(4) ?? 0 : 100.0}',
                              style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                  fontSize: 18,
                                  fontFamily: 'Quantico'),
                            ),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Icon(FontAwesomeIcons.pencilAlt),
                      SizedBox(width: 8),
                      Text(
                        '12',
                        style: TextStyle(fontSize: 18),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _Page extends StatefulWidget {
  final String pageName;

  const _Page({Key key, @required this.pageName}) : super(key: key);
  __PageState createState() => __PageState();
}

class __PageState extends State<_Page> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    final contributionBloc = Provider.of<ContributionBloc>(context);
    Stream<List<Contribution>> stream;

    switch (widget.pageName) {
      case 'unreviewed':
        stream = contributionBloc.pendingReviewStream;
        break;
      case 'pending':
        stream = contributionBloc.pendingUpvoteStream;
        break;
    }
    return ListView(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 12),
              child: StreamBuilder(
                stream: contributionBloc.filterStream,
                builder:
                    (BuildContext context, AsyncSnapshot<String> snapshot) {
                  if (snapshot.hasData) {
                    return Text(
                      '${formattedCategories[snapshot.data]}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ),
            // Hide avatar checkbox, Always hide category icon, Show additional stats, 
            // switch between card and tile
            Padding(
              padding: EdgeInsets.only(right: 8),
              child: Tooltip(
                message: 'Customise',
                child: InkWell(
                  onTap: () {},
                  borderRadius: BorderRadius.circular(30),
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Icon(
                      FontAwesomeIcons.thLarge,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        StreamBuilder(
          stream: stream,
          builder: (
            BuildContext context,
            AsyncSnapshot<List<Contribution>> snapshot,
          ) {
            // No data
            if (!snapshot.hasData)
              return Center(
                child: CircularProgressIndicator(),
              );
            // No data
            if (snapshot.data.length == 0) {
              return Center(
                child: Text(
                  'No Contributions for this category',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onBackground),
                ),
              );
            }
            return ListView.builder(
                padding: EdgeInsets.only(bottom: 4),
                itemCount: snapshot.data.length,
                primary: false,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  String category = snapshot.data[index].category;
                  int iconCode = icons[category];
                  String repo = checkRepo(snapshot, index);
                  String timestamp =
                      convertTimestamp(snapshot, index, widget.pageName);
                  Color categoryColor = iconColors[category];
                  return _content(
                    context,
                    title: snapshot.data[index].title,
                    subtitle: '$repo • $timestamp',
                    icon: iconCode,
                    iconColor: categoryColor,
                    avatarUrl:
                        'https://steemitimages.com/u/${snapshot.data[index].author}/avatar',
                    postUrl: snapshot.data[index].url,
                  );
                });
          },
        ),
      ],
    );
  }

  Widget _content(
    BuildContext context, {
    @required String title,
    @required String subtitle,
    @required int icon,
    @required Color iconColor,
    @required String avatarUrl,
    @required String postUrl,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Material(
        elevation: 4,
        borderRadius: BorderRadius.circular(8),
        color: Theme.of(context).colorScheme.surface,
        child: InkWell(
          onTap: () {
            launchUrl(postUrl);
          },
          borderRadius: BorderRadius.circular(8),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(avatarUrl),
                          backgroundColor: Colors.grey.shade300,
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              title,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                              textAlign: TextAlign.left,
                            ),
                            Text(
                              subtitle,
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(
                        IconData(
                          // Default icon
                          icon ?? 0x004e,
                          fontFamily: 'Utopicons',
                        ),
                        // Default color
                        color: iconColor ?? Color(0xFFB10DC9),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
