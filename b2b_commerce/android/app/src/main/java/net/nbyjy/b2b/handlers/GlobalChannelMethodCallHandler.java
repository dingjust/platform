package net.nbyjy.b2b.handlers;

import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.util.Log;

import androidx.annotation.NonNull;

import java.util.HashMap;
import java.util.Map;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;

public class GlobalChannelMethodCallHandler implements MethodCallHandler {

    final Context context;

    private Intent cacheIntent;

    private final Map<String, Handler> handlerMap = new HashMap<String, Handler>() {{
        //获取缓存Intent Uri
        put("getCacheIntentUri", (args, methodResult) -> {
            handleGetCacheIntentUri(methodResult);
        });
        //同意授权,返回授权信息
        put("respAuth", (args, methodResult) -> {
            handleRespAuth(args, methodResult);
        });
    }};

    public GlobalChannelMethodCallHandler(Context context) {
        this.context = context;
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        Map<String, Object> args = (Map<String, Object>) call.arguments;
        Handler handler = handlerMap.get(call.method);
        if (handler != null) {
            try {
                handler.call(args, result);
            } catch (Exception e) {
                e.printStackTrace();
                result.error(e.getMessage(), null, null);
            }
        } else {
            result.notImplemented();
        }
    }

    ///获取缓存Intent
    private void handleGetCacheIntentUri(@NonNull MethodChannel.Result result) {
        Uri uri = cacheIntent.getData();
        if (uri != null) {
            result.success(uri.toString());
        } else {
            result.success(null);
        }
    }

    ///允许授权
    private void handleRespAuth(Map<String, Object> args, @NonNull MethodChannel.Result result) {
        String packageName = cacheIntent.getExtras().getString("android.intent.nbyjy.EXTRA_MESSAGE_APP_PACKAGE_NAME");
        if (packageName != null && !packageName.isEmpty()) {
            String className = packageName + ".NBYJYActivity";
            String code = (String) args.get("code");
            String state = (String) args.get("state");
            Intent respIntent = new Intent();
            respIntent.setClassName(packageName, className);
            respIntent.putExtra("android.intent.nbyjy.EXTRA_SEND_AUTH_CODE", code);
            respIntent.putExtra("android.intent.nbyjy.EXTRA_SEND_AUTH_STATE", state);
            respIntent.putExtra("android.intent.nbyjy.EXTRA_MESSAGE_APP_PACKAGE_NAME", context.getPackageName());
            respIntent.putExtra("android.intent.nbyjy.EXTRA_COMMAND_TYPE", 100);
            respIntent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
            context.startActivity(respIntent);
            result.success(true);
        } else {
            Log.e("[nbyjy]", "auth packageName null");
            result.error("-1", "packageName null", null);
        }
    }

    @FunctionalInterface
    interface Handler {
        void call(Map<String, Object> args, MethodChannel.Result methodResult) throws Exception;
    }

    public Context getContext() {
        return context;
    }

    public Intent getCacheIntent() {
        return cacheIntent;
    }

    public void setCacheIntent(Intent cacheIntent) {
        this.cacheIntent = cacheIntent;
    }
}
