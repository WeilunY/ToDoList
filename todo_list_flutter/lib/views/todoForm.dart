import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';



class TodoForm extends StatefulWidget {
  @override
  _TodoFormState createState() => new _TodoFormState();
}

class _TodoFormState extends State<TodoForm> {

  final GlobalKey<FormBuilderState> _fbKey = new GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {

    Map<int, String> types = {1: "Home", 2: "School", 3: "Work"};

    return new Scaffold(

      appBar: new AppBar(
        title: new Text('Create A New Task'),
      ),
      //backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      

      body: new Container(
        padding: new EdgeInsets.all(20.0),

        child: Column(
          children: <Widget>[
            FormBuilder(
              key: _fbKey,
              autovalidate: true,
              initialValue: {

              },
              
              child: Column(
                children: <Widget>[

                  FormBuilderTextField(
                    attribute: "content",
                    decoration: InputDecoration(labelText: "Enter Your Task: ", labelStyle: TextStyle(fontSize: 16.0)),
                    validators: [
                      FormBuilderValidators.minLength(1),
                    ],

                  ),

                  FormBuilderDropdown(
                    attribute: "type",
                    decoration: InputDecoration(labelText: "Select your task type", labelStyle: TextStyle(fontSize: 16.0)),
                    initialValue: 1,
                    hint: Text('Select Type'),
                    validators: [FormBuilderValidators.required()],

                    items: [1, 2, 3]
                      .map((type) => DropdownMenuItem(
                        value: type,
                        child: Text(types[type])
                    )).toList(),
                  ),

                  FormBuilderDateTimePicker(
                    attribute: "date",
                    inputType: InputType.date,
                    format: DateFormat("yyyy-MM-dd"),
                    decoration:
                    InputDecoration(labelText: "Due Date", labelStyle: TextStyle(fontSize: 16.0)),
                  ),

                ],
              ),

            ),

            Row(
              children: <Widget>[
                MaterialButton(
                  child: Text("Submit"),
                  onPressed: () {
                    _fbKey.currentState.save();
                    if (_fbKey.currentState.validate()) {
                      print(_fbKey.currentState.value);
                      Navigator.pop(context, _fbKey.currentState.value);
                    }
                  },
                ),

                MaterialButton(
                  child: Text("Reset"),
                  onPressed: () {
                    _fbKey.currentState.reset();
                  },
                ),
              ],
            )
          ],
        ),

        
      ),
    );
  }
}

