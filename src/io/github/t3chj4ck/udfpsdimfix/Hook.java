package io.github.t3chj4ck.udfpsdimfix;

import de.robv.android.xposed.IXposedHookLoadPackage;
import de.robv.android.xposed.XC_MethodHook;
import de.robv.android.xposed.XposedBridge;
import de.robv.android.xposed.callbacks.XC_LoadPackage;
import java.lang.reflect.Field;
import java.lang.reflect.Method;

public class Hook implements IXposedHookLoadPackage {
    @Override
    public void handleLoadPackage(XC_LoadPackage.LoadPackageParam lpparam) throws Throwable {
        if (lpparam.packageName == null || !lpparam.packageName.equals("com.android.systemui")) return;
        try {
            Class<?> cls = Class.forName("com.android.systemui.biometrics.UdfpsControllerOverlay", false, lpparam.classLoader);
            final Field helperField = cls.getDeclaredField("udfpsHelper");
            helperField.setAccessible(true);
            Method target = null;
            for (Method m : cls.getDeclaredMethods()) {
                if (m.getName().equals("addViewNowOrLater")) { target = m; break; }
            }
            if (target == null) { XposedBridge.log("UdfpsFix: addViewNowOrLater not found"); return; }
            target.setAccessible(true);
            XposedBridge.hookMethod(target, new XC_MethodHook() {
                @Override
                protected void beforeHookedMethod(MethodHookParam param) throws Throwable {
                    try { helperField.set(param.thisObject, null); } catch (Throwable t) {}
                }
            });
            XposedBridge.log("UdfpsFix: hooked addViewNowOrLater");
        } catch (Throwable t) {
            XposedBridge.log("UdfpsFix: hook failed: " + t);
        }
    }
}
