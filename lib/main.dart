

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mycustomer/map.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('customer');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '',
      theme: ThemeData(

      ),

      home: login(),
    );
  }
}
class login extends StatelessWidget {
  final _form = GlobalKey<FormState>(); //for storing form state.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        bottom: Radius.circular(30),
      ),
    ),
        
        backgroundColor:Colors.lightBlue,
        title: Text("Login"),
        centerTitle: true,
      ),
  
      body:
    
      
       Center(
         child: Form(
          key: _form, //assigning key to form
          
          child: ListView(
            children: <Widget>[
              SizedBox(
                height: 40,
              ),
              Container(
                padding: EdgeInsets.all(20),
                
                  child: TextFormField(
                    decoration: const InputDecoration(
                      
                        labelText: 'Email',
                        
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color:Colors.blueAccent,width:2.0),
                          borderRadius:BorderRadius.all(Radius.circular(4.0))
                        )),

                    validator: (text) {
                      if (text == null || !(text.contains('@')) || text.isEmpty) {
                        return "Enter a valid email address!";
                      }
                      return null;
                    },
                  ),
                
              ),

              Container(
                padding: EdgeInsets.all(20),
             
                  child: TextFormField(
                    keyboardType:TextInputType.visiblePassword ,
                    decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(20),
                        labelText: 'Password', 
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color:Colors.blueAccent,width:2.0),
                          borderRadius:BorderRadius.all(Radius.circular(4.0))
                          
                        )),
                    validator: (text) {
                      if (text == null || !(text.length >= 6) || text.isEmpty) {
                        return "Enter valid password atmost 6 characters!";
                      }
                      return null;
                    },
                  ),
                
              ),
            
              
                
                  
                 SizedBox(height: 30,),
            

             
                    Container(
                      child: Column(
                        children: [
                          ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            textStyle: TextStyle(fontStyle:FontStyle.italic,),
        //background color of button
       side: BorderSide(width:3, color:Colors.blueGrey), //border width and color
       elevation: 3, //elevation of button
       shape: RoundedRectangleBorder( //to set border radius to button
                            borderRadius: BorderRadius.circular(30)
            ),
        padding: EdgeInsets.symmetric(horizontal:30,vertical: 20)//content padding inside button
   ),
                          
                            child: const Text("Sign In",),
                           
                              
                                  onPressed: () {
                                    
                                    final isValid = _form.currentState!.validate();
                                    if (isValid) {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) => Homepage()));
                                    } else {
                                      Fluttertoast.showToast(
                                          msg: "Username / Password is Incorrect",
                                          gravity: ToastGravity.BOTTOM,
                                          fontSize: 16.0,
                                          backgroundColor:Colors.white,
                                          textColor: Colors.black,
                                          webPosition: "center",
                                          );
                                    }
                                  }),
                        ],
                      ),
                    ),
                  
                
              
                
              
              
              
            ],
          ),
      ),
       ),
    );
  }
}
class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {

  final TextEditingController _nameController = TextEditingController();
    final TextEditingController _quantityController= TextEditingController();
    final TextEditingController _locationController = TextEditingController();
    final  TextEditingController _phoneController = TextEditingController();
    List<Map<String,dynamic>> _items = [];
    final  _customer = Hive.box('customer');
    @override
     initState(){
      super.initState();
      _refreshItems();
    }

    void _refreshItems(){
      final data = _customer.keys.map((key)  {
       

        final item = _customer.get(key);
        return { "key":key,"name":item["name"],"age":item['age'],"location":item["location"]};
      }).toList();

      setState(() {
        _items = data.reversed.toList();
        print(_items.length);
      });
    }
    //create new item
    Future<void> _createitem(Map<String,dynamic>newItem ) async{
      await _customer.add(newItem);
     _refreshItems();
    }

     Future<void> _updateitem(int itemkey,Map<String,dynamic>item ) async{
      await _customer.put(itemkey,item);
     _refreshItems();//update ui 
    }
   
   

    void _showForm(BuildContext ctx,int? itemkey)async{
      if(itemkey !=null){
        final existingItem = _items.firstWhere((element) => element['key']==itemkey);
     _nameController.text = existingItem['name'];
     _quantityController.text = existingItem['age'];
     _locationController.text=existingItem['location'];
    
    
    
      }






      showModalBottomSheet(context:ctx ,  
      elevation: 5,
      isScrollControlled: true,
       
      
      builder:(_)=> Container(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom,
        top: 15,left: 15,right: 15


      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(

          controller: _nameController,
          decoration: const InputDecoration(hintText: 'Name'),
          ),
          const SizedBox(
            height: 10,
          ),
          TextField(

          controller: _quantityController,
          decoration: const InputDecoration(hintText: 'age'),
          ),
          const SizedBox(
            height: 10,
          ), 
           TextField(

          controller: _phoneController,
          decoration: const InputDecoration(hintText: 'phone number'),
          ),
          const SizedBox(
            height: 10,
          ), 

           TextField(

          controller: _locationController,
          decoration:  InputDecoration(hintText: 'Location',
          suffixIcon: IconButton(onPressed: (){
             Navigator.push(context,
            MaterialPageRoute(builder: (context) => MapPage()));
          }, icon:Icon(Icons.map)),
          
          ),
          
          ),
          const SizedBox(
            height: 20,
          ),

          ElevatedButton(onPressed: ()async {

             if(itemkey ==null){
            _createitem({
              "name":_nameController.text,
              "age" :_quantityController.text,
              "location" :_locationController.text
               });
             }
          
            if(itemkey !=null){
              _updateitem(itemkey, {
                'name':_nameController.text.trim(),
                'age':_quantityController.text.trim(),
                'location':_locationController.text.trim()
              });
            }


            //clear the text fields
            _nameController.text='';
            _quantityController.text='';
            _locationController.text='';
            Navigator.of(context).pop();


          }, 
          
          child: Text (itemkey==null?'create New':'update'),
           
          ),
          const SizedBox(
            height: 15,
          )

        ],


      ),
      )
      );
    }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users'),
      ),

      body: ListView.builder(
        
        itemCount: _items.length,
        itemBuilder: (_,index){
          final currentItem = _items[index];
          return Card(
            
            color: Colors.orange.shade100,
            margin:const EdgeInsets.all(10),
            elevation: 3,
            child: ListTile(
              onTap: () {

              },
              title: Text(currentItem['name']),
              subtitle: Text(currentItem['location'].toString()),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(onPressed: (){
                    _showForm(context, currentItem['key']);
                  }, 
                  icon: const Icon(Icons.edit),)
                ],
              ),
            ),


          );


        }



      ),
     floatingActionButton: FloatingActionButton(onPressed: (){
      _showForm(context, null);
     }, 
     child: const Icon(Icons.add),
     ),
     

    );
  }
}






