//
//  ZQFCycleView.m
//  ZQFCycleViewDemo
//
//  Created by Work on 15/7/24.
//  Copyright (c) 2015年 zengqingfu. All rights reserved.
//

#define LABELHEIGHT 30

#import "ZQFCycleView.h"
@interface ZQFCycleView() <UIScrollViewDelegate>


@property (nonatomic, strong)UIView *backView;
@property (nonatomic, strong)UIScrollView *scrollView;

@property (nonatomic, strong)UIImageView *imageV1;
@property (nonatomic, strong)UIImageView *imageV2;
@property (nonatomic, strong)UIImageView *imageV3;

@property (nonatomic, strong)UILabel *titleLabel;

@property (nonatomic, strong)UIPageControl *pageControl;
@property (nonatomic, strong)UITapGestureRecognizer *tapGestureRecognizer;
@property (nonatomic, strong)NSTimer *timer;

@property (nonatomic, assign)NSInteger currentPage;
@property (nonatomic, assign)NSInteger totalCount;

@property (nonatomic, assign)BOOL isTimerFirst;
@end

@implementation ZQFCycleView

//纯代码初始化方法
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self config];
        //[self reset];
    }
    return self;
}

//xib初始化方法
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self config];
    }
    return self;
}
//reload
- (void)reload
{
    [self reset];
}

//配置子视图
- (void)config
{
    //设置手势
    self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    
    //设置一个BackView
    self.backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    _backView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [self addSubview:_backView];
    [_backView addGestureRecognizer:self.tapGestureRecognizer];
    
    //设置ScrollView
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.delegate = self;
    [self.backView addSubview:_scrollView];
    
    //设置Image1
    self.imageV1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [self.scrollView addSubview:_imageV1];
    
    //设置Image2
    self.imageV2 = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height)];
    [self.scrollView addSubview:_imageV2];
    
    //设置Image3
    self.imageV3 = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width * 2, 0, self.frame.size.width, self.frame.size.height)];
    [self.scrollView addSubview:_imageV3];
    
    //设置TitleLabel
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height - LABELHEIGHT, self.frame.size.width, LABELHEIGHT)];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.backView addSubview:_titleLabel];
    
    //设置pageControl
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.frame.size.height - LABELHEIGHT * 2, self.frame.size.width, LABELHEIGHT)];
    _pageControl.userInteractionEnabled = NO;
    [self.backView addSubview:_pageControl];
    
}


//一共有多少图片
- (NSInteger)totalCount
{
    NSInteger tempCount = [_delegate countOfCycleView:self];
    if (tempCount != _totalCount) {
        //_currentPage = 0;
        _totalCount = tempCount;
        self.pageControl.numberOfPages = _totalCount;
    }
    return _totalCount;
}

//tap点击的时候
- (void)tapAction:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(cycleView:didTouchImageView:titleLabel:index:)]) {
        [_delegate cycleView:self didTouchImageView:self.imageV2 titleLabel:self.titleLabel index:_currentPage];
    }
}

//定时器行为
- (void)timerAction:(id)sender
{
    if (_isTimerFirst) {
        _isTimerFirst = NO;//定时器启动的时候会上来就执行方法，这行代码是抛弃第一次执行
        return;
    }
    if (self.scrollView.isDragging || self.scrollView.isDecelerating) {
        return;//拖拽或者正在动的过程中忽略定时器作用
    }else {
        [self nextPage];
    }
}

//重置子视图的frame
- (void)layoutSubviews
{
    [self reloadFrames];
    [self reset];
}

- (void)reloadFrames
{
    self.scrollView.contentSize = CGSizeMake(self.frame.size.width * 3, self.frame.size.height);
    self.imageV1.frame = CGRectMake(self.frame.size.width * 0, 0, self.frame.size.width, self.frame.size.height);
    self.imageV2.frame = CGRectMake(self.frame.size.width * 1, 0, self.frame.size.width, self.frame.size.height);
    self.imageV3.frame = CGRectMake(self.frame.size.width * 2, 0, self.frame.size.width, self.frame.size.height);
    
    self.titleLabel.frame = CGRectMake(0, self.frame.size.height - LABELHEIGHT, self.frame.size.width, LABELHEIGHT);
    
    self.pageControl.frame = CGRectMake(0, self.frame.size.height - LABELHEIGHT * 2, self.frame.size.width, LABELHEIGHT);
}


//重置图片
- (void)resetImages
{
    NSInteger totalCount = self.totalCount;
    if (totalCount == 0) {
        return;//表示没有图片
    }
    NSInteger index1 = (_currentPage - 1 + totalCount) % totalCount;
    NSInteger index2 = _currentPage;
    NSInteger index3 = (_currentPage + 1 + totalCount) % totalCount;
    
    if (_delegate && [_delegate respondsToSelector:@selector(cycleView:willDisplayImageView:index:)]) {
        [_delegate cycleView:self willDisplayImageView:self.imageV1 index:index1];
        [_delegate cycleView:self willDisplayImageView:self.imageV2 index:index2];
        [_delegate cycleView:self willDisplayImageView:self.imageV3 index:index3];
    }
}


//重置标题
- (void)resetLabel
{
    if(_delegate && [_delegate respondsToSelector:@selector(cycleView:didDisplayTitleLabel:index:)]){
        [_delegate cycleView:self didDisplayTitleLabel:self.titleLabel index:_currentPage];
    }
}


//重置偏移量
- (void)resetOffset
{
    CGPoint offset = CGPointMake(self.frame.size.width, 0);
    [self.scrollView setContentOffset:offset];
}
- (void)reset
{
    [self resetOffset];
    [self resetImages];
    [self resetLabel];
}

//当前页数减一
- (void)currentPageDown
{
    _currentPage = (_currentPage - 1 + self.totalCount) % self.totalCount;
    self.pageControl.currentPage = _currentPage;
}
//当前页数加一
- (void)currentPageUp
{
    _currentPage = (_currentPage + 1) % self.totalCount;
    self.pageControl.currentPage = _currentPage;
}
//下一页
- (void)nextPage
{
    CGPoint offset = CGPointMake(self.scrollView.frame.size.width * 2, 0);
    [self.scrollView setContentOffset:offset animated:YES];
}

//定时器开始播放
- (void)startPlayWithTimeInterval:(NSTimeInterval)ti;
{
    if(_timer == nil){
        _isTimerFirst = YES;
        self.timer = [NSTimer scheduledTimerWithTimeInterval:ti target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
    }
    [self.timer fire];
}

//停止播放
- (void)stopPlay
{
    if (_timer) {
        [_timer invalidate];
        self.timer = nil;
    }
}
#pragma mark - strollView代理-
//代理
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint currentOffset = self.scrollView.contentOffset;
    if (currentOffset.x <= 0) {
        [self currentPageDown];
        [self reset];
    } else if (currentOffset.x >= self.scrollView.frame.size.width*2) {
        [self currentPageUp];
        [self reset];
    }
    
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    
    CGPoint currentOffset = self.scrollView.contentOffset;
    CGFloat width = self.scrollView.frame.size.width;
    
    if(currentOffset.x > width && currentOffset.x < width * 2){
        [self nextPage];
    }
}

@end
