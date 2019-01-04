import 'package:rxdart/rxdart.dart';

void main() {
  //将Stream包装成Observable
  // var obs = Observable(Stream.fromIterable([1,2,3,4]));

  //通过Future创建：fromFuture
  //var obs = Observable.fromFuture(Future.value("hi"));

  //通过Iterable创建：fromIterable
  var obs = Observable.fromIterable([1,2,3,4,5]);

  //interval方法能够让流“吐出数据”后间隔一段时间再吐下一个数据
  obs = obs.interval(Duration(seconds: 1));

  //map方法能够让我们迭代的处理每一个数据并返回一个新的数据
  //obs = obs.map((item) => ++item);

 // obs.listen(print);

  //expand方法能够让我们把每个item扩展成任意组的流
//  var obs1 = obs.expand((item) => [item,item.toDouble()]);

//  obs1.listen(print);

  //merge方法能够让我们合并多个流（输出结果：1,4,7,2,5,8,3,6,9）
  var obs2 = Observable.merge([
    Stream.fromIterable([1,2,3]),
    Stream.fromIterable([4,5,6]),
    Stream.fromIterable([7,8,9]),
  ]);

  //obs2.listen(print);

  //concat方法能够让我们按照顺序执行一组流，当一组流执行完毕后，再开始执行下一组（输出结果：1,2,3,4,5,6,7,8,9）
  var obs3 = Observable.concat([
    Stream.fromIterable([1,2,3]),
    Stream.fromIterable([4,5,6]),
    Stream.fromIterable([7,8,9]),
  ]);

  //obs3.listen(print);

  //every会检查每个item是否符合要求，然后它将会返回一个能够被转化为 Observable 的 AsObservableFuture< bool>
  //只有每个都符合要求才返回true，否则为false
  obs.every((x) => x > 0).asObservable().listen(print);

  //默认是单订阅流，asBroadcastStream()转化为多订阅流
  var obs4 = Observable(Stream.fromIterable([1,2,3,4,5])).asBroadcastStream();
}
