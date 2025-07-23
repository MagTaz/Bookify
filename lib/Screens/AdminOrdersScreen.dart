import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../Utils/MainColors.dart';
import '../Utils/TextStyle.dart';

class AdminOrdersScreen extends StatelessWidget {
  const AdminOrdersScreen({super.key});

  Future<void> updateStatus(String docId, String newStatus) async {
    await FirebaseFirestore.instance.collection('rentals').doc(docId).update({
      'status': newStatus,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Manage Rental Orders")),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance
                .collection('rentals')
                .orderBy('timestamp', descending: true)
                .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(
              child: Center(
                child: SpinKitThreeBounce(
                  size: 30,
                  color: MainColors.mainColor,
                ),
              ),
            );

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty)
            return Center(child: Text("No rental orders."));

          final orders = snapshot.data!.docs;

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final data = orders[index].data() as Map<String, dynamic>;
              final createdAt = data['timestamp']?.toDate();
              final id = orders[index].id;
              final title = data['book_title'] ?? '';
              final userEmail = data['user_email'] ?? '';
              final status = data['status'] ?? 'pending';
              final rentalDate = data['rental_date']?.toDate();
              final returnDate = data['return_date']?.toDate();

              return Container(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black38,
                      spreadRadius: 1,
                      blurRadius: 10,
                    ),
                  ],
                ),

                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Book: $title",
                        style: Text_Style.textStyleBold(Colors.black, 16),
                      ),
                      Text(
                        "Email: $userEmail",
                        style: Text_Style.textStyleNormal(Colors.black54, 14),
                      ),
                      Text("From: ${_formatDate(rentalDate)}"),
                      Text("To: ${_formatDate(returnDate)}"),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: "Status: ",
                              style: TextStyle(color: Colors.black),
                            ),
                            TextSpan(
                              text: status,
                              style: TextStyle(
                                color: _getStatusColor(status),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),

                      Text("Created at: ${_formatDateTime(createdAt)}"),

                      SizedBox(height: 10),
                      Row(
                        children: [
                          _statusButton("Approve", "approved", id, status),
                          SizedBox(width: 10),
                          _statusButton("Return", "returned", id, status),
                          SizedBox(width: 10),
                          _statusButton("Reject", "rejected", id, status),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _statusButton(
    String label,
    String status,
    String docId,
    String orderStatus,
  ) {
    return Builder(
      builder: (context) {
        return ElevatedButton(
          onPressed:
              status == orderStatus
                  ? null
                  : () {
                    showDialog(
                      context: context,
                      builder: (_) {
                        bool isLoading = false;

                        return StatefulBuilder(
                          builder: (context, setState) {
                            return AlertDialog(
                              title: Text("Confirm Status Change"),
                              content: Text(
                                "Are you sure you want to change status to \"$status\"?",
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text(
                                    "Cancel",
                                    style: Text_Style.textStyleNormal(
                                      MainColors.mainColor,
                                      15,
                                    ),
                                  ),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: MainColors.mainColor,
                                  ),
                                  onPressed:
                                      isLoading
                                          ? null
                                          : () async {
                                            setState(() => isLoading = true);
                                            await updateStatus(docId, status);
                                            Navigator.pop(context);
                                          },
                                  child:
                                      isLoading
                                          ? SizedBox(
                                            width: 18,
                                            height: 18,
                                            child: Center(
                                              child: SpinKitCircle(
                                                size: 10,
                                                color: MainColors.mainColor,
                                              ),
                                            ),
                                          )
                                          : Text(
                                            "Yes",
                                            style: Text_Style.textStyleNormal(
                                              Colors.white,
                                              15,
                                            ),
                                          ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    );
                  },
          style: ElevatedButton.styleFrom(
            backgroundColor: MainColors.mainColor,
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          child: Text(
            label,
            style: Text_Style.textStyleNormal(Colors.white, 15),
          ),
        );
      },
    );
  }

  String _formatDateTime(DateTime? date) {
    if (date == null) return 'Unknown';
    return "${date.year}/${date.month}/${date.day} - ${date.hour}:${date.minute.toString().padLeft(2, '0')}";
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Not set';
    return "${date.year}/${date.month}/${date.day}";
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'approved':
        return Colors.green;
      case 'returned':
        return Colors.blue;
      case 'rejected':
        return Colors.red;
      case 'cancelled':
        return Colors.grey;
      default:
        return Colors.black;
    }
  }
}
