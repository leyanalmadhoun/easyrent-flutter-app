import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../services/firebase_service.dart';
import '../widgets/car_image.dart';
import 'car_details_screen.dart';
import 'customer_bottom_nav.dart';

class CustomerHomeScreen extends StatefulWidget { const CustomerHomeScreen({super.key}); @override State<CustomerHomeScreen> createState()=>_CustomerHomeScreenState(); }
class _CustomerHomeScreenState extends State<CustomerHomeScreen>{
  static const navy=Color(0xFF12305D),blue=Color(0xFF1173EA),grey=Color(0xFF64748B);
  final categories=['All','Economy','SUV','Luxury']; int selected=0;
  @override Widget build(BuildContext context)=>Scaffold(backgroundColor:const Color(0xFFF4F7FD),body:SafeArea(bottom:false,child:Column(children:[
    StreamBuilder<DocumentSnapshot<Map<String,dynamic>>>(stream:FirebaseService.userStream(),builder:(_,s){final name=s.data?.data()?['fullName']??'Customer';return Container(height:92,padding:const EdgeInsets.symmetric(horizontal:20),color:Colors.white,child:Row(children:[const CircleAvatar(radius:23,backgroundImage:AssetImage('assets/images/profile.png')),const SizedBox(width:11),Column(mainAxisAlignment:MainAxisAlignment.center,crossAxisAlignment:CrossAxisAlignment.start,children:[const Text('Welcome back',style:TextStyle(color:grey,fontSize:12)),Text('$name',style:const TextStyle(color:navy,fontSize:16,fontWeight:FontWeight.w800))]),const Spacer(),Image.asset('assets/images/logo.png',width:42)]));}),
    Expanded(child:ListView(padding:const EdgeInsets.fromLTRB(20,22,20,28),children:[
      const Text('Find Your Car',style:TextStyle(color:navy,fontSize:27,fontWeight:FontWeight.w900)),const SizedBox(height:5),const Text('Discover and book cars from local rental offices.',style:TextStyle(color:grey,fontSize:14)),const SizedBox(height:18),
      Row(children:List.generate(categories.length,(i)=>Expanded(child:Padding(padding:EdgeInsets.only(right:i==3?0:7),child:InkWell(onTap:()=>setState(()=>selected=i),child:Container(height:42,alignment:Alignment.center,decoration:BoxDecoration(color:selected==i?blue:Colors.white,borderRadius:BorderRadius.circular(25),border:Border.all(color:selected==i?blue:const Color(0xFFE5EAF1))),child:Text(categories[i],style:TextStyle(color:selected==i?Colors.white:navy,fontWeight:FontWeight.w700)))))))),const SizedBox(height:24),
      const Text('Available Cars',style:TextStyle(color:navy,fontSize:23,fontWeight:FontWeight.w900)),const SizedBox(height:13),
      StreamBuilder<QuerySnapshot<Map<String,dynamic>>>(stream:FirebaseService.availableCars(),builder:(context,snapshot){
        if(snapshot.hasError)return Text('Could not load cars: ${snapshot.error}',style:const TextStyle(color:Colors.red));
        if(!snapshot.hasData)return const Padding(padding:EdgeInsets.all(40),child:Center(child:CircularProgressIndicator()));
        final cars=snapshot.data!.docs.where((d)=>selected==0||d.data()['category']==categories[selected]).toList();
        if(cars.isEmpty)return const Padding(padding:EdgeInsets.all(40),child:Center(child:Text('No available cars in this category.',style:TextStyle(color:grey))));
        return Column(children:cars.map((doc)=>Padding(padding:const EdgeInsets.only(bottom:14),child:_CarCard(doc:doc))).toList());
      })
    ]))
  ])),bottomNavigationBar:const CustomerBottomNav(currentIndex:0));
}

class _CarCard extends StatelessWidget{
  final QueryDocumentSnapshot<Map<String,dynamic>> doc; const _CarCard({required this.doc});
  @override Widget build(BuildContext context){final c=doc.data();return Container(padding:const EdgeInsets.all(11),decoration:BoxDecoration(color:Colors.white,borderRadius:BorderRadius.circular(17),border:Border.all(color:const Color(0xFFE8EDF4))),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
    Stack(children:[ClipRRect(borderRadius:BorderRadius.circular(13),child:CarImage(url:c['imageUrl'] as String?,height:190,width:double.infinity)),Positioned(top:10,left:10,child:_badge('${c['category']??'Car'}',const Color(0xFFF1F5F9),const Color(0xFF64748B))),Positioned(top:10,right:10,child:_badge('Available',const Color(0xFFDDFBEA),const Color(0xFF16A34A)))]),
    const SizedBox(height:12),Text('${c['name']??'Car'}',style:const TextStyle(color:Color(0xFF12305D),fontSize:18,fontWeight:FontWeight.w800)),const SizedBox(height:8),Text('${c['officeName']??'Rental Office'}',style:const TextStyle(color:Color(0xFF64748B))),const SizedBox(height:11),
    Row(children:[Expanded(child:Text('${c['seats']??5} Seats  •  ${c['fuel']??'Petrol'}  •  ${c['transmission']??'Automatic'}',style:const TextStyle(color:Color(0xFF64748B),fontSize:12))),Text('\$${c['dailyPrice']??0}',style:const TextStyle(color:Color(0xFF1173EA),fontSize:24,fontWeight:FontWeight.w900)),const Text('/day',style:TextStyle(color:Color(0xFF64748B),fontSize:11))]),const SizedBox(height:13),
    SizedBox(width:double.infinity,height:48,child:ElevatedButton(onPressed:()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>CarDetailsScreen(carId:doc.id,car:c))),style:ElevatedButton.styleFrom(backgroundColor:const Color(0xFF1173EA),foregroundColor:Colors.white,shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(11))),child:const Text('View Details',style:TextStyle(fontWeight:FontWeight.w800))))
  ]));}
  Widget _badge(String text,Color bg,Color fg)=>Container(padding:const EdgeInsets.symmetric(horizontal:11,vertical:5),decoration:BoxDecoration(color:bg,borderRadius:BorderRadius.circular(18)),child:Text(text,style:TextStyle(color:fg,fontSize:11,fontWeight:FontWeight.w700)));
}
