package com.nbyjy.android.nbyjymodule.message;

import android.os.Bundle;

public abstract class BaseReq {
    public String mTransaction;

    public BaseReq() {
    }

    public abstract int getType();

    public void toBundle(Bundle bundle) {
        if (bundle != null) {
            bundle.putInt("android.intent.nbyjy.EXTRA_COMMAND_TYPE", this.getType());
            bundle.putString("android.intent.nbyjy.EXTRA_BASEREQ_TRANSACTION", this.mTransaction);
        }

    }

    public void fromBundle(Bundle bundle) {
        if (bundle != null) {
            this.mTransaction = bundle.getString("android.intent.nbyjy.EXTRA_BASEREQ_TRANSACTION");
        }

    }

    public abstract boolean checkArgs();

    public abstract int getSupportVersion();
}
