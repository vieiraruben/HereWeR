import 'package:flutter/material.dart';
import 'package:mapview/constants/search.dart';
import 'package:mapview/utilities/here_we_r_icons_icons.dart';
import 'dart:math' as math;

import 'package:mapview/views/search_results_view.dart';

class SearchView extends StatefulWidget {
  const SearchView({Key? key}) : super(key: key);

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  late final ScrollController _scrollController;
  late final TextEditingController _search;
  bool silverCollapsed = false;
  double leftPadding = 20;
  bool showResults = false;

  @override
  void initState() {
    super.initState();
    showResults = false;
    _search = TextEditingController();
    _scrollController = ScrollController()
      ..addListener(() {
        if (_scrollController.offset <= 150 &&
            !_scrollController.position.outOfRange) {
          leftPadding = _scrollController.offset / 150 * (55 - 20) + 20;
          setState(() {});
        }
      });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  searchResults() {
    if (_search.text.isNotEmpty) {
      showResults = true;
    } else {
      showResults = false;
    }
    setState(() {});
  }

  static SliverPersistentHeader makeHeader(
      BuildContext context, String headerText) {
    return SliverPersistentHeader(
      pinned: true,
      floating: false,
      delegate: _SliverAppBarDelegate(
        minHeight: 40.0,
        maxHeight: 40.0,
        child: Container(
            color: Theme.of(context).backgroundColor,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Text(headerText,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
            )),
      ),
    );
  }

  SliverAppBar sliverSearchBar() {
    return SliverAppBar(
      excludeHeaderSemantics: true,
      automaticallyImplyLeading: true,
      pinned: true,
      snap: false,
      floating: false,
      toolbarHeight: 90,
      expandedHeight: 240.0,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        expandedTitleScale: 1.2,
        background: Image.asset('assets/images/artboard.png'),
        collapseMode: CollapseMode.parallax,
        titlePadding:
            EdgeInsets.only(left: leftPadding, right: 20, top: 20, bottom: 20),
        title: TextField(
          controller: _search,
          onSubmitted: (value) => searchResults(),
          textInputAction: TextInputAction.search,
          enableSuggestions: false,
          autocorrect: false,
          decoration: InputDecoration(
            suffixIcon: (showResults)
                ? IconButton(
                    onPressed: () {
                      _search.clear();
                      searchResults();
                    },
                    icon: const Icon(Icons.clear))
                : null,
            isCollapsed: false,
            isDense: true,
            filled: true,
            fillColor: Theme.of(context).canvasColor,
            border: const OutlineInputBorder(),
            hintText: "Search users, events and more...",
          ),
          keyboardType: TextInputType.multiline,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!showResults) {
      return Scaffold(
          body:
              CustomScrollView(controller: _scrollController, slivers: <Widget>[
        sliverSearchBar(),
        makeHeader(context, "ANNOUNCEMENTS"),
        SliverList(
            delegate: SliverChildListDelegate([
          SizedBox(
              height: 250,
              child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                            children: announcements.keys.map((key) {
                          return SizedBox(
                              width: 400,
                              child: Row(
                                children: [
                                  CircleAvatar(
                                      backgroundColor: const Color.fromARGB(
                                          255, 228, 228, 249),
                                      radius: 20,
                                      child: CircleAvatar(
                                          radius: 12,
                                          backgroundColor: const Color.fromARGB(
                                              255, 228, 228, 249),
                                          foregroundImage: Image.asset(
                                                  'assets/images/' + key)
                                              .image)),
                                  const SizedBox(width: 10),
                                  Flexible(
                                      child: Text(
                                    announcements[key]!,
                                    softWrap: true,
                                  )),
                                  const SizedBox(
                                    height: 60,
                                  )
                                ],
                              ));
                        }).toList())
                      ])))
        ])),
        makeHeader(context, "RIGHT NOW"),
        SliverList(
            delegate: SliverChildListDelegate([
          SizedBox(
              height: 700,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(



                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: rightnow.keys.map((key) {
                      return Column(
                        children: [Stack(children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.all(Radius.circular(10)),
                            child: Container(foregroundDecoration: BoxDecoration(gradient:
                            LinearGradient(colors:
                            [Colors.black, Colors.transparent], begin: Alignment.bottomRight),
                            ), child:
                            Image.asset(
                              'assets/images/sample/' + key,
                              width: 500, height: 150, fit: BoxFit.cover,
                            ))), Positioned(
                              bottom: 5, left: 5,
                              child: Text(rightnow[key]!.first, textScaleFactor: 1.2,
                              style: TextStyle( color: Colors.white,))),
                                Positioned(bottom: 5, right: 5,
                                  child: Container(
                                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: const Color.fromARGB(255, 160, 167, 211).withOpacity(0.9)), child:
                                IconButton(icon: Icon(HereWeRIcons.icons8_place_marker_64,), color: Colors.white,
                                onPressed: () {  },)))]),
                                const SizedBox(height: 20,)], );

                        }).toList()
                          
                      )
                    )
                    
              )
        ]))
      ]));
    } else {
      return Scaffold(
          body:
              CustomScrollView(controller: _scrollController, slivers: <Widget>[
        sliverSearchBar(),
        SliverList(
            delegate: SliverChildListDelegate([
          SizedBox(
            height: 700,
            child: Padding(
                padding: const EdgeInsets.all(20),
                child: SearchResultsView(
                  searchTerm: _search.text,
                )),
          )
        ]))
      ]));
    }
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });
  final double minHeight;
  final double maxHeight;
  final Widget child;
  @override
  double get minExtent => minHeight;
  @override
  double get maxExtent => math.max(maxHeight, minHeight);
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
