import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sql_lite/bloc/bloc.dart';
import 'package:sql_lite/lista/lista.dart';

class HomePage extends StatelessWidget {
  HomePage({Key key, this.title}) : super(key: key);

  //We load our Lista BLoC that is used to get
  //the stream of Lista for StreamBuilder
  final TodoBloc todoBloc = TodoBloc();
  final String title;

  //Allows Lista card to be dismissable horizontally
  final DismissDirection _dismissDirection = DismissDirection.horizontal;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.white,
        //systemNavigationBarColor: Colors.black54,
        systemNavigationBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.dark));
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        body: SafeArea(
            child: Container(
                color: Colors.white10,
                padding:
                const EdgeInsets.only(left: 2.0, right: 2.0, bottom: 2.0),
                child: Container(
                  //This is where the magic starts
                    child: getTodosWidget()))),
        bottomNavigationBar: BottomAppBar(
          color: Colors.lightGreen,
          child: Container(
            decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.green, width: 0.3),
                )),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                IconButton(
                    icon: Icon(
                      Icons.menu,
                      color: Colors.green,
                      size: 28,
                    ),
                    onPressed: () {
                      //just re-pull UI for testing purposes
                      todoBloc.getTodos();
                    }),
                Expanded(
                  child: Text(
                    "All",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'RobotoMono',
                        fontStyle: FontStyle.normal,
                        fontSize: 19),
                  ),
                ),
                Wrap(children: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.search,
                      size: 28,
                      color: Colors.green,
                    ),
                    onPressed: () {
                      _showTodoSearchSheet(context);
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 5),
                  )
                ])
              ],
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Padding(
          padding: EdgeInsets.only(bottom: 25),
          child: FloatingActionButton(
            elevation: 5.0,
            onPressed: () {
              _showAddTodoSheet(context);
            },
            backgroundColor: Colors.white10,
            child: Icon(Icons.add, size: 32, color: Colors.green),
          ),
        ));
  }

  void _showAddTodoSheet(BuildContext context) {
    final _todoDescriptionFormController = TextEditingController();
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return new Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: new Container(
              color: Colors.transparent,
              child: new Container(
                height: 230,
                decoration: new BoxDecoration(
                    color: Colors.black12,
                    borderRadius: new BorderRadius.only(
                        topLeft: const Radius.circular(10.0),
                        topRight: const Radius.circular(10.0))),
                child: Padding(
                  padding: EdgeInsets.only(
                      left: 15, top: 25.0, right: 15, bottom: 30),
                  child: ListView(
                    children: <Widget>[
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: TextFormField(
                              controller: _todoDescriptionFormController,
                              textInputAction: TextInputAction.newline,
                              maxLines: 4,
                              style: TextStyle(
                                  fontSize: 21,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white),
                              autofocus: true,
                              decoration: const InputDecoration(
                                  hintText: 'I have to...',
                                  hintStyle: TextStyle(color: Colors.white),
                                  labelText: 'Nova Lista',
                                  labelStyle: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.w500)),
                              validator: (String value) {
                                if (value.isEmpty) {
                                  return 'Empty description!';
                                }
                                return value.contains('')
                                    ? 'Do not use the @ char.'
                                    : null;
                              },
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 5, top: 15),
                            child: CircleAvatar(
                              backgroundColor: Colors.green,
                              radius: 18,
                              child: IconButton(
                                icon: Icon(
                                  Icons.save,
                                  size: 22,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  final newTodo = Lista(
                                      description:
                                      _todoDescriptionFormController
                                          .value.text);
                                  if (newTodo.description.isNotEmpty) {
                                    /*Create new Lista object and make sure
                                    the Lista description is not empty,
                                    because what's the point of saving empty
                                    Lista
                                    */
                                    todoBloc.addTodo(newTodo);

                                    //dismisses the bottomsheet
                                    Navigator.pop(context);
                                  }
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  void _showTodoSearchSheet(BuildContext context) {
    final _todoSearchDescriptionFormController = TextEditingController();
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return new Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: new Container(
              color: Colors.transparent,
              child: new Container(
                height: 230,
                decoration: new BoxDecoration(
                    color: Colors.black12,
                    borderRadius: new BorderRadius.only(
                        topLeft: const Radius.circular(10.0),
                        topRight: const Radius.circular(10.0))),
                child: Padding(
                  padding: EdgeInsets.only(
                      left: 15, top: 25.0, right: 15, bottom: 30),
                  child: ListView(
                    children: <Widget>[
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: TextFormField(
                              controller: _todoSearchDescriptionFormController,
                              textInputAction: TextInputAction.newline,
                              maxLines: 4,
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white),
                              autofocus: true,
                              decoration: const InputDecoration(
                                hintText: 'Search for...',
                                hintStyle: TextStyle(color: Colors.white),
                                labelText: 'Search *',
                                labelStyle: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.w500),
                              ),
                              validator: (String value) {
                                return value.contains('@')
                                    ? 'Do not use the @ char.'
                                    : null;
                              },
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 5, top: 15),
                            child: CircleAvatar(
                              backgroundColor: Colors.green,
                              radius: 18,
                              child: IconButton(
                                icon: Icon(
                                  Icons.search,
                                  size: 22,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  /*This will get all todos
                                  that contains similar string
                                  in the textform
                                  */
                                  todoBloc.getTodos(
                                      query:
                                      _todoSearchDescriptionFormController
                                          .value.text);
                                  //dismisses the bottomsheet
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  Widget getTodosWidget() {
    /*The StreamBuilder widget,
    basically this widget will take stream of data (todos)
    and construct the UI (with state) based on the stream
    */
    return StreamBuilder(
      stream: todoBloc.todos,
      builder: (BuildContext context, AsyncSnapshot<List<Lista>> snapshot) {
        return getTodoCardWidget(snapshot);
      },
    );
  }

  Widget getTodoCardWidget(AsyncSnapshot<List<Lista>> snapshot) {
    /*Since most of our operations are asynchronous
    at initial state of the operation there will be no stream
    so we need to handle it if this was the case
    by showing users a processing/loading indicator*/
    if (snapshot.hasData) {
      /*Also handles whenever there's stream
      but returned returned 0 records of Lista from DB.
      If that the case show user that you have empty Todos
      */
      return snapshot.data.length != 0
          ? ListView.builder(
        itemCount: snapshot.data.length,
        itemBuilder: (context, itemPosition) {
          Lista todo = snapshot.data[itemPosition];
          final Widget dismissibleCard = new Dismissible(
            background: Container(
              child: Padding(
                padding: EdgeInsets.only(left: 10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Deleting",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              color: Colors.greenAccent,
            ),
            onDismissed: (direction) {
              /*The magic
                    delete Lista item by ID whenever
                    the card is dismissed
                    */
              todoBloc.deleteTodoById(todo.id);
            },
            direction: _dismissDirection,
            key: new ObjectKey(todo),
            child: Card(
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.grey[200], width: 0.5),
                  borderRadius: BorderRadius.circular(5),
                ),
                color: Colors.grey,
                child: ListTile(
                  leading: InkWell(
                    onTap: () {
                      //Reverse the value
                      todo.isDone = !todo.isDone;
                      /*
                            Another magic.
                            This will update Lista isDone with either
                            completed or not
                          */
                      todoBloc.updateTodo(todo);
                    },
                    child: Container(
                      //decoration: BoxDecoration(),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: todo.isDone
                            ? Icon(
                          Icons.done,
                          size: 26.0,
                          color: Colors.green,
                        )
                            : Icon(
                          Icons.check_box_outline_blank,
                          size: 26.0,
                          color: Colors.green,
                        ),
                      ),
                    ),
                  ),
                  title: Text(
                    todo.description,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontFamily: 'RobotoMono',
                        fontWeight: FontWeight.w500,
                        decoration: todo.isDone
                            ? TextDecoration.lineThrough
                            : TextDecoration.none),
                  ),
                )),
          );
          return dismissibleCard;
        },
      )
          : Container(
          child: Center(
            //this is used whenever there 0 Lista
            //in the data base
            child: noTodoMessageWidget(),
          ));
    } else {
      return Center(
        /*since most of our I/O operations are done
        outside the main thread asynchronously
        we may want to display a loading indicator
        to let the use know the app is currently
        processing*/
        child: loadingData(),
      );
    }
  }

  Widget loadingData() {
    //pull todos again
    todoBloc.getTodos();
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(),
            Text("Loading...",
                style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w500,
                    color: Colors.white))
          ],
        ),
      ),
    );
  }

  Widget noTodoMessageWidget() {
    return Container(
      child: Text(
        "No coincidence...",
        style: TextStyle(
            fontSize: 19, fontWeight: FontWeight.w500, color: Colors.white),
      ),
    );
  }

  dispose() {
    /*close the stream in order
    to avoid memory leaks
    */
    todoBloc.dispose();
  }
}