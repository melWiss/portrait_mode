//
//  Generated file. Do not edit.
//

#import "GeneratedPluginRegistrant.h"

#if __has_include(<image_cropper/ImageCropperPlugin.h>)
#import <image_cropper/ImageCropperPlugin.h>
#else
@import image_cropper;
#endif

#if __has_include(<image_jpeg/ImageJpegPlugin.h>)
#import <image_jpeg/ImageJpegPlugin.h>
#else
@import image_jpeg;
#endif

#if __has_include(<image_picker_saver/ImagePickerSaverPlugin.h>)
#import <image_picker_saver/ImagePickerSaverPlugin.h>
#else
@import image_picker_saver;
#endif

#if __has_include(<tflite/TflitePlugin.h>)
#import <tflite/TflitePlugin.h>
#else
@import tflite;
#endif

@implementation GeneratedPluginRegistrant

+ (void)registerWithRegistry:(NSObject<FlutterPluginRegistry>*)registry {
  [FLTImageCropperPlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTImageCropperPlugin"]];
  [ImageJpegPlugin registerWithRegistrar:[registry registrarForPlugin:@"ImageJpegPlugin"]];
  [FLTImagePickerSaverPlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTImagePickerSaverPlugin"]];
  [TflitePlugin registerWithRegistrar:[registry registrarForPlugin:@"TflitePlugin"]];
}

@end
