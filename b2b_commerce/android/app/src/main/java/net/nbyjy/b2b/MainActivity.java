package net.nbyjy.b2b;

import android.os.Bundle;

import com.umeng.analytics.MobclickAgent;
import com.umeng.commonsdk.statistics.common.DeviceConfig;

import io.flutter.app.FlutterActivity;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        GeneratedPluginRegistrant.registerWith(this);
    }


    ///获取设备信息
    public void getDeviceInfo() {
        String[] deviceInfo = new String[2];
        try {
//            if(context != null){
            deviceInfo[0] = DeviceConfig.getDeviceIdForGeneral(this);
            deviceInfo[1] = DeviceConfig.getMac(this);
            System.out.println("===========================");
            System.out.println(">>>>>>>>>" + deviceInfo[0]);
            System.out.println(">>>>>>>>>" + deviceInfo[1]);
//            }
        } catch (Exception e) {
        }
    }

    @Override
    protected void onResume() {
        super.onResume();
        MobclickAgent.onResume(this);
    }

    @Override
    protected void onPause() {
        super.onPause();
        MobclickAgent.onPause(this);
    }
}
