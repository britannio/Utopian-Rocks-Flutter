import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:utopian_rocks_2/bloc_providers/base_provider.dart';
import 'package:utopian_rocks_2/blocs/contribution_bloc.dart';
import 'package:utopian_rocks_2/blocs/steem_bloc.dart';
import 'package:utopian_rocks_2/providers/steem_api.dart';
import 'package:utopian_rocks_2/utils.dart';
import 'package:utopian_rocks_2/views/contribution_page.dart';

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
            // Content
            Positioned.fill(
              child: Padding(
                  // Leaves space for the left vertical tabs
                  padding: const EdgeInsets.only(left: 48),
                  child: BlocProvider<SteemBloc>(
                    builder: (_, bloc) => bloc ?? SteemBloc(SteemApi()),
                    onDispose: (_, bloc) => bloc.dispose(),
                    child: ContributionPage(),
                  )),
            ),
            Positioned(
              bottom: 0,
              top: 0,
              left: 0,
              child: Material(
                color: Theme.of(context).colorScheme.secondary,
                elevation: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    _toggleTab(context),
                    _tab(context, id: 'all', imgPath: 'assets/images/all.png'),
                    _tab(context, id: 'analysis'),
                    _tab(context, id: 'anti-abuse'),
                    _tab(context, id: 'blog'),
                    _tab(context, id: 'bug-hunting'),
                    _tab(context, id: 'copywriting'),
                    _tab(context, id: 'development'),
                    _tab(context, id: 'graphics'),
                    _tab(context, id: 'iamutopian'),
                    _tab(context, id: 'ideas'),
                    _tab(context, id: 'social'),
                    _tab(context, id: 'translations'),
                    _tab(context, id: 'tutorials'),
                    _tab(context, id: 'video-tutorials'),
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
        message: formattedCategories[id],
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
                              BlendMode.srcATop,
                            ),
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
                        formattedCategories[id],
                        style: TextStyle(
                          color: selected
                              ? Colors.white
                              : Theme.of(context).colorScheme.onSecondary,
                        ),
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
