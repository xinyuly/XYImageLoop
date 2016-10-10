//
//  ASWeakTimerTarget.m

//
//  Created by MyMacbookPro on 16/3/13.
//  Copyright © 2016年 MyMacbookPro. All rights reserved.
//

#import "XYWeakTimerTarget.h"
#define SuppressPerformSelectorLeakWarning(code) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
code; \
_Pragma("clang diagnostic pop") \
} while (0);

@interface XYWeakTimerTarget ()

@property (nonatomic, weak) id aTarget;
@property (nonatomic, assign) SEL aSelector;

@end

@implementation XYWeakTimerTarget

+ (NSTimer *)timerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(id)userInfo repeats:(BOOL)yesOrNo {
    XYWeakTimerTarget *weakTarget = [[XYWeakTimerTarget alloc] init];
    weakTarget.aTarget = aTarget;
    weakTarget.aSelector = aSelector;
    NSTimer *timer = [NSTimer timerWithTimeInterval:ti target:weakTarget selector:@selector(executeSelector:) userInfo:userInfo repeats:yesOrNo];
    return timer;
}

- (void)executeSelector:(NSTimer *)timer {
    SuppressPerformSelectorLeakWarning([self.aTarget performSelector:self.aSelector withObject:timer])
}

@end
