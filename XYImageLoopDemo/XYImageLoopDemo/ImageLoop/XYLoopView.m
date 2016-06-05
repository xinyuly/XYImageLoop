//
//  XYLoopView.m
//
//  Created by MyMacbookPro on 16/5/10.
//  Copyright © 2016年 MyMacbookPro. All rights reserved.
//

#import "XYLoopView.h"
#import "XYLoopViewCell.h"
#import "XYWeakTimerTarget.h"

@interface XYLoopView () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, weak) UICollectionView *collectionView;  //!< 图片轮播collectionView

@property (nonatomic, strong) UICollectionViewFlowLayout *layout;

@property (nonatomic, strong) NSArray<NSString *> *imgSrcs;    //!< 图片地址数组
@property (nonatomic, weak) UIPageControl *pageControl;  //!< 图片轮播索引指示器
@property (nonatomic, copy) void (^imageSelectedCallBack)(NSInteger index);  //!< 选择指定索引的图片后的点击回调

@property (nonatomic, strong) NSTimer *timer;    //!< 定时器

@end

@implementation XYLoopView

#pragma mark - 初始化
/// 创建loopView
- (instancetype)initWithImageUrls:(NSArray<NSString *> *)imgSrcs  imageSelected:(void (^)(NSInteger))imageSelectedCallBack {
    if (self = [super init]) {
        // 记录属性
        self.imgSrcs = imgSrcs;
        
        self.imageSelectedCallBack = imageSelectedCallBack;
        self.pageControl.numberOfPages = imgSrcs.count;
        // 为什么要异步执行collectionView的滚动？
        // 设置collectionView，需要数据源，而数据来自网络，在子线程中执行。必须保证collectionView设置完毕之后，再执行collectionView的滚动
        dispatch_async(dispatch_get_main_queue(), ^{
            // 只有在头条数大于1时，才执行轮播
            if (imgSrcs.count > 1) {
                [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:imgSrcs.count inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
                [self startLoopTimer];
            }
        });
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.layout = [[UICollectionViewFlowLayout alloc] init];
    // 创建collectionView，设置相关参数
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.layout];
    [collectionView registerClass:[XYLoopViewCell class] forCellWithReuseIdentifier:@"loop_cell"];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.backgroundColor = [UIColor whiteColor];
    
    self.collectionView = collectionView;
    [self addSubview:collectionView];
    
    // 创建pageControl
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    pageControl.currentPageIndicatorTintColor = [UIColor orangeColor];
    pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    pageControl.hidesForSinglePage = YES;
    self.pageControl = pageControl;
    [self addSubview:pageControl];
}

// 布局子控件
- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect frame = self.bounds;
    
    self.collectionView.frame = frame;
    
    //设置flowlayout
    self.layout.itemSize = self.collectionView.frame.size;
    self.layout.minimumInteritemSpacing = 0;
    self.layout.minimumLineSpacing = 0;
    
    self.layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.collectionView.pagingEnabled = YES;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.bounces = NO;
    
    CGFloat marginX = 10;
    CGFloat pageW = self.imgSrcs.count * 15;
    CGFloat pageH = 20;
    CGFloat pageX = self.bounds.size.width - marginX - pageW;
    CGFloat pageY = self.bounds.size.height -20;
    self.pageControl.frame = CGRectMake(pageX, pageY, pageW, pageH);

}

#pragma mark - collection view 数据源 & 代理
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    // 如果页数大于1，则返回 3 * 模型数 个cell
//    NSLog(@"%ld",self.imgSrcs.count * (self.imgSrcs.count > 1 ? 3 : 1));
    return self.imgSrcs.count * (self.imgSrcs.count > 1 ? 3 : 1);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XYLoopViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"loop_cell" forIndexPath:indexPath];
    cell.imgsrc = self.imgSrcs[indexPath.item % self.imgSrcs.count];
    return cell;
}

// 监听collectionView cell的选中事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.imageSelectedCallBack) {
        self.imageSelectedCallBack(indexPath.item % self.imgSrcs.count);
    }
}

// 滚动停止时，根据内容偏移调整数据
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    // 当collectionView滚动结束时，根据内容偏移获取当前页
    NSInteger currentPage = scrollView.contentOffset.x / scrollView.bounds.size.width;
    // 如果当前页 % 实际图片数 == 0，则让collectionView将内容偏移切换到中间组的第0条，保证左右无限滚动
    if (currentPage % self.imgSrcs.count == 0) {
        scrollView.contentOffset = CGPointMake(self.imgSrcs.count * scrollView.bounds.size.width, 0);
    }
    //如果最后一张
    if (currentPage+1 == self.imgSrcs.count*3 &&self.imgSrcs.count!=1) {
        self.collectionView.contentOffset = CGPointMake(self.imgSrcs.count *self.collectionView.bounds.size.width, 0);
    }

        self.pageControl.currentPage = currentPage % self.imgSrcs.count;
}

// 动画方式自动轮播停止后，也执行对应的数据调整
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self scrollViewDidEndDecelerating:scrollView];
}

// 用户开始拖拽时，停止定时器
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self stopLoopTimer];
}

// 用户拖拽结束，开启轮播
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self startLoopTimer];
}

#pragma mark - 定时器相关功能
- (void)startLoopTimer {
     NSTimeInterval time = self.timeInterval ? self.timeInterval : 2.0;
    self.timer = [XYWeakTimerTarget timerWithTimeInterval:time target:self selector:@selector(nextImage) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)stopLoopTimer {
    [self.timer invalidate];
    self.timer = nil;
}

- (void)nextImage {
    
    NSInteger currentPage = self.collectionView.contentOffset.x / self.collectionView.bounds.size.width;
        [self.collectionView setContentOffset:CGPointMake((currentPage + 1) * self.collectionView.bounds.size.width, 0) animated:YES];
}

@end




















