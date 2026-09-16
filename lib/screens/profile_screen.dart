import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../services/firebase_service.dart';
import 'change_password_screen.dart';
import 'customer_bottom_nav.dart';
import 'edit_profile_screen.dart';
import 'login_screen.dart';
import 'payment_methods_screen.dart';
import 'wallet_screen.dart';

class ProfileScreen extends StatelessWidget{
  const ProfileScreen({super.key});static const navy=Color(0xFF12305D),blue=Color(0xFF1173EA);
  @override Widget build(BuildContext context)=>Scaffold(backgroundColor:const Color(0xFFF8FBFF),appBar:AppBar(automaticallyImplyLeading:false,backgroundColor:Colors.white,centerTitle:true,title:const Text('My Profile',style:TextStyle(color:navy,fontSize:21,fontWeight:FontWeight.w800))),body:StreamBuilder<DocumentSnapshot<Map<String,dynamic>>>(stream:FirebaseService.userStream(),builder:(_,s){if(!s.hasData)return const Center(child:CircularProgressIndicator());final u=s.data!.data()??{};return ListView(padding:const EdgeInsets.all(18),children:[
    Container(padding:const EdgeInsets.all(22),decoration:BoxDecoration(color:Colors.white,borderRadius:BorderRadius.circular(18),border:Border.all(color:const Color(0xFFE8EDF4))),child:Column(children:[Stack(children:[const CircleAvatar(radius:49,backgroundImage:AssetImage('assets/images/profile.png')),Positioned(right:0,bottom:0,child:GestureDetector(onTap:()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>const EditProfileScreen())),child:const CircleAvatar(radius:16,backgroundColor:blue,child:Icon(Icons.edit,color:Colors.white,size:15))))]),const SizedBox(height:14),Text('${u['fullName']??'Customer'}',style:const TextStyle(color:navy,fontSize:22,fontWeight:FontWeight.w800)),const SizedBox(height:6),Text('${u['email']??FirebaseService.auth.currentUser?.email??''}',style:const TextStyle(color:Color(0xFF64748B))),const SizedBox(height:5),Text('${u['phone']??''}',style:const TextStyle(color:Color(0xFF64748B)))])),const SizedBox(height:16),
    _group([_tile(Icons.edit_outlined,'Edit Profile',()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>const EditProfileScreen()))),_tile(Icons.account_balance_wallet_outlined,'Wallet & Payments',()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>const WalletScreen()))),_tile(Icons.credit_card_outlined,'Payment Methods',()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>const PaymentMethodsScreen())))]),const SizedBox(height:14),
    _group([_tile(Icons.lock_outline,'Change Password',()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>const ChangePasswordScreen()))),_tile(Icons.logout,'Log Out',()=>_logout(context),red:true)])
  ]);}),bottomNavigationBar:const CustomerBottomNav(currentIndex:3));
  Widget _group(List<Widget> children)=>Container(decoration:BoxDecoration(color:Colors.white,borderRadius:BorderRadius.circular(18)),child:Column(children:children));
  Widget _tile(IconData icon,String title,VoidCallback action,{bool red=false})=>ListTile(onTap:action,leading:Icon(icon,color:red?Colors.red:navy),title:Text(title,style:TextStyle(color:red?Colors.red:navy,fontWeight:FontWeight.w600)),trailing:const Icon(Icons.arrow_forward_ios,size:15,color:Color(0xFF94A3B8)));
  Future<void> _logout(BuildContext context)async{await FirebaseService.auth.signOut();if(context.mounted)Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder:(_)=>const LoginScreen()),(_)=>false);}
}
