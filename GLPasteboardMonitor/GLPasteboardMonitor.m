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

#import "GLPasteboardMonitor.h"
#import "GLUtility.h"

@interface GLPasteboardMonitor ()

@property (weak, nonatomic) id<GLPasteboardMonitorDelegate> delegate;
@property (assign, nonatomic) GLMonitorLevel level;
@property (strong, nonatomic) NSTimer *timer;
@property (copy, nonatomic) NSString *copiedString;
@property (copy, nonatomic) NSString *copiedImageHashString;

@end

@implementation GLPasteboardMonitor

GLMonitorLevel defaultMonitorLevel = GLMonitorLevelWatchString | GLMonitorLevelWatchImage;
NSTimeInterval defautTimerDuration = 1.0;

#pragma mark - Initializer

- (instancetype)initWithDelegate:(__weak id<GLPasteboardMonitorDelegate>)delegate level:(GLMonitorLevel)level
{
    if (self = [super init]) {
        self.delegate = delegate;
        self.level = level;
        self.timer = [NSTimer timerWithTimeInterval:defautTimerDuration
                                             target:self
                                           selector:@selector(tryDetectPasteboardChange:)
                                           userInfo:nil
                                            repeats:YES];
    }
    return self;
}

- (instancetype)initWithDelegate:(__weak id<GLPasteboardMonitorDelegate>)delegate;
{
    return [self initWithDelegate:delegate level:defaultMonitorLevel];
}

#pragma mark -

- (void)run
{
    self.copiedString = [UIPasteboard generalPasteboard].string;
    self.copiedImageHashString = [GLUtility imageHashString:[UIPasteboard generalPasteboard].image];
    
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
}

- (void)stop
{
    [self.timer invalidate];
}

#pragma mark -

- (void)tryDetectPasteboardChange:(NSTimer *)timer
{
    // skip if the application is in foreground
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
        return;
    }
    
    // check if the data in pasteboard is chacnged
    if (self.level & GLMonitorLevelWatchString) {
        [self tryDetectPasteboardStringChange];
    }
    if (self.level & GLMonitorLevelWatchImage) {
        [self tryDetectPasteboardImageChange];
    }
}

- (void)tryDetectPasteboardStringChange
{
    if (![self.copiedString isEqualToString:[UIPasteboard generalPasteboard].string]) {
        NSString * const newString = [UIPasteboard generalPasteboard].string;
        if (newString.length == 0) {
            return;
        }
        
        self.copiedString = newString;
        
        if ([self.delegate respondsToSelector:@selector(pasteboardMonitor:didChangeString:)]) {
            [self.delegate pasteboardMonitor:self didChangeString:newString];
        }
    }
}

- (void)tryDetectPasteboardImageChange
{
    NSString * const currentCopiedHashString = [GLUtility imageHashString:[UIPasteboard generalPasteboard].image];
    if (![self.copiedImageHashString isEqualToString:currentCopiedHashString]) {
        UIImage * const newImage = [UIPasteboard generalPasteboard].image;
        self.copiedImageHashString = currentCopiedHashString;
        
        if ([self.delegate respondsToSelector:@selector(pasteboardMonitor:didChangeImage:)]) {
            [self.delegate pasteboardMonitor:self didChangeImage:newImage];
        }
    }
}


@end
