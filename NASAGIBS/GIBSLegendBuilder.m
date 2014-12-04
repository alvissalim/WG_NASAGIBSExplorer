//
//  GIBSLegendBuilder.m
//  NASAGIBS
//
//  Created by MSaktiAlvissalim on 2014/12/03.
//  Copyright (c) 2014年 Alvis. All rights reserved.
//

#import "GIBSLegendBuilder.h"

static UIImage *legendImage;
static NSMutableArray *legendInfo;

@implementation GIBSLegendBuilder

{
    bool colorMapValid;
    bool colorMapEntryValid;

    double minVal;
    double maxVal;
    
    
    NSString *minLabel;
    NSString *maxLabel;

    
    
    NSString *unit;
    
}

+ (UIImage *) getImage{
    return legendImage;
}

+ (NSArray*) getInfo{
    return legendInfo;
}


- (id) initWithLayerObject:(GIBSLayer *) layer
{
    NSString *urlStr = layer.metaDataUrl;
    
    _colorMapArray = [[NSMutableArray alloc] init];
    
    legendInfo = [[NSMutableArray alloc] init];
    
    NSURLRequest *urlReq = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [NSURLConnection sendAsynchronousRequest:urlReq
     // the NSOperationQueue upon which the handler block will be dispatched:
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               
                               NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:data];
                               xmlParser.delegate = self;
                               [xmlParser parse];
                               
                               
                           }];
    
    
    
    return self;
}

-(void) parserDidStartDocument:(NSXMLParser *)parser
{

}

-(void) parserDidEndDocument:(NSXMLParser *)parser{
    CGFloat width = [_colorMapArray count];
    CGFloat height = 1;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    size_t bitsPerComponent = 8;
    size_t bytesPerPixel    = 4;
    size_t bytesPerRow      = (width * bitsPerComponent * bytesPerPixel + 7) / 8;
    size_t dataSize         = bytesPerRow * height;
    
    unsigned char *data = malloc(dataSize);
    memset(data, 0, dataSize);
    
    CGContextRef context = CGBitmapContextCreate(data, width, height,
                                                 bitsPerComponent,
                                                 bytesPerRow, colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    
    for (int i=0; i<width; i++) {
        NSArray *instance = [_colorMapArray objectAtIndex:i];
        
        double R, G, B;
        
        R = [[instance objectAtIndex:0] doubleValue] / 255.0;
        
        G = [[instance objectAtIndex:1] doubleValue] / 255.0;
        
        B = [[instance objectAtIndex:2] doubleValue] / 255.0;
        // a drawing for a test.
        CGContextSetRGBFillColor (context, R, G, B, 1);
        CGContextFillRect (context, CGRectMake (i, 0, 1, 1 ));
    }
    
    
    CGColorSpaceRelease(colorSpace);
    CGImageRef imageRef = CGBitmapContextCreateImage(context);
    legendImage = [UIImage imageWithCGImage:imageRef];
    //CGImageRelease(imageRef);
    CGContextRelease(context);
    
    /*
    NSNumber *temp = [[NSNumber alloc] initWithDouble:minVal];
    [legendInfo addObject: [temp stringValue]];
    NSNumber *temp2 = [[NSNumber alloc] initWithDouble:maxVal];
    [legendInfo addObject: [temp2 stringValue]];
    */
    [legendInfo addObject:minLabel];
    
    [legendInfo addObject:maxLabel];
    
    
    [legendInfo addObject: unit];
    
}



-(void) parser:(NSXMLParser *) parser foundCharacters:(NSString *)string
{

}


-(void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:@"ColorMap"]){
        colorMapValid = true;
        
        unit = [attributeDict objectForKey:@"units"];
        
        colorMapEntryValid = false;
        
        // Reset max min values
        minVal = MAXFLOAT;
        maxVal = -MAXFLOAT;
        
        
        minLabel = nil;
    }
    else if ([elementName isEqualToString:@"ColorMapEntry"]  &&  colorMapValid == true){
        colorMapEntryValid = true;
        double tempVal =  [[attributeDict objectForKey:@"value"] doubleValue];
        
        if (minLabel == nil){
            minLabel = [attributeDict objectForKey:@"label"];
            
            if ([attributeDict objectForKey:@"value"] == nil){
                minLabel = nil;
            }
        }
        
        if ([attributeDict objectForKey:@"value"] != nil){
            maxLabel = [attributeDict objectForKey:@"label"];
        }
        // Update min values
        if (tempVal < minVal){
            minVal = tempVal;
        }
        
        // Update max values
        if (tempVal > maxVal){
            maxVal = tempVal;
        }
        
        NSArray *rgbComponent = [[attributeDict objectForKey:@"rgb"] componentsSeparatedByString:@","];
        
        [_colorMapArray addObject:rgbComponent];
        
    }
}


-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    //NSLog(@"Element : %@",elementName);
    if([elementName isEqualToString:@"ColorMap"]){
        colorMapValid = false;
    }
}



@end
