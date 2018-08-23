//
//  RootTableViewController.m
//  Trucks
//
//  Created by Bryan Stevens on 7/16/15.
//  Copyright (c) 2015 PocketTools. All rights reserved.
//

#import "RootTableViewController.h"
#import "AppDelegate.h"
#import "ShoppingCartTVC.h"

@interface RootTableViewController (){
    BOOL displayed;
}
@property (nonatomic) float originalOriginRoot;

@end

@implementation RootTableViewController


- (AppDelegate *)sharedAppDelegate
{
    
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}


+ (RootTableViewController *)sharedRootTableViewController
{
    static RootTableViewController *sharedInstance = nil;
    
    
    UIStoryboard *storyboard;
    storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //    // detect the height of our screen
    //    int height = [UIScreen mainScreen].bounds.size.height;
    //
    //    if (height == 480) {
    //        storyboard = [UIStoryboard storyboardWithName:@"Main_3.5_inch" bundle:nil];
    //        // NSLog(@"Device has a 3.5inch Display.");
    //    }
    //    if (height == 568) {
    //        storyboard = [UIStoryboard storyboardWithName:@"Main_4_inch" bundle:nil];
    //        // NSLog(@"Device has a 4inch Display.");
    //    }
    //    if (height == 667) {
    //        storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //        // NSLog(@"Device has a 4inch Display.");
    //    }
    //    if (height == 736) {
    //        storyboard = [UIStoryboard storyboardWithName:@"Main_5.5_inch" bundle:nil];
    //        // NSLog(@"Device has a 4inch Display.");
    //    }
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = (RootTableViewController*)[storyboard instantiateViewControllerWithIdentifier: @"RootSlideOverController"];
    });
    return sharedInstance;
}


UIImageView *logoImage;
- (void)viewDidLoad {
    [super viewDidLoad];

    
    self.tableView.backgroundColor = [UIColor colorWithRed:41.0/255.0 green:127.0/255.0 blue:184.0/255.0 alpha:1];
    


    
}

// to make the button float over the tableView including tableHeader
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    CGRect tableBounds = self.view.bounds;
//    CGRect floatingButtonFrame = logoImage.frame;
//    floatingButtonFrame.origin.y = self.originalOriginRoot + tableBounds.origin.y;
//    logoImage.frame = floatingButtonFrame;
//    
//    [self.tableView bringSubviewToFront:logoImage]; // float over the tableHeader
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    CGFloat headerHeight = (self.view.frame.size.height - (44 * [self.tableView numberOfRowsInSection:0])) / 2;
    
    self.tableView.contentInset = UIEdgeInsetsMake(headerHeight, 0, -headerHeight, 0);
    
    if (logoImage == NULL) {
        
        logoImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]];
        logoImage.frame = CGRectMake(self.view.frame.origin.x, -160, 200, 92.5);
        logoImage.clipsToBounds = YES;
        logoImage.layer.zPosition = MAXFLOAT;
        [self.view insertSubview:logoImage aboveSubview:self.view];
        self.originalOriginRoot = logoImage.frame.origin.y;
        
    }
    else{
        logoImage.frame = CGRectMake(self.view.frame.origin.x, -160, 200, 92.5);
        logoImage.clipsToBounds = YES;
        logoImage.layer.zPosition = MAXFLOAT;
        [self.view insertSubview:logoImage aboveSubview:self.view];
    }

//    if (logoImage) {
//
//        [self.view addSubview:logoImage];
//        [self.view bringSubviewToFront:logoImage];
//        logoImage.frame = CGRectMake(-200, -200, 200, 92.5);
//        self.originalOriginRoot = logoImage.frame.origin.y;
//        //        logoImage.hidden = NO;
//        [UIView animateWithDuration:0.24f animations:^{
//            logoImage.frame = CGRectMake(0, -200, 200, 92.5);
//        }];
//    }
//    else{
//        logoImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]];
//        logoImage.frame = CGRectMake(-200, -200, 200, 92.5);
//        self.originalOriginRoot = logoImage.frame.origin.y;
//        [self.view addSubview:logoImage];
//        [self.view bringSubviewToFront:logoImage];
//
//        //        [[self sharedAppDelegate].window addSubview:logoImage];
//        [UIView animateWithDuration:0.24f animations:^{
//            logoImage.frame = CGRectMake(0, -200, 200, 92.5);
//        }];
//    }
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];


}

-(void)toggleSlideOver{
    
    if (displayed == YES) {
        displayed = NO;
        //logoImage.hidden = YES;
//        [UIView animateWithDuration:0.31f animations:^{
//            logoImage.frame = CGRectMake(-30, -190, 200, 92.5);
//        }];
    }
    if (displayed == NO) {
        displayed = YES;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 5;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithRed:41.0/255.0 green:127.0/255.0 blue:184.0/255.0 alpha:0.6];
    // Configure the cell...

    if (indexPath.row == 0) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12, 7, 75, 30)];
        label.textColor = [UIColor whiteColor];
        label.font=[label.font fontWithSize:13];
        label.text = @"STORE";
        [cell addSubview:label];
        
        
    }
    if (indexPath.row == 1) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12, 7, 100, 30)];
        label.textColor = [UIColor whiteColor];
        label.font=[label.font fontWithSize:13];
        label.text = @"PHOTOS";
        [cell addSubview:label];
    }


    if (indexPath.row == 2) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12, 7, 150, 30)];
        label.textColor = [UIColor whiteColor];
        label.font=[label.font fontWithSize:13];
        label.text = @"CART";
        //        if ([self sharedAppDelegate].shoppingCart.count != 0) {
        //            UIImageView *indicatorView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cartNotifier.png"]];
        //            indicatorView.frame = CGRectMake(60, 17.5, 9, 9);
        //            [cell addSubview:indicatorView];
        //        }
        [cell addSubview:label];
        
    }
//    if (indexPath.row == 3) {
//        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12, 7, 150, 30)];
//        label.textColor = [UIColor whiteColor];
//        label.font=[label.font fontWithSize:13];
//        label.text = @"SAVED CONTACTS";
//        [cell addSubview:label];
//    }
    if (indexPath.row == 3) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12, 7, 150, 30)];
        label.textColor = [UIColor whiteColor];
        label.font=[label.font fontWithSize:13];
        label.text = @"SUPPORT";
        [cell addSubview:label];
    }
    return cell;
}

- (void)DriveSelected:(id)sender{
    if([sender isOn]){

    } else{

    }
}

-(void)SlideLogo{
    
    [UIView animateWithDuration:0.31f animations:^{
        logoImage.frame = CGRectMake(-30, -190, 200, 92.5);
    }];
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    displayed = NO;
    NSTimer *slidetimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(SlideLogo) userInfo:nil repeats:NO];

    if (indexPath.row == 0) {
        [self sharedAppDelegate].displayingCart = NO;
        [self performSegueWithIdentifier:@"home" sender:self];
    }
    if (indexPath.row == 1) {
        [self sharedAppDelegate].displayingCart = NO;
        [self performSegueWithIdentifier:@"photos" sender:self];
    }


    if (indexPath.row == 2) {
        [self performSegueWithIdentifier:@"cart" sender:self];
    }
//    if (indexPath.row == 3) {
//        [self performSegueWithIdentifier:@"savedInfo" sender:self];
//    }
    if (indexPath.row == 3) {
        [self performSegueWithIdentifier:@"contactUs" sender:self];
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
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
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"cart"]) {
        [self sharedAppDelegate].cartIsMainController = YES;
    }
}


@end
