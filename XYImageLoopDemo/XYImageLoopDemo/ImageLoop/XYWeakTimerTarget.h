//
//  ASWeakTimerTarget.h

//
//  Created by MyMacbookPro on 16/3/13.
//  Copyright © 2016年 MyMacbookPro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XYWeakTimerTarget : NSObject

+ (NSTimer *)timerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(id)userInfo repeats:(BOOL)yesOrNo;

@end
