import 'package:flutter/material.dart';
import 'utils.dart';

class FibonacciScreen extends StatefulWidget {
  @override
  _FibonacciScreenState createState() => _FibonacciScreenState();
}

class _FibonacciScreenState extends State<FibonacciScreen> {
  List<Map<String, dynamic>> mainFibonacciDetails;
  List<Map<String, dynamic>> bottomSheetItemList = [];
  Map<String, dynamic>? lastTappedItem;
  Map<String, dynamic>? lastAddedItem;
  ScrollController _scrollController = ScrollController();
  ScrollController _bottomSheetScrollController = ScrollController();

  _FibonacciScreenState() : mainFibonacciDetails = generateFibonacciDetails(40);

  void _showBottomSheetWithIconFilter(BuildContext context, IconData icon) {
    List<Map<String, dynamic>> filtered = mainFibonacciDetails.where((detail) => detail['icon'] == icon).toList();
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ListView.builder(
          controller: _bottomSheetScrollController,
          itemCount: filtered.length,
          itemBuilder: (context, index) {
            var item = filtered[index];
            Color bgColor = item == lastTappedItem ? Colors.green : Colors.white;
            return ListTile(
              title: Text('Number: ${item['number']}'),
              subtitle: Text('Index: ${item['index']}'),
              trailing: Icon(item['icon']),
              tileColor: bgColor,
            );
          },
        );
      }
    );

     _postModalActions(filtered);
  }

  void _showBottomSheetSelectedIcon(BuildContext context, IconData icon, int index) {
    Map<String, dynamic> item = mainFibonacciDetails.removeAt(index);
    bottomSheetItemList.add(item);
    bottomSheetItemList.sort((a, b) => a['index'].compareTo(b['index']));
    lastTappedItem = item;
    List<Map<String, dynamic>> filteredItems = bottomSheetItemList.where((detail) => detail['icon'] == icon).toList();
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ListView.builder(
          controller: _bottomSheetScrollController,
          itemCount: filteredItems.length,
          itemBuilder: (context, index) {
            var item = filteredItems[index];
            Color bgColor = item == lastTappedItem ? Colors.green : Colors.white;
            return ListTile(
              title: Text('Number: ${item['number']}'),
              subtitle: Text('Index: ${item['index']}'),
              trailing: Icon(item['icon']),
              tileColor: bgColor,
              onTap: () => _handleItemTap(item),
            );
          },
        );
      }
    );

    _postModalActions(filteredItems);
  }

  void _postModalActions(List<Map<String, dynamic>> filtered) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_bottomSheetScrollController.hasClients && lastTappedItem != null) {
        int index = filtered.indexWhere((item) => item == lastTappedItem);
        if (index != -1) {
          double itemHeight = 50;
          double scrollPosition = index * itemHeight;
          
          if (scrollPosition <= _bottomSheetScrollController.position.maxScrollExtent) {
            _bottomSheetScrollController.animateTo(
              scrollPosition,
              duration: Duration(milliseconds: 300),
              curve: Curves.easeIn,
            );
          } else {
            _bottomSheetScrollController.jumpTo(_bottomSheetScrollController.position.maxScrollExtent);
          }
        }
      }
    });
  }
  
  void _handleItemTap(Map<String, dynamic> item) {
    setState(() {
      bottomSheetItemList.remove(item);
      mainFibonacciDetails.add(item);
      mainFibonacciDetails.sort((a, b) => a['index'].compareTo(b['index']));
      lastAddedItem = item;
    });
    Navigator.pop(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      int mainIndex = mainFibonacciDetails.indexWhere((mainItem) => mainItem == item);
      if (mainIndex != -1) {
        _scrollController.animateTo(
          mainIndex * 50,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeIn,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fibonacci Numbers'),
        centerTitle: true,
      ),
      body: ListView.builder(
        controller: _scrollController,
        itemCount: mainFibonacciDetails.length,
        itemBuilder: (context, index) {
          var item = mainFibonacciDetails[index];
          Color bgColor = item == lastAddedItem ? Colors.red : Colors.white;
          return ListTile(
            title: Text('Index: ${item['index']} Number: ${item['number']}'),
            trailing: GestureDetector(
              onTap: () => setState(() {
                _showBottomSheetSelectedIcon(context, item['icon'], index);
              }),
              child: Icon(item['icon']),
            ),
            tileColor: bgColor,
            onTap: () {
              setState(() {
                lastTappedItem = item;
                _showBottomSheetWithIconFilter(context, item['icon']);
              });
            },
          );
        },
      ),
    );
  }
}
