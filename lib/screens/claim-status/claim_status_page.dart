import '../../models/form_model.dart';
import '../../service/form_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ClaimStatusModel {
  String? submittedDate;
  String? status;
  ClaimStatusModel();
}

class ClaimStatus extends StatefulWidget {
  const ClaimStatus({Key? key}) : super(key: key);

  @override
  _ClaimStatusState createState() => _ClaimStatusState();
}

class _ClaimStatusState extends State<ClaimStatus> {
  FormService formService = FormService();
  ClaimStatusModel claimStatusModel = ClaimStatusModel();
  List<FormModel> formList = [];

  List<DataRow> dataRowList = [];
  bool? isDataLoading = false;
  @override
  void initState() {
    super.initState();
    updateFormList();
  }

  void updateFormList() async {
    setState(() {
      isDataLoading = true;
    });
    await formService.newFetchForm();
    formList = formService.newFormModelList;

    formList.forEach((e) {
      claimStatusModel.submittedDate =
          DateFormat('yyyy-MM-dd').format(e.addedDate!);
      claimStatusModel.status = e.status;
      final dataRow = DataRow(
        cells: <DataCell>[
          DataCell(Text(claimStatusModel.submittedDate.toString())),
          DataCell(Text(claimStatusModel.status.toString())),
        ],
      );

      dataRowList.add(dataRow);
    });
    setState(() {
      isDataLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Claim Status"),
      ),
      body: SingleChildScrollView(
        child: isDataLoading!
            ? Center(
                heightFactor: 10,
                child: Container(
                    child: Center(child: CircularProgressIndicator())))
            : dataRowList.isNotEmpty
                ? Center(
                    heightFactor: 1.3,
                    child: Container(
                      child: DataTable(
                        decoration: BoxDecoration(border: Border.all()),
                        headingRowHeight: 40,
                        dividerThickness: 2,
                        dataRowColor:
                            MaterialStateProperty.all(Colors.grey[200]),
                        headingRowColor:
                            MaterialStateProperty.all(Colors.grey[700]),
                        dataRowHeight: 30,
                        horizontalMargin: 20,
                        columnSpacing: 100,
                        columns: [
                          DataColumn(
                              label: Text("Submitted Date",
                                  style: TextStyle(color: Colors.white))),
                          DataColumn(
                              label: Text("Status",
                                  style: TextStyle(color: Colors.white)))
                        ],
                        rows: dataRowList,
                      ),
                    ),
                  )
                : Center(
                    heightFactor: 10,
                    child: Column(
                      children: [
                        Text("Claim status is empty"),
                        SizedBox(height: 10),
                        Text("Please submit a claim first"),
                      ],
                    ),
                  ),
      ),
    );
  }
}
