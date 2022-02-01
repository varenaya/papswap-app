import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:intl/intl.dart';

class SuperTokenTile extends StatelessWidget {
  static final customCacheManger = CacheManager(Config(
    'customCaheKey',
    stalePeriod: const Duration(
      days: 30,
    ),
    maxNrOfCacheObjects: 100,
  ));
  final Map tokendata;
  const SuperTokenTile({Key? key, required this.tokendata}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 10,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        padding: const EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CachedNetworkImage(
              key: UniqueKey(),
              cacheManager: customCacheManger,
              imageUrl: tokendata['tokenImg'],
              placeholder: (context, url) => Container(
                color: Colors.black12,
              ),
              errorWidget: (context, url, error) => const Icon(
                Icons.error,
                color: Colors.red,
              ),
              fit: BoxFit.fitHeight,
              height: 130,
            ),
            const SizedBox(
              width: 5,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(1.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tokendata['tokenName'],
                      maxLines: 2,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    RichText(
                        text: TextSpan(
                            text: 'Launched On:   ',
                            style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.bold,
                                color: Colors.black54),
                            children: [
                          TextSpan(
                              text: DateFormat('MMM dd, yyyy')
                                  .format(tokendata['launchedOn'].toDate()),
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                              ))
                        ])),
                    const SizedBox(
                      height: 2,
                    ),
                    RichText(
                        text: TextSpan(
                            text: 'Denoted To:   ',
                            style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.bold,
                                color: Colors.black54),
                            children: [
                          TextSpan(
                              text: tokendata['denotedTo'],
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                              ))
                        ])),
                    const SizedBox(
                      height: 5,
                    ),
                    RichText(
                      text: TextSpan(
                        text: 'Get upto ',
                        style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                            color: Colors.blue),
                        children: [
                          TextSpan(
                              text: '${tokendata['value']}INR',
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                color: Colors.teal,
                                fontWeight: FontWeight.bold,
                              )),
                          const TextSpan(
                            text: ' by redeeming this SuperToken.',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              color: Colors.blue,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    RichText(
                      text: TextSpan(
                        text: '${tokendata['tokenAmount']['left']}',
                        style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                            color: Colors.red),
                        children: [
                          TextSpan(
                              text: ' SuperTokens left of ',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                color: Colors.indigo.shade900,
                                fontWeight: FontWeight.w400,
                              )),
                          TextSpan(
                            text: '${tokendata['tokenAmount']['total']}.',
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              color: Colors.red,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
