//
//  XYLoopView.h
//
//  Created by MyMacbookPro on 16/5/10.
//  Copyright © 2016年 MyMacbookPro. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface XYLoopView : UIView

//播放时间
@property (nonatomic, assign) NSTimeInterval timeInterval;
/**
 *  创建图片轮播器
 *
 *  @param urlStrings            图片的url地址字符串
 *  @param titles                每张图片对应的标题内容
 *  @param type                  标题显示的位置
 *  @param imageSelectedCallBack 选中某一图片后的点击回调
 */
- (instancetype)initWithImageUrls:(NSArray<NSString *> *)imgSrcs imageSelected:(void (^)(NSInteger index))imageSelectedCallBack;

@end
