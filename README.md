GLPasteboardMonitor
=====================================

GLPasteboardMonitor monitors a change of the general pasteboard.


## Usage

initialization and how to start and stop monitoring.

```objc
#import “GLPasteboardMonitor.h”

GLPasteboardMonitor *monitor = [GLPasteboardMonitor alloc] initWithDelegate:delegate];

// start monitoring
[monitor run];

// stop monitoring
[monitor stop];
```

To receive a change of the general pasteboard, implement these delegate methods.

```objc
- (void)pasteboardMonitor:(GLPasteboardMonitor *)Monitor didChangeString:(NSString *)newCopiedString;

- (void)pasteboardMonitor:(GLPasteboardMonitor *)Monitor didChangeImage:(UIImage *)newCopiedImage;
```

Finally, to keep monitoring pasteboard, you must implement the task competion in your app delegate.

```objc

@interface GLAppDelegate () <GLPasteboardMonitorDelegate>

@property (nonatomic, assign) UIBackgroundTaskIdentifier backgroundTask;

@end


- (void)applicationDidEnterBackground:(UIApplication *)application
{
    self.backgroundTask = [application beginBackgroundTaskWithExpirationHandler:^{
        [application endBackgroundTask:self.backgroundTask];
        self.backgroundTask = UIBackgroundTaskInvalid;
    }];
}
```

## Requirement

GLPasteboardMonitor must be built with ARC enabled.

## License

GLPasteboardMonitor is available under the [MIT license](LICENSE).
