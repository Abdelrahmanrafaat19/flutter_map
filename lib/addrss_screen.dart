import 'package:flutter/material.dart';
import 'package:map/feilde_name.dart';
import 'package:map/main.dart';

class AddressesScreen extends StatefulWidget {
  const AddressesScreen({super.key});

  @override
  State<AddressesScreen> createState() => _AddressesScreenState();
}

class _AddressesScreenState extends State<AddressesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
        title: const Text(
          "Addresses Screen",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        leading: InkWell(
          child: Icon(Icons.arrow_back),
          onTap: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: ListView.builder(
        itemCount: allAdresses.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => FeildsName(
                  start: empty!,
                  end: allAdresses[index],
                ),
              ));
            },
            child: Container(
                margin: const EdgeInsets.symmetric(
                  vertical: 5,
                  horizontal: 10,
                ),
                decoration: BoxDecoration(
                    border: Border.all(
                        color: Theme.of(context).colorScheme.inversePrimary,
                        width: 3),
                    borderRadius: BorderRadius.circular(15)),
                width: double.infinity,
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                          onTap: () {
                            setState(() {
                              allAdresses.removeAt(index);
                            });
                          },
                          child: const Icon(Icons.remove_circle_outline_sharp)),
                    ),
                    Expanded(
                        flex: 5,
                        child: Text(
                          allAdresses[index],
                          textAlign: TextAlign.center,
                          style: const TextStyle(),
                        )),
                  ],
                )),
          );
        },
      ),
    );
  }
}
