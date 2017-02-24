scripts
=======

Scripts developed for a CentOS server running on AWS cloud.


todo: take a look at this:

    // stage('align') {
    //     sh 'rm *.apk'
    //     sh '$ANDROID_SDK_BUILD_TOOLS/zipalign -v -p 4 app/build/outputs/apk/app-release-unsigned.apk app-release-aligned.apk'
    // }
    // stage('assign') {
    //     String keyAlias = sh(returnStdout: true, script: 'grep "keyAlias" tvpt_automation/keystore/keystore.properties | awk -F "=" \'{print $2}\'').trim()
    //     String storePassword = sh(returnStdout: true, script: 'grep "storePassword" tvpt_automation/keystore/keystore.properties | awk -F "=" \'{print $2}\'').trim()
    //     String keyPassword = sh(returnStdout: true, script: 'grep "keyPassword" tvpt_automation/keystore/keystore.properties | awk -F "=" \'{print $2}\'').trim()
    //     sh "$ANDROID_SDK_BUILD_TOOLS/apksigner sign --ks tvpt_automation/keystore/keystore.jks --ks-key-alias $keyAlias --ks-pass pass:$storePassword --key-pass pass:$keyPassword --out app.apk app-release-aligned.apk"
    //     sh 'cp app.apk app/build/outputs/apk/app-release.apk'
    // }
