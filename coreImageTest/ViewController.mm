//
//  ViewController.m
//  coreImageTest
//
//  Created by Colin on 14/11/19.
//  Copyright (c) 2014年 icephone. All rights reserved.
//

#import "ViewController.h"
#include "cubeMap.c"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    int padding = 10;
    int width =([UIScreen mainScreen].bounds.size.width-3*padding)*0.5;
    
    UIImageView *profileImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 30, width, width)];
    profileImageView.image = [UIImage imageNamed:@"testPic1"];
    [self.view addSubview:profileImageView];
    
    UIImageView *backgroundImageView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(profileImageView.frame) +padding, 30, width, width)];
    backgroundImageView.image = [UIImage imageNamed:@"background1"];
    [self.view addSubview:backgroundImageView];
    
    
    
    
    UIImageView *myImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(profileImageView.frame)+padding, [UIScreen mainScreen].bounds.size.width-2*padding, 300)];
    myImageView.image = [UIImage imageNamed:@"testPic1"];
    [self.view addSubview:myImageView];

    UIImage *backgroundImage = [UIImage imageNamed:@"background1"];
    
    CubeMap myCube = createCubeMap(210,240); //最重要的地方:CubeMap 参数(float minHueAngle, float maxHueAngle)
    NSData *myData = [[NSData alloc]initWithBytesNoCopy:myCube.data length:myCube.length freeWhenDone:true];
    CIFilter *colorCubeFilter = [CIFilter filterWithName:@"CIColorCube"];
    [colorCubeFilter setValue:[NSNumber numberWithFloat:myCube.dimension] forKey:@"inputCubeDimension"];
    [colorCubeFilter setValue:myData forKey:@"inputCubeData"];
    [colorCubeFilter setValue:[CIImage imageWithCGImage:myImageView.image.CGImage] forKey:kCIInputImageKey];

    CIImage *outputImage = colorCubeFilter.outputImage;
    CIFilter *sourceOverCompositingFilter = [CIFilter filterWithName:@"CISourceOverCompositing"];
    [sourceOverCompositingFilter setValue:outputImage forKey:kCIInputImageKey];
    [sourceOverCompositingFilter setValue:[CIImage imageWithCGImage:backgroundImage.CGImage] forKey:kCIInputBackgroundImageKey];
    
    outputImage = sourceOverCompositingFilter.outputImage;
    CGImage *cgImage = [[CIContext contextWithOptions: nil]createCGImage:outputImage fromRect:outputImage.extent];
    myImageView.image = [UIImage imageWithCGImage:cgImage];
	// Do any additional setup after loading the view, typically from a nib.
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
