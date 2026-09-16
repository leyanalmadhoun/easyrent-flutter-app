import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../services/firebase_service.dart';
import 'change_password_screen.dart';
import 'edit_profile_screen.dart';
import 'login_screen.dart';
import 'office_bottom_nav.dart';
import 'office_wallet_screen.dart';

class OfficeProfileScreen extends StatelessWidget{
  const OfficeProfileScreen({super.key});static const navy=Color(0xFF12305D),blue=Color(0xFF1173EA);
  @override Widget build(BuildContext context)=>Scaffold(backgroundColor:const Color(0xFFF4F7FD),appBar:AppBar(automaticallyImplyLeading:false,backgroundColor:Colors.white,centerTitle:true,title:const Text('Office Profile',style:TextStyle(color:navy,fontSize:21,fontWeight:FontWeight.w800))),body:StreamBuilder<DocumentSnapshot<Map<String,dynamic>>>(stream:FirebaseService.userStream(),builder:(_,s){if(!s.hasData)return const Center(child:CircularProgressIndicator());final u=s.data!.data()??{};return ListView(padding:const EdgeInsets.all(18),children:[
    Container(padding:const EdgeInsets.all(22),decoration:BoxDecoration(color:Colors.white,borderRadius:BorderRadius.circular(18)),child:Column(children:[const CircleAvatar(radius:49,backgroundImage:AssetImage('assets/images/profile.png')),const SizedBox(height:13),Text('${u['fullName']??'Rental Office'}',style:const TextStyle(color:navy,fontSize:21,fontWeight:FontWeight.w900)),const SizedBox(height:8),Text('${u['email']??''}',style:const TextStyle(color:Color(0xFF64748B))),Text('${u['phone']??''}',style:const TextStyle(color:Color(0xFF64748B)))])),const SizedBox(height:16),
    Container(decoration:BoxDecoration(color:Colors.white,borderRadius:BorderRadius.circular(17)),child:Column(children:[_tile(Icons.edit_outlined,'Edit Profile',()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>const EditProfileScreen()))),_tile(Icons.account_balance_wallet_outlined,'Wallet & Payments',()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>const OfficeWalletScreen()))),_tile(Icons.lock_outline,'Change Password',()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>const ChangePasswordScreen()))),_tile(Icons.logout,'Log Out',()=>_logout(context),red:true)]))
  ]);}),bottomNavigationBar:const OfficeBottomNav(currentIndex:4));
  Widget _tile(IconData i,String t,VoidCallback tap,{bool red=false})=>ListTile(onTap:tap,leading:Icon(i,color:red?Colors.red:navy),title:Text(t,style:TextStyle(color:red?Colors.red:navy,fontWeight:FontWeight.w600)),trailing:const Icon(Icons.arrow_forward_ios,size:15));
  Future<void> _logout(BuildContext context)async{await FirebaseService.auth.signOut();if(context.mounted)Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder:(_)=>const LoginScreen()),(_)=>false);}
}
