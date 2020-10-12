package com.nbyjy.android.nbyjymodule;

import com.nbyjy.android.nbyjymodule.message.BaseReq;
import com.nbyjy.android.nbyjymodule.message.BaseResp;

public interface INBYJYAPIEventHandler {
    void onReq(BaseReq var1);

    void onResp(BaseResp var1);
}
