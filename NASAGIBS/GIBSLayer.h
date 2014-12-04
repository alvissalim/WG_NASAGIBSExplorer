//
//  TR1Layer.h
//  NASAGIBS
//
//  Created by MSaktiAlvissalim on 2014/11/05.
//  Copyright (c) 2014年 Alvis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GIBSLayer : NSObject

@property NSString *name;
@property NSString *timeRange;
@property NSString *compatibility;
@property NSString *format;
@property NSDate *startDate;
@property NSDate *endDate;
@property NSString *metaDataUrl;
@property NSString *unitName;
@property NSString *minVal;
@property NSString *maxVal;
@end
