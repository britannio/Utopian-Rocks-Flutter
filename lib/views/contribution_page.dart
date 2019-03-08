import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:utopian_rocks_2/bloc_providers/base_provider.dart';
import 'package:utopian_rocks_2/blocs/contribution_bloc.dart';
import 'package:utopian_rocks_2/blocs/settings_bloc.dart';
import 'package:utopian_rocks_2/components/dialogs/about_dialog.dart';
import 'package:utopian_rocks_2/components/dialogs/change_theme_dialog.dart';
import 'package:utopian_rocks_2/models/contribution_model.dart';
import 'package:utopian_rocks_2/models/settings_model.dart';
import 'package:utopian_rocks_2/utils.dart';

class ContributionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _appBar(BuildContext context) {
    List<String> options = ['About', 'Customise'];
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
              IconButton(
                icon: Icon(FontAwesomeIcons.slidersH),
                color: Theme.of(context).colorScheme.onPrimary,
                tooltip: 'Customise',
                onPressed: () => ChangeThemeDialog(context),
              )
              /*  PopupMenuButton<String>(
                tooltip: 'Options',
                icon: Icon(
                  Icons.more_vert,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
                padding: EdgeInsets.all(0),
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
                    /* case 'settings':
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => SettingsPage(),
                        ),
                      );
                      break; */
                    case 'customise':
                      ChangeThemeDialog(context);
                      break;
                  }
                },
              ) */
            ],
          ),
          TabBar(
            indicatorColor: Theme.of(context).colorScheme.primary,
            labelColor: Theme.of(context).colorScheme.onPrimary,
            unselectedLabelColor: Colors.grey,
            tabs: <Widget>[
              Tab(
                child: Text(
                  'Waiting for review',
                  textAlign: TextAlign.center,
                  maxLines: 2,
                ),
              ),
              Tab(
                child: Text(
                  'Waiting for upvote',
                  textAlign: TextAlign.center,
                  maxLines: 2,
                ),
              ),
            ],
          ),
          Divider(
            height: 0,
          ),
        ],
      ),
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
  bool useCards = false;
  bool showAvatar = true;
  bool showCategory = true;
  bool showStats = false;

  @override
  Widget build(BuildContext context) {
    final contributionBloc = Provider.of<ContributionBloc>(context);
    final settingsBloc = Provider.of<SettingsBloc>(context);
    Stream<List<Contribution>> stream;

    switch (widget.pageName) {
      case 'unreviewed':
        stream = contributionBloc.pendingReviewStream;
        break;
      case 'pending':
        stream = contributionBloc.pendingUpvoteStream;
        break;
    }
    return StreamBuilder(
      stream: settingsBloc.getSettings,
      builder: (context, AsyncSnapshot<SettingsModel> settingsSnapshot) {
        if (settingsSnapshot.hasData) {
          return StreamBuilder(
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
                  padding: EdgeInsets.symmetric(vertical: 4),
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
                      contributionBloc: contributionBloc,
                      votes: snapshot.data[index].totalVotes,
                      payout: snapshot.data[index].totalPayout,
                      comments: snapshot.data[index].totalComments,
                      showAvatar: settingsSnapshot.data.show_avatar,
                      showCard: settingsSnapshot.data.show_card,
                      showCategory: settingsSnapshot.data.show_category,
                      showStats: settingsSnapshot.data.show_stats,
                    );
                  });
            },
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
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
    @required ContributionBloc contributionBloc,
    @required int votes,
    @required double payout,
    @required int comments,
    @required bool showAvatar,
    @required bool showCard,
    @required bool showCategory,
    @required bool showStats,
  }) {
    return StreamBuilder(
        stream: contributionBloc.filterStream,
        builder: (BuildContext context, snapshot) {
          //String filter = snapshot.data;
          return Padding(
            padding: EdgeInsets.symmetric(
                vertical: showCard ? 4 : 2, horizontal: showCard ? 8 : 0),
            child: Material(
              elevation: showCard ? 4 : 0,
              borderRadius:
                  showCard ? BorderRadius.circular(8) : BorderRadius.zero,
              color: Theme.of(context).colorScheme.surface,
              child: InkWell(
                onTap: () {
                  launchUrl(postUrl);
                },
                borderRadius:
                    showCard ? BorderRadius.circular(8) : BorderRadius.zero,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                          child: Column(
                            children: <Widget>[
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  showAvatar
                                      ? Padding(
                                          padding:
                                              EdgeInsets.symmetric(vertical: 8),
                                          child: CircleAvatar(
                                            backgroundImage:
                                                NetworkImage(avatarUrl),
                                            backgroundColor:
                                                Colors.grey.shade300,
                                          ),
                                        )
                                      : Container(),
                                  SizedBox(width: showAvatar ? 16 : 4),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          title,
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.left,
                                        ),
                                        Text(
                                          subtitle,
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.grey,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 4),
                                  showCategory
                                      ? Icon(
                                          IconData(
                                            // Default icon
                                            icon ?? 0x004e,
                                            fontFamily: 'Utopicons',
                                          ),
                                          // Default color
                                          color: iconColor ?? Color(0xFFB10DC9),
                                        )
                                      : Container(),
                                  SizedBox(width: showCategory ? 4 : 0),
                                ],
                              ),
                              showStats
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            Icon(
                                              FontAwesomeIcons.arrowUp,
                                              size: 16,
                                              color: Colors.grey,
                                            ),
                                            SizedBox(width: 4),
                                            Text(votes.toString(),
                                                style: TextStyle(
                                                    color: Colors.grey))
                                          ],
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Icon(
                                              FontAwesomeIcons.moneyCheckAlt,
                                              size: 16,
                                              color: Colors.grey,
                                            ),
                                            SizedBox(width: 8),
                                            Text(
                                              payout.toString(),
                                              style:
                                                  TextStyle(color: Colors.grey),
                                            )
                                          ],
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Icon(
                                              FontAwesomeIcons.solidCommentAlt,
                                              size: 16,
                                              color: Colors.grey,
                                            ),
                                            SizedBox(width: 4),
                                            Text(
                                              comments.toString(),
                                              style:
                                                  TextStyle(color: Colors.grey),
                                            )
                                          ],
                                        ),
                                      ],
                                    )
                                  : Container(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
