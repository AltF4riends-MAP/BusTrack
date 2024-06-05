import 'package:cloud_firestore/cloud_firestore.dart';

class Stop {
  String id;
  String stopName;
  double posX;
  double posY;

  Stop(this.id, this.stopName, this.posX, this.posY);

  factory Stop.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Stop(
      doc.id,
      data['stopName'] ?? '',
      data['posX']?.toDouble() ?? 0.0,
      data['posY']?.toDouble() ?? 0.0,
    );
  }
}
