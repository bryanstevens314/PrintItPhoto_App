//
//  ShippingTVC.m
//  Metal Prints
//
//  Created by Bryan Stevens on 4/20/16.
//  Copyright © 2016 Pocket Tools. All rights reserved.
//

#import "ShippingTVC.h"
#import "AppDelegate.h"
#import "Order.h"

@interface ShippingTVC ()
@property (retain, nonatomic) UIToolbar* keyboardDoneButtonView1;

@end

@implementation ShippingTVC


- (AppDelegate *)sharedAppDelegate
{
    
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}


+ (ShippingTVC *)sharedShippingTVC
{
    static ShippingTVC *sharedInstance = nil;
    
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
        sharedInstance = (ShippingTVC*)[storyboard instantiateViewControllerWithIdentifier: @"shipping"];
    });
    return sharedInstance;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:self action:@selector(PlaceAndConfirmOrder)];
    [self.navigationItem setRightBarButtonItem:rightBarButtonItem];
    [self.navigationItem setTitle:@"Shipping"];
    
    self.keyboardDoneButtonView1 = [[UIToolbar alloc] init];
    self.keyboardDoneButtonView1.barStyle = UIBarStyleDefault;
    self.keyboardDoneButtonView1.translucent = YES;
    self.keyboardDoneButtonView1.tintColor = nil;
    [self.keyboardDoneButtonView1 sizeToFit];
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                                   style:UIBarButtonItemStyleDone target:self
                                                                  action:@selector(BackClicked:)];
    UIBarButtonItem *nextButton = [[UIBarButtonItem alloc] initWithTitle:@"Next"
                                                                   style:UIBarButtonItemStyleDone target:self
                                                                  action:@selector(NextClicked:)];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                   style:UIBarButtonItemStyleDone target:self
                                                                  action:@selector(DoneClicked:)];
    
    [self.keyboardDoneButtonView1 setItems:[NSArray arrayWithObjects:backButton,nextButton,flexSpace,doneButton, nil]];
    
    self.name_TextField.inputAccessoryView = self.keyboardDoneButtonView1;
    
    self.email_TextField.inputAccessoryView = self.keyboardDoneButtonView1;
    
    self.street_TextField.inputAccessoryView = self.keyboardDoneButtonView1;
    
    self.apt_TextField.inputAccessoryView = self.keyboardDoneButtonView1;
    
    self.city_TextField.inputAccessoryView = self.keyboardDoneButtonView1;
    
    self.state_TextField.inputAccessoryView = self.keyboardDoneButtonView1;
    
    self.zip_TextField.inputAccessoryView = self.keyboardDoneButtonView1;
}


- (void)BackClicked:(id)sender {
    BOOL stop = NO;
    if ([self.name_TextField isFirstResponder] && stop == NO) {
        NSLog(@"name");
        stop = YES;
    }
    
    if ([self.email_TextField isFirstResponder] && stop == NO) {
        NSLog(@"email");
        stop = YES;
        [self.name_TextField becomeFirstResponder];
    }
    
    if ([self.street_TextField isFirstResponder] && stop == NO) {
        NSLog(@"street");
        stop = YES;
        [self.email_TextField becomeFirstResponder];
    }
    
    if ([self.apt_TextField isFirstResponder] && stop == NO) {
        NSLog(@"city");
        stop = YES;
        [self.street_TextField becomeFirstResponder];
    }
    
    if ([self.city_TextField isFirstResponder] && stop == NO) {
        NSLog(@"city");
        stop = YES;
        [self.apt_TextField becomeFirstResponder];
    }
    
    if ([self.state_TextField isFirstResponder] && stop == NO) {
        NSLog(@"state");
        stop = YES;
        [self.city_TextField becomeFirstResponder];
    }
    
    if ([self.zip_TextField isFirstResponder] && stop == NO) {
        NSLog(@"Zip");
        stop = YES;
        [self.state_TextField becomeFirstResponder];
        

    }
}

