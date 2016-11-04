//
//  ViewController.m
//  PicShow
//
//  Created by wanggang on 2016/11/4.
//  Copyright © 2016年 wanggang. All rights reserved.
//

#import "ViewController.h"
#import "GPUImage.h"

@interface ViewController ()

@property (nonatomic)CGRect sizeRect;
@property (strong,nonatomic)UIImage *originaImage;
@property (strong,nonatomic)UIImage *currentImage;
@property (weak, nonatomic) IBOutlet UIImageView *someIamge;
@property (strong, nonatomic) GPUImageVignetteFilter *filter;
@property (weak, nonatomic) IBOutlet UIButton *aband;
@property (weak, nonatomic) IBOutlet UIButton *save;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _sizeRect = self.someIamge.frame;
}

- (IBAction)lightChange:(UISlider *)sender {
    //初始化滤镜
    GPUImageBrightnessFilter *light = [[GPUImageBrightnessFilter alloc] init];
    [light forceProcessingAtSize:self.someIamge.frame.size];
    [light useNextFrameForImageCapture];
    //更改滤镜的值
    light.brightness = sender.value;

    [self getThePicNeedChange:light];
}

- (IBAction)contrastChange:(UISlider *)sender {
    GPUImageContrastFilter *contrast = [[GPUImageContrastFilter alloc] init];
    [contrast forceProcessingAtSize:self.someIamge.frame.size];
    [contrast useNextFrameForImageCapture];
    contrast.contrast = sender.value;
    [self getThePicNeedChange:contrast];
}

- (IBAction)saturabilityChange:(UISlider *)sender {
    GPUImageSaturationFilter *saturability = [[GPUImageSaturationFilter alloc] init];
    [saturability forceProcessingAtSize:self.someIamge.frame.size];
    [saturability useNextFrameForImageCapture];
    saturability.saturation = sender.value;
    [self getThePicNeedChange:saturability];
}

- (IBAction)drawingStyle:(UIButton *)sender {
    GPUImageSketchFilter *drawingStyle = [[GPUImageSketchFilter alloc] init];
    [drawingStyle forceProcessingAtSize:self.someIamge.frame.size];
    [drawingStyle useNextFrameForImageCapture];
    [self getThePicNeedChange:drawingStyle];
}

- (IBAction)cortoonStyle:(id)sender {
    GPUImageToonFilter *cortoonStyle = [[GPUImageToonFilter alloc] init];
    [cortoonStyle forceProcessingAtSize:self.someIamge.frame.size];
    [cortoonStyle useNextFrameForImageCapture];
    [self getThePicNeedChange:cortoonStyle];
}

- (IBAction)mosaicStyle:(id)sender {
    GPUImageMaskFilter *mosaicStyle = [[GPUImageMaskFilter alloc] init];
    [mosaicStyle forceProcessingAtSize:self.someIamge.frame.size];
    [mosaicStyle useNextFrameForImageCapture];
    [self getThePicNeedChange:mosaicStyle];
}

- (IBAction)reliefStyle:(id)sender {
    GPUImageEmbossFilter *reliefStyle = [[GPUImageEmbossFilter alloc] init];
    [reliefStyle forceProcessingAtSize:self.someIamge.frame.size];
    [reliefStyle useNextFrameForImageCapture];
    [self getThePicNeedChange:reliefStyle];
}

- (IBAction)aband:(id)sender {
    _aband.hidden = YES;
    _save.hidden = YES;
    [UIView animateWithDuration:0.25f animations:^{
        _someIamge.frame = _sizeRect;
    }];
    if ([[self.view viewWithTag:155] isKindOfClass:[UIImageView class]]) {
        UIImageView *iv = (UIImageView *)[self.view viewWithTag:155];
        [iv removeFromSuperview];
    }
}

- (IBAction)save:(id)sender {
    if (!_currentImage) {
        return;
    }
    UIImageWriteToSavedPhotosAlbum(_currentImage, self, nil, nil);
}

- (void)getThePicNeedChange:(GPUImageFilter *)filter{
    if (_aband.hidden && _save.hidden) {
        _aband.hidden = NO;
        _save.hidden = NO;
    }

    //获取需要改变的图片
    GPUImagePicture *gpuImage = [[GPUImagePicture alloc] initWithImage:self.originaImage];
    [gpuImage addTarget:filter];
    [gpuImage processImage];

    //获取改变后的图片
    self.currentImage = filter.imageFromCurrentFramebuffer;

    [self changeFrameWhenNewPicShow:self.currentImage];
}

- (void)changeFrameWhenNewPicShow:(UIImage *)newImage{
    [UIView animateWithDuration:0.25f animations:^{
        _someIamge.frame = CGRectMake(20, 20, 120, 120);
    }];
    [self showNewPic:self.currentImage];
}

- (void)showNewPic:(UIImage *)newImage{
    UIImageView *iv;
    if ([[self.view viewWithTag:155] isKindOfClass:[UIImageView class]]) {
        iv = (UIImageView *)[self.view viewWithTag:155];
        iv.image = newImage;
    }else{
        iv = [[UIImageView alloc] initWithImage:newImage];
        iv.backgroundColor = [UIColor redColor];
        iv.tag = 155;
        iv.frame = CGRectMake(self.view.frame.size.width-140, 20, 120, 120);
    }
    [self.view addSubview:iv];
}


- (GPUImageVignetteFilter *)filter{
    if (!_filter) {
        _filter = [[GPUImageVignetteFilter alloc] init];
        [_filter forceProcessingAtSize:self.someIamge.frame.size];
        [_filter useNextFrameForImageCapture];
    }
    return _filter;
}

- (UIImage *)originaImage{
    if (!_originaImage) {
        _originaImage = _someIamge.image;
    }
    return _originaImage;
}

- (UIImage *)currentImage{
    if (!_currentImage) {
        _currentImage = [[UIImage alloc] init];
    }
    return _currentImage;
}


@end
