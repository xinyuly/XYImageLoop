# XYImageLoop
图片轮播功能
## 使用说明：
 1、iOS9.0后需要在info.plist文件配置 App Transport Security Settings
 2、如果是网络图片，使用SDWebImage框架
 3、自定义时钟，避免循环引用问题
 4、播放时间默认为
```objc
    XYLoopView *loopView = [[XYLoopView alloc] initWithImageUrls:arrURL imageSelected:^(NSInteger index) {
     //点击事件
    }];
    [self.view addSubview:loopView];
    loopView.frame = CGRectMake(0, 20, self.view.bounds.size.width, 200);
    loopView.timeInterval = 2.0;
    self.loopView = loopView;
``` 