//
//  ViewController.m
//  ceshi
//
//  Created by MAC on 16/6/13.
//  Copyright © 2016年 MAC. All rights reserved.
//
#import "ViewController.h"

#define kCount 8

@interface ViewController ()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *visibleView;
@property (weak, nonatomic) IBOutlet UIImageView *reuseView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CGFloat w = self.view.frame.size.width;
    CGFloat h = self.view.frame.size.height;
    
    // 初始化scrollView
    _scrollView.pagingEnabled = YES;
    _scrollView.contentSize = CGSizeMake(w * 3, 0);
    _scrollView.contentOffset = CGPointMake(w, 0);
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.delegate = self;
    
    // 创建可见的imageView
    UIImageView *visibleView = [[UIImageView alloc] init];
    _visibleView = visibleView;
    _visibleView.image = [UIImage imageNamed:@"00"];
    _visibleView.frame = CGRectMake(w, 0, w, h);
    _visibleView.tag = 0;
    [_scrollView addSubview:_visibleView];
    
    // 创建重复利用的imageView
    UIImageView *reuseView = [[UIImageView alloc] init];
    _reuseView = reuseView;
    _reuseView.frame = self.view.bounds;
    [_scrollView addSubview:_reuseView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 获取偏移量
    CGFloat offsetX = scrollView.contentOffset.x;
    CGFloat w = scrollView.frame.size.width;
    
    // 1.设置 循环利用view 的位置
    CGRect f = _reuseView.frame;
    NSInteger index = 0;
    
    if (offsetX > _visibleView.frame.origin.x) { // 显示在最右边
        
        f.origin.x = scrollView.contentSize.width - w;
        
        index = _visibleView.tag + 1;
        if (index >= kCount) index = 0;
    } else { // 显示在最左边
        f.origin.x = 0;
        
        index = _visibleView.tag - 1;
        if (index < 0) index = kCount - 1;
    }
    
    // 设置重复利用的视图
    _reuseView.frame = f;
    _reuseView.tag = index;
    NSString *icon = [NSString stringWithFormat:@"0%ld", index];
    _reuseView.image = [UIImage imageNamed:icon];
    
    
    // 2.滚动到 最左 或者 最右 的图片
    if (offsetX <= 0 || offsetX >= w * 2) {
        // 2.1.交换 中间的 和 循环利用的指针
        UIImageView *temp = _visibleView;
        _visibleView = _reuseView;
        _reuseView = temp;
        
        // 2.2.交换显示位置
        _visibleView.frame = _reuseView.frame;
        
        // 2.3 初始化scrollView的偏移量
        scrollView.contentOffset = CGPointMake(w, 0);
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
