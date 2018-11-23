package pedia.flutterumenganalytics;

import android.app.Activity;

import com.umeng.analytics.MobclickAgent;
import com.umeng.commonsdk.UMConfigure;

import java.util.Map;

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
                logEvent(call);
                result.success(null);
                break;
            case "onProfileSignIn":
                if (call.argument("provider") == null) {
                    MobclickAgent.onProfileSignIn((String) call.argument("uid"));
                } else {
                    MobclickAgent.onProfileSignIn((String) call.argument("uid"),
                            (String) call.argument("provider"));
                }
                break;
            case "onProfileSignOff":
                MobclickAgent.onProfileSignOff();
                break;
            default:
                result.notImplemented();
                break;
        }
    }

    private void logEvent(MethodCall call) {
        String name = call.argument("name");
        if (call.hasArgument("map") && call.argument("map") != null) {
            MobclickAgent.onEvent(activity, name, (Map<String, String>) call.argument("map"));
        } else if (call.hasArgument("label") && call.argument("label") != null) {
            MobclickAgent.onEvent(activity, name, (String) call.argument("label"));
        } else {
            MobclickAgent.onEvent(activity, name);
        }
    }

    private void init(MethodCall call, Result result) {
        String appKey = call.argument("key");
        String channel = call.argument("channel");
        Integer deviceType = call.argument("deviceType");
        UMConfigure.init(activity, appKey, channel, deviceType, null);

        if (call.hasArgument("logEnable"))
            UMConfigure.setLogEnabled((Boolean) call.argument("logEnable"));

        if (call.hasArgument("encrypt"))
            UMConfigure.setEncryptEnabled((Boolean) call.argument("encrypt"));

        if (call.hasArgument("reportCrash"))
            MobclickAgent.setCatchUncaughtExceptions((Boolean) call.argument("reportCrash"));

        MobclickAgent.openActivityDurationTrack(false);

        result.success(true);
    }
}
