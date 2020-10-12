package com.nbyjy.android.nbyjymodule;

import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.os.Bundle;
import android.text.TextUtils;
import android.util.Log;

import com.nbyjy.android.nbyjymodule.message.BaseReq;
import com.nbyjy.android.nbyjymodule.message.MessageAct;
import com.nbyjy.android.nbyjymodule.message.SendAuth;
import com.nbyjy.android.nbyjymodule.plugin.SignatureCheck;

public class NBYJYApi implements INBYJYApi {
    private static final String TAG = "NBYJYApi";

    //钉单应用签名
    private static final String APP_SIGNATURE = "3f045be741894c975a172866d2d51a8b";

    private Context mContext;
    private String mAppId;
    private boolean mNeedSignatureCheck;

    public NBYJYApi(Context context, String appId, boolean needSignatureCheck) {
        this.mContext = context;
        this.mAppId = appId;
        this.mNeedSignatureCheck = needSignatureCheck;
    }

    @Override
    public boolean isAppInstalled() {
        return this.isAppInstalled(this.mContext);
    }

    @Override
    public boolean sendReq(BaseReq var1) {
        return this.sendReq(this.mContext, var1);
    }

    protected boolean checkSumConsistent(Context context, String packageName) {
        if (!this.mNeedSignatureCheck) {
            Log.d("[NBYJYApi]", "ignore dd app signature validation");
            return true;
        } else {
            String md5Signature = SignatureCheck.getMD5Signature(context, packageName);
            return TextUtils.equals(md5Signature, APP_SIGNATURE);
        }
    }

    public boolean isAppInstalled(Context context) {
        try {
            return context.getPackageManager().getPackageInfo("net.nbyjy.b2b", PackageManager.GET_SIGNATURES) != null && this.checkSumConsistent(context, "net.nbyjy.b2b");
        } catch (PackageManager.NameNotFoundException var3) {
            return false;
        } catch (NullPointerException var4) {
            return false;
        }
    }

    private boolean sendReq(Context context, BaseReq baseReq) {
        if (!this.isAppInstalled(context)) {
            Log.e("[NBYJYApi]", "App not installed");
            return false;
        } else if (!this.checkSumConsistent(context, "net.nbyjy.b2b")) {
            Log.e("[NBYJYApi]", "sendReq failed for dd app signature check failed");
            return false;
        } else if (!baseReq.checkArgs()) {
            Log.e("[NBYJYApi]", "sendReq checkArgs fail");
            return false;
        } else {
            Bundle bundle = new Bundle();
            baseReq.toBundle(bundle);
            return baseReq.getType() == 100 ? MessageAct.sendAuth(context, this.mAppId, bundle) : false;
        }
    }

    public boolean handleIntent(Intent intent, INBYJYAPIEventHandler handler) {
        String packageName;
        if ((packageName = intent.getStringExtra("android.intent.nbyjy.EXTRA_MESSAGE_APP_PACKAGE_NAME")) != null && packageName.length() != 0 && handler != null) {
            switch (intent.getIntExtra("android.intent.nbyjy.EXTRA_COMMAND_TYPE", 0)) {
                case 100:
                    SendAuth.Resp sendAuthResp = new SendAuth.Resp();
                    sendAuthResp.fromBundle(intent.getExtras());
                    handler.onResp(sendAuthResp);
                    return true;
                default:
                    return false;
            }
        } else {
            Log.e("TAG", "invalid argument");
            return false;
        }
    }
}
