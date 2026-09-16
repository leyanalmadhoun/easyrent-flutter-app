import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../services/firebase_service.dart';
import '../widgets/car_image.dart';
import 'customer_bottom_nav.dart';

class BookingsScreen extends StatelessWidget {
  const BookingsScreen({super.key});
  static const navy=Color(0xFF12305D),blue=Color(0xFF1173EA);
  @override Widget build(BuildContext context)=>Scaffold(backgroundColor:const Color(0xFFF8FBFF),appBar:AppBar(automaticallyImplyLeading:false,backgroundColor:Colors.white,centerTitle:true,title:const Text('My Bookings',style:TextStyle(color:navy,fontSize:21,fontWeight:FontWeight.w800))),body:StreamBuilder<QuerySnapshot<Map<String,dynamic>>>(stream:FirebaseService.customerBookings(),builder:(_,s){
    if(s.hasError)return Center(child:Text('Could not load bookings.\n${s.error}',textAlign:TextAlign.center));
    if(!s.hasData)return const Center(child:CircularProgressIndicator());
    final docs=s.data!.docs.toList()..sort((a,b)=>_date(b.data()['createdAt']).compareTo(_date(a.data()['createdAt'])));
    if(docs.isEmpty)return const Center(child:Text('You do not have any bookings yet.',style:TextStyle(color:Color(0xFF64748B))));
    return ListView.separated(padding:const EdgeInsets.all(18),itemCount:docs.length,separatorBuilder:(_,__)=>const SizedBox(height:14),itemBuilder:(_,i)=>_Card(doc:docs[i]));
  }),bottomNavigationBar:const CustomerBottomNav(currentIndex:1));
  static DateTime _date(dynamic value)=>value is Timestamp?value.toDate():DateTime(2000);
}

class _Card extends StatelessWidget{
  final QueryDocumentSnapshot<Map<String,dynamic>> doc; const _Card({required this.doc});
  String date(dynamic t){if(t is! Timestamp)return '-';final d=t.toDate();return '${d.day.toString().padLeft(2,'0')}/${d.month.toString().padLeft(2,'0')}/${d.year}';}
  @override Widget build(BuildContext context){final b=doc.data(),status='${b['status']??'pending'}';final color=status=='confirmed'?const Color(0xFF16A34A):status=='declined'?Colors.red:const Color(0xFFB7791F);return Container(padding:const EdgeInsets.all(13),decoration:BoxDecoration(color:Colors.white,borderRadius:BorderRadius.circular(16),border:Border.all(color:const Color(0xFFE8EDF4))),child:Row(children:[
    ClipRRect(borderRadius:BorderRadius.circular(12),child:CarImage(url:b['imageUrl'] as String?,width:92,height:92)),const SizedBox(width:13),Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
      Container(padding:const EdgeInsets.symmetric(horizontal:9,vertical:4),decoration:BoxDecoration(color:color.withValues(alpha:.10),borderRadius:BorderRadius.circular(20)),child:Text(status[0].toUpperCase()+status.substring(1),style:TextStyle(color:color,fontSize:11,fontWeight:FontWeight.w700))),const SizedBox(height:7),
      Text('${b['carName']??'Car'}',style:const TextStyle(color:BookingsScreen.navy,fontSize:16,fontWeight:FontWeight.w800)),const SizedBox(height:5),Text('${date(b['pickupAt'])} – ${date(b['returnAt'])}',style:const TextStyle(color:Color(0xFF64748B),fontSize:12)),const SizedBox(height:3),Text('Total: \$${b['total']??0}',style:const TextStyle(color:BookingsScreen.blue,fontWeight:FontWeight.w700))
    ]))]));}
}
