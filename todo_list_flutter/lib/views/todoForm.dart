import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';



class TodoForm extends StatefulWidget {
  @override
  _TodoFormState createState() => new _TodoFormState();
}

class _TodoFormState extends State<TodoForm> {

  final GlobalKey<FormBuilderState> _fbKey = new GlobalKey<FormBuilderState>();

  Map<int, String> types = {1: "Home", 2: "School", 3: "Work"};

  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),

      appBar: new AppBar(
        title: new Text('Create A New Task'),
      ),

      body: new Container(
        padding: new EdgeInsets.all(10.0),
       
        child: ListView(
          children: <Widget>[ 
            buildFormContents(),
            buildButtons(),
          ],
        ),
      ),
    );
  }


  Widget buildFormContents(){
    return FormBuilder(
      key: _fbKey,
      autovalidate: true,
     
      child: Column(
        children: <Widget>[

          Card(
            elevation: 8.0,
            color: Colors.blue[800],
            child: Container(
              padding: EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[

                  Text("Enter Your Task: ", style: TextStyle(fontSize: 20.0, color: Colors.white, fontWeight: FontWeight.bold),),

                  FormBuilderTextField(
                    attribute: "content",
                    cursorColor: Colors.white,
                    
                    style: TextStyle(fontSize: 16.0, color: Colors.white),
                    decoration: InputDecoration(isDense: false),
                   
                    validators: [
                      FormBuilderValidators.minLength(1),
                    ],
                  ),

                ],
              )
                
            )
            
          ),
          
          Card(
            elevation: 8.0,
            color: Colors.blue,
            child: Container(
              padding: EdgeInsets.all(10.0),
              child: Container(
                
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[

                  Text("Set a Due Date (optional): ", style: TextStyle(fontSize: 20.0, color: Colors.white, fontWeight: FontWeight.bold),),

                  FormBuilderDateTimePicker(
                    attribute: "date",
                    inputType: InputType.date,
                    style: TextStyle(fontSize: 16.0, color: Colors.white),
                    format: DateFormat("yyyy-MM-dd"),
                    
                    ),
                  ]
                )
              ) 
            )
          ),

          Card(
            elevation: 8.0,
            color: Colors.blue[200],
            child: Container(
              padding: EdgeInsets.all(10.0),
              child: Container(
                
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Select Type: ", style: TextStyle(fontSize: 20.0, color: Colors.black87, fontWeight: FontWeight.bold),),
                    FormBuilderDropdown(
                      attribute: "type",
                      
                      hint: Text('Select Type'),
                      validators: [FormBuilderValidators.required()],

                      items: [1, 2, 3]
                        .map((type) => DropdownMenuItem(
                          value: type,
                          child: Text(types[type])
                      )).toList(),
                    ),
                  ]
                )
              ),
            )
          )
        ],
      ),

    );
  }

  Widget buildButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          margin: EdgeInsets.all(8.0),
          child: RaisedButton(
            elevation: 8.0,
            color: Colors.cyan[200],
            child: Text("Submit", style: TextStyle(fontSize: 18.0, color: Colors.black87, fontWeight: FontWeight.bold),),
            onPressed: () {
              _fbKey.currentState.save();
              if (_fbKey.currentState.validate()) {
                print(_fbKey.currentState.value);
                Navigator.pop(context, _fbKey.currentState.value);
              }
            },
          ),
        ),
        
        Container(
          margin: EdgeInsets.all(8.0),
          child: RaisedButton(
            color: Colors.purple[200],
            elevation: 8.0,
            child: Text("Reset", style: TextStyle(fontSize: 18.0, color: Colors.black87, fontWeight: FontWeight.bold),),
            onPressed: () {
              _fbKey.currentState.reset();
            },
          ),
        )
      ],
    );
  }

}

