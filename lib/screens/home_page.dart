import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _controller = TextEditingController();
  Random rand = Random();
  var time = 1000;
  bool automate = false;
  List<String> goodPasswords = [];
  var input;
  bool modeChoser = false;

  var modeText = 'Best';
  double _value = 1;
  var displayPassword;
  var keys = [
    "oOdDqQ",
    "iIlLjJ",
    "vVuUzZnN",
    "eEmMwW",
    "tTkK",
    "sSaA",
    "gGfFcC",
    "hHyY",
    "xXbB",
    "rRpP",
    " ",
  ];

  void _generatePassword() {
    var encode;
    var r;
    var password;
    var input = _controller.text;
    if (input.isEmpty) {
      setState(() {
        displayPassword = '...';
      });
    } else {
      input = _controller.text;
      for (int i = 0; i < input.length; i++) {
        for (int j = 0; j < keys.length; j++) {
          int index = keys[j].indexOf(input[i]);
          if (index != -1) {
            // print('$i ${input[i]}: $j ');
            if (password == null) {
              r = rand.nextInt(keys[j].length);
              password = '${j}';
              encode = keys[j][r];
              // print(encode);neofetch

            } else {
              r = rand.nextInt(keys[j].length);
              password = '$password$j';
              encode = '${encode}${keys[j][r]}';
              // print(encode);
            }
          }
        }
      }
      setState(() {
        displayPassword = '$encode';
      });
    }
  }

  bool isAlternatingVowels(text) {
    String str = text;
    int length = str.length;
    String newStr = str.replaceAll(RegExp(r"\s+"), '');
    RegExp regEx = RegExp(r'[^aeiouyAEIOUY]{2,}');
    RegExp regEx2 = RegExp(r'[^aeiouyAEIOUY]{3,}');
    if (modeChoser) {
      return !regEx.hasMatch(newStr) || !regEx2.hasMatch(newStr);
    } else {
      return !regEx.hasMatch(newStr);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      displayPassword = "...";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lockey Shell'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Container(
              height: 40,
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
              padding:
                  EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
              child: Text(
                'Create your password',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  icon: Icon(Icons.keyboard),
                  labelText: 'Enter a word',
                  hintText: 'Name, Food, Movie, etc',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            Slider(
              min: 1.0,
              max: 40.0,
              divisions: 100,
              value: _value,
              onChanged: (value) {
                time = (2000 / value).toInt();
                setState(() {
                  _value = value;
                });
                // Update the state of your application with the new value
              },
            ),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  child: Container(
                    width: 230,
                    decoration: BoxDecoration(
                      border: Border.all(width: 2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.only(
                        left: 20, right: 20, top: 10, bottom: 10),
                    child: SelectableText(
                      '$displayPassword',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
                MaterialButton(
                  color: Colors.lime,
                  onPressed: () {
                    var count = 0;
                    while (count < 5) {
                      _generatePassword();
                      count++;
                    }
                  },
                  // _generatePassword();

                  child: Text('Generate Password'),
                  elevation: 10,
                  splashColor: Colors.blue,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                MaterialButton(
                  elevation: 30,
                  color: Colors.blue,
                  onPressed: () async {
                    setState(() {
                      automate = true;
                      goodPasswords = [];
                    });
                    for (int i = 0; i < 10000; i++) {
                      if (automate) {
                        await Future.delayed(Duration(milliseconds: time));
                        setState(() {
                          _generatePassword();
                          if (isAlternatingVowels(displayPassword)) {
                            goodPasswords.insert(0, displayPassword);
                          }
                        });
                      }
                    }
                    print(goodPasswords);
                  },
                  child: Text('Automate'),
                ),
                SizedBox(
                  width: 20,
                ),
                MaterialButton(
                  color: Colors.red,
                  elevation: 30,
                  onPressed: () {
                    setState(() {
                      automate = false;
                    });
                  },
                  child: Text(
                    'Stop',
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                MaterialButton(
                  color: Colors.deepPurple,
                  elevation: 30,
                  onPressed: () {
                    setState(() {
                      modeChoser = !modeChoser;
                      if (modeChoser) {
                        modeText = 'Fast';
                      } else {
                        modeText = 'Best';
                      }
                    });
                  },
                  child: Text(
                    modeText,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: goodPasswords.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        GestureDetector(
                          onTap: () async {
                            Clipboard.setData(
                                ClipboardData(text: goodPasswords[index]));
                            await ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text('${goodPasswords[index]} stored in clipboard'), duration: Duration(seconds: 1)),);

                          },
                          child: Container(
                            padding: EdgeInsets.only(
                              left: 80,
                              right: 80,
                              top: 15,
                              bottom: 15,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              border: Border.all(
                                color: Colors.grey,
                              ),
                            ),
                            child: SelectableText(
                              goodPasswords[index],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                          height: 16,
                        )
                      ],
                    );
                  }),
            )
          ],
        ),
      ),

    );
  }
}
