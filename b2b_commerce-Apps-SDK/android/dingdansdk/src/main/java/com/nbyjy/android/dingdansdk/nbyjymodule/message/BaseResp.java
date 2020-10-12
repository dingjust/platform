package com.nbyjy.android.nbyjymodule.message;

import android.os.Bundle;

public abstract class BaseResp {
    public int mErrCode;
    public String mErrStr;
    public String mTransaction;

    public BaseResp() {
    }

    public abstract int getType();

    public void toBundle(Bundle bundle) {
        if (bundle != null) {
            bundle.putInt("android.intent.nbyjy.EXTRA_COMMAND_TYPE", this.getType());
            bundle.putInt("android.intent.nbyjy.EXTRA_BASEREQ_ERROR_CODE", this.mErrCode);
            bundle.putString("android.intent.nbyjy.EXTRA_BASEREQ_ERROR_STRING", this.mErrStr);
            bundle.putString("android.intent.nbyjy.EXTRA_BASEREQ_TRANSACTION", this.mTransaction);
        }

    }

    public void fromBundle(Bundle bundle) {
        if (bundle != null) {
            this.mErrCode = bundle.getInt("android.intent.nbyjy.EXTRA_BASEREQ_ERROR_CODE");
            this.mErrStr = bundle.getString("android.intent.nbyjy.EXTRA_BASEREQ_ERROR_STRING");
            this.mTransaction = bundle.getString("android.intent.nbyjy.EXTRA_BASEREQ_TRANSACTION");
        }

    }

    abstract boolean checkArgs();

    public interface ErrCode {
        int ERR_OK = 0;
        int ERR_COMM = -1;
        int ERR_USER_CANCEL = -2;
        int ERR_SENT_FAILED = -3;
        int ERR_AUTH_DENIED = -4;
        int ERR_UNSUPPORT = -5;
    }
}
