#!/bin/bash
# Build UDFPS Dim Fix Xposed module APK
# Requires: javac (JDK), r8.jar (d8), aapt2, framework-res.apk, uber-apk-signer.jar
set -e
ROOT="$(cd "$(dirname "$0")" && pwd)"
WORK="$ROOT/.build"
TOOLS="$ROOT/tools"

rm -rf "$WORK" && mkdir -p "$WORK/classes" "$WORK/dex"
javac -source 8 -target 8 -d "$WORK/classes" $(find "$ROOT/src" -name "*.java")
java -cp "$TOOLS/r8.jar" com.android.tools.r8.D8 --min-api 34 --output "$WORK/dex" \
  "$WORK/classes/io/github/t3chj4ck/udfpsdimfix/Hook.class" "$WORK/classes/io/github/t3chj4ck/udfpsdimfix/Hook\$1.class"
"$TOOLS/aapt2" link --manifest "$ROOT/AndroidManifest.xml" -I "$TOOLS/framework-res.apk" \
  -o "$WORK/base.apk" -A "$ROOT/assets" --min-sdk-version 34 --target-sdk-version 36
python3 - "$WORK" <<'PY'
import zipfile, shutil, sys
w = sys.argv[1]
shutil.copy(w + '/base.apk', w + '/final.apk')
with zipfile.ZipFile(w + '/final.apk', 'a') as z:
    z.write(w + '/dex/classes.dex', 'classes.dex')
PY
java -jar "$TOOLS/uber-apk-signer.jar" -a "$WORK/final.apk" --out "$WORK/out"
cp "$WORK/out/final-aligned-debugSigned.apk" "$ROOT/UdfpsDimFix-v1.0.apk"
echo "Done: $ROOT/UdfpsDimFix-v1.0.apk"
