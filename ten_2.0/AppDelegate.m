//
//  AppDelegate.m
//  ten_2.0
//
//  Created by qianfeng on 9/8/15.
//  Copyright (c) 2015 __None__. All rights reserved.
//

#import "AppDelegate.h"
#import "MainTabBarController.h"
#import "ADModel.h"
#import "FVCustomAlertView.h"
#import "UMSocial.h"
@interface AppDelegate (){
    ADModel *_aModel;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
//    [self askAdUrl];
    [UMSocialData setAppKey:@"55f0d4dce0f55a8c05008611"];
    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self checkNetWorking];
    MainTabBarController *rvc = [[MainTabBarController alloc]init];
    self.window.rootViewController = rvc;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)checkNetWorking{
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager startMonitoring];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable:{
                [FVCustomAlertView showDefaultDoneAlertOnView:self.window withTitle:@"无法连接"];
                [FVCustomAlertView hideAlertFromView:self.window fading:YES];
            }
                break;
            case AFNetworkReachabilityStatusUnknown:{
                [FVCustomAlertView showDefaultDoneAlertOnView:self.window withTitle:@"网络未知"];
                [FVCustomAlertView hideAlertFromView:self.window fading:YES];

            }
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:{
                [FVCustomAlertView showDefaultDoneAlertOnView:self.window withTitle:@"移动网络"];
                [FVCustomAlertView hideAlertFromView:self.window fading:YES];

            }
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:{
                [FVCustomAlertView showDefaultDoneAlertOnView:self.window withTitle:@"WIFI网络"];
                [FVCustomAlertView hideAlertFromView:self.window fading:YES];

            }
                break;

            default:
                break;
        }
    }];
    
}

- (void)askAdUrl {
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:AD_URL]];
//            id responseObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//            _aModel = [[ADModel alloc] init];
//            [_aModel setValuesForKeysWithDictionary:responseObject];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
//                [user setObject:_aModel.image forKey:@"image"];
//                [user setObject:_aModel.addisplaytime forKey:@"time"];
//        });
//    });
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:AD_URL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //
        _aModel = [[ADModel alloc] init];
        [_aModel setValuesForKeysWithDictionary:responseObject];
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        [user setObject:_aModel.image forKey:@"image"];
        [user setObject:_aModel.addisplaytime forKey:@"time"];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //
        NSLog(@"%@",error);
    }];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
