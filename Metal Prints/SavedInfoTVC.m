//
//  SavedInfoTVC.m
//  Metal Prints
//
//  Created by Bryan Stevens on 10/26/16.
//  Copyright © 2016 Pocket Tools. All rights reserved.
//

#import "SavedInfoTVC.h"
#import "SWRevealViewController.h"
#import "SavedAddressTVCell.h"
#import "AppDelegate.h"
#import "UserShipping.h"

@interface SavedInfoTVC ()

@end

@implementation SavedInfoTVC



- (AppDelegate *)sharedAppDelegate
{
    
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

+ (SavedInfoTVC *)sharedSavedInfoTVC
{
    static SavedInfoTVC *sharedInstance = nil;
    
    UIStoryboard *storyboard;
    
    // detect the height of our screen
    int height = [UIScreen mainScreen].bounds.size.height;
    
    if (height == 480) {
        storyboard = [UIStoryboard storyboardWithName:@"Main_3.5_inch" bundle:nil];
        // NSLog(@"Device has a 3.5inch Display.");
    }
    if (height == 568) {
        storyboard = [UIStoryboard storyboardWithName:@"Main_4_inch" bundle:nil];
        // NSLog(@"Device has a 4inch Display.");
    }
    if (height == 667) {
        storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        // NSLog(@"Device has a 4inch Display.");
    }
    if (height == 736) {
        storyboard = [UIStoryboard storyboardWithName:@"Main_5.5_inch" bundle:nil];
        // NSLog(@"Device has a 4inch Display.");
    }
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = (SavedInfoTVC*)[storyboard instantiateViewControllerWithIdentifier: @"savedInfo"];
    });
    return sharedInstance;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImage *background = [UIImage imageNamed:@"Hamburger_icon.svg.png"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(toggleReveal2) forControlEvents:UIControlEventTouchUpInside]; //adding action
    [button setBackgroundImage:background forState:UIControlStateNormal];
    button.frame = CGRectMake(0 ,0,35,30);
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [self.navigationItem setLeftBarButtonItem:leftBarButtonItem];
    [self.navigationItem setTitle:@"Contacts"];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:41.0/255.0 green:127.0/255.0 blue:184.0/255.0 alpha:0.6];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

UITapGestureRecognizer *singleTap2;
-(void)toggleReveal2{
    //collView.collectionView.userInteractionEnabled = NO;
    singleTap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(SingleTap2:)];
    singleTap2.numberOfTapsRequired = 1;
    [self.tableView  addGestureRecognizer:singleTap2];
    [self.revealViewController revealToggle];
}

-(void)SingleTap2:(UITapGestureRecognizer *)gesture{
    
    [self.revealViewController revealToggle];
    [self.tableView removeGestureRecognizer:singleTap2];
    singleTap2 = nil;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

NSInteger rows;
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    rows = [self sharedAppDelegate].savedAddressesArray.count + 1;
    
    return rows;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    
    if (indexPath.row == 0) {
        SavedAddressTVCell *cell1 = [tableView dequeueReusableCellWithIdentifier:@"section" forIndexPath:indexPath];
        [cell1.addAddressButton addTarget:self action:@selector(addAddress) forControlEvents:UIControlEventTouchUpInside];
        cell1.addAddressButton.hidden = NO;
        cell = cell1;
    }
    else{
        
        SavedAddressTVCell *cell1 = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        cell1.addAddressButton.hidden = YES;
            NSDictionary *userShipDict = [[self sharedAppDelegate].savedAddressesArray objectAtIndex:indexPath.row-1];
            cell1.NameTextField.text = [userShipDict objectForKey:@"name"];
            cell1.NameTextField.userInteractionEnabled = NO;
            NSString *street = [userShipDict objectForKey:@"street"];
            NSString *city = [userShipDict objectForKey:@"city"];
            NSString *state = [userShipDict objectForKey:@"state"];
            NSString *zip = [userShipDict objectForKey:@"zip"];
            cell1.AddressTextField.text = [NSString stringWithFormat:@"%@",street];
            cell1.AddressTextField.userInteractionEnabled = NO;
            cell1.StateZIPTextField.text = [NSString stringWithFormat:@"%@ %@, %@",city,state,zip];
            cell1.StateZIPTextField.userInteractionEnabled = NO;


        cell = cell1;
    }
    
    
    return cell;
}

BOOL addAddressClicked;
-(void)addAddress{
    editing = NO;
    [self performSegueWithIdentifier:@"addAddressSegue" sender:self];
    
}


-(void)FinishedEnteringShippingInformation{
    
    [self.tableView reloadData];
    [self.navigationController popViewControllerAnimated:YES];
    
}
 
 
 
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [[self sharedAppDelegate].savedAddressesArray removeObjectAtIndex:indexPath.row-1];
        [NSKeyedArchiver archiveRootObject:[self sharedAppDelegate].savedAddressesArray toFile:[self archiveAddresses]];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 0;
    if (indexPath.row == 0) {
        height = 32;
    }
    else{
        height = 80;
    }
    
    return height;
}

BOOL editing;
NSDictionary *addressDictionary;
NSInteger selectedRows;
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    editing = YES;
    selectedRows = indexPath.row-1;
    addressDictionary = [[self sharedAppDelegate].savedAddressesArray objectAtIndex:indexPath.row-1];
    [self performSegueWithIdentifier:@"addAddressSegue" sender:self];
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"addAddressSegue"]) {
        ShippingInfoVC *shipVC = segue.destinationViewController;
        shipVC.delegate = self;
        shipVC.savingAddress = YES;
        shipVC.selectedRow = selectedRows;
        shipVC.editingAddress = editing;
        shipVC.addressDict = addressDictionary;
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"", returnbuttontitle) style:UIBarButtonItemStylePlain target:nil action:nil];
        self.navigationItem.backBarButtonItem = backButton;
    }
}


- (IBAction)AddAddress:(id)sender {
    

}


- (NSString*)archiveAddresses{
    NSArray *documentDirs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = documentDirs[0];
    return [docDir stringByAppendingPathComponent:@"addresses"];
}
@end
