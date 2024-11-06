// import 'package:flutter/material.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       home: const InteractiveExample(),
//     );
//   }
// }

// class InteractiveExample extends StatefulWidget {
//   const InteractiveExample({super.key});

//   @override
//   State<InteractiveExample> createState() => _InteractiveExampleState();
// }

// class _InteractiveExampleState extends State<InteractiveExample> {
//   int? firstNumber, secondNumber, sum;

//   // TextField controller to capture the value
//   TextEditingController? _controller1;
//   TextEditingController? _controller2;

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     sum = 0;
//     // initialize the values of the variables above
//     _controller1 = TextEditingController(text: 0.toString());
//     _controller2 = TextEditingController(text: 0.toString());
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Interactive Widgets'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             TextField(
//               decoration: const InputDecoration(labelText: "First Number"),
//               keyboardType: TextInputType.number,
//               controller: _controller1,
//             ),

//             TextField(
//               decoration: const InputDecoration(labelText: "Second Number"),
//               keyboardType: TextInputType.number,
//               controller: _controller2,
//             ),

//             Text("Sum of two numbers: $sum"),

//             // ElevatedButton
//             ElevatedButton(
//               onPressed: () {
//                 print('Elevated Button Pressed!');

//                 setState(() {
//                   sum = int.parse(_controller1!.value.text) +
//                       int.parse(_controller2!.value.text);
//                 });
//               },
//               child: const Text('Elevated Button - Get Sum'),
//             ),

//             // TextButton
//             TextButton(
//               onPressed: () {
//                 print('Text Button Pressed!');

//                 setState(() {
//                   _controller1!.text = 0.toString();
//                   _controller2!.text = 0.toString();
//                   sum = 0;
//                 });
//               },
//               child: const Text('Text Button - Clear Input'),
//             ),

//             // OutlinedButton
//             OutlinedButton(
//               onPressed: () {
//                 print('Outlined Button Pressed!');
//               },
//               child: const Text('Outlined Button'),
//             ),

//             // Gesture Detector
//             GestureDetector(
//               onTap: () {
//                 print('Tapped!');
//               },
//               onLongPress: () {
//                 print('Long pressed!');
//               },
//               child: const Padding(
//                 padding: EdgeInsets.all(20.0),
//                 child: Text(
//                   'Tap or Long Press',
//                   style: TextStyle(fontSize: 24),
//                 ),
//               ),
//             ),

//             // Dismissible
//             Dismissible(
//               key: const Key('dismissible'),
//               onDismissed: (direction) {
//                 print('Dismissed in $direction');
//               },
//               // change the direction of the dismiss
//               direction: DismissDirection.horizontal,
//               child: const ListTile(
//                 title: Text('Swipe to Dismiss'),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  // manage the sum section
  int sum = 0, difference = 0, product = 0;
  double quotient = 0 ;

  // either use a TextEditingController for each input field to get the value
  TextEditingController add1Controller = TextEditingController();
  TextEditingController add2Controller = TextEditingController();
  TextEditingController sub1Controller = TextEditingController();
  TextEditingController sub2Controller = TextEditingController();
  TextEditingController mul1Controller = TextEditingController();
  TextEditingController mul2Controller = TextEditingController();
  TextEditingController div1Controller = TextEditingController();
  TextEditingController div2Controller = TextEditingController();


  // or store each value in the state
  int firstAddNum = 0, secondAddNum = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Unit 5 Calculator"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // Add Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(labelText: "First Number"),
                  controller: add1Controller,
                  // update the firstAddNum state
                  onChanged: (value) {
                    setState(() {
                      firstAddNum = int.parse(value);
                    });
                  },
                ),
              ),
              const Text(" + "),
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(labelText: "Second Number"),
                  controller: add2Controller,
                  onChanged: (value) {
                    setState(() {
                      secondAddNum = int.parse(value);
                    });
                  },
                ),
              ),
              Text(' = $sum'),
              // 3.a Add an IconButton here
              IconButton(
                icon: const Icon(Icons.check_circle), 
                onPressed: () {
                  setState(() {
                    sum = firstAddNum + secondAddNum;
                  });
                },),
              // b.b Add an button here
              TextButton(
              onPressed: () {
                setState(() {
                  add1Controller.text = 0.toString();
                  add2Controller.text = 0.toString();
                  sum = 0;
                });
              },
              child: const Text('Clear Input'),
            ),
            ],
          ),

          // 3.c - Add the other operations
          // Minus Row
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(labelText: "First Number"),
                  controller: sub1Controller,
                ),
              ),
              const Text(" - "),
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(labelText: "Second Number"),
                  controller: sub2Controller,
                ),
              ),
              Text(' = $difference'),
              // 3.a Add an IconButton here
              IconButton(
                icon: const Icon(Icons.check_circle), 
                onPressed: () {
                  setState(() {
                    difference = int.parse(sub1Controller.value.text) - int.parse(sub2Controller.value.text);
                  });
                },),
              // b.b Add an button here
              TextButton(
              onPressed: () {
                setState(() {
                  sub1Controller.text = 0.toString();
                  sub2Controller.text = 0.toString();
                  difference = 0;
                });
              },
              child: const Text('Clear Input'),
            ),
            ],
          ),

          // Multiplication Row
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(labelText: "First Number"),
                  controller: mul1Controller,
                ),
              ),
              const Text(" * "),
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(labelText: "Second Number"),
                  controller: mul2Controller,
                ),
              ),
              Text(' = $product'),
              // 3.a Add an IconButton here
              IconButton(
                icon: const Icon(Icons.check_circle), 
                onPressed: () {
                  setState(() {
                    product = int.parse(mul1Controller.value.text) * int.parse(mul2Controller.value.text);
                  });
                },),
              // b.b Add an button here
              TextButton(
              onPressed: () {
                setState(() {
                  mul1Controller.text = 0.toString();
                  mul2Controller.text = 0.toString();
                  product = 0;
                });
              },
              child: const Text('Clear Input'),
            ),
            ],
          ),

          // Division Row
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(labelText: "First Number"),
                  controller: div1Controller,
                ),
              ),
              const Text(" / "),
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(labelText: "Second Number"),
                  controller: div2Controller,
                ),
              ),
              Text(' = $quotient'),
              // 3.a Add an IconButton here
              IconButton(
                icon: const Icon(Icons.check_circle), 
                onPressed: () {
                  setState(() {
                    quotient = double.parse(div1Controller.value.text) / double.parse(div2Controller.value.text);
                  });
                },),
              // b.b Add an button here
              TextButton(
              onPressed: () {
                setState(() {
                  div1Controller.text = 0.toString();
                  div2Controller.text = 0.toString();
                  quotient = 0;
                });
              },
              child: const Text('Clear Input'),
            ),
            ],
          ),
        ],
      ),
    );
  }
}
