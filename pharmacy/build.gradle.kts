import org.jetbrains.kotlin.gradle.tasks.KotlinCompile
import java.net.URI

plugins {
    id("org.springframework.boot") version "3.2.3"
    id("io.spring.dependency-management") version "1.1.4"
    kotlin("jvm") version "1.9.22"
    kotlin("plugin.spring") version "1.9.22"
    id("maven-publish")
}

group = "ch.govtech"
version = "0.0.1-SNAPSHOT"

java {
    sourceCompatibility = JavaVersion.VERSION_17
}

configurations {
    compileOnly {
        extendsFrom(configurations.annotationProcessor.get())
    }
}

repositories {
    mavenCentral()
}

extra["springCloudAzureVersion"] = "5.10.0"

dependencies {
    dependencies {
        implementation("org.springframework.boot:spring-boot-starter-data-jpa")
        implementation("org.springframework.boot:spring-boot-starter-web")
        implementation("com.h2database:h2")
        implementation("com.fasterxml.jackson.datatype:jackson-datatype-jsr310:2.13.0")
        implementation("org.springframework.boot:spring-boot-starter-actuator")
        implementation("com.azure.spring:spring-cloud-azure-starter")
        implementation("com.fasterxml.jackson.module:jackson-module-kotlin:2.13.0")
        implementation("com.azure.spring:spring-cloud-azure-starter-actuator")
        implementation("org.jetbrains.kotlin:kotlin-reflect")
        implementation("org.springframework.boot:spring-boot-starter-web")
        compileOnly("org.projectlombok:lombok")
        developmentOnly("org.springframework.boot:spring-boot-devtools")
        annotationProcessor("org.projectlombok:lombok")
        implementation("org.springframework.boot:spring-boot-starter-thymeleaf")
        testImplementation("org.springframework.boot:spring-boot-starter-test")
       implementation("com.google.zxing:javase:3.5.3")
       implementation("com.google.zxing:core:3.5.3")
    }
}
dependencyManagement {
    imports {
        mavenBom("com.azure.spring:spring-cloud-azure-dependencies:${property("springCloudAzureVersion")}")
    }
}

tasks.withType<KotlinCompile> {
    kotlinOptions {
        freeCompilerArgs += "-Xjsr305=strict"
        jvmTarget = "17"
    }
}

tasks.withType<Test> {
    useJUnitPlatform()
}

publishing {
    publications {
        create<MavenPublication>("maven-java") {
            from(components["java"])
            artifact(tasks.bootJar)
        }
        repositories {
            maven {
                name = "GitHubPackages"
                url = URI("https://maven.pkg.github.com/needToRoll/govTechHack24-issuermock")
                credentials {
                    username = System.getenv("USERNAME")
                    password = System.getenv("TOKEN")
                }
            }
        }
    }
}
