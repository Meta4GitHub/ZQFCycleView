# ZQFCycleView
纯代码写出来的无限轮播图，可以轻松的使用第三方比如SDImage等异步加载轮播图上的图片

---
作者的新浪微博是 [@爱编程的小福子](http://weibo.com/zengqingf) 记得关注我哦！

---

##开始使用ZQFCycleView
### 创建轮播图


```objective-c
self.cycleView = [[ZQFCycleView alloc] initWithFrame:CGRectMake(0, 20, width, 180) delegate:self];
[self.view addSubview:_cycleView];
```

#### 实现代理方法

```objective-c
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
//点击触发的
- (void)cycleView:(ZQFCycleView *)cycleView didTouchImageView:(UIImageView *)imageView  titleLabel:(UILabel *)titleLabel index:(NSInteger)index{
    NSLog(@"%@", [NSString stringWithFormat:@"当前点击的是：%ld", index]);
}
```

#### 开始播放

```objective-c
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.cycleView startPlayWithTimeInterval:5];//轮播图开始播放
}
```

#### 停止播放

```objective-c
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.cycleView stopPlay];//控制器消失的时候记得停止轮播图的定时器，否则可能出现内存泄露
}
```
