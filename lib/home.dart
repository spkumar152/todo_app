import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo/constants/colors.dart';
import 'package:todo/tdItems.dart';

import 'model/todo.dart';

class Home extends StatefulWidget{

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final todosList = ToDo.todoList();
  List<ToDo> _foundToDo = [];
  final _todoController = TextEditingController();



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _foundToDo = todosList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: tdAppBarColor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(Icons.menu, color: tdBGColor, size: 34,),

            Container(
              height: 40,
              width: 40,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child:Image.asset('assets/images/pramod.png'),)
            )
          ]),
      ),
      body: Stack(
        children: [
          Container(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              child: Column(
                children: [
                  searchBox(),

                  Expanded(
                    child: ListView(
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 50, bottom: 20),
                          child: Text('All ToDos', style: TextStyle(
                            fontSize: 34,
                            fontWeight: FontWeight.w700,
                            color: tdBlack
                          ),),),




                        for (ToDo todo in _foundToDo.reversed)
                        ToDoItems(
                          todo: todo,
                          onToDoChanged: _handleToDoChange,
                          onDeleteItem: _deleteToDoItems,
                        ),


                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              children: [
                Expanded(child: Container(
                  margin: EdgeInsets.only(bottom: 20, right: 20, left: 20),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: const [BoxShadow(
                      color: Colors.grey,
                      offset: Offset(0.0, 0.0),
                      blurRadius: 10.0,
                      spreadRadius: 0.0,
                    ),],
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: TextField(
                    controller: _todoController,
                    decoration: InputDecoration(
                      hintText: 'Add a new ToDo item',
                      border: InputBorder.none
                    ),
                  ),
                ),),
                Container(
                  margin: EdgeInsets.only(
                      bottom: 20,
                    right: 20
                  ),
                  child: ElevatedButton(
                    child: Text('+', style: TextStyle(
                      fontSize: 40,
                      color: Colors.white
                    ),),
                    onPressed: (){
                      _addToDoItems(_todoController.text);
                    },
                    style:ElevatedButton.styleFrom(
                      backgroundColor: tdBlue,
                      minimumSize: Size(60, 60),
                      elevation: 10,
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
      backgroundColor: tdBGColor,

    );
  }

  void _handleToDoChange (ToDo todo){
    setState(() {
      todo.isDone = !todo.isDone;
    });
  }

  void _deleteToDoItems(String id){
    setState(() {
      todosList.removeWhere((item)=> item.id == id);
    });
  }

  void _addToDoItems(String toDo){
    setState(() {
      todosList.add(ToDo(
          id: DateTime.now().millisecondsSinceEpoch.toString(), todoText: toDo
      ));
      _todoController.clear();
    }
    );

  }

  void _runFilter(String enteredKeyword){
    List<ToDo> results = [];
    if(enteredKeyword.isEmpty){
      results = todosList;
    }else{
      results = todosList
          .where((item) => item.todoText!
          .toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();

    }
    setState(() {
      _foundToDo = results;
    });

  }



  Widget searchBox(){
    return Container(
      decoration:BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20)
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: TextField(
          onChanged: (value) => _runFilter(value),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(0),
            prefixIcon: Icon(Icons.search, color: tdBlack, size: 20,),
            prefixIconConstraints: BoxConstraints(
                maxHeight: 20,
                minWidth: 30
            ),
            border: InputBorder.none,
            hintText: 'Search',
            hintStyle: TextStyle(color: tdGray),
          ),
        ),
      ),
    );
  }
}