#import "FlutterUmengAnalyticsPlugin.h"

#import <UMCommon/UMCommon.h>
#import <UMAnalytics/MobClick.h>

@implementation FlutterUmengAnalyticsPlugin
+ (void)registerWithRegistrar:(NSObject <FlutterPluginRegistrar> *)registrar {
    FlutterMethodChannel *channel =
            [FlutterMethodChannel methodChannelWithName:@"flutter_umeng_analytics"
                                        binaryMessenger:[registrar messenger]];
    FlutterUmengAnalyticsPlugin *instance = [[FlutterUmengAnalyticsPlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result {
    if ([@"getPlatformVersion" isEqualToString:call.method]) {
        result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
    } else if ([@"init" isEqualToString:call.method]) {
        [self init:call result:result];
    } else if ([@"logPageView" isEqualToString:call.method]) {
        [MobClick logPageView:call.arguments[@"name"] seconds:[call.arguments[@"seconds"] intValue]];
        result(nil);
    } else if ([@"beginPageView" isEqualToString:call.method]) {
        [MobClick beginLogPageView:call.arguments[@"name"]];
        result(nil);
    } else if ([@"endPageView" isEqualToString:call.method]) {
        [MobClick endLogPageView:call.arguments[@"name"]];
        result(nil);
    } else if ([@"logEvent" isEqualToString:call.method]) {
        if (call.arguments[@"label"] != [NSNull null])
            [MobClick event:call.arguments[@"name"] label:call.arguments[@"label"]];
        else
            [MobClick event:call.arguments[@"name"]];
        result(nil);
    } else {
        result(FlutterMethodNotImplemented);
    }
}

- (void)init:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *appKey = call.arguments[@"key"];

    NSString *channel = call.arguments[@"channel"];
    if (!channel) channel = @"default";

    [UMConfigure initWithAppkey:appKey channel:channel];

    NSNumber *reportCrash = call.arguments[@"reportCrash"];
    if (reportCrash) [MobClick setCrashReportEnabled:[reportCrash boolValue]];

    NSNumber *logEnable = call.arguments[@"logEnable"];
    if (logEnable) [UMConfigure setLogEnabled:[logEnable boolValue]];

    NSNumber *encrypt = call.arguments[@"encrypt"];
    if (encrypt) [UMConfigure setEncryptEnabled:[encrypt boolValue]];
}

@end
