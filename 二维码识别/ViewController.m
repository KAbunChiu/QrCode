//
//  ViewController.m
//  二维码识别
//
//  Created by KAbun on 17/4/19.
//  Copyright © 2017年 KABIN. All rights reserved.
//

#import "ViewController.h"
#import "QRCodeGenerator.h"

#define KABINColor [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1]

@interface ViewController ()

@property(nonatomic,strong)UIImageView *ErWeiMaView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.ErWeiMaView=[[UIImageView alloc]initWithFrame:CGRectMake(40, 110, self.view.frame.size.width-80, [UIScreen mainScreen].bounds.size.height/2-60)];
    UITapGestureRecognizer *Taps=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(shibiema:)];
    self.ErWeiMaView.userInteractionEnabled=YES;
    [self.ErWeiMaView addGestureRecognizer:Taps];
    [self.view addSubview:self.ErWeiMaView];
    
    UIImage *image;
    image=self.ErWeiMaView.image;
    NSString *tempStr;
    tempStr=[NSString stringWithFormat:@"https://github.com/KAbunChiu"];
    UIImage *tempImage=[QRCodeGenerator qrImageForString:tempStr imageSize:360 Topimg:image withColor:KABINColor];
    self.ErWeiMaView.image=tempImage;
    
}

-(void)shibiema:(UITapGestureRecognizer *)tap{
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"请选择" message:nil preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *sbm=[UIAlertAction actionWithTitle:@"识别二维码" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
        if (self.ErWeiMaView.image) {
            //1. 初始化扫描仪，设置设别类型和识别质量
            CIDetector*detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{ CIDetectorAccuracy : CIDetectorAccuracyHigh }];
            //2. 扫描获取的特征组
            NSArray *features = [detector featuresInImage:[CIImage imageWithCGImage:self.ErWeiMaView.image.CGImage]];
            //3. 获取扫描结果
            CIQRCodeFeature *feature = [features objectAtIndex:0];
            NSString *scannedResult = feature.messageString;
            [self accordingQcode:scannedResult];
        }else{
            UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"扫描结果" message:@"您还没有生成二维码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }
    }];
    
    UIAlertAction *save=[UIAlertAction actionWithTitle:@"保存至相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
         UIImageWriteToSavedPhotosAlbum(self.ErWeiMaView.image, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
    }];
    
    [alert addAction:sbm];
    [alert addAction:save];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)accordingQcode:(NSString *)str
{
    NSURL *url = [NSURL URLWithString:str];
    [[UIApplication sharedApplication]openURL:url];
    
}

- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    //保存成功提示
}

@end
