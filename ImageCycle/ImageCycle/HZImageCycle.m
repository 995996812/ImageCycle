//
//  HZImageCycle.m
//  NetWork
//
//  Created by admin on 2019/1/24.
//  Copyright © 2019年 admin. All rights reserved.
//

#import "HZImageCycle.h"

#define kScreenW [UIScreen mainScreen].bounds.size.width

@interface HZImageCycle()<UIScrollViewDelegate>

@property(nonatomic, strong) UIScrollView *scrollView;

@property(nonatomic, strong) UIImageView *image1;

@property(nonatomic, strong) UIImageView *image2;

@property(nonatomic, strong) UIImageView *image3;

@property(nonatomic, assign) NSInteger index;

@property(nonatomic, strong) NSMutableArray *imgArr;

@property(nonatomic, strong) NSTimer *timer;

@property (nonatomic, assign) BOOL isTimer;
@end
@implementation HZImageCycle
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self configCycle:frame];
    }
    return self;
}

- (void)configCycle:(CGRect)frame{
    
    [self addSubview:self.scrollView];
    [self.scrollView addSubview:self.image1];
    [self.scrollView addSubview:self.image2];
    [self.scrollView addSubview:self.image3];
    
    self.index = 0;
    
    self.scrollView.contentSize = CGSizeMake(kScreenW * 3, frame.size.height);
    
    self.scrollView.contentOffset = CGPointMake(kScreenW, 0);
}

- (void)setDataSource:(NSArray *)dataSource{
    _dataSource = dataSource;
    
    [self.imgArr addObjectsFromArray:dataSource];
    [self setImagData:self.image1 index:self.imgArr.count - 1];
    [self setImagData:self.image2 index:self.index];
    [self setImagData:self.image3 index:self.index + 1];
    
    //创建定时器
    [self configTimer];
}

- (void)configTimer{
    if (self.timer == nil) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(automaticCycle) userInfo:nil repeats:YES];
    }
}

- (void)automaticCycle{
    NSLog(@"111");
    self.isTimer = YES;
    [self.scrollView setContentOffset:CGPointMake(kScreenW * 2, 0) animated:YES];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    //NSLog(@"%f",scrollView.contentOffset.x);
    
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    NSLog(@"%s",__func__);
    if (self.isTimer) {
        [self setImageData:scrollView];
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView;{
    [self.timer invalidate];
    self.timer = nil;
    self.isTimer = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self setImageData:scrollView];
    
    __weak typeof(self)weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
      [weakSelf configTimer];
    });
}

- (void)setImageData:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.x > kScreenW) {
        self.index++;
        if (self.index == (self.imgArr.count - 1)) {
            [self setImagData:self.image1 index:self.index - 1];
            [self setImagData:self.image2 index:self.index];
            [self setImagData:self.image3 index:0];
        }else{
            if (self.index == self.imgArr.count) {
                self.index = 0;
                [self setImagData:self.image1 index:self.imgArr.count - 1];
            }else{
                [self setImagData:self.image1 index:self.index - 1];
            }
            [self setImagData:self.image2 index:self.index];
            [self setImagData:self.image3 index:self.index + 1];
        }
    }
    if (scrollView.contentOffset.x < kScreenW) {
        if (self.index == 0) {
            self.index = self.imgArr.count - 1;
            [self setImagData:self.image1 index:self.index - 1];
            [self setImagData:self.image2 index:self.index];
            [self setImagData:self.image3 index:0];
        }else{
            self.index--;
            if (self.index == 0) {
                [self setImagData:self.image1 index:self.imgArr.count - 1];
            }else{
                [self setImagData:self.image1 index:self.index - 1];
            }
            [self setImagData:self.image2 index:self.index];
            [self setImagData:self.image3 index:self.index + 1];
        }
    }
    
    [self.scrollView setContentOffset:CGPointMake(kScreenW, 0) animated:NO];
}

- (void)setImagData:(UIImageView *)imgView index:(NSInteger)index{
    imgView.userInteractionEnabled = YES;
    imgView.image = [UIImage imageNamed:self.imgArr[index]];
    imgView.tag = index;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickImageMethod:)];
    [imgView addGestureRecognizer:tap];
}

- (void)clickImageMethod:(UITapGestureRecognizer *)tap{
    
    if (self.didSelectImageBlock) {
        self.didSelectImageBlock(self.index);
    }
    
}
// MARK: - lazy
- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, self.frame.size.height)];
        _scrollView.backgroundColor = [UIColor redColor];
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.bounces = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}

- (UIImageView *)image1{
    if (!_image1) {
        _image1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, self.frame.size.height)];
    }
    return _image1;
}

- (UIImageView *)image2{
    if (!_image2) {
        _image2 = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenW, 0, kScreenW, self.frame.size.height)];
    }
    return _image2;
}

- (UIImageView *)image3{
    if (!_image3) {
        _image3 = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenW * 2, 0, kScreenW, self.frame.size.height)];
    }
    return _image3;
}

- (NSMutableArray *)imgArr{
    if (!_imgArr) {
        _imgArr = [NSMutableArray arrayWithCapacity:5];
    }
    return _imgArr;
}


@end
