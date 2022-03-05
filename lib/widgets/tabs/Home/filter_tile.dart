import 'package:flutter/material.dart';
import 'package:papswap/services/datarepo/providers/postprovider.dart';
import 'package:provider/provider.dart';

class FilterTile extends StatefulWidget {
  final dynamic ministry;
  final bool isselcted;
  const FilterTile({Key? key, required this.ministry, required this.isselcted})
      : super(key: key);

  @override
  _FilterTileState createState() => _FilterTileState();
}

class _FilterTileState extends State<FilterTile> {
  var isslected = false;
  @override
  void initState() {
    isslected = widget.isselcted;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final addcategory = Provider.of<PostData>(context);
    return ListTile(
        onTap: () async {
          setState(() {
            isslected = !isslected;
            addcategory.selectedcategoryactions(
                widget.ministry, isslected, context);
            Navigator.of(context).pop();
          });
        },
        selected: isslected,
        selectedTileColor: Colors.blue,
        contentPadding: const EdgeInsets.symmetric(horizontal: 24.0),
        minLeadingWidth: 30,
        title: Text(
          widget.ministry,
          style: TextStyle(
              fontSize: 15, color: isslected ? Colors.white : Colors.black),
        ),
        trailing: Icon(
          Icons.check,
          color: isslected ? Colors.white : Colors.grey,
        ));
  }
}
