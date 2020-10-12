package com.nbyjy.android.nbyjymodule.message;

import android.content.ActivityNotFoundException;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.util.Log;

import com.nbyjy.android.nbyjymodule.plugin.SignatureCheck;


public class MessageAct {
    private static final String TAG = "MessageAct";

    public MessageAct() {
    }


    private static boolean send(Context context, String appId, Bundle bundle, Intent intent) {
        if (bundle != null) {
            intent.putExtras(bundle);
        }

        String packageName = context.getPackageName();
        String md5String = SignatureCheck.getMD5Signature(context, packageName);
        intent.putExtra("android.intent.nbyjy.EXTRA_MESSAGE_SDK_VERSION", 20201009);
        intent.putExtra("android.intent.nbyjy.EXTRA_MESSAGE_APP_PACKAGE_NAME", packageName);
        intent.putExtra("android.intent.nbyjy.EXTRA_ACTION_TYPE", "sendAuth");
        intent.putExtra("android.intent.nbyjy.EXTRA_MESSAGE_APP_SIGNATURE", md5String);
        intent.putExtra("android.intent.nbyjy.EXTRA_MESSAGE_APP_ID", appId);
        intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);

        try {
            context.startActivity(intent);
        } catch (ActivityNotFoundException var7) {
            Log.e("MessageAct", "send v2 fail, target ActivityNotFound");
            return false;
        } catch (Exception var8) {
            Log.e("MessageAct", "send v2 fail " + var8.getMessage());
            return false;
        }

        Log.d("MessageAct", "send dd message, intent=" + intent);
        return true;
    }

    private static Intent initSendByAuthIntent() {
        return initIntentByScheme("dingdan://net.nbyjy.b2b/sign?type=1&user_package_name=net.nbyjy.b2b");
    }


    private static Intent initIntentByScheme(String scheme) {
        return new Intent("android.intent.action.VIEW", Uri.parse(scheme));
    }

    public static boolean sendAuth(Context context, String appId, Bundle bundle) {
        if (context != null) {
            Intent intent = initSendByAuthIntent();
            return send(context, appId, bundle, intent);
        } else {
            Log.e("MessageAct", "send fail, invalid arguments");
            return false;
        }
    }
}
