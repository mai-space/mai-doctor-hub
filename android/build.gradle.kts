allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

// Legacy-Plugins (flutter_local_notifications 8.x, pdf_text 0.5) setzen kein
// `namespace` — AGP 8+ verlangt es. Group aus dem Plugin-build.gradle übernehmen.
// Linse: Reproduzierbarkeit — Fix im Repo, nicht im Runner-Pub-Cache.
subprojects {
    pluginManager.withPlugin("com.android.library") {
        val android = extensions.getByName("android")
        val getNamespace =
            android.javaClass.methods.firstOrNull {
                it.name == "getNamespace" && it.parameterCount == 0
            }
        val current = getNamespace?.invoke(android) as? String
        if (current.isNullOrEmpty()) {
            val groupStr = group.toString()
            val namespace =
                if (groupStr.isNotBlank() && groupStr != "unspecified") {
                    groupStr
                } else {
                    "com.placeholder.${name.replace('-', '_')}"
                }
            android.javaClass
                .getMethod("setNamespace", String::class.java)
                .invoke(android, namespace)
        }
    }
}

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
