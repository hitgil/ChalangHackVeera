import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:veera/Screen/SearchScreen.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool hasFocus = false;
  FocusNode focus = FocusNode();
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    focus.addListener(() {
      onFocusChange();
    });
    searchController.addListener(() {
      filterClints() {
        String searchText = searchController.text;
        if (searchText.isNotEmpty) {
          print("Filtering customers based on search: $searchText");
        }
      }

      ;
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    focus.removeListener(onFocusChange);
    super.dispose();
  }

  void onFocusChange() {
    if (focus.hasFocus) {
      setState(() {
        hasFocus = true;
      });
    } else {
      setState(() {
        hasFocus = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isSearching = searchController.text.isNotEmpty;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.purple,
                  Colors.purple[100] ?? Colors.white,
                ],
                stops: [0.1, 0.9],
              ),
            ),
          ),
          Positioned(
            top: 150.0,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'veera',
                style: GoogleFonts.ubuntu(
                  color: Colors.purple[200],
                  fontSize: 50.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height / 2.2,
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 100,
                  right: 100,
                  top: 0,
                  bottom: 0,
                ),
                child: TextField(
                  focusNode: focus,
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: "Search",
                    contentPadding: const EdgeInsets.symmetric(vertical: 12.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50.0),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: IconButton(
                      onPressed: () {
                        print(searchController.text);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SearchScreen(
                                    initialSearchText: searchController.text,
                                    searchController: searchController,
                                  )),
                        );
                      },
                      icon: Icon(Icons.search),
                    ),
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (hasFocus)
                          InkWell(
                            onTap: () {
                              searchController.clear();
                            },
                            child: const Icon(
                              Icons.clear,
                              color: Colors.grey,
                            ),
                          ),
                        const SizedBox(
                          width: 10,
                        ),
                        PopupMenuButton(
                          icon: const Icon(Icons.more_vert_sharp,
                              color: Colors.grey),
                          itemBuilder: (context) => [
                            PopupMenuItem<int>(
                              value: 1,
                              child: Text('Option 1'),
                            ),
                            PopupMenuItem<int>(
                              value: 2,
                              child: Text('Option 2'),
                            ),
                          ],
                          onSelected: (value) {},
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
