
import 'dart:convert';
import 'dart:math'; // Import Random for generating random index
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import 'package:shimmer/shimmer.dart'; // Import shimmer package

class SearchScreen extends StatefulWidget {
  final String initialSearchText;
  final TextEditingController searchController;

  const SearchScreen(
      {Key? key,
      required this.initialSearchText,
      required this.searchController})
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
  String? responseId;
  String? queryParamId;

  final List<String> loadingMessages = [
    "Hang tight! Our AI wizards are conjuring up the perfect results just for you!",
    "Brace yourself for the magic! Our AI is weaving its spell to deliver curated treasures!",
    "Buckle up! Our AI engines are revving up to bring you the most delightful discoveries!",
    "Hold on to your hats! Our AI is on a mission to sprinkle some joy into your search results!",
    "Prepare to be dazzled! Our AI magicians are orchestrating a spectacle of curated wonders!",
    "Get ready to be amazed! Our AI is painting a canvas of curated delights just for you!",
    "Stay tuned! Our AI maestros are composing a symphony of curated brilliance!",
    "Excitement is in the air! Our AI is brewing up a storm of curated awesomeness!",
    "Keep the faith! Our AI is working its magic to uncover the hidden gems you seek!",
    "Anticipation building! Our AI is on a quest to deliver the most enchanting results!",
    "Hold onto your socks! Our AI is about to knock them off with curated excellence!"
  ];

  @override
  void initState() {
    super.initState();
    focus.addListener(() {
      onFocusChange();
    });
    searchController.text = widget.initialSearchText;
    searchQuery(widget.initialSearchText);
    final id = Uri.base.queryParameters["id"];
    print(id);
  }

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

  Future<void> sharedQuery() async {
    if (responseId != null) {
      final String url = 'http://localhost:3000/?id=$responseId';

      Clipboard.setData(ClipboardData(text: url));
    }
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
        final responseData = json.decode(response.body);
        searchResults = responseData;
        responseId = responseData['id'];
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
                  Colors.white,
                  // Colors.white[100] ?? Colors.white,
                ],
                // stops: [0,1 ], // Halfway split
              ),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height,
            // width: MediaQuery.of(context).size.width,
            width: 800,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.indigo,
                ],
              ),
            ),
          ),
          Positioned(
            top: 10.0,
            left: 18,
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
                    fillColor: const Color.fromARGB(255, 234, 212, 238),
                    prefixIcon: IconButton(
                      onPressed: () async {
                        await searchQuery(searchController.text);
                      },
                      icon: Icon(Icons.search, color: Colors.grey),
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
                        if (!isLoading &&
                            searchResults !=
                                null) // Show share icon only if content is loaded
                          IconButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text("Share"),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        ElevatedButton.icon(
                                          onPressed: () async {
                                            await sharedQuery();
                                            Navigator.pop(context);
                                          },
                                          icon: Icon(Icons.content_copy),
                                          label: Text("Copy to Clipboard"),
                                        ),
                                        ElevatedButton.icon(
                                          onPressed: () async {
                                            await sharedQuery();
                                            Navigator.pop(context);
                                          },
                                          icon: Icon(Icons.share),
                                          label: Text("Share to WhatsApp"),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                            icon: Icon(
                              Icons.share,
                              color: Colors.grey,
                            ),
                          ),
                        const SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: isLoading
                    ? _buildLoadingWidget() // Show shimmer effect while loading
                    : searchResults != null
                        ? ListView(
                            children: [
                              ListTile(
                                title: Text(
                                  searchResults!['results']['generatedTitle'],
                                  style: GoogleFonts.ubuntu(
                                      fontSize: 25.0,
                                      fontWeight: FontWeight.bold),
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
                                  title: Text(
                                    link['title'],
                                    style: GoogleFonts.ubuntuMono(
                                      color:
                                          const Color.fromARGB(255, 51, 22, 56),
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Text(
                                    link['whyRelevant'],
                                    style: GoogleFonts.ubuntu(
                                      fontSize: 10.0,
                                    ),
                                  ),
                                  onTap: () {
                                    // Handle link tap
                                  },
                                ),
                              Divider(),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      // Handle thumbs up action
                                    },
                                    icon: Icon(Icons.thumb_up),
                                    color: Colors.purple[200],
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      // Handle thumbs down action
                                    },
                                    icon: Icon(Icons.thumb_down),
                                    color: Colors.purple[200],
                                  ),
                                ],
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

  // Widget to show shimmer effect while loading
  Widget _buildLoadingWidget() {
    final Random random = Random();
    final int randomIndex = random.nextInt(loadingMessages.length);
    final String loadingMessage = loadingMessages[randomIndex];

    return ListView.builder(
      itemCount: 5, // Number of shimmer lines
      itemBuilder: (BuildContext context, int index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: ListTile(
            title: Text(loadingMessage),
            subtitle: Text(''),
          ),
        );
      },
    );
  }
}
