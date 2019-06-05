package io.flutter.plugins;

import io.flutter.plugin.common.PluginRegistry;
import com.yangyxd.alipayme.AlipayMePlugin;
import com.jzoom.amaplocation.AmapLocationPlugin;
import com.example.citypickers.CityPickersPlugin;
import io.flutter.plugins.connectivity.ConnectivityPlugin;
import com.jarvan.fluwx.FluwxPlugin;
import io.flutter.plugins.imagepicker.ImagePickerPlugin;
import com.crazecoder.openfile.OpenFilePlugin;
import io.flutter.plugins.packageinfo.PackageInfoPlugin;
import io.flutter.plugins.pathprovider.PathProviderPlugin;
import io.flutter.plugins.sharedpreferences.SharedPreferencesPlugin;
import com.ethras.simplepermissions.SimplePermissionsPlugin;
import com.tekartik.sqflite.SqflitePlugin;
import com.danieldallos.storeredirect.StoreRedirectPlugin;
import io.flutter.plugins.urllauncher.UrlLauncherPlugin;

/**
 * Generated file. Do not edit.
 */
public final class GeneratedPluginRegistrant {
  public static void registerWith(PluginRegistry registry) {
    if (alreadyRegisteredWith(registry)) {
      return;
    }
    AlipayMePlugin.registerWith(registry.registrarFor("com.yangyxd.alipayme.AlipayMePlugin"));
    AmapLocationPlugin.registerWith(registry.registrarFor("com.jzoom.amaplocation.AmapLocationPlugin"));
    CityPickersPlugin.registerWith(registry.registrarFor("com.example.citypickers.CityPickersPlugin"));
    ConnectivityPlugin.registerWith(registry.registrarFor("io.flutter.plugins.connectivity.ConnectivityPlugin"));
    FluwxPlugin.registerWith(registry.registrarFor("com.jarvan.fluwx.FluwxPlugin"));
    ImagePickerPlugin.registerWith(registry.registrarFor("io.flutter.plugins.imagepicker.ImagePickerPlugin"));
    OpenFilePlugin.registerWith(registry.registrarFor("com.crazecoder.openfile.OpenFilePlugin"));
    PackageInfoPlugin.registerWith(registry.registrarFor("io.flutter.plugins.packageinfo.PackageInfoPlugin"));
    PathProviderPlugin.registerWith(registry.registrarFor("io.flutter.plugins.pathprovider.PathProviderPlugin"));
    SharedPreferencesPlugin.registerWith(registry.registrarFor("io.flutter.plugins.sharedpreferences.SharedPreferencesPlugin"));
    SimplePermissionsPlugin.registerWith(registry.registrarFor("com.ethras.simplepermissions.SimplePermissionsPlugin"));
    SqflitePlugin.registerWith(registry.registrarFor("com.tekartik.sqflite.SqflitePlugin"));
    StoreRedirectPlugin.registerWith(registry.registrarFor("com.danieldallos.storeredirect.StoreRedirectPlugin"));
    UrlLauncherPlugin.registerWith(registry.registrarFor("io.flutter.plugins.urllauncher.UrlLauncherPlugin"));
  }

  private static boolean alreadyRegisteredWith(PluginRegistry registry) {
    final String key = GeneratedPluginRegistrant.class.getCanonicalName();
    if (registry.hasPlugin(key)) {
      return true;
    }
    registry.registrarFor(key);
    return false;
  }
}
