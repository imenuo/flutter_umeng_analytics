package pedia.flutterumenganalytics;

import android.app.Activity;

import com.umeng.analytics.MobclickAgent;
import com.umeng.commonsdk.UMConfigure;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/**
 * FlutterUmengAnalyticsPlugin
 */
public class FlutterUmengAnalyticsPlugin implements MethodCallHandler {
    private Activity activity;

    /**
     * Plugin registration.
     */
    public static void registerWith(Registrar registrar) {
        final MethodChannel channel =
                new MethodChannel(registrar.messenger(), "flutter_umeng_analytics");
        channel.setMethodCallHandler(new FlutterUmengAnalyticsPlugin(registrar.activity()));
    }

    private FlutterUmengAnalyticsPlugin(Activity activity) {
        this.activity = activity;
    }

    @Override
    public void onMethodCall(MethodCall call, Result result) {
        switch (call.method) {
            case "init":
                init(call, result);
                break;
            case "beginPageView":
                MobclickAgent.onPageStart((String) call.argument("name"));
                result.success(null);
                break;
            case "endPageView":
                MobclickAgent.onPageEnd((String) call.argument("name"));
                result.success(null);
                break;
            case "logEvent":
                MobclickAgent.onEvent(activity, (String) call.argument("name"));
                result.success(null);
                break;
            default:
                result.notImplemented();
                break;
        }
    }

    private void init(MethodCall call, Result result) {
        UMConfigure.init(activity, (Integer) call.argument("deviceType"),
                (String) call.argument("key"));

        if (call.hasArgument("logEnable"))
            UMConfigure.setLogEnabled((Boolean) call.argument("logEnable"));

        if (call.hasArgument("encrypt"))
            UMConfigure.setEncryptEnabled((Boolean) call.argument("encrypt"));

        if (call.hasArgument("reportCrash"))
            MobclickAgent.setCatchUncaughtExceptions((Boolean) call.argument("reportCrash"));

        result.success(true);
    }
}
