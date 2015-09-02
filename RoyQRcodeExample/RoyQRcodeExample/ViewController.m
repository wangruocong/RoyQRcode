//
//  ViewController.m
//  RoyQRcodeExample
//
//  Created by Roy on 15/9/2.
//  Copyright (c) 2015年 wangruocong. All rights reserved.
//

#import "ViewController.h"
#import "QRViewController.h"
#import "QRBuildViewController.h"
@interface ViewController ()
- (IBAction)Scan_QR_code_Btn:(UIButton *)sender;
- (IBAction)Show_QR_code_Btn:(UIButton *)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)Scan_QR_code_Btn:(UIButton *)sender {
    QRViewController *qrVC = [[QRViewController alloc]init];
    [self.navigationController pushViewController:qrVC animated:YES];
    
}

- (IBAction)Show_QR_code_Btn:(UIButton *)sender {
    QRBuildViewController *qrbVc = [[QRBuildViewController alloc]init];
    [self.navigationController pushViewController:qrbVc animated:YES];
}
@end
