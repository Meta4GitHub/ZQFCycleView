//
//  ViewController.m
//  ZQFCycleViewDemo
//
//  Created by Work on 15/7/24.
//  Copyright (c) 2015年 zengqingfu. All rights reserved.
//

#import "ViewController.h"
#import "ZQFCycleView.h"
@interface ViewController ()<ZQFCycleViewDelegate>
@property (nonatomic, strong)NSMutableArray *dataArr;
@property (strong, nonatomic) ZQFCycleView *cycleView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.dataArr = [NSMutableArray arrayWithCapacity:7];
    for (NSInteger i = 0; i < 8; i++) {//创建数据源
        UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"%ld.jpg", i]];
        [self.dataArr addObject:img];
    }

    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    self.cycleView = [[ZQFCycleView alloc] initWithFrame:CGRectMake(0, 20, width, 180)];
    _cycleView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleWidth;
    _cycleView.delegate = self;
    [self.view addSubview:_cycleView];
    [_cycleView reload];//一定要执行此方法，否则图片将不会显示

}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.cycleView startPlayWithTimeInterval:5];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.cycleView stopPlay];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//返回图片的个数

- (NSInteger)countOfCycleView:(ZQFCycleView *)cycleView{
    return self.dataArr.count;
}


//设置imageview
- (void)cycleView:(ZQFCycleView *)cycleView willDisplayImageView:(UIImageView *)imageView index:(NSInteger)index{
    imageView.image = self.dataArr[index];
}

//滑动停止的时候显示标签
- (void)cycleView:(ZQFCycleView *)cycleView didDisplayTitleLabel:(UILabel *)titleLabel index:(NSInteger)index{
    titleLabel.text = [NSString stringWithFormat:@"当前的索引是：%ld", index];
}

//点击触发的
- (void)cycleView:(ZQFCycleView *)cycleView didTouchImageView:(UIImageView *)imageView  titleLabel:(UILabel *)titleLabel index:(NSInteger)index{
    NSLog(@"%@", [NSString stringWithFormat:@"当前点击的是：%ld", index]);
}


@end
