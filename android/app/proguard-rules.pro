# ML Kit Texterkennung: optionale Schrift-Modelle (chinesisch, devanagari,
# japanisch, koreanisch) sind nur compileOnly eingebunden — wir nutzen nur
# lateinische Schrift.
-dontwarn com.google.mlkit.vision.text.chinese.**
-dontwarn com.google.mlkit.vision.text.devanagari.**
-dontwarn com.google.mlkit.vision.text.japanese.**
-dontwarn com.google.mlkit.vision.text.korean.**
