import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../services/firebase_service.dart';
import '../widgets/car_image.dart';
import 'office_bottom_nav.dart';

class OfficeBookingsScreen extends StatelessWidget{
  const OfficeBookingsScreen({super.key}); static const navy=Color(0xFF12305D),blue=Color(0xFF1173EA);
  @override Widget build(BuildContext context)=>Scaffold(backgroundColor:const Color(0xFFF4F7FD),appBar:AppBar(automaticallyImplyLeading:false,backgroundColor:Colors.white,centerTitle:true,title:const Text('Bookings',style:TextStyle(color:navy,fontSize:21,fontWeight:FontWeight.w800))),body:StreamBuilder<QuerySnapshot<Map<String,dynamic>>>(stream:FirebaseService.officeBookings(),builder:(_,s){
    if(s.hasError)return Center(child:Text('Could not load bookings.\n${s.error}',textAlign:TextAlign.center));if(!s.hasData)return const Center(child:CircularProgressIndicator());final docs=s.data!.docs;
    if(docs.isEmpty)return const Center(child:Text('No booking requests yet.',style:TextStyle(color:Color(0xFF64748B))));
    return ListView.separated(padding:const EdgeInsets.all(18),itemCount:docs.length,separatorBuilder:(_,__)=>const SizedBox(height:14),itemBuilder:(_,i)=>_Card(doc:docs[i]));
  }),bottomNavigationBar:const OfficeBottomNav(currentIndex:2));
}
class _Card extends StatelessWidget{
  final QueryDocumentSnapshot<Map<String,dynamic>> doc;const _Card({required this.doc});
  String date(dynamic t){if(t is! Timestamp)return '-';final d=t.toDate();return '${d.day}/${d.month}/${d.year}';}
  @override Widget build(BuildContext context){final b=doc.data(),status='${b['status']??'pending'}',pending=status=='pending';final color=pending?const Color(0xFFB7791F):status=='confirmed'?const Color(0xFF16A75C):Colors.red;return Container(padding:const EdgeInsets.all(13),decoration:BoxDecoration(color:Colors.white,borderRadius:BorderRadius.circular(16),border:Border.all(color:const Color(0xFFE7ECF3))),child:Column(children:[
    Row(crossAxisAlignment:CrossAxisAlignment.start,children:[ClipRRect(borderRadius:BorderRadius.circular(11),child:CarImage(url:b['imageUrl'] as String?,width:88,height:88)),const SizedBox(width:12),Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text('${b['carName']??'Car'}',style:const TextStyle(color:OfficeBookingsScreen.navy,fontSize:16,fontWeight:FontWeight.w800)),const SizedBox(height:5),Text('${b['customerName']??'Customer'}',style:const TextStyle(color:Color(0xFF64748B))),const SizedBox(height:7),Text('${date(b['pickupAt'])} – ${date(b['returnAt'])}',style:const TextStyle(color:Color(0xFF64748B),fontSize:11)),Text('Total: \$${b['total']??0}',style:const TextStyle(color:OfficeBookingsScreen.blue,fontWeight:FontWeight.w700))])),Container(padding:const EdgeInsets.symmetric(horizontal:10,vertical:5),decoration:BoxDecoration(color:color.withValues(alpha:.10),borderRadius:BorderRadius.circular(20)),child:Text(status,style:TextStyle(color:color,fontSize:10,fontWeight:FontWeight.w700))) ]),
    if(pending)...[const SizedBox(height:13),Row(children:[Expanded(child:OutlinedButton(onPressed:()=>FirebaseService.updateBookingStatus(doc.id,'declined'),style:OutlinedButton.styleFrom(foregroundColor:Colors.red,side:const BorderSide(color:Colors.red)),child:const Text('Decline'))),const SizedBox(width:10),Expanded(child:ElevatedButton(onPressed:()=>FirebaseService.updateBookingStatus(doc.id,'confirmed'),style:ElevatedButton.styleFrom(backgroundColor:OfficeBookingsScreen.blue,foregroundColor:Colors.white),child:const Text('Accept')))])]
  ]));}
}
