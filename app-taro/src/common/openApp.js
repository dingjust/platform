var download_schema = "nbyjy://callphone/startapp"; //app的协议有安卓同事提供
var universal_link =
  "https://itunes.apple.com/cn/app/%E9%92%89%E5%8D%95/id1459206673?mt=8"; //ios下载地址
var getVersionUrl =
  "https://android.myapp.com/myapp/detail.htm?apkName=net.nbyjy.b2b&ADTAG=mobile"; //Android移动端下载地址
var u = navigator.userAgent.toLocaleLowerCase();
//console.log(u);
var isWeixin = u.match(/MicroMessenger/i) == "micromessenger"; //判断是不是微信浏览器
var isAndroid = u.indexOf("android") > -1 || u.indexOf("linux") > -1; //android终端或者uc浏览器
var isiOS = !!u.match(/(iphone|ipod|ipad|mac)/i);

function openApp() {
  if (isAndroid) {
    android1();
  }
  if (isiOS) {
    ios();
  }
}

function android1() {
  console.log("Open2");
  //如果是微信,直接下载
  if (isWeixin) {
    window.location.href =
      "https://android.myapp.com/myapp/detail.htm?apkName=net.nbyjy.b2b&ADTAG=mobile"; /***Android移动端下载地址***/
  } else {
    window.location = download_schema; /***打开app的协议，有安卓同事提供***/
    var clickedAt = +new Date();
    setTimeout(function() {
      !window.document.webkitHidden &&
        setTimeout(function() {
          if (+new Date() - clickedAt < 2000) {
            window.location.href = getVersionUrl;
          }
        }, 500);
    }, 500);
  }
}

function ios() {
  window.location.href =
    universal_link + "?schema=" + encodeURIComponent(download_schema);
}

export default openApp;
