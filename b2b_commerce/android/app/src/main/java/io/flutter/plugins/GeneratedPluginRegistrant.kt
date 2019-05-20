package io.flutter.plugins

import io.flutter.plugin.common.PluginRegistry
import io.flutter.plugins.connectivity.ConnectivityPlugin
import com.jarvan.fluwx.FluwxPlugin
import io.flutter.plugins.imagepicker.ImagePickerPlugin
import com.crazecoder.openfile.OpenFilePlugin
import io.flutter.plugins.pathprovider.PathProviderPlugin
import com.baseflow.permissionhandler.PermissionHandlerPlugin
import io.flutter.plugins.sharedpreferences.SharedPreferencesPlugin
import io.flutter.plugins.urllauncher.UrlLauncherPlugin

/**
 * Generated file. Do not edit.
 */
object GeneratedPluginRegistrant {
    fun registerWith(registry: PluginRegistry) {
        if (alreadyRegisteredWith(registry)) {
            return
        }
        ConnectivityPlugin.registerWith(registry.registrarFor("io.flutter.plugins.connectivity.ConnectivityPlugin"))
        FluwxPlugin.registerWith(registry.registrarFor("com.jarvan.fluwx.FluwxPlugin"))
        ImagePickerPlugin.registerWith(registry.registrarFor("io.flutter.plugins.imagepicker.ImagePickerPlugin"))
        OpenFilePlugin.registerWith(registry.registrarFor("com.crazecoder.openfile.OpenFilePlugin"))
        PathProviderPlugin.registerWith(registry.registrarFor("io.flutter.plugins.pathprovider.PathProviderPlugin"))
        PermissionHandlerPlugin.registerWith(registry.registrarFor("com.baseflow.permissionhandler.PermissionHandlerPlugin"))
        SharedPreferencesPlugin.registerWith(registry.registrarFor("io.flutter.plugins.sharedpreferences.SharedPreferencesPlugin"))
        UrlLauncherPlugin.registerWith(registry.registrarFor("io.flutter.plugins.urllauncher.UrlLauncherPlugin"))
    }

    private fun alreadyRegisteredWith(registry: PluginRegistry): Boolean {
        val key = GeneratedPluginRegistrant::class.java!!.getCanonicalName()
        if (registry.hasPlugin(key)) {
            return true
        }
        registry.registrarFor(key)
        return false
    }
}
