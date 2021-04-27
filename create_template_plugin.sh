#!/bin/bash

PROJECT_NAME=$1

echo "project name :$PROJECT_NAME"

PROJECT_NAME_DIFF_SPACE=$(echo $PROJECT_NAME | sed 's/ //g')
PROJECT_NAME_UNDERLINE=$(echo $PROJECT_NAME | sed 's/ /_/g')
PROJECT_NAME_LOWER=$(echo $PROJECT_NAME_UNDERLINE | sed 's/\(.*\)/\L\1/')
PROJECT_NAME_LINE=$(echo $PROJECT_NAME_LOWER | sed 's/_/-/g')
PROJECT_NAME_LOWER_DIFF_SPACE=$(echo $PROJECT_NAME_DIFF_SPACE | sed 's/ //g' | sed 's/\(.*\)/\L\1/')

echo "project name diff space         : $PROJECT_NAME_DIFF_SPACE"
echo "project name underline          : $PROJECT_NAME_UNDERLINE"
echo "project name lower              : $PROJECT_NAME_LOWER"
echo "project name lower diff space   : $PROJECT_NAME_LOWER_DIFF_SPACE"

SETTINGS_GRANDLE=settings.gradle
echo "create $SETTINGS_GRANDLE"
echo "
include ':$PROJECT_NAME_LINE'
rootProject.name = \"$PROJECT_NAME\"

" > $SETTINGS_GRANDLE

GRANDLE_PROPERTIES=gradle.properties
echo "create $GRANDLE_PROPERTIES"
echo "
android.useAndroidX=true

android.enableJetifier=true

kotlin.code.style=official

" > $GRANDLE_PROPERTIES


GDAP=$PROJECT_NAME_DIFF_SPACE.gdap
echo "create $GDAP"
echo "
[config]

name=\"$PROJECT_NAME_DIFF_SPACE\"
binary_type=\"local\"
binary=\"$PROJECT_NAME_DIFF_SPACE.1.0.0.release.aar\"

[dependencies]
remote=[\"com.google.android.play:core:1.8.0\"]

" > $GDAP

BUILD_GRANDLE="build.gradle"
echo "create $BUILD_GRANDLE"
echo "
buildscript {
    repositories {
        google()
        jcenter()
    }
    dependencies {
        classpath \"com.android.tools.build:gradle:4.0.0\"
    }
}

allprojects {
    repositories {
        google()
        jcenter()
    }
}

task clean(type: Delete) {
    delete rootProject.buildDir
}

" > $BUILD_GRANDLE


TRAVIS=.travis.yml
echo "create $TRAVIS"
echo "
language: android

dist: trusty
android:
  components:
    - build-tools-29.0.3
    - android-29

before_cache:
  - rm -f  $HOME/.gradle/caches/modules-2/modules-2.lock
  - rm -fr $HOME/.gradle/caches/*/plugin-resolution/

cache:
  directories:
    - $HOME/.gradle/caches/
    - $HOME/.gradle/wrapper/

script:
  - wget -P ./$PROJECT_NAME_LINE/libs https://downloads.tuxfamily.org/godotengine/3.2.2/rc2/godot-lib.3.2.2.rc2.release.aar
  - ./gradlew build -s

" > $TRAVIS

SRC_PATH="./$PROJECT_NAME_LINE/src/main/java/org/godotengine/godot/plugin/$PROJECT_NAME_LOWER_DIFF_SPACE"
echo "src path $SRC_PATH"

SRC_MAIN_PATH="./$PROJECT_NAME_LINE/src/main"
echo "src main path $SRC_MAIN_PATH"

SRC_MANIFEST_PATH="$SRC_MAIN_PATH/AndroidManifest.xml"
echo "src manifest path $SRC_MANIFEST_PATH"

SRC_CODE_PATH="$SRC_PATH/$PROJECT_NAME_DIFF_SPACE.java"
echo "src java path $SRC_CODE_PATH"

mkdir -p $SRC_PATH
echo "creating..."

echo "create $SRC_MANIFEST_PATH"
echo "
<manifest xmlns:android=\"http://schemas.android.com/apk/res/android\"
    package=\"org.godotengine.godot.plugin.$PROJECT_NAME_LOWER_DIFF_SPACE\">

    <application>

        <meta-data
            android:name=\"org.godotengine.plugin.v1.$PROJECT_NAME_DIFF_SPACE\"
            android:value=\"org.godotengine.godot.plugin.$PROJECT_NAME_LOWER_DIFF_SPACE.$PROJECT_NAME_DIFF_SPACE\" />

    </application>
</manifest>

" > $SRC_MANIFEST_PATH

BUILD_GRANDLE_PLUGIN="./$PROJECT_NAME_LINE/$BUILD_GRANDLE"
echo "create $BUILD_GRANDLE_PLUGIN"
echo "
plugins {
    id 'com.android.library'
}

ext.pluginVersionCode = 1
ext.pluginVersionName = '1.0.0'

android {
    compileSdkVersion 29
    buildToolsVersion '29.0.3'

    defaultConfig {
        minSdkVersion 18
        targetSdkVersion 29 
        versionCode pluginVersionCode
        versionName pluginVersionName
    }
    compileOptions {
        sourceCompatibility JavaVersion.VERSION_1_8
        targetCompatibility JavaVersion.VERSION_1_8
    }

    libraryVariants.all { variant ->
        variant.outputs.all { output ->
            output.outputFileName = '$PROJECT_NAME_DIFF_SPACE.\$pluginVersionName.\${variant.name}.aar'
        }
    }
}

dependencies {
    implementation 'com.google.android.play:core:1.8.0'
    implementation 'androidx.legacy:legacy-support-v4:1.0.0'
    compileOnly fileTree(dir: 'libs', include: ['godot-lib*.aar'])
}

" > $BUILD_GRANDLE_PLUGIN

echo "create $SRC_CODE_PATH"
echo "
package org.godotengine.godot.plugin.$PROJECT_NAME_LOWER_DIFF_SPACE;

import android.util.ArraySet;
import org.godotengine.godot.Dictionary;
import org.godotengine.godot.Godot;
import org.godotengine.godot.plugin.GodotPlugin;
import org.godotengine.godot.plugin.SignalInfo;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

public class $PROJECT_NAME_DIFF_SPACE extends GodotPlugin {

    public $PROJECT_NAME_DIFF_SPACE(Godot godot) {
        super(godot);
    }

    public void sampleMethod() {}

    @NonNull
    @Override
    public String getPluginName() {
        return \"$PROJECT_NAME_DIFF_SPACE\";
    }

    @NonNull
    @Override
    public List<String> getPluginMethods() {
        return Arrays.asList(\"sampleMethod\");
    }

    @NonNull
    @Override
    public Set<SignalInfo> getPluginSignals() {
        Set<SignalInfo> signals = new ArraySet<>();
        signals.add(new SignalInfo(\"sampleSignal\"));
        return signals;
    }
}

" > $SRC_CODE_PATH


