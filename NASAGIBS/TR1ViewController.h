//
//  TR1ViewController.h
//  NASAGIBS
//
//  Created by MSaktiAlvissalim on 2014/10/10.
//  Copyright (c) 2014年 Alvis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WhirlyGlobeComponent.h"
#import "SettingViewController.h"
#import "TR1Layer.h"

@interface TR1ViewController : UIViewController <WhirlyGlobeViewControllerDelegate>

@property OptionType option;

@property TR1Layer *selectedLayer;
@property TR1Layer *overlayLayer;

@end
