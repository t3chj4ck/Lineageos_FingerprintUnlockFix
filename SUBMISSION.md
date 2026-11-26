# 提交清单（Xposed-Modules-Repo）

提交入口：https://github.com/Xposed-Modules-Repo/submission/issues/new
**标题必须带 `[submission] ` 前缀**，否则 bot 会直接按 spam 关掉（上一轮就是这么废的）。

## 1. issue 标题

```
[submission] io.github.t3chj4ck.udfpsdimfix
```

## 2. issue 正文（复制粘贴）

```
Module: UDFPS Dim Fix
Package: io.github.t3chj4ck.udfpsdimfix

Disables the fullscreen UDFPS dim layer that SystemUI draws over the lockscreen while the
fingerprint overlay is shown. On AOSP-based ROMs this layer is a fullscreen composition
buffer and causes dropped frames / jank. Fingerprint unlock itself is unaffected.

Works on AOSP-based ROMs with UDFPS (LineageOS, crDroid, PixelExperience...).
Tested: OnePlus 11 / LineageOS 24 (Android 17). OEM ROMs use different SystemUI code and are
unsupported.

Source: <你的源码仓库地址>
```

## 3. bot 建好仓库、接受邀请之后

仓库地址会是：https://github.com/Xposed-Modules-Repo/io.github.t3chj4ck.udfpsdimfix

- **Description**（列表里显示成模块名，不填就不收录）：
  `UDFPS Dim Fix — 锁屏暗层关闭`
- 仓库根目录放 `SUMMARY`（单行简介）和 `README.md`
- **不要传源码**。官方 README 原话："Please do not upload your source code here, we don't need your source code"
- 仓库要求：名字=包名、有非空 description、至少一个带 APK 的 release

## 4. 发 Release

- Tag：`1-1.0`（`versionCode-versionName`；bot 会自动纠正写错的 tag）
- Asset：`UdfpsDimFix-v1.0.apk`
- Release 标题：`1.0`（版本名），正文：changelog

注意：**只替换已有 release 里的 APK 不会触发重新抓取**，要连着正文一起改动（或直接发新 release）。

## 5. 之后

- 约 3 个工作日出现在 https://modules.lsposed.org
- 手机端：先卸载旧包 `com.hj.udfpsfix`，再装新版；Vector 里给 `com.android.systemui` 勾上作用域
