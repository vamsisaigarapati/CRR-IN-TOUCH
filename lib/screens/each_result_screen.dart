import 'package:flutter/material.dart';

class EachSubjectResult extends StatelessWidget {
  final Map result;
  EachSubjectResult({@required this.result});
  List<DataRow> cells=[];
  @override
  Widget build(BuildContext context) {
    result.forEach((rno, score) {
      cells.add(DataRow(cells: [
        DataCell(Text(
          rno.toString(),
          style: TextStyle(fontSize: 22, color: Colors.indigo),
        )),
        DataCell(Text(score.toString(), style: TextStyle(fontSize: 20)))
      ]));
    });
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Today Result",
          style: TextStyle(
            fontFamily: "Quando",
          ),
        ),
      ),
      body: SingleChildScrollView(
              child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              Container(
                // decoration: BoxDecoration(color: Colors.grey),
                child: DataTable(columns: [
                  DataColumn(label: Text('Roll No',style: TextStyle(fontSize: 20),)),
                  DataColumn(label: Text('Score',style: TextStyle(fontSize: 20),))
                ], rows: cells),
              )
            ],
          ),
        ),
      ),
    );
  }
}
