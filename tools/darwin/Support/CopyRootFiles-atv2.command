#!/bin/bash

echo "copy root files"

if [ "$ACTION" = build ] ; then

# for external testing
TARGET_NAME=$PRODUCT_NAME.$WRAPPER_EXTENSION
#SRCROOT=/Users/Shared/xbmc_svn/$APP_NAME
#TARGET_BUILD_DIR=/Users/Shared/xbmc_svn/$APP_NAME/build/Debug

# rsync command with exclusions for items we don't want in the app package
SYNC="rsync -aq --exclude .git* --exclude .DS_Store* --exclude *.dll --exclude *.DLL --exclude *linux.* --exclude *x86-osx.* --exclude *.zlib --exclude *.a --exclude *.pyd --exclude *x86-osx.so --exclude *powerpc-osx.so"

# rsync command for skins. jpg, png exclusion is handled during sync
# if a Textures.xbt file is found 
SKINSYNC="rsync -aq --exclude .git* --exclude CVS* --exclude .svn* --exclude .cvsignore* --exclude .cvspass* --exclude .DS_Store* --exclude *.dll  --exclude *.DLL --exclude *linux.*  --exclude *.bat"

# rsync command for including everything but the skins
ADDONSYNC="rsync -aq --exclude .git* --exclude CVS* --exclude .svn* --exclude .cvsignore* --exclude .cvspass* --exclude .DS_Store* --exclude addons/skin.confluence --exclude addons/skin.re-touched --exclude screensaver.rsxs* --exclude visualization.*"

# binary name is Kodi but we build Kodi.bin so to get a clean binary each time
mv $TARGET_BUILD_DIR/$TARGET_NAME/$APP_NAME.bin $TARGET_BUILD_DIR/$TARGET_NAME/$APP_NAME

mkdir -p "$TARGET_BUILD_DIR/$TARGET_NAME/AppData/AppHome"
mkdir -p "$TARGET_BUILD_DIR/$TARGET_NAME/AppData/AppHome/addons"
mkdir -p "$TARGET_BUILD_DIR/$TARGET_NAME/AppData/AppHome/language"
mkdir -p "$TARGET_BUILD_DIR/$TARGET_NAME/AppData/AppHome/media"
mkdir -p "$TARGET_BUILD_DIR/$TARGET_NAME/AppData/AppHome/sounds"
mkdir -p "$TARGET_BUILD_DIR/$TARGET_NAME/AppData/AppHome/system"
mkdir -p "$TARGET_BUILD_DIR/$TARGET_NAME/AppData/AppHome/userdata"
mkdir -p "$TARGET_BUILD_DIR/$TARGET_NAME/AppData/AppHome/media"
mkdir -p "$TARGET_BUILD_DIR/$TARGET_NAME/AppData/AppHome/tools/darwin/runtime"

${SYNC} "$SRCROOT/LICENSE.GPL" 	"$TARGET_BUILD_DIR/$TARGET_NAME/AppData/"
${SYNC} "$SRCROOT/xbmc/osx/Credits.html" 	"$TARGET_BUILD_DIR/$TARGET_NAME/AppData/"
${ADDONSYNC} "$SRCROOT/addons"		"$TARGET_BUILD_DIR/$TARGET_NAME/AppData/AppHome"
${SYNC} "$SRCROOT/addons/visualization.glspectrum"   	"$TARGET_BUILD_DIR/$TARGET_NAME/AppData/AppHome/addons"
${SYNC} "$SRCROOT/addons/visualization.waveform"    	"$TARGET_BUILD_DIR/$TARGET_NAME/AppData/AppHome/addons"
${SYNC} "$SRCROOT/language"		"$TARGET_BUILD_DIR/$TARGET_NAME/AppData/AppHome"
${SYNC} "$SRCROOT/media" 		"$TARGET_BUILD_DIR/$TARGET_NAME/AppData/AppHome"

SYNCSKIN_A=${SKINSYNC}
if [ -f "$SRCROOT/addons/skin.confluence/media/Textures.xbt" ]; then
SYNCSKIN_A="${SKINSYNC} --exclude *.png --exclude *.jpg"
fi
${SYNCSKIN_A} "$SRCROOT/addons/skin.confluence" 	"$TARGET_BUILD_DIR/$TARGET_NAME/AppData/AppHome/addons"
${SYNC} "$SRCROOT/addons/skin.confluence/backgrounds" 	"$TARGET_BUILD_DIR/$TARGET_NAME/AppData/AppHome/addons/skin.confluence"
${SYNC} "$SRCROOT/addons/skin.confluence/icon.png" 	"$TARGET_BUILD_DIR/$TARGET_NAME/AppData/AppHome/addons/skin.confluence"

${SYNC} "$SRCROOT/sounds" 		"$TARGET_BUILD_DIR/$TARGET_NAME/AppData/AppHome"
${SYNC} "$SRCROOT/system" 		"$TARGET_BUILD_DIR/$TARGET_NAME/AppData/AppHome"
${SYNC} "$SRCROOT/userdata" 	"$TARGET_BUILD_DIR/$TARGET_NAME/AppData/AppHome"

fi

