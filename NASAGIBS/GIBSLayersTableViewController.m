//
//  SettingViewController.m
//  NASAGIBS
//
//  Created by MSaktiAlvissalim on 2014/10/11.
//  Copyright (c) 2014年 Alvis. All rights reserved.
//

#import "GIBSLayersTableViewController.h"
#import "GIBSGlobeViewController.h"

@interface GIBSLayersTableViewController ()

@end

@implementation GIBSLayersTableViewController



int numofLayers;

int layerCount = 0;


- (void) runParser{
    [self parseCapabilities];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveNewData:)
                                                 name:@"layerAdd"
                                               object:_capabilitiesParser];
    
}

- (void) parseCapabilities{
    NSString *urlStr = @"http://map1.vis.earthdata.nasa.gov/wmts-webmerc/wmts.cgi?SERVICE=WMTS&request=GetCapabilities";
    NSURLRequest *urlReq = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [NSURLConnection sendAsynchronousRequest:urlReq
     // the NSOperationQueue upon which the handler block will be dispatched:
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               
                               _capabilitiesParser = [[GIBSCapabilityParser alloc] initWithXMLData:data];
                               
                           }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (_capabilitiesParser == NULL){
        [self runParser];
    }

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveNewData:(NSNotification *) notification{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView beginUpdates];
        
        [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:layerCount inSection:0]] withRowAnimation:UITableViewRowAnimationRight];
        layerCount++;
        [self.tableView endUpdates];
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    
    //[self fetchCapabilities];
    
    //numofLayers = capabilitiesParser.layerList.count;
    
    //[self.tableView reloadData];
    
    return layerCount;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"myCell" ];

    cell.textLabel.text = [[_capabilitiesParser.layerList objectAtIndex:indexPath.row] name];
    
    
    /*
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"Earthquakes";
            break;
            
        case 1:
            cell.textLabel.text = @"Stadium";
            break;
    }
    */
    // Configure the cell...
    
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GIBSLayer *itemToPassBack = [[_capabilitiesParser layerList] objectAtIndex:indexPath.row];
    [self.delegate addItemViewController:self didFinishEnteringItem:itemToPassBack layerType:_selection];
    
    
    [self.navigationController popViewControllerAnimated:TRUE];
    
    
    /*
    // Navigation logic may go here, for example:
    // Create the next view controller.
    TR1ViewController *globeViewC = [[TR1ViewController alloc] init];
    
    globeViewC.option = indexPath.row;
    
    globeViewC.selectedLayer = [[capabilitiesParser layerList] objectAtIndex:indexPath.row];
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:globeViewC animated:YES];

     */
}


@end
