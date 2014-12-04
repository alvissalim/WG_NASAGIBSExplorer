//
//  GIBSLegendBuilder.h
//  NASAGIBS
//
//  Created by MSaktiAlvissalim on 2014/12/03.
//  Copyright (c) 2014年 Alvis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GIBSLayer.h"

@interface GIBSLegendBuilder : NSObject <NSXMLParserDelegate>
- (id) initWithLayerObject:(GIBSLayer *) layer;

@property NSMutableArray * colorMapArray;

+ (UIImage *) getImage;
+ (NSArray*) getInfo;
@end
