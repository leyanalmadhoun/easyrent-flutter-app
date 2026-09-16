import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  FirebaseService._();

  static final auth = FirebaseAuth.instance;
  static final db = FirebaseFirestore.instance;

  static String get uid => auth.currentUser!.uid;

  static Stream<DocumentSnapshot<Map<String, dynamic>>> userStream() {
    return db.collection('users').doc(uid).snapshots();
  }

  static Future<void> updateProfile({required String fullName, required String phone}) {
    return db.collection('users').doc(uid).update({
      'fullName': fullName.trim(),
      'phone': phone.trim(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> availableCars() {
    return db.collection('cars').where('status', isEqualTo: 'Available').snapshots();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> officeCars() {
    return db.collection('cars').where('officeId', isEqualTo: uid).snapshots();
  }

  static Future<void> addCar(Map<String, dynamic> car) async {
    final user = await db.collection('users').doc(uid).get();
    await db.collection('cars').add({
      ...car,
      'officeId': uid,
      'officeName': user.data()?['fullName'] ?? 'Rental Office',
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  static Future<void> deleteCar(String carId) => db.collection('cars').doc(carId).delete();

  static Future<void> createBooking({
    required String carId,
    required Map<String, dynamic> car,
    required DateTime pickup,
    required DateTime returned,
    required String delivery,
    required String payment,
  }) async {
    final user = await db.collection('users').doc(uid).get();
    final days = returned.difference(pickup).inDays < 1 ? 1 : returned.difference(pickup).inDays;
    final dailyPrice = (car['dailyPrice'] as num?)?.toDouble() ?? 0;
    final booking = db.collection('bookings').doc();
    final batch = db.batch();
    batch.set(booking, {
      'carId': carId,
      'carName': car['name'] ?? 'Car',
      'imageUrl': car['imageUrl'] ?? '',
      'officeId': car['officeId'],
      'officeName': car['officeName'] ?? 'Rental Office',
      'customerId': uid,
      'customerName': user.data()?['fullName'] ?? 'Customer',
      'pickupAt': Timestamp.fromDate(pickup),
      'returnAt': Timestamp.fromDate(returned),
      'deliveryOption': delivery,
      'paymentMethod': payment,
      'dailyPrice': dailyPrice,
      'days': days,
      'total': dailyPrice * days,
      'status': 'pending',
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
    final notification = db.collection('notifications').doc();
    batch.set(notification, {
      'userId': car['officeId'],
      'title': 'New booking request',
      'message': '${user.data()?['fullName'] ?? 'A customer'} requested ${car['name'] ?? 'your car'}.',
      'bookingId': booking.id,
      'read': false,
      'createdAt': FieldValue.serverTimestamp(),
    });
    await batch.commit();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> customerBookings() {
    return db.collection('bookings').where('customerId', isEqualTo: uid).snapshots();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> officeBookings() {
    return db.collection('bookings').where('officeId', isEqualTo: uid).snapshots();
  }

  static Future<void> updateBookingStatus(String bookingId, String status) async {
    final booking = db.collection('bookings').doc(bookingId);
    final snapshot = await booking.get();
    final batch = db.batch();
    batch.update(booking, {
      'status': status,
      'updatedAt': FieldValue.serverTimestamp(),
    });
    final notification = db.collection('notifications').doc();
    batch.set(notification, {
      'userId': snapshot.data()?['customerId'],
      'title': status == 'confirmed' ? 'Booking confirmed' : 'Booking declined',
      'message': 'Your booking for ${snapshot.data()?['carName'] ?? 'the car'} was $status.',
      'bookingId': bookingId,
      'read': false,
      'createdAt': FieldValue.serverTimestamp(),
    });
    await batch.commit();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> notifications() {
    return db.collection('notifications').where('userId', isEqualTo: uid).snapshots();
  }
}
