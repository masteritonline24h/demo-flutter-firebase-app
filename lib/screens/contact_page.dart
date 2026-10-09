import 'package:flutter/material.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ទំនាក់ទំនង (Contact)'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: const [
          ListTile(
            leading: Icon(Icons.email, color: Colors.deepPurple),
            title: Text('អ៊ីមែល'),
            subtitle: Text('info@example.com'),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.phone, color: Colors.deepPurple),
            title: Text('លេខទូរស័ព្ទ'),
            subtitle: Text('+855 12 345 678'),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.location_on, color: Colors.deepPurple),
            title: Text('អាសយដ្ឋាន'),
            subtitle: Text('រាជធានីភ្នំពេញ, ប្រទេសកម្ពុជា'),
          ),
        ],
      ),
    );
  }
}