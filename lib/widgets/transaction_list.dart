import 'package:expanse_planner/widgets/transaction_item.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';

class TransactionList extends StatelessWidget {

  final List<Transaction> transactions;
  final Function deleteTx;

  TransactionList(this.transactions, this.deleteTx);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return transactions.isEmpty
        ?
    LayoutBuilder(
      builder: (ctx, constraints) {
        return Column(
          children: <Widget> [
            Text("No added yet.", style: Theme.of(context).textTheme.titleMedium,),
            SizedBox(height: 10,),
            Container(
                height: 200,
                child: Image.asset(
                  "assets/images/snake.jpg",
                  fit: BoxFit.cover,
                )
            )
          ],
        );
      }
    )
        :
    ListView(
      children: transactions.map((tx) =>
        TransactionItem(
          key: ValueKey(tx.id),
          transaction: tx,
          deleteTx: deleteTx,
          mediaQuery: mediaQuery
        )
      ).toList()
    );
  }
}
