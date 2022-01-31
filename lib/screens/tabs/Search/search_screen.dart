import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:papswap/models/app/color_const.dart';
import 'package:papswap/models/post.dart';
import 'package:papswap/models/reswappost.dart';
import 'package:papswap/services/datarepo/Api/data_fetcher.dart';
import 'package:papswap/widgets/tabs/Profile/reswap_feed_tile.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late final TextEditingController controller;
  final DataFetcher dataFetcher = DataFetcher();
  ReswapPost reswapPost = ReswapPost.empty();

  @override
  void initState() {
    controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future runquery(String value) async {
    final commentdata = await dataFetcher.getquerycomment(
      value,
    );
    final postId = commentdata.data()!['post_id'];
    final postdata = await dataFetcher.getpost(postId);
    final Post post = Post.fromDoc(postdata);
    setState(() {
      reswapPost = ReswapPost.fromDoc(commentdata, post);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.scaffColor,
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 10, 8, 5),
                child: Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 50,
                        child: TextField(
                          controller: controller,
                          cursorColor: Colors.grey,
                          onSubmitted: (value) {
                            runquery(value);
                          },
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 18),
                            filled: true,
                            fillColor: Colors.white,
                            prefixIcon:
                                const Icon(Icons.search, color: Colors.black),
                            suffix: InkWell(
                                onTap: () {
                                  controller.text.isEmpty
                                      ? FocusScope.of(context).unfocus()
                                      : controller.text = '';
                                },
                                child: const Icon(Icons.close,
                                    color: Colors.black)),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide.none),
                            hintText: "Enter Reciept No.",
                            hintStyle: const TextStyle(
                                fontSize: 14, color: Colors.grey),
                          ),
                        ),
                      ),
                    ),
                    // const SizedBox(width: 10),
                    // Container(
                    //   height: 50,
                    //   width: 50,
                    //   decoration: BoxDecoration(
                    //       color: Colors.white,
                    //       borderRadius: BorderRadius.circular(10)),
                    //   child: IconButton(
                    //     onPressed: () {},
                    //     icon: const Icon(
                    //       Icons.filter_list,
                    //       color: Colors.black,
                    //       size: 30,
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              reswapPost.commentId == ''
                  ? const Text('no data')
                  : ReswapFeedTile(reswapPost: reswapPost),
              // FutureBuilder(
              //   future: runquery(value),
              //   builder: (context, snapshot) {
              //     if (snapshot.connectionState == ConnectionState.waiting) {
              //       return const CustomProgressIndicator();
              //     }
              //     final reswapPost = snapshot.data;
              //     if (snapshot.hasData) {
              //       return ReswapFeedTile(reswapPost: );
              //     }
              //     return Text('Data not found');
              //   },
              // )
            ],
          ),
        ));
  }
}

// class MySearchDelegate extends SearchDelegate {
//   @override
//   List<Widget>? buildActions(BuildContext context) {
//     // TODO: implement buildActions
//     throw UnimplementedError();
//   }

//   @override
//   Widget? buildLeading(BuildContext context) {
//     // TODO: implement buildLeading
//     throw UnimplementedError();
//   }

//   @override
//   Widget buildResults(BuildContext context) {
//     // TODO: implement buildResults
//     throw UnimplementedError();
//   }

//   @override
//   Widget buildSuggestions(BuildContext context) {
//     // TODO: implement buildSuggestions
//     throw UnimplementedError();
//   }
// }
