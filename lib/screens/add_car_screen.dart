import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/cloudinary_service.dart';
import '../services/firebase_service.dart';

class AddCarScreen extends StatefulWidget {
  const AddCarScreen({super.key});
  @override
  State<AddCarScreen> createState() => _AddCarScreenState();
}

class _AddCarScreenState extends State<AddCarScreen> {
  static const navy = Color(0xFF12305D), blue = Color(0xFF1173EA);
  final formKey = GlobalKey<FormState>();
  final name = TextEditingController(), daily = TextEditingController(), weekly = TextEditingController(), seats = TextEditingController(), description = TextEditingController();
  String? category, fuel, transmission, status = 'Available';
  bool loading = false;
  XFile? selectedImage;

  Future<void> pickImage() async {
    final image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 82,
      maxWidth: 1600,
    );
    if (image != null && mounted) setState(() => selectedImage = image);
  }

  @override
  void dispose() {
    for (final c in [name, daily, weekly, seats, description]) { c.dispose(); }
    super.dispose();
  }

  Future<void> save() async {
    if (!formKey.currentState!.validate() || [category, fuel, transmission, status].contains(null) || selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please complete all fields.')));
      return;
    }
    setState(() => loading = true);
    try {
      final imageUrl = await CloudinaryService.uploadImage(selectedImage!);
      await FirebaseService.addCar({
        'name': name.text.trim(), 'category': category, 'dailyPrice': double.parse(daily.text),
        'weeklyPrice': double.parse(weekly.text), 'seats': int.parse(seats.text),
        'description': description.text.trim(), 'fuel': fuel, 'transmission': transmission, 'status': status,
        'imageUrl': imageUrl,
      });
      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Car added successfully.')));
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Could not save the car: $e')));
    } finally { if (mounted) setState(() => loading = false); }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFFF4F7FD),
    appBar: AppBar(backgroundColor: Colors.white, centerTitle: true, leading: IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back_ios_new_rounded, color: navy)), title: const Text('Add New Car', style: TextStyle(color: navy, fontWeight: FontWeight.w800))),
    body: Form(key: formKey, child: ListView(padding: const EdgeInsets.fromLTRB(20, 20, 20, 30), children: [
      InkWell(onTap: loading ? null : pickImage,borderRadius:BorderRadius.circular(15),child:Container(height:165,clipBehavior:Clip.antiAlias,decoration:BoxDecoration(color:Colors.white,borderRadius:BorderRadius.circular(15),border:Border.all(color:const Color(0xFFD8E0EA))),child:selectedImage==null?const Column(mainAxisAlignment:MainAxisAlignment.center,children:[Icon(Icons.add_photo_alternate_outlined,color:navy,size:42),SizedBox(height:9),Text('Upload Car Photo',style:TextStyle(color:navy,fontWeight:FontWeight.w700)),SizedBox(height:4),Text('Tap to choose from gallery',style:TextStyle(color:Color(0xFF94A3B8),fontSize:11))]):FutureBuilder<Uint8List>(future:selectedImage!.readAsBytes(),builder:(_,s)=>s.hasData?Stack(fit:StackFit.expand,children:[Image.memory(s.data!,fit:BoxFit.cover),Positioned(right:10,bottom:10,child:Container(padding:const EdgeInsets.symmetric(horizontal:12,vertical:7),decoration:BoxDecoration(color:Colors.black54,borderRadius:BorderRadius.circular(20)),child:const Text('Change photo',style:TextStyle(color:Colors.white,fontWeight:FontWeight.w700))))]):const Center(child:CircularProgressIndicator())))),
      const _Label('Car Name'), _TextBox(controller: name, hint: 'Example: Toyota Camry 2023'),
      const _Label('Category'), _DropBox(value: category, items: const ['Economy','SUV','Luxury'], hint: 'Choose category', onChanged: (v) => setState(() => category = v)),
      const _Label('Daily Price (\$)'), _TextBox(controller: daily, hint: '45', number: true),
      const _Label('Weekly Price (\$)'), _TextBox(controller: weekly, hint: '220', number: true),
      const _Label('Number of Seats'), _TextBox(controller: seats, hint: '5', number: true),
      const _Label('Description'), _TextBox(controller: description, hint: 'Write a short description', lines: 4),
      const _Label('Fuel Type'), _DropBox(value: fuel, items: const ['Petrol','Diesel','Electric','Hybrid'], hint: 'Choose fuel type', onChanged: (v) => setState(() => fuel = v)),
      const _Label('Transmission'), _DropBox(value: transmission, items: const ['Automatic','Manual'], hint: 'Choose transmission', onChanged: (v) => setState(() => transmission = v)),
      const _Label('Car Status'), _DropBox(value: status, items: const ['Available','Unavailable','Maintenance'], hint: 'Choose status', onChanged: (v) => setState(() => status = v)),
      const SizedBox(height: 24), SizedBox(height: 54, child: ElevatedButton(onPressed: loading ? null : save, style: ElevatedButton.styleFrom(backgroundColor: blue, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), child: loading ? const CircularProgressIndicator(color: Colors.white) : const Text('Save Car', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)))),
    ])),
  );
}

class _Label extends StatelessWidget { final String text; const _Label(this.text); @override Widget build(BuildContext context) => Padding(padding: const EdgeInsets.only(top: 15,bottom: 7), child: Text(text, style: const TextStyle(color: Color(0xFF12305D), fontWeight: FontWeight.w700))); }
class _TextBox extends StatelessWidget { final TextEditingController controller; final String hint; final int lines; final bool number; const _TextBox({required this.controller,required this.hint,this.lines=1,this.number=false}); @override Widget build(BuildContext context) => TextFormField(controller: controller,maxLines: lines,keyboardType: number ? TextInputType.number : null,validator:(v)=>v==null||v.trim().isEmpty?'Required':null,decoration:_decoration(hint)); }
class _DropBox extends StatelessWidget { final String? value; final List<String> items; final String hint; final ValueChanged<String?> onChanged; const _DropBox({required this.value,required this.items,required this.hint,required this.onChanged}); @override Widget build(BuildContext context)=>DropdownButtonFormField<String>(initialValue:value,hint:Text(hint),items:items.map((e)=>DropdownMenuItem(value:e,child:Text(e))).toList(),onChanged:onChanged,validator:(v)=>v==null?'Required':null,decoration:_decoration(hint)); }
InputDecoration _decoration(String hint)=>InputDecoration(hintText:hint,filled:true,fillColor:Colors.white,enabledBorder:OutlineInputBorder(borderRadius:BorderRadius.circular(12),borderSide:const BorderSide(color:Color(0xFFD8E0EA))),focusedBorder:OutlineInputBorder(borderRadius:BorderRadius.circular(12),borderSide:const BorderSide(color:Color(0xFF1173EA))),errorBorder:OutlineInputBorder(borderRadius:BorderRadius.circular(12),borderSide:const BorderSide(color:Colors.red)));
