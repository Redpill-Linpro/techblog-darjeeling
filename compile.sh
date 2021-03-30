#! /bin/sh
mkdir -p META-INF/native-image
echo '[{
    "name" : "org.apache.commons.logging.impl.Jdk14Logger",
    "allDeclaredConstructors" : true,
    "allPublicConstructors" : true,
    "allDeclaredMethods" : true,
    "allPublicMethods" : true
  },
  {
    "name" : "org.apache.commons.logging.impl.LogFactoryImpl",
    "allDeclaredConstructors" : true,
    "allPublicConstructors" : true,
    "allDeclaredMethods" : true,
    "allPublicMethods" : true,
    "allDeclaredClasses" : true,
    "allPublicClasses" : true
  },{
    "name" : "java.lang.String",
    "allDeclaredConstructors" : true,
    "allPublicConstructors" : true,
    "allDeclaredMethods" : true,
    "allPublicMethods" : true,
    "allDeclaredClasses" : true,
    "allPublicClasses" : true
  },
  {
    "name" : "org.apache.commons.logging.LogFactory",
    "allDeclaredConstructors" : true,
    "allPublicConstructors" : true,
    "allDeclaredMethods" : true,
    "allPublicMethods" : true,
    "allDeclaredClasses" : true,
    "allPublicClasses" : true
  },
  {
    "name" : "org.apache.commons.logging.impl.SimpleLog",
    "allDeclaredConstructors" : true,
    "allPublicConstructors" : true,
    "allDeclaredMethods" : true,
    "allPublicMethods" : true,
    "allDeclaredClasses" : true,
    "allPublicClasses" : true
  }]' | tee META-INF/native-image/logging.json
native-image -cp app.jar -jar app.jar \
	     -H:Name=app -H:+ReportExceptionStackTraces \
	     -J-Dclojure.spec.skip.macros=true -J-Dclojure.compiler.direct-linking=true -J-Xmx3G \
	     --initialize-at-build-time --enable-http --enable-https --verbose --no-fallback --no-server\
	     --report-unsupported-elements-at-runtime --native-image-info \
	     -H:+StaticExecutableWithDynamicLibC -H:CCompilerOption=-pipe \
	     --allow-incomplete-classpath --enable-url-protocols=http,https --enable-all-security-services \
	     -H:ReflectionConfigurationFiles=META-INF/native-image/logging.json
chmod +x app
echo "Size of generated native-image `ls -sh app`"
