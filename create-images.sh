#!/bin/sh
path=$(pwd)

echo "Building Database image"
cd $path/database; ./build-image.sh ;

echo "Building enterprise manager image"
cd $path/enterprise-manager; ./build-image.sh ;

echo "Building webview image"
cd $path/webview; ./build-image.sh ;

echo "Building ACC Config Server image"
cd $path/configserver; ./build-image.sh ;

echo "Building MathApp java image"
cd $path/mathapp; ./build-image.sh ;
