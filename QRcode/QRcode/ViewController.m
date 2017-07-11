//
//  ViewController.m
//  QRcode
//
//  Created by 王若聪 on 2017/4/8.
//  Copyright © 2017年 leve. All rights reserved.
//

#import "ViewController.h"
#import "QRViewController.h"
#import "QRBuildViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //test
}
- (void)test{
    //
};

- (IBAction)scan:(UIButton *)sender {
    QRViewController *qrVC = [[QRViewController alloc]init];
    [self.navigationController pushViewController:qrVC animated:YES];
}
- (IBAction)gen:(UIButton *)sender {
    QRBuildViewController *qrbVc = [[QRBuildViewController alloc]init];
    [self.navigationController pushViewController:qrbVc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
