//
//  XYLoopViewCell.m
//  LoopView
//
//  Created by MyMacbookPro on 16/5/10.
//  Copyright © 2016年 MyMacbookPro. All rights reserved.
//

#import "XYLoopViewCell.h"
#import "UIImageView+WebCache.h" // 如果集成了SDWebImage，获取网络图片，打开这句

@interface XYLoopViewCell ()

@property (nonatomic, weak) UIImageView *imgView;  //!< 图片展示view

@end

@implementation XYLoopViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // 创建填满整个cell的imageView，添加到cell中
        UIImageView *imgView = [[UIImageView alloc] init];
        [self.contentView addSubview:imgView];
        self.imgView = imgView;
    }
    return self;
}

/// 设置图片，如果是网络图片，使用SDWebImage框架
- (void)setImgsrc:(NSString *)imgsrc {
    imgsrc = imgsrc;
    // 已导入SDWebImage框架，图片通过网络获取，打开这句话
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:imgsrc]];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imgView.frame = self.contentView.bounds;
}

@end
