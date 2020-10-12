package com.nbyjy.android.nbyjymodule;

import android.content.Intent;

import com.nbyjy.android.nbyjymodule.message.BaseReq;


public interface INBYJYApi {

    boolean isAppInstalled();

    boolean handleIntent(Intent var1, INBYJYAPIEventHandler var2);

    boolean sendReq(BaseReq var1);
}
