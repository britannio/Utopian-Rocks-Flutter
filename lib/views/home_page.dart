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
  bool allChips = false;
  @override
  Widget build(BuildContext context) {
    ContributionBloc contributionBloc = Provider.of<ContributionBloc>(context);
    List<Widget> chips = categories
        .map(
          (id) => Padding(
                padding: EdgeInsets.symmetric(horizontal: 2),
                child: ChoiceChip(
                  label: Text(formattedCategories[id]),
                  labelStyle: TextStyle(color: Colors.white),
                  selected: id.length % 2 == 0,
                  selectedColor: iconColors[id],
                  onSelected: (bool) {},
                  /* onPressed: () {},
                  backgroundColor: iconColors[id], */
                ),
              ),
        )
        .toList();
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: BlocProvider<SteemBloc>(
          builder: (_, bloc) => bloc ?? SteemBloc(SteemApi()),
          onDispose: (_, bloc) => bloc.dispose(),
          child: ContributionPage(),
        ),
      ),
      bottomNavigationBar: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        height: allChips ? 240 : 48,
        child: Material(
          elevation: 8,
          color: Theme.of(context).colorScheme.surface,
          child: Row(
            children: <Widget>[
              Expanded(
                child: StreamBuilder(
                  stream: contributionBloc.filterStream,
                  initialData: ['all'],
                  builder: (context, snapshot) {
                    List<String> filterList = snapshot.data;
                    List<Widget> chipList = categories
                        .map(
                          (id) => Padding(
                                padding: EdgeInsets.symmetric(horizontal: 2),
                                child: ChoiceChip(
                                  label: Text(formattedCategories[id]),
                                  labelStyle: TextStyle(color: Colors.white),
                                  selected: filterList.contains(id),
                                  selectedColor: iconColors[id],
                                  onSelected: (bool inactive) {
                                    inactive
                                        ? contributionBloc.addFilter(id)
                                        : contributionBloc.removeFilter(id);
                                  },
                                ),
                              ),
                        )
                        .toList();
                    if (allChips) {
                      return Wrap(
                        alignment: WrapAlignment.center,
                        children: chipList,
                      );
                    } else {
                      return ListView(
                        scrollDirection: Axis.horizontal,
                        children: chipList,
                      );
                    }
                  },
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: IconButton(
                    icon: Icon(
                      allChips
                          ? FontAwesomeIcons.chevronDown
                          : FontAwesomeIcons.chevronUp,
                    ),
                    onPressed: () {
                      setState(() {
                        allChips = !allChips;
                      });
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
