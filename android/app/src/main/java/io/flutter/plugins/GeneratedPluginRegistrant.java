package io.flutter.plugins;

import io.flutter.plugin.common.PluginRegistry;
import vn.hunghd.flutter.plugins.imagecropper.ImageCropperPlugin;
import com.yangyxd.imagejpeg.ImageJpegPlugin;
import io.flutter.plugins.imagepickersaver.ImagePickerSaverPlugin;
import sq.flutter.tflite.TflitePlugin;

/**
 * Generated file. Do not edit.
 */
public final class GeneratedPluginRegistrant {
  public static void registerWith(PluginRegistry registry) {
    if (alreadyRegisteredWith(registry)) {
      return;
    }
    ImageCropperPlugin.registerWith(registry.registrarFor("vn.hunghd.flutter.plugins.imagecropper.ImageCropperPlugin"));
    ImageJpegPlugin.registerWith(registry.registrarFor("com.yangyxd.imagejpeg.ImageJpegPlugin"));
    ImagePickerSaverPlugin.registerWith(registry.registrarFor("io.flutter.plugins.imagepickersaver.ImagePickerSaverPlugin"));
    TflitePlugin.registerWith(registry.registrarFor("sq.flutter.tflite.TflitePlugin"));
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
