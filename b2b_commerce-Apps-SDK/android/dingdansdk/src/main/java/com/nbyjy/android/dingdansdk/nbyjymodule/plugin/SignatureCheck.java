package com.nbyjy.android.nbyjymodule.plugin;

import android.content.Context;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.content.pm.Signature;

import com.nbyjy.android.nbyjymodule.algorithm.MD5;


public class SignatureCheck {
    public SignatureCheck() {
    }

    public static String getMD5Signature(Context context, String packageName) {
        Signature[] arrayOfSignature = getRawSignature(context, packageName);
        if (arrayOfSignature != null && arrayOfSignature.length != 0) {
            StringBuffer sb = new StringBuffer();

            for (int i = 0; i < arrayOfSignature.length; ++i) {
                String s = MD5.getMessageDigest(arrayOfSignature[i].toByteArray());
                sb.append(s);
            }

            return sb.toString();
        } else {
            return null;
        }
    }

    private static Signature[] getRawSignature(Context paramContext, String paramString) {
        if (paramString != null && paramString.length() != 0 && paramContext != null) {
            PackageManager localPackageManager = paramContext.getPackageManager();

            PackageInfo localPackageInfo;
            try {
                localPackageInfo = localPackageManager.getPackageInfo(paramString, PackageManager.GET_SIGNATURES);
                if (localPackageInfo == null) {
                    return null;
                }
            } catch (PackageManager.NameNotFoundException var5) {
                return null;
            }

            return localPackageInfo.signatures;
        } else {
            return null;
        }
    }
}
