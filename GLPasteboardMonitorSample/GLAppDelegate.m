//
//  GLAppDelegate.m
//  GLPasteboardMonitorSample
//
//  Created by Yohei Yamaguchi on 2013/12/12.
//  Copyright (c) 2013年 Yohei Yamaguchi. All rights reserved.
//

#import "GLAppDelegate.h"
#import "GLPasteboardMonitor.h"

@interface GLAppDelegate () <GLPasteboardMonitorDelegate>

@property (nonatomic, strong) GLPasteboardMonitor *monitor;
@property (nonatomic, assign) UIBackgroundTaskIdentifier backgroundTask;

@end

@implementation GLAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.monitor = [[GLPasteboardMonitor alloc] initWithDelegate:self];
    [self.monitor run];
    
    return YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    self.backgroundTask = [application beginBackgroundTaskWithExpirationHandler:^{
        [application endBackgroundTask:self.backgroundTask];
        self.backgroundTask = UIBackgroundTaskInvalid;
    }];
}

#pragma mark - GLPasteboardMonitor

- (void)pasteboardMonitor:(GLPasteboardMonitor *)Monitor didChangeString:(NSString *)newCopiedString
{
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    if (!localNotification) {
        return;
    }
    
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    localNotification.alertBody = [NSString stringWithFormat:@"copied a string now. %@", newCopiedString];
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}

- (void)pasteboardMonitor:(GLPasteboardMonitor *)Monitor didChangeImage:(UIImage *)newCopiedImage
{
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    if (!localNotification) {
        return;
    }
    
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    localNotification.alertBody = [NSString stringWithFormat:@"copied a image now."];
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}

@end
