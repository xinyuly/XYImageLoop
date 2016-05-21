//
//  ViewController.m
//  XYImageLoopDemo
//
//  Created by lixinyu on 16/5/21.
//  Copyright © 2016年 xiaoyu. All rights reserved.
//

#import "ViewController.h"
#import "XYLoopView.h"

@interface ViewController ()
@property (nonatomic, strong) XYLoopView *loopView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    NSArray *arrURL = @[@"http://img5.duitang.com/uploads/item/201411/16/20141116152242_XTsZZ.jpeg",@"http://img4.duitang.com/uploads/item/201312/03/20131203154121_rPHaH.jpeg",@"http://h.hiphotos.baidu.com/baike/c0%3Dbaike60%2C5%2C5%2C60%2C20/sign=dea9e7f2564e9258b2398ebcfdebba3d/dbb44aed2e738bd46496bda7a18b87d6267ff9f5.jpg"];
    
    XYLoopView *loopView = [[XYLoopView alloc] initWithImageUrls:arrURL imageSelected:^(NSInteger index) {
        
    }];
    [self.view addSubview:loopView];
    loopView.frame = self.view.frame;
    loopView.timeInterval = 5.0;
    self.loopView = loopView;
    //使用说明：
    /**
     *  1、iOS9.0后需要在info.plist文件配置 App Transport Security Settings
     *  2、如果是网络图片，使用SDWebImage框架
     *  3、自定义时钟，避免循环引用问题
     */
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
