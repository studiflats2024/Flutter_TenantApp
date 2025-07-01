# Keep all classes and members (for debugging only)
-keep class * { *; }

# Avoid warnings
-dontwarn **
# flutter_inappwebview required rules
-keep class com.pichillilorenzo.** { *; }
-keepclassmembers class com.pichillilorenzo.** { *; }
-dontwarn com.pichillilorenzo.**