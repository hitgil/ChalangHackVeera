import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';

class SearchScreen extends StatefulWidget {
  final String initialSearchText;
  final TextEditingController searchController;

  const SearchScreen({Key? key, required this.initialSearchText, required this.searchController})
      : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  bool hasFocus = false;
  FocusNode focus = FocusNode();
  TextEditingController searchController = TextEditingController();
  bool isLoading = false;
  Map<String, dynamic>? searchResults;

  @override
  void initState() {
    super.initState();
    focus.addListener(() {
      onFocusChange();
    });
    searchController.text = widget.initialSearchText;  }

  @override
  void dispose() {
    searchController.dispose();
    focus.removeListener(onFocusChange);
    super.dispose();
  }

  void onFocusChange() {
    setState(() {
      hasFocus = focus.hasFocus;
    });
  }

  Future<void> searchQuery(String query) async {
    setState(() {
      isLoading = true;
    });

    final response = await http.post(
      Uri.parse('https://hackathon-challang-qlqg3uyioq-el.a.run.app/search'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'userEmail': 'kee@hskdjal',
        'query': query,
      }),
    );

    if (response.statusCode == 200) {
      setState(() {
        searchResults = json.decode(response.body);
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
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
                stops: [0.1, 0.9], // Halfway split
              ),
            ),
          ),
          Positioned(
            top: 10.0,
            left: 10,
            right: 0,
            child: Text(
              'veera',
              style: GoogleFonts.ubuntu(
                color: Colors.purple[200],
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 10,
                  right: 10,
                  top: 60,
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
                      onPressed: () async {
                        await searchQuery(searchController.text);
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
                              setState(() {
                                searchResults = null;
                              });
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
              Expanded(
                child: isLoading
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : searchResults != null
                        ? ListView(
                            children: [
                              ListTile(
                                title: Text(
                                  searchResults!['results']['generatedTitle'],
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                  searchResults!['results']['generatedBrief'],
                                ),
                              ),
                              ListTile(
                                title: Text(
                                  searchResults!['results']['generatedSummary'],
                                ),
                              ),
                              Divider(),
                              for (var link in searchResults!['results']
                                  ['linksToShow'])
                                ListTile(
                                  title: Text(link['title']),
                                  subtitle: Text(link['whyRelevant']),
                                  onTap: () {
                                    // Handle link tap
                                  },
                                ),
                            ],
                          )
                        : SizedBox(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showSnackbar(String message) {
    final snackBar = SnackBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      content: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          boxShadow: const [
            BoxShadow(
              color: Color(0xFF90A4AE),
            )
          ],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          message,
          style: GoogleFonts.ubuntu(
            color: Colors.grey[800],
            letterSpacing: -1,
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
