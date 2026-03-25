plugins {
    kotlin("jvm") version "1.9.22"
    kotlin("plugin.serialization") version "1.9.22"
    application
    id("io.github.goooler.shadow") version "8.1.8"
}

group = "org.example"
version = "1.0-SNAPSHOT"

repositories {
    mavenCentral()
}

dependencies {
    implementation("org.apache.poi:poi-ooxml:5.2.3")
    implementation("com.itextpdf:itextpdf:5.5.13.3")
    implementation("org.jetbrains.kotlinx:kotlinx-serialization-json:1.6.0")
    implementation("org.apache.logging.log4j:log4j-core:2.22.1")
}

application {
    mainClass.set("MainKt")
}
