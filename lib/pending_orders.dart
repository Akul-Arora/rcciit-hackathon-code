import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class PendingOrdersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pending Orders'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('pending_orders')
            .doc('pending_orders')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          Map<String, dynamic>? data = snapshot.data?.data() as Map<String, dynamic>?;
          Map<String, dynamic>? pending_orders = Map<String, dynamic>.from(data?['pending_orders'] ?? {});
          List myOrder = pending_orders.values
              .where((submission) => submission['Name'] == FirebaseAuth.instance.currentUser!.displayName)
              .toList();

          return ListView.builder(
            itemCount: myOrder.length,
            itemBuilder: (BuildContext context, int index) {
              Map<String, dynamic>? pending = Map<String, dynamic>.from(myOrder[index]);

              print(pending);
              String projectName = pending['Medicine name'];
              String quantity = pending['Medicine Quantity'].toString() ;
              return ListTile(
                title: Text(projectName,style: TextStyle(color: Colors.white,)),
                subtitle: Text(quantity,style: TextStyle(color: Colors.white,)),
                onTap:(){},
              );
            },
          );
        },
      ),
    );
  }
}