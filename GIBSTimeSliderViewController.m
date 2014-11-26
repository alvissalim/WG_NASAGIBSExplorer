//
//  SliderViewController.m
//  NASAGIBS
//
//  Created by MSaktiAlvissalim on 2014/11/20.
//  Copyright (c) 2014年 Alvis. All rights reserved.
//


#import "GIBSTimeSliderViewController.h"

@interface GIBSTimeSliderViewController ()

@end

@implementation GIBSTimeSliderViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //[self.view setBackgroundColor:[UIColor redColor]];
    // Do any additional setup after loading the view.
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    _slider = [[UISlider alloc] initWithFrame:CGRectMake(10,screenHeight - 30,screenWidth - 20,10)];
    
    _slider.minimumValue = 0.0;
    _slider.maximumValue = 50.0;
    _slider.continuous = YES;
    _slider.value = 25.0;
    
    [_slider setBackgroundColor:[UIColor clearColor]];
//    [_slider addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventValueChanged];
    
    
    [self.view addSubview:_slider];
    
   
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
