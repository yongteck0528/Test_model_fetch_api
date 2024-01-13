import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:test_model_fetch_api/model/food.dart';

class TesAPI extends StatefulWidget {
  const TesAPI({super.key});

  @override
  State<TesAPI> createState() => _TesAPIState();
}

class _TesAPIState extends State<TesAPI> {
  // List<Food> _food = <Food>[];
  List<Food> _foodList = <Food>[];
  TextEditingController _foodNameController = TextEditingController();

  Future<List<Food>> fetchFoods(String foodName) async {
    var apiKey = "7JdkTq3FchntRBv5Ax1Eog==lWifTLw8ivhrr98C";
    var url = 'https://api.api-ninjas.com/v1/nutrition?query=$foodName';
    var response =
        await http.get(Uri.parse(url), headers: {'X-Api-Key': apiKey});

    var foods = <Food>[];

    if (response.statusCode == 200) {
      List<dynamic> jsonList = jsonDecode(response.body);

      for (var foodsJson in jsonList) {
        foods.add(Food.fromJson(foodsJson));
      }
    } else {
      throw Exception('Failed to load food nutritions');
    }
    return foods;
  }

  @override
  void initState() {
    super.initState();
  }

  Future<void> _updateFoodData(String foodName) async {
    try {
      var foods = await fetchFoods(foodName);
      setState(() {
        // Store the fetched data in the list
        _foodList = foods;
      });

      // Print the stored data
      _foodList.forEach((food) {
        printFoodDetails(food);
      });
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  void printFoodDetails(Food food) {
    print('Name: \t\t ${food.name}');
    print('Calories: \t ${food.calories}');
    print('Serving size (g): \t ${food.servingSizeG}');
    print('Fat Total (g): \t ${food.fatTotalG}');
    print('Sodium (mg): \t\t ${food.sodiumMg}');
    print('Potassium (mg): \t ${food.potassiumMg}');
    print('Cholesterol (mg): \t ${food.cholesterolMg}');
    print('Carbohydrates Total (g): ${food.carbohydratesTotalG}');
    print('Fiber (g): \t\t ${food.fiberG}');
    print('Sugar (g): \t\t ${food.sugarG}');
    // ... print other details ...
    print('-------------------------');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tes API"),
      ),
      body: Column(
        children: [
          // Input box for food name
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _foodNameController,
              decoration: InputDecoration(
                labelText: 'Enter Food Name',
              ),
            ),
          ),

          // Button to trigger API call
          ElevatedButton(
            onPressed: () => _updateFoodData(_foodNameController.text),
            child: Text('Fetch Data'),
          ),

          // Display fetched data
          Expanded(
            child: ListView.builder(
              itemCount: _foodList.length,
              itemBuilder: (context, index) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _buildText('Name', _foodList[index].name),
                      _buildText(
                          'Calories', _foodList[index].calories.toString()),
                      _buildText('Serving Size (g)',
                          _foodList[index].servingSizeG.toString()),
                      _buildText('Total Fat (g)',
                          _foodList[index].fatTotalG.toString()),
                      _buildText('Saturated Fat (g)',
                          _foodList[index].fatSaturatedG.toString()),
                      _buildText(
                          'Protein (g)', _foodList[index].proteinG.toString()),
                      _buildText(
                          'Sodium (mg)', _foodList[index].sodiumMg.toString()),
                      _buildText('Potassium (mg)',
                          _foodList[index].potassiumMg.toString()),
                      _buildText('Cholesterol (mg)',
                          _foodList[index].cholesterolMg.toString()),
                      _buildText('Total Carbohydrates (g)',
                          _foodList[index].carbohydratesTotalG.toString()),
                      _buildText(
                          'Fiber (g)', _foodList[index].fiberG.toString()),
                      _buildText(
                          'Sugar (g)', _foodList[index].sugarG.toString()),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildText(String variable, String data) {
  return Text('$variable = $data');
}
