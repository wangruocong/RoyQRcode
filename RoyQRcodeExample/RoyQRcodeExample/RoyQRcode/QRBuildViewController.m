//
//  DGTQRBuilderViewController.m
//  GeniusTalk
//
//  Created by Roy on 15/8/26.
//  Copyright (c) 2015年 DJI TECHNOLOGY CO., LTD. All rights reserved.
//

#import "QRBuildViewController.h"


#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define MyColor(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0];

@interface QRBuildViewController ()
{
    UITextField *textField;
    UIImageView *QRView;
    NSString *QRString;
}


@end

@implementation QRBuildViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"My QR code", nil);
    self.view.backgroundColor = [UIColor whiteColor];
    [self buildUI];
    QRString = @"Roy";
    [self gen];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)buildUI{
    //二维码
    //宽度
    CGFloat QRWidth = SCREEN_WIDTH*0.6;
    QRView = [[UIImageView alloc] init];
    QRView.frame = CGRectMake((SCREEN_WIDTH-QRWidth)/2, SCREEN_HEIGHT*0.3, QRWidth, QRWidth);
    QRView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:QRView];
    
    //输入框
    textField = [[UITextField alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-QRWidth)/2-40, 100, QRWidth+40, 40)];
    textField.backgroundColor = [UIColor whiteColor];
    textField.placeholder = @"input something";
    textField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    textField.layer.borderWidth = 1;
    [self.view addSubview:textField];
    
    //确认button
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-QRWidth)/2+textField.frame.size.width-32, 100, 70, 40)];
    [btn setTitle:@"genrate" forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor whiteColor];
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    btn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    btn.layer.borderWidth = 1;
    [btn addTarget:self action:@selector(btnTaped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    //labelView
    UIView *addView = [[UIView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-QRWidth-60)/2, SCREEN_HEIGHT*0.65, QRWidth+60, 30)];
    addView.backgroundColor = [UIColor colorWithRed:240.0/255.0 green:242.0/255.0 blue:243.0/255.0 alpha:1];
    UILabel *addLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, addView.frame.size.width-30, 30)];
    addLabel.textColor = [UIColor grayColor];
    addLabel.font = [UIFont systemFontOfSize:14];
    addLabel.text = NSLocalizedString(@"扫一扫二维码，即可与我发起会话", nil);
    addLabel.textAlignment = NSTextAlignmentCenter;
    addView.layer.cornerRadius = addView.frame.size.height/2;
    [addView addSubview:addLabel];
    [self.view addSubview:addView];
}
- (void)btnTaped
{
    [textField resignFirstResponder];
    QRString = textField.text;
    [self gen];
}
//生成二维码的方法
-(void)gen{
    QRView.image = [self qrCodeImageWithString:QRString];
}


-(UIImage*)qrCodeImageWithString:(NSString*)str{
    if (str && [str isKindOfClass:[NSString class]] && str.length > 0) {
        return [self createNonInterpolatedUIImageFromCIImage:[self createQRForString:str]
                                                   withScale:2*[[UIScreen mainScreen] scale]];
    }
    return nil;
}

- (CIImage *)createQRForString:(NSString *)qrString
{
    // Need to convert the string to a UTF-8 encoded NSData object
    NSData *stringData = [qrString dataUsingEncoding: NSISOLatin1StringEncoding];
    
    // Create the filter
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // Set the message content and error-correction level
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    [qrFilter setValue:@"H" forKey:@"inputCorrectionLevel"];
    
    // Send the image back
    return qrFilter.outputImage;
}

- (UIImage *)createNonInterpolatedUIImageFromCIImage:(CIImage *)image withScale:(CGFloat)scale
{
    // Render the CIImage into a CGImage
    CGImageRef cgImage = [[CIContext contextWithOptions:nil] createCGImage:image fromRect:image.extent];
    // Now we'll rescale using CoreGraphics
    UIGraphicsBeginImageContext(CGSizeMake(image.extent.size.width * scale, image.extent.size.width * scale));
    CGContextRef context = UIGraphicsGetCurrentContext();
    // We don't want to interpolate (since we've got a pixel-correct image)
    CGContextSetInterpolationQuality(context, kCGInterpolationNone);
    CGContextDrawImage(context, CGContextGetClipBoundingBox(context), cgImage);
    // Get the image out
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // Tidy up
    UIGraphicsEndImageContext();
    CGImageRelease(cgImage);
    return scaledImage;
}


@end
