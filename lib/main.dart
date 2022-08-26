import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Teste Carone'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  final numberInputTextController = TextEditingController();

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> numbers = [];
  void updateNumbers () {
    setState(() {
      numbers.insert(0, widget.numberInputTextController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 20),
                child: SizedBox(
                  width: 200,
                  child: TextField(
                      controller: widget.numberInputTextController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9-]+')),] ,
                      decoration: const InputDecoration(
                        hintText: 'Valores do Array',
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
                        contentPadding: EdgeInsets.only(left: 2.0),
                      ),
                    ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 20),
                child: RawMaterialButton(
                  onPressed: () async {
                    if(widget.numberInputTextController.text.isEmpty) {
                       await CaroneAppUtils()._showInputErrorDialog(context);
                    } else {
                      updateNumbers();
                    }
                  },
                  elevation: 2,
                  fillColor: Colors.blue,
                  padding: const EdgeInsets.all(15),
                  shape: const CircleBorder(),
                  child: const Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('Array em ordem de inserção: $numbers'),
                Text('Tamanho da lista: ' + numbers.length.toString()),
                Text(CaroneAppUtils().calculateMinNumber(numbers)),
                Text(CaroneAppUtils().calculateMaxNumber(numbers)),
                Text(CaroneAppUtils().sortNumbers(numbers))
              ],
            ),
          ),
        ]
      ),
    );
  }
}

class CaroneAppUtils {

  Future<void> _showInputErrorDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Erro ao inserir valor'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const [
                Text('Por favor não deixe o campo de Valores em branco.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  String calculateMinNumber (List<String> numbers) {
    List<int> intNumbers = numbers.map((e) => int.parse(e)).toList();
    int minValue = 9223372036854775807;
    for(int i = 0; i < intNumbers.length; i++) {
      if(intNumbers[i] < minValue) {
        minValue = intNumbers[i];
      }
    }
    if(numbers.isEmpty){
      return 'Menor valor do Array: Nenhum número encontrado';
    } else {
      return 'Menor valor do Array: $minValue';
    }
  }

  String calculateMaxNumber (List<String> numbers) {
    List<int> intNumbers = numbers.map((e) => int.parse(e)).toList();
    int maxValue = -9223372036854775807;
    for(int i = 0; i < intNumbers.length; i++) {
      if(intNumbers[i] > maxValue) {
        maxValue = intNumbers[i];
      }
    }
    if(numbers.isEmpty) {
      return 'Maior valor do Array: Nenhum número encontrado';
    } else {
      return 'Maior valor do Array: $maxValue';
    }
  }

  String sortNumbers (List<String> numbers) {
    List<int> intNumbers = numbers.map((e) => int.parse(e)).toList();
    int i, j;
    for(j = 0; j < intNumbers.length; j++) {
      for(i = 0; i < intNumbers.length - 1; i++) {
        if(intNumbers[i] > intNumbers[i + 1]) {
          int aux = intNumbers[i];
          intNumbers[i] = intNumbers[i+1];
          intNumbers[i+1] = aux;
        }
      }
    }

    return 'Array ordenado: $intNumbers';
  }
}
