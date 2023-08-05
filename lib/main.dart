import 'package:flutter/material.dart';

const List<String> algorithms = <String>['Selection Sort', 'Insertion Sort', 'Bubble Sort', 'Merge Sort', "Quick Sort"];
const List<String> speeds = <String>['Slow', 'Medium', 'Fast'];
List<int> values = <int>[];

String algorithm = algorithms.first;
String speed = speeds.first;

int heightMultiplier = 1;
List<int> yellowValues = <int>[]; 
List<int> redValues = <int>[];
List<int> greenValues = <int>[];
List<int> purpleValues = <int>[];
List<int> orangeValues = <int>[];

bool running = false;

void main() {
  
  /// Sets the numer of items in the list
  /// 
  /// Can be modified to have more of less values
  const int sizeOfValues = 100; 
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
        primarySwatch: Colors.green,
      ),
      home: const MyHomePage(title: 'Sorting Algorithms Visualizer'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    int timeOut = 1;
    
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(widget.title),
        ),
      ),
      body: Center(
        child: Column(
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
                    /// This is called when the user selects an item.
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
                    /// This is called when the user selects an item.
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
            /// Row for the three buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton( 
                  child: const Text("Scramble", style: TextStyle(fontSize: 20),),   
                  onPressed: () {
                    setState(() {
                      running = false;
                      values.shuffle();
                      reset();
                    });
                  },  
                ),
                const SizedBox(width: 10),
                ElevatedButton(  
                  child: const Text("Stop", style: TextStyle(fontSize: 20),),  
                  onPressed: () {
                    setState(() {
                      running = false;
                      reset();
                    });
                  },  
                ),
                const SizedBox(width: 10),

                /// Sort Button
                /// 
                /// Contains all the logic for the sorting algorithms
                ElevatedButton(  
                  child: const Text("Sort", style: TextStyle(fontSize: 20),), 
                  onPressed: () async {
                    reset();
                    if(running){
                      return;
                    }else{
                      running = true;
                    }
                    switch(speed){
                      case "Slow": { timeOut = 1000; } break;
                      case "Medium": { timeOut = 20; } break;
                      case "Fast": { timeOut = 0; } break;
                    }
                    switch(algorithm){
                      case "Selection Sort": {
                        int minValIndex;
                        for(int i = 0; i < values.length; i++){
                          if(!running) return;
                          minValIndex = i;
                          setState(() {
                            yellowValues = [minValIndex];
                          });
                          await Future.delayed(Duration(milliseconds: timeOut));

                          for(int j = i + 1; j < values.length; j++){
                            if(!running) return;
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
                          // swap values[i] and values[minValIndex]
                          setState(() {
                            int temp = values[i];
                            values[i] = values[minValIndex];
                            values[minValIndex] = temp; 
                            greenValues.add(i);
                          });
                          await Future.delayed(Duration(milliseconds: timeOut));
                        }
                        setState(() {
                          running = false;
                          redValues.clear();
                          yellowValues.clear();
                        });
                      } break;

                      case "Insertion Sort": {
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
                            if(!running) return;
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
                            j--;
                          }
                          values[j + 1] = curr;
                          setState(() {
                            greenValues.add(i);
                          });
                        }
                        setState(() {
                          running = false;
                          redValues.clear();
                          yellowValues.clear();
                        });
                      } break;

                      case "Bubble Sort": {
                        int i, j;
                        int temp;
                        bool swapped;
                        for(i = 0; i < values.length; i++){
                          swapped = false;
                          for(j = 0; j < values.length - i - 1; j++){
                            if(!running) return;
                            setState(() {
                              yellowValues = [j];
                              redValues = [j+1];
                            });
                            await Future.delayed(Duration(milliseconds: timeOut));
                            if(values[j] > values[j+1]){  // if value on left is less than value on right swap them
                              temp = values[j+1];
                              values[j+1] = values[j];
                              values[j] = temp;
                              swapped = true;
                              setState(() {
                                // values have swapped
                                yellowValues = [j+1];
                                redValues = [j];
                              });
                              await Future.delayed(Duration(milliseconds: timeOut));
                            }
                          }
                          if(!swapped) break;
                        }
                        setState(() {
                          greenValues = values.toList();
                          greenValues.add(0);
                          yellowValues.clear();
                          redValues.clear();
                        });
                      } break;

                      case "Merge Sort": {
                        Future<List<int>> merge(final List<int> values, int leftIndex, int middleIndex, int rightIndex) async{
                          if(!running) values;
                          List<int> leftArray = values.sublist(leftIndex, middleIndex + 1); // [leftIndex, middleIndex]
                          List<int> rightArray = values.sublist(middleIndex + 1, rightIndex + 1); // (middleIndex, rightIndex]
                          setState(() {
                            yellowValues = [for(int i = leftIndex; i <= middleIndex; i++) i];
                            redValues = [for(int i = middleIndex + 1; i <= rightIndex; i++) i];
                          });
                          await Future.delayed(Duration(milliseconds: timeOut));
                          int i = 0, j = 0; //index of left array, index of right array
                          int indexOfMergedArray = leftIndex;
                          while(i < leftArray.length && j < rightArray.length){
                            if(!running) values;
                            if(leftArray[i] < rightArray[j]){
                              values[indexOfMergedArray] = leftArray[i];
                              i++;
                            } else {
                              values[indexOfMergedArray] = rightArray[j];
                              j++;
                            }
                            indexOfMergedArray++;
                          }

                          while(i < leftArray.length){
                            if(!running) values;
                            values[indexOfMergedArray] = leftArray[i];
                            i++;
                            indexOfMergedArray++;
                          }

                          while(j < rightArray.length){
                            if(!running) values;
                            values[indexOfMergedArray] = rightArray[j];
                            j++;
                            indexOfMergedArray++;
                          }

                          setState(() {});
                          await Future.delayed(Duration(milliseconds: timeOut));
                          return values;
                        }

                        Future<List<int>> mergeSort(List<int> values, int leftIndex, int rightIndex) async{
                          if(!running) return values;
                          if(leftIndex >= rightIndex) return values;
                          
                          int middleIndex = leftIndex + ((rightIndex - leftIndex) / 2).floor();
                          setState(() {
                            yellowValues = [for(int i = leftIndex; i <= middleIndex; i++) i];
                            redValues = [for(int i = middleIndex + 1; i <= rightIndex; i++) i];
                          });
                          await Future.delayed(Duration(milliseconds: timeOut));
                          // Sort the left half
                          values = await mergeSort(values, leftIndex, middleIndex);
                          if(!running) return values;
                          // Sort the right half
                          values = await mergeSort(values, middleIndex + 1, rightIndex);
                          if(!running) return values;
                          // MERGE BABY MERGE!
                          values = await merge(values, leftIndex, middleIndex, rightIndex);
                          return values;
                        }

                        //Call the merge sort function
                        values = await mergeSort(values, 0, values.length - 1);
                        if(running){
                          setState(() {
                            running = false;
                            greenValues = values.toList();
                            greenValues.add(0);
                          });
                        }
                      } break;

                      case "Quick Sort": {
                        Future<List<int>> quickSort(List<int> values, int leftIndex, int rightIndex) async{
                          if(!running) return values;
                          int partitionIndex;
                          int pivot; 
                          int j;
                          int temp;
                          if(leftIndex < rightIndex){
                            // PARTITION FUNCTION
                            pivot = values[rightIndex];
                            partitionIndex = leftIndex - 1;
                            setState(() {
                              yellowValues = [for(int i = leftIndex; i < rightIndex; i++) i];
                              purpleValues = [rightIndex];
                              redValues = [];
                            });
                            await Future.delayed(Duration(milliseconds: timeOut));

                            // go from left to right, count how many are smaller than the pivot element
                            // I
                            for(j = leftIndex; j <= rightIndex; j++){
                              if(!running) return values;
                              if(values[j] < pivot){
                                partitionIndex++;
                                // swap (values[partitionIndex], values[j])
                                temp = values[j];
                                values[j] = values[partitionIndex];
                                values[partitionIndex] = temp;
                                setState(() {
                                  yellowValues.remove(partitionIndex);
                                  redValues.add(partitionIndex);
                                });
                                await Future.delayed(Duration(milliseconds: (timeOut ~/ 2)));
                              }
                            }
                            // swap (values[partitionIndex + 1], values[rightIndex])
                            // move the pivot element into the right position in [leftIndex, rightIndex]
                            partitionIndex++;
                            temp = values[partitionIndex];
                            values[partitionIndex] = values[rightIndex];
                            values[rightIndex] = temp;
                            // END OF PARTITION FUNCTION

                            setState(() {
                              purpleValues = [partitionIndex];
                              yellowValues = [for(int i = leftIndex; i < partitionIndex; i++) i];
                              redValues = [for(int i = partitionIndex + 1; i <= rightIndex; i++) i];
                            });
                            await Future.delayed(Duration(milliseconds: timeOut));

                            //sort the left
                            values = await quickSort(values, leftIndex, partitionIndex - 1);
                            // sort the right
                            values = await quickSort(values, partitionIndex + 1, rightIndex);
                          }
                          return values;
                        }
                        values = await quickSort(values, 0, values.length - 1);
                        if(running){
                          setState(() {
                            greenValues = values.toList();
                            greenValues.add(0);
                          });
                        }
                      } break;
                    }
                  },  
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

/// Return [Color] for a given value
/// 
/// Blue = default, Green = sorted, Red and Yellow are used in sorting operations
Color getColor(int value){
  if(greenValues.contains(value)){
    return Colors.green;
  }else if(redValues.contains(value)){
    return Colors.red;
  }else if(purpleValues.contains(value)){
    return Colors.purple;
  }else if(yellowValues.contains(value)){
    return Colors.yellow;
  }else if(orangeValues.contains(value)){
    return Colors.orange;
  }else{
    return Colors.blue;
  }
}

void reset(){
  redValues.clear();
  yellowValues.clear();
  greenValues.clear();
  purpleValues.clear();
  orangeValues.clear();
}

