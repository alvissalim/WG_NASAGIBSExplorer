//
//  TR1AppDelegate.m
//  NASAGIBS
//
//  Created by MSaktiAlvissalim on 2014/10/10.
//  Copyright (c) 2014年 Alvis. All rights reserved.
//

#import "TR1AppDelegate.h"
#import "TR1ViewController.h"
#import "SettingViewController.h"
#import "TR1LayerSelectViewController.h"

@implementation TR1AppDelegate

{
    UINavigationController *navC;
    
}


/*
- (void)fetchCapabilities{
    
    NSString *urlStr = @"http://map1.vis.earthdata.nasa.gov/wmts-webmerc/wmts.cgi?SERVICE=WMTS&request=GetCapabilities";
    NSURLRequest *urlReq = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    NSURLResponse *urlResponse = [NSURLResponse alloc];
    NSError *urlError = [NSError alloc];
    NSData *data;

    data = [NSURLConnection sendSynchronousRequest:urlReq returningResponse:&urlResponse error:&urlError];
    
    
    capabilitiesParser = [[GIBSCapabilityParser alloc] initWithXMLData:data];
    
}
 */
     

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    //[self parseCapabilities];
    
    //NSLog(@"num of layers : %d", capabilitiesParser.layerList.count);
    
    //TR1ViewController *viewC = [[TR1ViewController alloc] init];
    
    SettingViewController *viewC = [[SettingViewController alloc] initWithNibName:@"SettingViewController" bundle:[NSBundle mainBundle]];
    
    
    TR1LayerSelectViewController *mainView = [[TR1LayerSelectViewController alloc] initWithStyle:UITableViewStylePlain];
    
    navC = [[UINavigationController alloc] initWithRootViewController:mainView];
    
    
    navC.navigationBar.barStyle = UIBarStyleBlackOpaque;
    self.window.rootViewController = navC;
    
    [self.window makeKeyAndVisible];
    return YES;
    
    // Override point for customization after application launch.
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}



@end
