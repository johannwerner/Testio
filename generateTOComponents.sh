rm -rf /tmp/xcf
xcodebuild archive -project Testio.xcodeproj -scheme TOComponents -destination="iOS" -archivePath /tmp/xcf/ios.xcarchive -derivedDataPath /tmp/iphoneos -sdk iphoneos SKIP_INSTALL=NO BUILD_LIBRARIES_FOR_DISTRIBUTION=YES
xcodebuild archive -project Testio.xcodeproj -scheme TOComponents -destination="iOS Simulator" -archivePath /tmp/xcf/iossimulator.xcarchive -derivedDataPath /tmp/iphoneos -sdk iphonesimulator SKIP_INSTALL=NO BUILD_LIBRARIES_FOR_DISTRIBUTION=YES
xcodebuild -create-xcframework -framework /tmp/xcf/ios.xcarchive/Products/Library/Frameworks/TOComponents.framework -framework /tmp/xcf/iossimulator.xcarchive/Products/Library/Frameworks/TOComponents.framework -output /tmp/xcf/TOComponents.xcframework
cp -r /tmp/xcf/TOComponents.xcframework/ ~/Desktop/TOComponents.xcframework/
