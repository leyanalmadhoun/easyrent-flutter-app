import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../services/firebase_service.dart';
import '../widgets/car_image.dart';
import 'add_car_screen.dart';
import 'office_bottom_nav.dart';

class OfficeMyCarsScreen extends StatelessWidget {
  const OfficeMyCarsScreen({super.key});
  static const navy = Color(0xFF12305D), blue = Color(0xFF1173EA);

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFFF4F7FD),
    appBar: AppBar(automaticallyImplyLeading:false,backgroundColor:Colors.white,centerTitle:true,title:const Text('My Cars',style:TextStyle(color:navy,fontSize:21,fontWeight:FontWeight.w800)),actions:[IconButton(onPressed:()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>const AddCarScreen())),icon:const Icon(Icons.add_box_outlined,color:navy)),const SizedBox(width:8)]),
    body: StreamBuilder<QuerySnapshot<Map<String,dynamic>>>(
      stream: FirebaseService.officeCars(),
      builder:(context,snapshot){
        if(snapshot.hasError)return _message('Could not load cars.\n${snapshot.error}');
        if(!snapshot.hasData)return const Center(child:CircularProgressIndicator());
        final cars=snapshot.data!.docs;
        if(cars.isEmpty)return _message('No cars yet.\nTap + to add your first car.');
        return ListView.separated(padding:const EdgeInsets.all(17),itemCount:cars.length,separatorBuilder:(_,__)=>const SizedBox(height:14),itemBuilder:(_,i)=>_CarCard(doc:cars[i]));
      },
    ),
    bottomNavigationBar:const OfficeBottomNav(currentIndex:1),
  );

  Widget _message(String text)=>Center(child:Text(text,textAlign:TextAlign.center,style:const TextStyle(color:Color(0xFF64748B),fontSize:15,height:1.5)));
}

class _CarCard extends StatelessWidget {
  final QueryDocumentSnapshot<Map<String,dynamic>> doc;
  const _CarCard({required this.doc});
  @override Widget build(BuildContext context){
    final car=doc.data(); final status='${car['status']??'Available'}'; final available=status=='Available';
    return Container(padding:const EdgeInsets.all(11),decoration:BoxDecoration(color:Colors.white,borderRadius:BorderRadius.circular(17),border:Border.all(color:const Color(0xFFE7ECF3))),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
      ClipRRect(borderRadius:BorderRadius.circular(13),child:CarImage(url:car['imageUrl'] as String?,height:180,width:double.infinity)),const SizedBox(height:12),
      Row(children:[Expanded(child:Text('${car['name']??'Car'}',style:const TextStyle(color:OfficeMyCarsScreen.navy,fontSize:17,fontWeight:FontWeight.w800))),Container(padding:const EdgeInsets.symmetric(horizontal:11,vertical:4),decoration:BoxDecoration(color:available?const Color(0xFFE8FAF0):const Color(0xFFFFF4CC),borderRadius:BorderRadius.circular(20)),child:Text(status,style:TextStyle(color:available?const Color(0xFF20B75A):const Color(0xFFB7791F),fontSize:10,fontWeight:FontWeight.w700)))]),
      const SizedBox(height:6),Text('\$${car['dailyPrice']??0} / day',style:const TextStyle(color:OfficeMyCarsScreen.blue,fontSize:25,fontWeight:FontWeight.w900)),const SizedBox(height:13),
      SizedBox(width:double.infinity,height:48,child:OutlinedButton.icon(onPressed:()=>_delete(context),icon:const Icon(Icons.delete_outline_rounded),label:const Text('Delete Car'),style:OutlinedButton.styleFrom(foregroundColor:Colors.red,side:const BorderSide(color:Colors.red),shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(11)))))
    ]));
  }
  Future<void> _delete(BuildContext context)async{
    final yes=await showDialog<bool>(context:context,builder:(_)=>AlertDialog(title:const Text('Delete car?'),content:const Text('This car will be removed permanently.'),actions:[TextButton(onPressed:()=>Navigator.pop(context,false),child:const Text('Cancel')),TextButton(onPressed:()=>Navigator.pop(context,true),child:const Text('Delete',style:TextStyle(color:Colors.red)))]));
    if(yes==true)await FirebaseService.deleteCar(doc.id);
  }
}
