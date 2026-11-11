# Add project specific ProGuard rules here.
# You can control the set of applied configuration files using the
# proguardFiles setting in build.gradle.
#
# For more details, see
#   http://developer.android.com/guide/developing/tools/proguard.html

# If your project uses WebView with JS, uncomment the following
# and specify the fully qualified class name to the JavaScript interface
# class:
#-keepclassmembers class fqcn.of.javascript.interface.for.webview {
#   public *;
#}

# Uncomment this to preserve the line number information for
# debugging stack traces.
#-keepattributes SourceFile,LineNumberTable

# If you keep the line number information, uncomment this to
# hide the original source file name.
#-renamesourcefileattribute SourceFile
-ignorewarnings
#
#-keep class cloudpos.device.printer {
#    public <methods>;
#    protected <methods>;
#    private <methods>;
#}
#
#-keep class com.cloudpos.* {
#    public <methods>;
#    protected <methods>;
#    private <methods>;
#}

#Flutter Wrapper
 -keep class io.flutter.app.** { *; }
 -keep class io.flutter.plugin.**  { *; }
 -keep class io.flutter.util.**  { *; }
 -keep class io.flutter.view.**  { *; }
 -keep class io.flutter.**  { *; }
 -keep class io.flutter.plugins.**  { *; }

-keep class * {
    public private *;
}

-keep class com.cloudpos.** { *; }

#-keep class com.cloudpos.** { *; }
#-keep class com.didi.protocol.** { *; }
#-keep class com.qs.helper.printer.PrinterClass.** { *; }
#-keep class cloudpos.device.printer.** { *; }
#-keep class com.** { *; }
#-keep public class com.jetbrains.** { *; }
#-keep public class com.sun.** { *; }

#-keep class com.cloudpos.** {
#    public <methods>;
#    protected <methods>;
#    private <methods>;
#}

#-keepclassmembers, allowobfuscation class * {
#
#}

#-keep class com.webcorporation.webvfdapp.** { *; }

