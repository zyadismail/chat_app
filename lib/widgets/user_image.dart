// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';

// class UserImagePicker extends StatefulWidget {
//   const UserImagePicker({super.key});

//   @override
//   State<UserImagePicker> createState() => _UserImagePickerState();
// }

// class _UserImagePickerState extends State<UserImagePicker> {
//   File? pickedImageFile;

//   void pickImagefun()async{
//    final XFile? pickImage =  await ImagePicker().pickImage(
//     source: ImageSource.camera,
//     maxWidth: 150,
//     imageQuality: 50,
//     );
//     if(pickImage == null ){
//       return;
//     }

//     setState(() {
//       pickedImageFile = File(pickImage.path);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return  Column(
//         children: [
//            CircleAvatar(
//             radius: 30,
//             foregroundImage:pickedImageFile == null ? null : FileImage(pickedImageFile!),
//             backgroundColor:Colors.grey ,
//           ),
//           TextButton.icon(
//             onPressed: pickImagefun, 
//             icon: const Icon(Icons.image),
//             label:  Text(
//               "add Image",
//               style: TextStyle(
//                 color: Theme.of(context).colorScheme.primary,
//               ),
//               ),
//             ),
//         ],
      
//     );
//   }
// }




import 'dart:io';

import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  const UserImagePicker({super.key, required this.onPickImage});

  final void Function(File pickedImage) onPickImage;

  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? _pickedImageFile;

  void _pickImage() async {
    final XFile? pickedImage = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxWidth: 150,
      imageQuality: 50,
    );

    if (pickedImage == null) {
      return;
    }

    setState(() {
      _pickedImageFile = File(pickedImage.path);
    });

    widget.onPickImage(_pickedImageFile!);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey,
          foregroundImage:
              _pickedImageFile == null ? null : FileImage(_pickedImageFile!),
        ),
        TextButton.icon(
          onPressed: _pickImage,
          icon: const Icon(Icons.image),
          label: Text(
            'Add Image',
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      ],
    );
  }
}
