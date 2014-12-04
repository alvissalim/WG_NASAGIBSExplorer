//
//  TR1LayerSelectViewController.m
//  NASAGIBS
//
//  Created by MSaktiAlvissalim on 2014/11/14.
//  Copyright (c) 2014年 Alvis. All rights reserved.
//

#import "GIBSRootLayerSelectTableViewController.h"
#import "GIBSLayersTableViewController.h"
#import "GIBSGlobeViewController.h"


@interface GIBSRootLayerSelectTableViewController ()

@end

@implementation GIBSRootLayerSelectTableViewController

GIBSLayersTableViewController *selection;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) runGlobe{
    GIBSGlobeViewController *globeViewC = [[GIBSGlobeViewController alloc] init];
    
    if (_base != NULL){
        globeViewC.selectedLayer = _base;
    }
    else{
        globeViewC.selectedLayer = [selection.capabilitiesParser.layerList objectAtIndex:10];
    }
    
    if (_overlay != NULL){
        globeViewC.overlayLayer = _overlay;
    }
    else{
        globeViewC.overlayLayer = [selection.capabilitiesParser.layerList objectAtIndex:20];
    }
    
    
    // Pass the selected object to the new view controller.
    _overlay = [selection.capabilitiesParser.layerList objectAtIndex:1];
    // Push the view controller.
    [self.navigationController pushViewController:globeViewC animated:YES];
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Start" style:UIBarButtonItemStyleBordered target:self action:@selector(runGlobe)];
    self.navigationItem.rightBarButtonItem = doneButton;
    
    selection = [[GIBSLayersTableViewController alloc] initWithNibName:@"SettingViewController" bundle:[NSBundle mainBundle]];
    selection.delegate = self;
    
    [selection runParser];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdenfier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdenfier];
    
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdenfier];
    }
    
    if(indexPath.row == 0){
        cell.textLabel.text = @"Base Layer";
    }
    else
    if(indexPath.row == 1){
        cell.textLabel.text = @"Overlay Layer";
    }
    
    
    // Configure the cell...
    
    return cell;
}

- (void)addItemViewController:(GIBSLayersTableViewController *)controller didFinishEnteringItem:(GIBSLayer *)item layerType:(SelectionType)type
{
    switch (type) {
        case BaseLayerSelection:
            _base = item;
            break;
            
        case OverlayLayerSelection:
            _overlay = item;
            
            // Create Legends
            _legend = [[GIBSLegendBuilder alloc] initWithLayerObject:_overlay];
            
            
            break;
    }
}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
            selection.selection = BaseLayerSelection;
            break;
            
        case 1:
            selection.selection = OverlayLayerSelection;
            break;
    }
    
    // Push the view controller.
    [self.navigationController pushViewController:selection animated:YES];
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
