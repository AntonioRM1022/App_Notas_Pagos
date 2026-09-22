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
subprojects {
    afterEvaluate {
        val androidExtension = extensions.findByName("android")
        if (androidExtension != null) {
            try {
                androidExtension.javaClass.getMethod("setCompileSdkVersion", Int::class.javaPrimitiveType).invoke(androidExtension, 36)
            } catch (ignored: Exception) {}
            
            try {
                val namespaceProperty = androidExtension.javaClass.getMethod("getNamespace").invoke(androidExtension)
                if (namespaceProperty == null) {
                    androidExtension.javaClass.getMethod("setNamespace", String::class.java).invoke(androidExtension, project.group.toString())
                }
            } catch (ignored: Exception) {}
        }
    }
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
