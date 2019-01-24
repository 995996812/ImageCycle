//
//  ViewController.m
//  ImageCycle
//
//  Created by admin on 2019/1/24.
//  Copyright © 2019年 admin. All rights reserved.
//

#import "ViewController.h"
#import "HZImageCycle.h"
@interface ViewController ()

@property (nonatomic, strong) HZImageCycle *imageCycle;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.view addSubview:self.imageCycle];
    self.imageCycle.dataSource = @[@"timg.jpg",@"timg1.jpg",@"timg2.jpg",@"timg3.jpg"];
    
    self.imageCycle.didSelectImageBlock = ^(NSInteger index) {
      
        NSLog(@"%ld",(long)index);
    };
}

- (HZImageCycle *)imageCycle{
    if (!_imageCycle) {
        _imageCycle = [[HZImageCycle alloc]initWithFrame:CGRectMake(0, 200, [UIScreen mainScreen].bounds.size.width, 200)];
    }
    return _imageCycle;
}
@end
