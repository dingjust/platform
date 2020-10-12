typedef BaseChannelMessage _BaseChannelMessageInvoker(Map argument);

///Response callback mapping
Map<String, _BaseChannelMessageInvoker> _nameAndMessageMapper = {
  "RouteMessage": (Map argument) => RouteMessage.fromMap(argument),
};

///通道消息基类
class BaseChannelMessage {
  factory BaseChannelMessage.create(String name, Map argument) =>
      _nameAndMessageMapper[name](argument);

  BaseChannelMessage._();
}

///路由消息
class RouteMessage extends BaseChannelMessage {
  ///路由路径
  final String route;

  ///参数
  final Map params;

  RouteMessage.fromMap(Map map)
      : route = map["route"],
        params = map["params"],
        super._();
}
