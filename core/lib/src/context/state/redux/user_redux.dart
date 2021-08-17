import 'package:core/src/context/model/user.dart';
import 'package:redux/redux.dart';

/**
 * 用户相关Redux
 * Created by zhanhongbo
 * Date: 2018-11-13
 */

/// redux 的 combineReducers, 通过 TypedReducer 将 UpdateUserAction 与 reducers 关联起来
final userReducer = combineReducers<User?>([
  TypedReducer<User?, UpdateUserAction>(_updateLoaded) as User? Function(
      User?, dynamic),
]);

/// 如果有 UpdateUserAction 发起一个请求时
/// 就会调用到 _updateLoaded
/// _updateLoaded 这里接受一个新的user，并返回
User? _updateLoaded(User? user, action) {
  user = action.user;
  return user;
}

/// 定一个 UpdateUserAction ，用于发起 userInfo 的的改变
/// 类名随你喜欢定义，只要通过上面TypedReducer绑定就好
class UpdateUserAction {
  final User user;

  UpdateUserAction(this.user);
}
