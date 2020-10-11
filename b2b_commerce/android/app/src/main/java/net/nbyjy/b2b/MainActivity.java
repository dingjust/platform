package net.nbyjy.b2b;

import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.umeng.analytics.MobclickAgent;

import net.nbyjy.b2b.handlers.GlobalChannelMethodCallHandler;

import java.util.HashMap;
import java.util.Map;

import io.flutter.Log;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {

    private static final String CHANNEL = "net.nbyjy.b2b/global_channel";
    //授权申请类型100
    private static final int AUTH_EXTRA_COMMAND_TYPE = 100;

    private MethodChannel channel;
    private GlobalChannelMethodCallHandler globalChannelMethodCallHandler;

    String route = "/";

    @Override
    protected void onResume() {
        super.onResume();
        MobclickAgent.onResume(this);
    }

    @Override
    protected void onPause() {
        super.onPause();
        MobclickAgent.onPause(this);
    }

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Log.d("[nbyjy]", "******OnCreate******");
        globalChannelMethodCallHandler = new GlobalChannelMethodCallHandler(MainActivity.this);
        channel = new MethodChannel(getFlutterEngine().getDartExecutor().getBinaryMessenger(), CHANNEL);
        channel.setMethodCallHandler(globalChannelMethodCallHandler);

        //获取传递的数据
        Intent intent = getIntent();
        if (hasAuthRequest(intent)) {
            //缓存intent
            globalChannelMethodCallHandler.setCacheIntent(intent);
            route = "/auth_request_page";
        }
    }

    @Override
    protected void onNewIntent(@NonNull Intent intent) {
        super.onNewIntent(intent);
        //缓存intent
        if (hasAuthRequest(intent)) {
            globalChannelMethodCallHandler.setCacheIntent(intent);
            Map<String, Object> message = new HashMap<>();
            message.put("route", "/auth_request_page");
            channel.invokeMethod("RouteMessage", message);
        }
    }

    @NonNull
    @Override
    public String getInitialRoute() {
//        return super.getInitialRoute();
        return route;
    }

    ///判断是否授权请求Intent
    protected boolean hasAuthRequest(@NonNull Intent intent) {
        Uri uri = intent.getData();
        if (uri != null) {
            Bundle bundle = intent.getExtras();
            int type = bundle.getInt("android.intent.nbyjy.EXTRA_COMMAND_TYPE");
            if (type == AUTH_EXTRA_COMMAND_TYPE) {
                return true;
            }
        }
        return false;
    }
}


