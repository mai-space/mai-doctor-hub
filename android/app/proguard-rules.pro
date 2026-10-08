# ML Kit Texterkennung: optionale Schrift-Modelle (chinesisch, devanagari,
# japanisch, koreanisch) sind nur compileOnly eingebunden — wir nutzen nur
# lateinische Schrift.
-dontwarn com.google.mlkit.vision.text.chinese.**
-dontwarn com.google.mlkit.vision.text.devanagari.**
-dontwarn com.google.mlkit.vision.text.japanese.**
-dontwarn com.google.mlkit.vision.text.korean.**

# ML Kit Dokumentenscanner: ohne diese Regeln entfernt/vereinfacht R8 interne
# Klassen, die per Reflection bzw. als Komponenten geladen werden — der Scanner
# startet dann mit NullPointerException im Konstruktor (Release-Build).
-keep class com.google.mlkit.vision.documentscanner.** { *; }
-keep class com.google.android.gms.internal.mlkit_vision_document_scanner.** { *; }
-keep class com.google.mlkit.common.** { *; }
-keep class com.google.android.gms.internal.mlkit_common.** { *; }
-keep class * implements com.google.firebase.components.ComponentRegistrar { *; }
-keepattributes Signature,InnerClasses,EnclosingMethod,*Annotation*
