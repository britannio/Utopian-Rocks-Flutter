import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:url_launcher/url_launcher.dart';
import 'package:utopian_rocks_2/models/contribution_model.dart';

//import 'package:utopian_rocks/models/model.dart';

List<Contribution> applyFilter(
  List<String> filter,
  List<Contribution> contributions,
) {
  if (filter.isNotEmpty && !(filter.contains('all') && filter.length == 1)) {
    return contributions.where((con) => filter.contains(con.category)).toList();
    // TODO make sure it distinguishes Tutorials and Video-Tutorials
  }

  return contributions;
}

int getIcon(String name) {
  // Our Font file has a series of icons instead of capital letters.
  // We take a category string and use the const icons map to return the corresponding
  // ascii hexadecimal reference to the icon from within our font file.
  // IconData then knows what icon to display as long as we specify the font family,
  // otherwise we are simply referring to a letter and that's what we'll be shown.
  return icons[name];
}

Color getCategoryColor(String name) {
  return iconColors[name];
}

String checkRepo(AsyncSnapshot snapshot, int index) {
  // We could take in the raw repository string however that would
  // force us to unpack the snapshot in the view class which clutters
  // our view class so we create an abstraction by unpacking here instead.
  if (snapshot.data[index].repository != '') {
    return snapshot.data[index].repository;
  } else {
    return 'No Repository';
  }
}

String convertTimestamp(AsyncSnapshot snapshot, int index, String pageName) {
  // The timestamp looks like this: 2018-12-02 19:52:24
  if (pageName == 'unreviewed') {
    // Will look something like: Created 3 days ago
    return '${timeago.format(DateTime.parse(snapshot.data[index].created))}';
  } else {
    return 'Reviewed ${timeago.format(DateTime.parse(snapshot.data[index].reviewDate))}';
  }
}

void launchUrl(String url) async {
  if (await canLaunch(url)) {
    print('Launching: $url');
    await launch(url);
  } else {
    print('Could not launch $url');
  }
}

const iconColors = <String, Color>{
  'ideas': Color(0xFF4DD39F),
  'development': Color(0xFF838485),
  'bug-hunting': Color(0xffdb524c),
  'translations': Color(0xffffcf26),
  'graphics': Color(0xfff8a700),
  'analysis': Color(0xff174265),
  'documentation': Color(0xffa0a0a0),
  'tutorials': Color(0xFF782c51),
  'video-tutorials': Color(0xFFec3424),
  'copywriting': Color(0xFF007f80),
  'blog': Color(0xff0275d8),
  'social': Color(0xff7bc0f5),
  'anti-abuse': Color(0xff800000),
  'all': Color(0xff4786ff),
  'iamutopian': Color(0xffB10DC9),
};

const icons = <String, int>{
  // Each hexadecimal value corresponds to an ascii letter.
  // However in our font file some letters are replaced
  // with the icons we want
  'ideas': 0x0049,
  'development': 0x0046,
  'bug-hunting': 0x0043,
  'translations': 0x004a,
  'graphics': 0x0045,
  'analysis': 0x0041,
  'documentation': 0x0047,
  'tutorials': 0x004b,
  'video-tutorials': 0x0048,
  'copywriting': 0x0044,
  'blog': 0x0042,
  'social': 0x004c,
  'anti-abuse': 0x0050,
  'all': 0x004e,
  'iamutopian': 0x004e
};

const categories = [
  'all',
  'analysis',
  'anti-abuse',
  'blog',
  'bug-hunting',
  'copywriting',
  'development',
  'documentation',
  'graphics',
  'iamutopian',
  'ideas',
  'social',
  'translations',
  'tutorials',
  'video-tutorials'
];

const formattedCategories = <String, String>{
  'ideas': 'Ideas',
  'development': 'Development',
  'bug-hunting': 'Bug Hunting',
  'translations': 'Translations',
  'graphics': 'Graphics',
  'analysis': 'Analysis',
  'documentation': 'Documentation',
  'tutorials': 'Tutorials',
  'video-tutorials': 'Video Tutorials',
  'copywriting': 'Copywriting',
  'blog': 'Blog',
  'social': 'Social',
  'anti-abuse': 'Anti-Abuse',
  'all': 'All',
  'iamutopian': 'I Am Utopian'
};
