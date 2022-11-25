import 'dart:io';

import 'package:expanse_planner/models/transaction.dart';
import 'package:expanse_planner/widgets/chart.dart';
import 'package:expanse_planner/widgets/new_transaction.dart';
import 'package:expanse_planner/widgets/transaction_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Expenses',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        accentColor: Colors.amber,
        fontFamily: "Quicksand",
        appBarTheme: AppBarTheme(
          titleTextStyle: TextStyle(
            fontFamily: "OpenSans",
            fontSize: 20,
            fontWeight: FontWeight.bold,
          )
        )
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver   {

  final List<Transaction> _userTransactions = [
    Transaction(
        id: "t1",
        title: "New Shoes",
        amount: 69.99,
        date: DateTime.now()
    ),
    Transaction(
        id: "t2",
        title: "Weekly Groceries",
        amount: 16.53,
        date: DateTime.now()
    ),
  ];

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print(state);
  }

  @override
  dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  List<Transaction> get _recentTransactions {
    return _userTransactions.where((tx) {
      return tx.date.isAfter(
          DateTime.now().subtract(
              Duration(days: 7)
          )
      );
    }).toList();
  }

  bool _showChart = false;

  void _addNewTransaction(String title, double amount, DateTime date) {
    final newTx = Transaction(
        id: DateTime.now().toString(),
        title: title,
        amount: amount,
        date: date
    );
    setState(() {
      _userTransactions.add(newTx);
    });
  }

  void startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return NewTransaction(_addNewTransaction);
        }
    );
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((tx) => tx.id == id);
    });
  }

  List<Widget> _buildLandscapeContent(
      MediaQueryData mediaQuery,
      PreferredSizeWidget appbar,
      Widget txListWidget
  ) {
    return [Row(
      mainAxisAlignment: MainAxisAlignment.center ,
      children: <Widget> [
        Text("Show Chart", style: Theme.of(context).textTheme.titleMedium),
        Switch.adaptive(
          activeColor: Theme.of(context).primaryColor,
          value: _showChart,
          onChanged: (value) {
            setState( () {
              _showChart = value;
            });
          },
        ),
      ],
    ),_showChart ? Container(
        height: (
            mediaQuery.size.height -
                appbar.preferredSize.height -
                mediaQuery.padding.top
        ) * 0.7,
        child: Chart(_recentTransactions)
    ): txListWidget ];
  }

  List<Widget> _buildPortaitContent(
      MediaQueryData mediaQuery,
      PreferredSizeWidget appbar,
      Widget txListWidget
  ) {
    return [Container(
        height: (
            mediaQuery.size.height -
                appbar.preferredSize.height -
                mediaQuery.padding.top
        ) * 0.3,
        child: Chart(_recentTransactions)
    ), txListWidget];
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandScape = mediaQuery.orientation == Orientation.landscape;
    final PreferredSizeWidget appbar = Platform.isIOS
      ? CupertinoNavigationBar(
        middle: Text('Personal Expenses'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget> [
            GestureDetector(
              onTap: () => startAddNewTransaction(context),
              child: Icon(CupertinoIcons.add),
            )
          ],
        ) ,
      )
      : AppBar(
        title: Text('Personal Expenses'),
        actions: [
          IconButton(
              onPressed: () => startAddNewTransaction(context),
              icon: Icon(
                  Icons.add
              )
          )
        ],
      );
    final txListWidget = Container(
      height: (
          mediaQuery.size.height -
              appbar.preferredSize.height -
              mediaQuery.padding.top
      ) * 0.7,
      child: TransactionList(_userTransactions, _deleteTransaction)
    );

    final pageBody =  SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget> [
            if(isLandScape) ..._buildLandscapeContent(mediaQuery, appbar, txListWidget),
            if(!isLandScape) ..._buildPortaitContent(mediaQuery, appbar, txListWidget),
          ],
        ),
      ),
    );

    return Platform.isIOS
      ? CupertinoPageScaffold(child: pageBody, navigationBar: appbar,)
      : Scaffold(
          appBar: appbar,
          body: pageBody,
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          floatingActionButton: Platform.isIOS ? Container() : FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () => startAddNewTransaction(context),
          ),
      );
  }
}
