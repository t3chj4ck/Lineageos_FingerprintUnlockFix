# UDFPS Dim Fix

An Xposed module (LSPosed / Vector) that disables the fullscreen dim layer drawn by SystemUI
over the lockscreen when under-display fingerprint (UDFPS) is active.

Package: `io.github.t3chj4ck.udfpsdimfix`

## Why

On lockscreens with UDFPS enabled, SystemUI creates a fullscreen `VRI-Dim Layer for UDFPS`
(a 1080x2412 buffer) every time the fingerprint overlay is shown. This adds a fullscreen
composition layer and causes noticeable frame drops on some AOSP-based ROMs.

This module hooks `com.android.systemui.biometrics.UdfpsControllerOverlay.addViewNowOrLater`
and sets its `udfpsHelper` field to null before the method runs, which skips adding the dim
layer. The fingerprint icon/overlay still renders, so fingerprint unlock keeps working.

## Compatibility

- AOSP-based ROMs with UDFPS (LineageOS, PixelExperience, crDroid, etc.)
- Android 14+ (method name `addViewNowOrLater`)
- Tested: OnePlus 11 / LineageOS 24 (Android 17 / API 37)
- OEM ROMs (MIUI/HyperOS, ColorOS, One UI) may use different SystemUI implementations:
  untested and unsupported.

## Build

See `build.sh`. Requires `javac`, `r8.jar` (d8), `aapt2`, a `framework-res.apk`,
and `uber-apk-signer.jar` in `tools/`.

## Scope

Only `com.android.systemui` needs to be enabled in the module scope.
