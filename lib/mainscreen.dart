import 'package:flutter/material.dart';

import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
class contactscreen extends StatelessWidget {
   contactscreen({super.key});
var contacts;
var imagesList;
var im;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      home: Scaffold(
        appBar: AppBar(title: Text("Contact")),
        body: FutureBuilder(future: getcontact(),builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting){
            return CircularProgressIndicator();
          }
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 5 ,vertical: 10),
          
          child: ListView.builder(
            itemCount:contacts.length,
            scrollDirection: Axis.vertical,
            itemBuilder:(context, index) {
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 5 , vertical: 5),

              padding: EdgeInsets.symmetric(horizontal: 5 , vertical: 5),
                decoration: BoxDecoration(color: Colors.grey.withOpacity(0.2),borderRadius: BorderRadius.circular(15)),
                child: Row( mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                  contacts.elementAt(index).photo == null? ClipRRect(borderRadius: BorderRadius.circular(20 , ),child: Image.asset('assets/profile.jpg' ,height: 80 ,width: 80,),):
                  ClipRRect( borderRadius: BorderRadius.circular(20), child: Image(image:  MemoryImage(contacts.elementAt(index).thumbnail ) , height: 80 ,width: 80,)),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.35,
                        child: Text("${contacts.elementAt(index).displayName}" , style: TextStyle(fontSize: 20 , fontWeight: FontWeight.w600 , overflow: TextOverflow.ellipsis),)),
                      SizedBox(height: 10,),
                      Text("${contacts.elementAt(index).phones.first.number}" ,style: TextStyle(fontSize: 15 , fontWeight: FontWeight.w500),)
                    ],
                  ),
                  IconButton(onPressed: ()async{
                    
                    String formattedPhoneNumber = contacts.elementAt(index).phones.first.number.replaceAll('-', '');
                 
                    

                try {
                await launch('https://wa.me/' +  formattedPhoneNumber);
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error")));
              }
                  }, icon:Icon(Icons.video_camera_back_rounded,color: Colors.cyan,)),
                  IconButton(onPressed: ()async{
                    try {
                await FlutterPhoneDirectCaller.callNumber('${contacts.elementAt(index).phones.first.number}');
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error")));
              }
                  }, icon: Icon(Icons.call , size: 30,))
                ],),
              );
            }
          ),
        );
        } ,)
      ),
    );
  }


  Future getcontact()async{
      contacts = await FlutterContacts.getContacts(
      withProperties: true, withPhoto: true);
      print(contacts.elementAt(1));
      print("break");
      print(contacts.elementAt(3).phones);
  }
}