package com.nbyjy.android.nbyjymodule.message;

import android.os.Bundle;
import android.util.Log;

public class SendAuth {
    public SendAuth() {
    }

    public static class Req extends BaseReq {
        public static final String SNS_LOGIN = "sns_login";
        private static final String TAG = "SendDDAuth.Req";
        private static final int LENGTH_LIMIT = 1024;
        private static final int MIN_SUPPORT_VERSION = 20201009;
        public String scope;
        public String state;

        public Req() {
        }

        public void toBundle(Bundle bundle) {
            super.toBundle(bundle);
            if (bundle != null) {
                bundle.putString("android.intent.nbyjy.EXTRA_SEND_AUTH_SCOPE", this.scope);
                bundle.putString("android.intent.nbyjy.EXTRA_SEND_AUTH_STATE", this.state);
            }

        }

        public void fromBundle(Bundle bundle) {
            super.fromBundle(bundle);
            if (bundle != null) {
                this.scope = bundle.getString("android.intent.nbyjy.EXTRA_SEND_AUTH_SCOPE", (String) null);
                this.state = bundle.getString("android.intent.nbyjy.EXTRA_SEND_AUTH_STATE", (String) null);
            }

        }

        public int getType() {
            return 100;
        }

        public boolean checkArgs() {
            if (this.scope != null && this.scope.length() != 0 && this.scope.length() <= 1024) {
                if (this.state != null && this.state.length() > 1024) {
                    Log.e("SendDDAuth.Req", "checkArgs fail, state is invalid");
                    return false;
                } else {
                    return true;
                }
            } else {
                Log.e("SendDDAuth.Req", "checkArgs fail, scope is invalid");
                return false;
            }
        }

        public int getSupportVersion() {
            return 20160101;
        }
    }

    public static class Resp extends BaseResp {
        private static final String TAG = "SendDDAuth.Resp";
        public String code;
        public String state;

        public Resp() {
        }

        public int getType() {
            return 100;
        }

        public void toBundle(Bundle bundle) {
            super.toBundle(bundle);
            if (bundle != null) {
                bundle.putString("android.intent.nbyjy.EXTRA_SEND_AUTH_CODE", this.code);
                bundle.putString("android.intent.nbyjy.EXTRA_SEND_AUTH_STATE", this.state);
            }

        }

        public void fromBundle(Bundle bundle) {
            super.fromBundle(bundle);
            if (bundle != null) {
                this.code = bundle.getString("android.intent.nbyjy.EXTRA_SEND_AUTH_CODE", (String) null);
                this.state = bundle.getString("android.intent.nbyjy.EXTRA_SEND_AUTH_STATE", (String) null);
            }

        }

        boolean checkArgs() {
            return true;
        }
    }
}