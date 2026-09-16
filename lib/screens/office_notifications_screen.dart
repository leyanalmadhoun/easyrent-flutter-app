import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../services/firebase_service.dart';
import 'office_bottom_nav.dart';

class OfficeNotificationsScreen extends StatelessWidget{
  const OfficeNotificationsScreen({super.key});
  @override Widget build(BuildContext context)=>Scaffold(backgroundColor:const Color(0xFFF4F7FD),appBar:AppBar(automaticallyImplyLeading:false,backgroundColor:Colors.white,centerTitle:true,title:const Text('Notifications',style:TextStyle(color:Color(0xFF12305D),fontSize:21,fontWeight:FontWeight.w800))),body:StreamBuilder<QuerySnapshot<Map<String,dynamic>>>(stream:FirebaseService.notifications(),builder:(_,s){if(!s.hasData)return const Center(child:CircularProgressIndicator());final docs=s.data!.docs.toList()..sort((a,b)=>_date(b.data()['createdAt']).compareTo(_date(a.data()['createdAt'])));if(docs.isEmpty)return const Center(child:Text('No notifications yet.'));return ListView.separated(padding:const EdgeInsets.all(16),itemCount:docs.length,separatorBuilder:(_,__)=>const SizedBox(height:12),itemBuilder:(_,i){final n=docs[i].data();return Container(padding:const EdgeInsets.all(15),decoration:BoxDecoration(color:Colors.white,borderRadius:BorderRadius.circular(16)),child:ListTile(contentPadding:EdgeInsets.zero,leading:const CircleAvatar(backgroundColor:Color(0xFFEAF2FF),child:Icon(Icons.notifications_outlined,color:Color(0xFF1173EA))),title:Text('${n['title']??'Notification'}',style:const TextStyle(color:Color(0xFF12305D),fontWeight:FontWeight.w800)),subtitle:Text('${n['message']??''}')));});}),bottomNavigationBar:const OfficeBottomNav(currentIndex:3));
  static DateTime _date(dynamic value)=>value is Timestamp?value.toDate():DateTime(2000);
}
