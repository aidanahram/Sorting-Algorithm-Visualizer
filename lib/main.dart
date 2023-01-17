import 'package:flutter/material.dart';

const List<String> algorithms = <String>['Selection Sort', 'Insertion Sort', 'Merge Sort', 'Bubble Sort'];
const List<String> speeds = <String>['Slow', 'Medium', 'Fast'];
List<int> values = <int>[];

String algorithm = algorithms.first;
String speed = speeds.first;

int heightMultiplier = 1;
List<int> yellowValues = <int>[]; 
List<int> redValues = <int>[];
List<int> greenValues = <int>[];

bool running = false;
void main() {
  const int sizeOfValues = 100; //SETS THE NUMBER OF ITEMS IN THE LIST
  for(int i = 1; i < sizeOfValues + 1; i++){
    values.add(i);
  } 
  heightMultiplier = (600/sizeOfValues).floor();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sorting Algorithms Visualizer',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.green,
      ),
      home: const MyHomePage(title: 'Sorting Algorithms Visualizer'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    int timeOut = 1;
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Center(
          child: Text(widget.title),
        ),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Select an Algorithm: '),
                DropdownButton<String>(
                  value: algorithm,
                  icon: const Icon(Icons.arrow_downward),
                  elevation: 16,
                  style: const TextStyle(color: Colors.deepPurple),
                  underline: Container(
                    height: 2,
                    color: Colors.deepPurpleAccent,
                  ),
                  onChanged: (String? value) {
                    // This is called when the user selects an item.
                    setState(() {
                      algorithm = value!;
                    });
                  },
                  items: algorithms.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ]
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Select a Speed: '),
                DropdownButton<String>(
                  value: speed,
                  icon: const Icon(Icons.arrow_downward),
                  elevation: 16,
                  style: const TextStyle(color: Colors.deepPurple),
                  underline: Container(
                    height: 2,
                    color: Colors.deepPurpleAccent,
                  ),
                  onChanged: (String? value) {
                    // This is called when the user selects an item.
                    setState(() {
                      speed = value!;
                    });
                  },
                  items: speeds.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ]
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(  
                  onPressed: () {
                    setState(() {
                      running = false;
                      values.shuffle();
                      reset();
                    });
                  },  
                  child: const Text("Scramble", style: TextStyle(fontSize: 20),),  
                ),
                const SizedBox(width: 10),
                ElevatedButton(  
                  onPressed: () {
                    setState(() {
                      running = false;
                      reset();
                    });
                  },  
                  child: const Text("Stop", style: TextStyle(fontSize: 20),),  
                ),
                const SizedBox(width: 10),
                ElevatedButton(  
                  onPressed: () async {
                    reset();
                    if(running){
                      return;
                    }else{
                      running = true;
                    }
                    switch(speed){
                      case 'Slow': { timeOut = 1000; } break;
                      case 'Medium': { timeOut = 2; } break;
                      case 'Fast': { timeOut = 0; } break;
                    }
                    switch(algorithm){
                      case 'Selection Sort': {
                        int minValIndex;
                        for(int i = 0; i < values.length; i++){
                          minValIndex = i;
                          setState(() {
                            yellowValues = [minValIndex];
                          });
                          await Future.delayed(Duration(milliseconds: timeOut));

                          for(int j = i + 1; j < values.length; j++){
                            if(!running){
                              return;
                            }
                            setState(() {
                              //current
                              redValues = [j];
                            });
                            await Future.delayed(Duration(milliseconds: timeOut));

                            if(values[minValIndex] > values[j]){
                              minValIndex = j;
                              setState(() {
                                yellowValues = [j];
                              });
                              await Future.delayed(Duration(milliseconds: timeOut));
                            }                    
                          }
                          //swap values[i] and values[minValIndex]
                          setState(() {
                            int temp = values[i];
                            values[i] = values[minValIndex];
                            values[minValIndex] = temp; 
                            greenValues.add(i);
                          });
                          await Future.delayed(Duration(milliseconds: timeOut));
                        }
                        setState(() {
                          redValues = [];
                          yellowValues = [];
                        });
                        running = false;
                      } break;

                      case 'Insertion Sort': {
                        for(int i = 0; i < values.length; i++){
                          int curr = values[i];
                          int j = i - 1;

                          setState(() {
                            redValues = [i];
                            yellowValues = [j];
                          });
                          await Future.delayed(Duration(milliseconds: timeOut));

                          //check if the one before curr is greater, if it is we need to swap
                          while (j >= 0 && curr < values[j]) {
                            if(!running){
                              return;
                            }
                            setState(() {
                              redValues = [j+1];
                              yellowValues = [j];
                            });
                            await Future.delayed(Duration(milliseconds: timeOut));

                            int temp = values[j];
                            values[j] = curr;
                            values[j + 1] = temp;
                            
                            setState(() {
                              redValues = [j];
                              yellowValues = [j+1];
                            });
                            await Future.delayed(Duration(milliseconds: timeOut));
                            j -= 1;
                          }
                          values[j + 1] = curr;
                          setState(() {
                            greenValues.add(i);
                          });
                        }
                        running = false;
                        setState(() {
                          redValues = [];
                          yellowValues = [];
                        });
                      } break;
                    }
                  },  
                  child: const Text("Sort", style: TextStyle(fontSize: 20),),  
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              height: 600,
              width: 600,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blueAccent)
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  for (int i = 0; i < values.length; i++) Expanded(  // each element takes the same space
                    child: Container(
                      height: (values[i].toDouble() * heightMultiplier),  // you can scale this to make them taller
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        color: getColor(i),
                        
                      ),
                    ),
                  ),
                ]
              ),
            ),
          ],
        ),
      ),

    );
  }
}

Color getColor(int index){
  if(yellowValues.contains(index)){
    return Colors.yellow;
  }else if(redValues.contains(index)){
    return Colors.red;
  }else if(greenValues.contains(index)){
    return Colors.green;
  }else{
    return Colors.blue;
  }
}

void reset(){
  redValues = [];
  yellowValues = [];
  greenValues = [];
}