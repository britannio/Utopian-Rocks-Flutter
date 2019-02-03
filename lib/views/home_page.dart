import 'package:flutter/material.dart';
import 'package:utopian_rocks_2/bloc_providers/base_provider.dart';
import 'package:utopian_rocks_2/blocs/contribution_bloc.dart';
import 'package:utopian_rocks_2/blocs/steem_bloc.dart';
import 'package:utopian_rocks_2/providers/steem_api.dart';
import 'package:utopian_rocks_2/utils.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:utopian_rocks_2/views/content_page.dart';

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() {
    return new HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  bool wideTabs = false;
  String selectedId = 'all';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Positioned.fill(
              child: Padding(
                  // Leaves space for the left vertical tabs
                  padding: const EdgeInsets.only(left: 48),
                  child: BlocProvider<SteemBloc>(
                    builder: (_, bloc) => bloc ?? SteemBloc(SteemApi()),
                    onDispose: (_, bloc) => bloc.dispose(),
                    child: ContentPage(),
                  )),
            ),
            Positioned(
              bottom: 0,
              top: 0,
              left: 0,
              child: Material(
                color: Theme.of(context).colorScheme.secondary,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _toggleTab(context),
                    _tab(
                      context,
                      id: 'all',
                      friendlyName: 'All',
                      imgPath: 'assets/images/all.png',
                    ),
                    _tab(context, id: 'analysis', friendlyName: 'Analysis'),
                    _tab(
                      context,
                      id: 'anti-abuse',
                      friendlyName: 'Anti-Abuse',
                    ),
                    _tab(context, id: 'blog', friendlyName: 'Blog'),
                    _tab(context,
                        id: 'bug-hunting', friendlyName: 'Bug Hunting'),
                    _tab(context,
                        id: 'copywriting', friendlyName: 'Copywriting'),
                    _tab(context,
                        id: 'development', friendlyName: 'Development'),
                    _tab(context, id: 'graphics', friendlyName: 'Graphics'),
                    _tab(context,
                        id: 'iamutopian', friendlyName: 'I Am Utopian'),
                    _tab(context, id: 'ideas', friendlyName: 'Ideas'),
                    _tab(context, id: 'social', friendlyName: 'Social'),
                    _tab(context,
                        id: 'translations', friendlyName: 'Translations'),
                    _tab(context, id: 'tutorials', friendlyName: 'Tutorials'),
                    _tab(context,
                        id: 'video-tutorials', friendlyName: 'Video Tutorials'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _toggleTab(BuildContext context) {
    final double height = (MediaQuery.of(context).size.height -
            MediaQuery.of(context).padding.top) /
        15;
    return Container(
      height: height,
      width: 48,
      child: Tooltip(
        message: 'Toggle Width',
        child: Material(
          color: Theme.of(context).colorScheme.secondary,
          child: InkWell(
            onTap: () {
              setState(() {
                wideTabs = !wideTabs;
              });
            },
            child: Icon(
              FontAwesomeIcons.bars,
              color: Theme.of(context).colorScheme.onSecondary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _tab(
    BuildContext context, {
    @required String id,
    @required String friendlyName,
    String imgPath,
  }) {
    bool selected = selectedId == id;
    final contributionBloc = Provider.of<ContributionBloc>(context);
    return AnimatedContainer(
      height: (MediaQuery.of(context).size.height -
              MediaQuery.of(context).padding.top) /
          15,
      width: wideTabs ? 160 : 48,
      duration: Duration(milliseconds: 200),
      child: Tooltip(
        message: friendlyName,
        child: Material(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
          color: selected
              ? iconColors[id]
              : Theme.of(context).colorScheme.secondary,
          child: InkWell(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
            highlightColor: iconColors[id].withOpacity(0.75),
            onTap: () {
              setState(() {
                wideTabs = false;
                selectedId = id;
                contributionBloc.filter.add(id);
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                imgPath != null
                    ? Container(
                        width: 24,
                        margin: EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(imgPath),
                            fit: BoxFit.contain,
                            colorFilter: ColorFilter.mode(
                                selected ? Colors.white : iconColors[id],
                                BlendMode.srcATop),
                          ),
                        ),
                      )
                    : Container(
                        width: 48,
                        child: Icon(
                          IconData(icons[id], fontFamily: 'Utopicons'),
                          color: selected ? Colors.white : iconColors[id],
                        ),
                      ),
                wideTabs
                    ? Text(
                        friendlyName,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onSecondary,
                            fontFamily: 'Quantico'),
                      )
                    : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
