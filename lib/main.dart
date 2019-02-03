import 'dart:math';

import 'package:flutter/material.dart';
import 'package:othello_game_flutter/block_unit.dart';
import 'package:othello_game_flutter/coordinate.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Othello',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Othello'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

const double BLOCK_SIZE = 40;
const int ITEM_EMPTY = 0;
const int ITEM_WHITE = 1;
const int ITEM_BLACK = 2;

class _MyHomePageState extends State<MyHomePage> {

  List<List<BlockUnit>> table;
  int currentTurn = ITEM_BLACK;
  int countItemWhite = 0;
  int countItemBlack = 0;


  @override
  void initState() {
    initTable();
    initTableItems();
    super.initState();
  }

  void initTable() {
    table = List();
    for (int row = 0; row < 8; row++) {
      List<BlockUnit> list = List();
      for (int col = 0; col < 8; col++) {
        list.add(BlockUnit(value: ITEM_EMPTY));
      }
      table.add(list);
    }
  }

  void initTableItems() {
    table[3][3].value = ITEM_WHITE;
    table[4][3].value = ITEM_BLACK;
    table[3][4].value = ITEM_BLACK;
    table[4][4].value = ITEM_WHITE;
  }

  int randomItem() {
    Random random = Random();
    return random.nextInt(3);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          color: Color(0xffecf0f1),
          child: Column(children: <Widget>[
            buildMenu(),
            Expanded(child: Center(
              child: Container(
                  decoration: BoxDecoration(
                      color: Color(0xff34495e),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(width: 8, color: Color(0xff2c3e50))),
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: buildTable()
                  )),
            )),
            buildScoreTab()
          ])),
    );
  }

  Widget buildScoreTab() {
    return Row(mainAxisSize: MainAxisSize.max, children: <Widget>[
      Expanded(child: Container(color: Color(0xff34495e),
          child: Row(mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(padding: EdgeInsets.all(16),
                    child: buildItem(BlockUnit(value: ITEM_WHITE))),
                Text("x $countItemWhite", style: TextStyle(fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white))
              ]))),
      Expanded(child: Container(color: Color(0xffbdc3c7),
          child: Row(mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(padding: EdgeInsets.all(16),
                    child: buildItem(BlockUnit(value: ITEM_BLACK))),
                Text("x $countItemBlack", style: TextStyle(fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.black))
              ])))
    ]);
  }

  Container buildMenu() {
    return Container(
      padding: EdgeInsets.only(top: 36, bottom: 12, left: 16, right: 16),
      color: Color(0xff34495e),
      child:
      Row(mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            GestureDetector(onTap: () {
              restart();
            },
                child: Container(constraints: BoxConstraints(minWidth: 120),
                    decoration: BoxDecoration(color: Color(0xff27ae60),
                        borderRadius: BorderRadius.circular(4)),
                    padding: EdgeInsets.all(12),
                    child: Column(children: <Widget>[
                      Text("New Game", style: TextStyle(fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white))
                    ]))),
            Expanded(child: Container()),
            Container(constraints: BoxConstraints(minWidth: 120),
                decoration: BoxDecoration(color: Color(0xffbbada0),
                    borderRadius: BorderRadius.circular(4)),
                padding: EdgeInsets.all(8),
                child: Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                  Text("TURN", style: TextStyle(fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
                  Container(margin: EdgeInsets.only(left: 8), child:
                  buildItem(BlockUnit(value: currentTurn)))
                ]))
          ]),
    );
  }

  List<Row> buildTable() {
    List<Row> listRow = List();
    for (int row = 0; row < 8; row++) {
      List<Widget> listCol = List();
      for (int col = 0; col < 8; col++) {
        listCol.add(buildBlockUnit(row, col));
      }
      Row rowWidget = Row(mainAxisSize: MainAxisSize.min, children: listCol);
      listRow.add(rowWidget);
    }
    return listRow;
  }

  Widget buildBlockUnit(int row, int col) {
    return GestureDetector(
        onTap: () {
          setState(() {
            pasteItemToTable(row, col, currentTurn);
          });
        }, child: Container(
      decoration: BoxDecoration(
        color: Color(0xff27ae60),
        borderRadius: BorderRadius.circular(2),
      ),
      width: BLOCK_SIZE,
      height: BLOCK_SIZE,
      margin: EdgeInsets.all(2),
      child: Center(child: buildItem(table[row][col])),
    ));
  }

  Widget buildItem(BlockUnit block) {
    if (block.value == ITEM_BLACK) {
      return Container(width: 30, height: 30,
          decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.black));
    } else if (block.value == ITEM_WHITE) {
      return Container(width: 30, height: 30,
          decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white));
    }
    return Container();
  }

  bool pasteItemToTable(int row, int col, int item) {
    if (table[row][col].value == ITEM_EMPTY) {
      List<Coordinate> listCoordinate = List();
      listCoordinate.addAll(checkRight(row, col, item));
      listCoordinate.addAll(checkDown(row, col, item));
      listCoordinate.addAll(checkLeft(row, col, item));
      listCoordinate.addAll(checkUp(row, col, item));
      listCoordinate.addAll(checkUpLeft(row, col, item));
      listCoordinate.addAll(checkUpRight(row, col, item));
      listCoordinate.addAll(checkDownLeft(row, col, item));
      listCoordinate.addAll(checkDownRight(row, col, item));

      if (listCoordinate.isNotEmpty) {
        table[row][col].value = item;
        inverseItemFromList(listCoordinate);
        currentTurn = inverseItem(currentTurn);
        updateCountItem();
        return true;
      }
    }
    return false;
  }

  List<Coordinate> checkRight(int row, int col, int item) {
    List<Coordinate> list = List();
    if (col + 1 < 8) {
      for (int c = col + 1; c < 8; c++) {
        if (table[row][c].value == item) {
          return list;
        } else if (table[row][c].value == ITEM_EMPTY) {
          return List();
        } else {
          list.add(Coordinate(row: row, col: c));
        }
      }
    }
    return List();
  }

  List<Coordinate> checkLeft(int row, int col, int item) {
    List<Coordinate> list = List();
    if (col - 1 >= 0) {
      for (int c = col - 1; c >= 0; c--) {
        if (table[row][c].value == item) {
          return list;
        } else if (table[row][c].value == ITEM_EMPTY) {
          return List();
        } else {
          list.add(Coordinate(row: row, col: c));
        }
      }
    }
    return List();
  }

  List<Coordinate> checkDown(int row, int col, int item) {
    List<Coordinate> list = List();
    if (row + 1 < 8) {
      for (int r = row + 1; r < 8; r++) {
        if (table[r][col].value == item) {
          return list;
        } else if (table[r][col].value == ITEM_EMPTY) {
          return List();
        } else {
          list.add(Coordinate(row: r, col: col));
        }
      }
    }
    return List();
  }

  List<Coordinate> checkUp(int row, int col, int item) {
    List<Coordinate> list = List();
    if (row - 1 >= 0) {
      for (int r = row - 1; r >= 0; r--) {
        if (table[r][col].value == item) {
          return list;
        } else if (table[r][col].value == ITEM_EMPTY) {
          return List();
        } else {
          list.add(Coordinate(row: r, col: col));
        }
      }
    }
    return List();
  }

  List<Coordinate> checkUpLeft(int row, int col, int item) {
    List<Coordinate> list = List();
    if (row - 1 >= 0 && col - 1 >= 0) {
      int r = row - 1;
      int c = col - 1;
      while (r >= 0 && c >= 0) {
        if (table[r][c].value == item) {
          return list;
        } else if (table[r][c].value == ITEM_EMPTY) {
          return List();
        } else {
          list.add(Coordinate(row: r, col: c));
        }
        r--;
        c--;
      }
    }
    return List();
  }

  List<Coordinate> checkUpRight(int row, int col, int item) {
    List<Coordinate> list = List();
    if (row - 1 >= 0 && col + 1 < 8) {
      int r = row - 1;
      int c = col + 1;
      while (r >= 0 && c < 8) {
        if (table[r][c].value == item) {
          return list;
        } else if (table[r][c].value == ITEM_EMPTY) {
          return List();
        } else {
          list.add(Coordinate(row: r, col: c));
        }
        r--;
        c++;
      }
    }
    return List();
  }

  List<Coordinate> checkDownLeft(int row, int col, int item) {
    List<Coordinate> list = List();
    if (row + 1 < 8 && col - 1 >= 0) {
      int r = row + 1;
      int c = col - 1;
      while (r < 8 && c >= 0) {
        if (table[r][c].value == item) {
          return list;
        } else if (table[r][c].value == ITEM_EMPTY) {
          return List();
        } else {
          list.add(Coordinate(row: r, col: c));
        }
        r++;
        c--;
      }
    }
    return List();
  }

  List<Coordinate> checkDownRight(int row, int col, int item) {
    List<Coordinate> list = List();
    if (row + 1 < 8 && col + 1 < 8) {
      int r = row + 1;
      int c = col + 1;
      while (r < 8 && c < 8) {
        if (table[r][c].value == item) {
          return list;
        } else if (table[r][c].value == ITEM_EMPTY) {
          return List();
        } else {
          list.add(Coordinate(row: r, col: c));
        }
        r++;
        c++;
      }
    }
    return List();
  }

  void inverseItemFromList(List<Coordinate> list) {
    for (Coordinate c in list) {
      table[c.row][c.col].value = inverseItem(table[c.row][c.col].value);
    }
  }

  int inverseItem(int item) {
    if (item == ITEM_WHITE) {
      return ITEM_BLACK;
    } else if (item == ITEM_BLACK) {
      return ITEM_WHITE;
    }
    return item;
  }

  void updateCountItem() {
    countItemBlack = 0;
    countItemWhite = 0;
    for (int row = 0; row < 8; row++) {
      for (int col = 0; col < 8; col++) {
        if (table[row][col].value == ITEM_BLACK) {
          countItemBlack++;
        } else if (table[row][col].value == ITEM_WHITE) {
          countItemWhite++;
        }
      }
    }
  }

  void restart() {
    setState(() {
      countItemWhite = 0;
      countItemBlack = 0;
      currentTurn = ITEM_BLACK;
      initTable();
      initTableItems();
    });
  }
}
