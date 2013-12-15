//  Copyright (c) 2013 GLPasteboardMonitor (https://github.com/gologo13/GLPasteboardMonitor)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import <Foundation/Foundation.h>

/**
 *  Monitor level
 */
typedef NS_OPTIONS(NSInteger, GLMonitorLevel) {
    /**
     *  monitors a change of the string of the general pasteboard.
     */
    GLMonitorLevelWatchString = 1,
    /**
     *  monitors a change of the image of the general pasteboard.
     */
    GLMonitorLevelWatchImage  = 1 << 1,
};

@protocol GLPasteboardMonitorDelegate;

/**
 *  GLPasteboardMonitor
 */
@interface GLPasteboardMonitor : NSObject

/**
 *  Initializer. monitors both string and image of the general pasteboard in the default setting.
 *  Monitoring is executed in the background mode.
 *
 *  @param delegate a delegate instance
 *
 *  @return a GLPasteboardMonitor instance
 */
- (instancetype)initWithDelegate:(__weak id<GLPasteboardMonitorDelegate>)delegate;

/**
 *  Initializer. can specify the monitoring level.
 *
 *  @param delegate a delegate instance
 *  @param level    a monitoring level
 *
 *  @return a GLPasteboardMonitor instance
 */
- (instancetype)initWithDelegate:(__weak id<GLPasteboardMonitorDelegate>)delegate level:(GLMonitorLevel)level;

/**
 *  start monitoring the general pasteboard. if a delegate is set, delegate methods will be called.
 */
- (void)run;

/**
 *  stop monitoring the general pasteboard.
 */
- (void)stop;

@end

@protocol GLPasteboardMonitorDelegate<NSObject>

@optional

/**
 *  pasteboardMonitor:didChangeString: is called when then the string of the general pasteboard is changed.
 *
 *  @param Monitor   a GLPasteboardMonitor instance
 *  @param newString a string right after the string of the general pasteboard is changed
 */
- (void)pasteboardMonitor:(GLPasteboardMonitor *)Monitor didChangeString:(NSString *)newCopiedString;

/**
 *  pasteboardMonitor:didChangeImage: is called when the image of the general pasteboard is changed.
 *
 *  @param Monitor  a GLPasteboardMonitor instance
 *  @param newImage a image right after the image of the general pasteboard is changed
 */
- (void)pasteboardMonitor:(GLPasteboardMonitor *)Monitor didChangeImage:(UIImage *)newCopiedImage;

@end
