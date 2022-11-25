import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {

  final Function addTx;

  NewTransaction(this.addTx) {
   print("Constructor  NewTransaction Widget");
  }

  @override
  State<NewTransaction> createState() {
    print("createState  NewTransaction Widget");
    return _NewTransactionState();
  }
}

class _NewTransactionState extends State<NewTransaction> {

  final _titleController = TextEditingController();

  final _amountController = TextEditingController();

  DateTime _selectedDate;

  _NewTransactionState() {
    print("Constructor NewTransaction State");
  }

  @override
  void initState() {
    print("initState()");
    super.initState();
  }

  @override
  void didUpdateWidget(covariant NewTransaction oldWidget) {
    print("didUpdateWidget()");
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    print("dispose()");
    super.dispose();
  }

  void _submitData() {

    if(_amountController.text.isEmpty) {
      return;
    }

    final enteredTitle = _titleController.text;
    final enteredAmount = double.parse(_amountController.text);

    if(enteredTitle.isEmpty || enteredAmount <= 0 || _selectedDate == null) {
      return;
    }

    widget.addTx(
        enteredTitle,
        enteredAmount,
        _selectedDate
    );

    Navigator.of(context).pop();
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if(pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.only(
              top:10,
              left: 10,
              right: 10,
              bottom: 100 + mediaQuery.viewInsets.bottom,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget> [
              TextField(
                decoration: InputDecoration(labelText: "Title"),
                controller: _titleController,
                keyboardType: TextInputType.text,
              ),
              TextField(
                decoration: InputDecoration(labelText: "Amount"),
                controller: _amountController,
                keyboardType: TextInputType.number,
                onSubmitted: (_) => _submitData,
              ),
              Container(
                height: 70,
                child: Row(
                  children: <Widget> [
                    Expanded(
                      child: Text(
                        _selectedDate == null
                          ? "No Date Chosen"
                          :  "Picked Date: ${DateFormat.yMd().format(_selectedDate)}"
                      ),
                    ),
                    TextButton(
                      style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.all(Theme.of(context).primaryColor)
                      ),
                      child: Text(
                        "Choose Date",
                        style: TextStyle(
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      onPressed: _presentDatePicker,
                    )
                  ],
                ),
              ),
              ElevatedButton(
                child: Text("Add Transaction"),
                onPressed: _submitData,
              )
            ],
          ),
        ),
      ),
    );
  }
}
