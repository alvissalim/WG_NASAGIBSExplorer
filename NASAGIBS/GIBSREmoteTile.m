//
//  GIBSREmoteTile.m
//  NASAGIBS
//
//  Created by MSaktiAlvissalim on 2014/10/10.
//  Copyright (c) 2014年 Alvis. All rights reserved.
//

#import "GIBSREmoteTile.h"
#import "QuakeParser.h"

@implementation GIBSREmoteTile

- (NSURLRequest *)requestForTile:(MaplyTileID)tileID

{
    
    int y = ((int)(1<<tileID.level)-tileID.y)-1;
    
    NSMutableURLRequest *urlReq = nil;
    
    // Fetch the traditional way
    
    NSMutableString *fullURLStr = [NSMutableString stringWithFormat:@"%@%d/%d/%d.%@",self.baseURL,tileID.level,y,tileID.x,self.ext];
    
    
    urlReq = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:fullURLStr]];
    
    if (self.timeOut != 0.0)
        
        [urlReq setTimeoutInterval:self.timeOut];
    
    return urlReq;
    
}

@end
