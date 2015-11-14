//
//  ViewController.m
//  ZQFCycleViewDemo
//
//  Created by zqf on 15/11/15.
//  Copyright © 2015年 zengqingfu. All rights reserved.
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
    self.cycleView = [[ZQFCycleView alloc] initWithFrame:CGRectMake(0, 20, width, 180) delegate:self];
    _cycleView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:_cycleView];
    [_cycleView startPlayWithTimeInterval:5];
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
    //如果需要网络加载，这里可以使用第三方，比如SDImage等等
    imageView.image = self.dataArr[index];
}

//滑动停止的时候显示标签
- (void)cycleView:(ZQFCycleView *)cycleView didDisplayTitleLabel:(UILabel *)titleLabel index:(NSInteger)index{
    titleLabel.text = [NSString stringWithFormat:@"当前的索引是：%ld", index];
}

@end
