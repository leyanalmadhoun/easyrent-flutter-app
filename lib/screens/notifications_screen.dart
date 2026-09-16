import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../services/firebase_service.dart';
import 'customer_bottom_nav.dart';

class NotificationsScreen extends StatelessWidget{
  const NotificationsScreen({super.key});static const navy=Color(0xFF12305D),blue=Color(0xFF1173EA);
  @override Widget build(BuildContext context)=>Scaffold(backgroundColor:const Color(0xFFF4F7FD),appBar:AppBar(automaticallyImplyLeading:false,backgroundColor:Colors.white,centerTitle:true,title:const Text('Notifications',style:TextStyle(color:navy,fontSize:21,fontWeight:FontWeight.w800))),body:_NotificationsList(),bottomNavigationBar:const CustomerBottomNav(currentIndex:2));
}

class _NotificationsList extends StatelessWidget{
  @override Widget build(BuildContext context)=>StreamBuilder<QuerySnapshot<Map<String,dynamic>>>(stream:FirebaseService.notifications(),builder:(_,s){if(s.hasError)return Center(child:Text('Could not load notifications.\n${s.error}',textAlign:TextAlign.center));if(!s.hasData)return const Center(child:CircularProgressIndicator());final docs=s.data!.docs.toList()..sort((a,b)=>_date(b.data()['createdAt']).compareTo(_date(a.data()['createdAt'])));if(docs.isEmpty)return const Center(child:Text('No notifications yet.',style:TextStyle(color:Color(0xFF64748B))));return ListView.separated(padding:const EdgeInsets.all(16),itemCount:docs.length,separatorBuilder:(_,__)=>const SizedBox(height:12),itemBuilder:(_,i){final n=docs[i].data();return Container(padding:const EdgeInsets.all(15),decoration:BoxDecoration(color:Colors.white,borderRadius:BorderRadius.circular(16)),child:Row(children:[Container(width:48,height:48,decoration:BoxDecoration(color:const Color(0xFFEAF2FF),borderRadius:BorderRadius.circular(12)),child:const Icon(Icons.notifications_outlined,color:Color(0xFF1173EA))),const SizedBox(width:13),Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text('${n['title']??'Notification'}',style:const TextStyle(color:Color(0xFF12305D),fontWeight:FontWeight.w800)),const SizedBox(height:4),Text('${n['message']??''}',style:const TextStyle(color:Color(0xFF64748B),height:1.4))]))]));});});
  static DateTime _date(dynamic value)=>value is Timestamp?value.toDate():DateTime(2000);
}
