package com.nbyjy.android.nbyjymodule;

import android.content.Context;

public class NBYJYApiFactory {
    public NBYJYApiFactory() {

    }

    public static INBYJYApi createNBYJYApi(Context context, String appId, boolean needSignatureCheck) {
        return new NBYJYApi(context, appId, needSignatureCheck);
    }
}
