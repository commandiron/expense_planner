import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';

class TransactionList extends StatelessWidget {

  final List<Transaction> transactions;
  final Function deleteTx;

  TransactionList(this.transactions, this.deleteTx);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 550,
      child: transactions.isEmpty ? Column(
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
      ) : ListView.builder(
        itemCount: transactions.length,
        itemBuilder: (ctx, index) {
          return Card(
            elevation: 5,
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
            child: ListTile(
              leading: CircleAvatar(
                radius: 30,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: FittedBox(
                      child: Text("\$ ${transactions[index].amount}")
                  ),
                ),
              ),
              title: Text(
                transactions[index].title,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              subtitle: Text(
                  DateFormat.yMMMd().format(transactions[index].date)
              ),
              trailing: IconButton(
                icon: Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
                onPressed: () => deleteTx(transactions[index].id),
              ),
            ),
          );
        }
      )
    );
  }
}
