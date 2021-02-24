import 'package:sql_lite/Dao/dao.dart';
import 'package:sql_lite/Lista/lista.dart';

class TodoRepository {
  final todoDao = Dao();

  Future getAllTodos({String query}) => todoDao.getTodos(query: query);

  Future insertTodo(Lista todo) => todoDao.createTodo(todo);

  Future updateTodo(Lista todo) => todoDao.updateTodo(todo);

  Future deleteTodoById(int id) => todoDao.deleteTodo(id);

  Future deleteAllTodos() => todoDao.deleteAllTodos();
}