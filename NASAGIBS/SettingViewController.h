//
//  SettingViewController.h
//  NASAGIBS
//
//  Created by MSaktiAlvissalim on 2014/10/11.
//  Copyright (c) 2014年 Alvis. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {EarthQuakeOption,StadiumOption} OptionType;

@interface SettingViewController : UITableViewController

@property OptionType optionType;
@end