- (void)DoneClicked:(id)sender {
    [self.keyboardDoneButtonView1 removeFromSuperview];
    [self.delegate zipResignedFirstResponderMoveViewDown];
    if ([self.name_TextField isFirstResponder]) {
        NSLog(@"name");
        [self.name_TextField resignFirstResponder];
    }
    
    if ([self.email_TextField isFirstResponder]) {
        NSLog(@"email");
        [self.email_TextField resignFirstResponder];
    }
    
    if ([self.street_TextField isFirstResponder]) {
        NSLog(@"street");
        [self.street_TextField resignFirstResponder];
    }
    
    if ([self.apt_TextField isFirstResponder]) {
        NSLog(@"city");
        [self.apt_TextField resignFirstResponder];
    }
    
    if ([self.city_TextField isFirstResponder]) {
        NSLog(@"city");
        [self.city_TextField resignFirstResponder];
    }
    
    if ([self.state_TextField isFirstResponder]) {
        NSLog(@"state");
        [self.state_TextField resignFirstResponder];
    }
    
    if ([self.zip_TextField isFirstResponder]) {
        NSLog(@"Zip");
        [self.zip_TextField resignFirstResponder];
        
    }
}
        
        
- (void)NextClicked:(id)sender {
    BOOL stop = NO;
    if ([self.name_TextField isFirstResponder] && stop == NO) {
        NSLog(@"name");
        stop = YES;
        [self.email_TextField becomeFirstResponder];
    }
    
    if ([self.email_TextField isFirstResponder] && stop == NO) {
        NSLog(@"email");
        stop = YES;
        [self.street_TextField becomeFirstResponder];
    }
    
    if ([self.street_TextField isFirstResponder] && stop == NO) {
        NSLog(@"street");
        stop = YES;
        [self.apt_TextField becomeFirstResponder];
    }
    
    if ([self.apt_TextField isFirstResponder] && stop == NO) {
        NSLog(@"city");
        stop = YES;
        [self.city_TextField becomeFirstResponder];
    }
    
    if ([self.city_TextField isFirstResponder] && stop == NO) {
        NSLog(@"city");
        stop = YES;
        [self.state_TextField becomeFirstResponder];
    }
    
    if ([self.state_TextField isFirstResponder] && stop == NO) {
        NSLog(@"state");
        stop = YES;
        [self.zip_TextField becomeFirstResponder];
        [self.delegate zipIsFirstResponderMoveViewUp];
    }
    
    if ([self.zip_TextField isFirstResponder] && stop == NO) {
        NSLog(@"Zip");
        stop = YES;             
        [self.zip_TextField resignFirstResponder];
        [self.keyboardDoneButtonView1 removeFromSuperview];
        [self.delegate zipResignedFirstResponderMoveViewDown];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    BOOL stop = NO;
    if (textField == self.name_TextField) {
        stop = YES;
        [self.email_TextField becomeFirstResponder];
    }
    if (textField == self.email_TextField) {
        stop = YES;
        [self.street_TextField becomeFirstResponder];
    }
    if (textField == self.street_TextField) {
        stop = YES;
        [self.apt_TextField becomeFirstResponder];
    }
    if (textField == self.apt_TextField) {
        stop = YES;
        [self.city_TextField becomeFirstResponder];
    }
    if (textField == self.city_TextField) {
        stop = YES;
        [self.state_TextField becomeFirstResponder];
    }
    if (textField == self.state_TextField) {
        stop = YES;
        [self.zip_TextField becomeFirstResponder];
    }
    if (textField == self.zip_TextField) {
        stop = YES;
        [self.zip_TextField resignFirstResponder];
    }
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField == self.zip_TextField) {
        [self.delegate zipIsFirstResponderMoveViewUp];
    }
    return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 7;
}

-(void)PlaceAndConfirmOrder{

    
    

    


                

                [self performSegueWithIdentifier:@"Billing" sender:self];
    
    
//    Order *event = [[Order alloc] init];
//    event.name = @"";
//    event.date = @"";
//    event.email = @"";
//    event.product = @"";
//    event.Image = nil;
//    event.retouching = @"";
//    event.instructions = @"";
//    event.aluminum_prints = @"";
//    event.shipping_name = @"";
//    event.shipping_address = @"";
//    [[self sharedAppDelegate].store saveObject:event withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
//        if (errorOrNil != nil) {
//            //save failed
//            NSLog(@"Save failed, with error: %@", [errorOrNil localizedFailureReason]);
//            //            [NSKeyedArchiver archiveRootObject:[self sharedAppDelegate].videoInfoArrayMain toFile:[self archivePath]];
//            [self uploadFailed];
//            
//        } else {
//            //save was successful
//            NSLog(@"Successfully saved event (id='%@').", [objectsOrNil[0] kinveyObjectId]);
//            
//            
//            
//        }
//    } withProgressBlock:nil];
}



/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
