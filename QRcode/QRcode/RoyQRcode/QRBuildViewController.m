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
#define BuilderButtonWidth 60
#define BuilderTextFieldHeight 40
#define MyColor(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0];

@interface QRBuildViewController ()<UITextFieldDelegate>
{
    UITextField *_textField;
    UIImageView *QRView;
    NSString *QRString;
}


@end

@implementation QRBuildViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self buildUI];
    QRString = @"Roy";
    [self gen];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)buildUI{
    self.title = NSLocalizedString(@"生成二维码", nil);
    self.view.backgroundColor = [UIColor whiteColor];
    


    //输入框
    float y = 74;
    _textField = [[UITextField alloc]initWithFrame:CGRectMake(10, y, self.view.bounds.size.width-10*2-3-BuilderButtonWidth, BuilderTextFieldHeight)];
    _textField.backgroundColor = [UIColor whiteColor];
    _textField.placeholder = @"输入字符生成二维码";
    _textField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _textField.layer.borderWidth = 1;
    _textField.clearButtonMode = UITextFieldViewModeAlways;
    _textField.returnKeyType = UIReturnKeyDone;
    _textField.delegate = self;
    [self.view addSubview:_textField];
    
    //确认button
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(_textField.frame.origin.x+_textField.frame.size.width+3, y, BuilderButtonWidth, BuilderTextFieldHeight)];
    [btn setTitle:@"生成" forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor whiteColor];
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    btn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    btn.layer.borderWidth = 1;
    [btn addTarget:self action:@selector(btnTaped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    
    
    //二维码
    y += BuilderTextFieldHeight;
    y += 10;
    QRView = [[UIImageView alloc] init];
    QRView.center = self.view.center;
    QRView.frame = CGRectMake(10, y, self.view.bounds.size.width-10*2, self.view.bounds.size.width-10*2);
    QRView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:QRView];
    
    //labelView
    
    y += QRView.bounds.size.height;
    y += 5;
    
    UIView *addView = [[UIView alloc]initWithFrame:CGRectMake(QRView.frame.origin.x, y, QRView.frame.size.width, 30)];
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
    [_textField resignFirstResponder];
    QRString = _textField.text;
    [self gen];
}
//生成二维码的方法
-(void)gen{
    QRView.image = [self qrCodeImageWithString:QRString];
}


#pragma mark UItextField delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [_textField resignFirstResponder];
    QRString = _textField.text;
    [self gen];
    
    return YES;
}

#pragma mark- 相册读取相关

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
