package io.flutter.plugins;

import io.flutter.plugin.common.PluginRegistry;
import com.roughike.facebooklogin.facebooklogin.FacebookLoginPlugin;
import io.flutter.plugins.googlesignin.GoogleSignInPlugin;
import com.dfa.introslider.IntroSliderPlugin;
import io.flutter.plugins.pathprovider.PathProviderPlugin;
import fr.skyost.rate_my_app.RateMyAppPlugin;
import com.razorpay.razorpay_flutter.RazorpayFlutterPlugin;
import io.flutter.plugins.share.SharePlugin;
import io.flutter.plugins.sharedpreferences.SharedPreferencesPlugin;
import com.aboutyou.dart_packages.sign_in_with_apple.SignInWithApplePlugin;
import com.tekartik.sqflite.SqflitePlugin;
import io.flutter.plugins.webviewflutter.WebViewFlutterPlugin;

/**
 * Generated file. Do not edit.
 */
public final class GeneratedPluginRegistrant {
  public static void registerWith(PluginRegistry registry) {
    if (alreadyRegisteredWith(registry)) {
      return;
    }
    FacebookLoginPlugin.registerWith(registry.registrarFor("com.roughike.facebooklogin.facebooklogin.FacebookLoginPlugin"));
    GoogleSignInPlugin.registerWith(registry.registrarFor("io.flutter.plugins.googlesignin.GoogleSignInPlugin"));
    IntroSliderPlugin.registerWith(registry.registrarFor("com.dfa.introslider.IntroSliderPlugin"));
    PathProviderPlugin.registerWith(registry.registrarFor("io.flutter.plugins.pathprovider.PathProviderPlugin"));
    RateMyAppPlugin.registerWith(registry.registrarFor("fr.skyost.rate_my_app.RateMyAppPlugin"));
    RazorpayFlutterPlugin.registerWith(registry.registrarFor("com.razorpay.razorpay_flutter.RazorpayFlutterPlugin"));
    SharePlugin.registerWith(registry.registrarFor("io.flutter.plugins.share.SharePlugin"));
    SharedPreferencesPlugin.registerWith(registry.registrarFor("io.flutter.plugins.sharedpreferences.SharedPreferencesPlugin"));
    SignInWithApplePlugin.registerWith(registry.registrarFor("com.aboutyou.dart_packages.sign_in_with_apple.SignInWithApplePlugin"));
    SqflitePlugin.registerWith(registry.registrarFor("com.tekartik.sqflite.SqflitePlugin"));
    WebViewFlutterPlugin.registerWith(registry.registrarFor("io.flutter.plugins.webviewflutter.WebViewFlutterPlugin"));
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
