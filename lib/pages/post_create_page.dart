import 'package:flutter/material.dart';

class PostCreatePage extends StatelessWidget {
  const PostCreatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title:const Text('Wish creator'),
      ),
      body:const Padding(
        padding:  EdgeInsets.only(left: 10,right: 10),
        child:  Center(
          child: Text(
            textAlign: TextAlign.center,
            'This feature will be available in the next update.\n\n Thank you for your support ❤️',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
// class PostCreatePage extends StatelessWidget {
//   PostCreatePage({super.key});
//   late BuildContext pageContext;
//   @override
//   Widget build(BuildContext context) {
//     pageContext = context;
//     return Scaffold(
      
//       appBar: AppBar(
//         title: const Text('Wish maker'),
//       ),
//       body: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: [
//           chooseList(Icons.format_shapes, chooseTemplate),
//           chooseList(Icons.person, enterName),
//           chooseList(Icons.description, () {}),
//           chooseList(Icons.image, () {}),
//         ],
//       ),
      
//     );
//   }

//   IconButton chooseList(IconData iconName, Function() onTap) {
//     return IconButton(
//       onPressed: onTap,
//       icon: Icon(iconName),
//     );
//   }

//   void enterName() async {
//     showDialog(
//       context: pageContext,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text('Enter Name'),
//           content: const TextField(
//             decoration: InputDecoration(hintText: 'Enter name'),
//           ),
//           actions: [
//             TextButton(
//                 onPressed: () => Navigator.pop(context),
//                 child: const Text("OK"))
//           ],
//         );
//       },
//     );
//   }

//   void chooseTemplate() async {
//     final pageController = PageController(
//       initialPage: 0,
//     );
//     showDialog(
//         context: pageContext,
//         builder: (context) {
//           return AlertDialog(
//             actions: [
//               TextButton(
//                   onPressed: () => Navigator.pop(context), child:const Text('OK'))
//             ],
//             content: PageView(
//               controller: pageController,
//               children: [
//                 Container(color: Colors.red,),
//                 Container(color: Colors.green,),
//                 Container(color: Colors.blue,),
//               ],
//             ),
//           );
//         });
//   }
// }



//select Template
//select a wish
// Name
// Image