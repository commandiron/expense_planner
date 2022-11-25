

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';

class TransactionItem extends StatefulWidget {

  const TransactionItem({
    Key key,
    @required this.transaction,
    @required this.deleteTx,
    @required this.mediaQuery
  }): super(key: key);

  final Transaction transaction;
  final MediaQueryData mediaQuery;
  final Function deleteTx;

  @override
  State<TransactionItem> createState() => _TransactionItemState();
}

class _TransactionItemState extends State<TransactionItem> {

  Color _bgColor;

  @override
  void initState() {
    const availbleColor = [
      Colors.red,
      Colors.black,
      Colors.blue,
      Colors.purple
    ];

    _bgColor = availbleColor[Random().nextInt(4)];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _bgColor,
          radius: 30,
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: FittedBox(
                child: Text("\$ ${widget.transaction.amount}")
            ),
          ),
        ),
        title: Text(
          widget.transaction.title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: Text(
            DateFormat.yMMMd().format(widget.transaction.date)
        ),
        trailing: widget.mediaQuery.size.width > 460 ? ElevatedButton.icon(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.white),
                foregroundColor: MaterialStateProperty.all(Colors.red)
            ),
            onPressed: () => widget.deleteTx(widget.transaction.id),
            icon: Icon(
                Icons.delete
            ),
            label: Text("Delete")
        ) : IconButton(
          icon: Icon(
            Icons.delete,
            color: Colors.red,
          ),
          onPressed: () => widget.deleteTx(widget.transaction.id),
        ),
      ),
    );
  }
}
