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
}

- (void)Order {
    //[self performSegueWithIdentifier:@"PlaceOrder" sender:self];
    
    

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField == self.name_TextField) {
        [self.email_TextField becomeFirstResponder];
    }
    if (textField == self.email_TextField) {
        [self.street_TextField becomeFirstResponder];
    }
    if (textField == self.street_TextField) {
        [self.apt_TextField becomeFirstResponder];
    }
    if (textField == self.apt_TextField) {
        [self.city_TextField becomeFirstResponder];
    }
    if (textField == self.city_TextField) {
        [self.state_TextField becomeFirstResponder];
    }
    if (textField == self.state_TextField) {
        [self.zip_TextField becomeFirstResponder];
    }
    if (textField == self.zip_TextField) {
        [self.zip_TextField resignFirstResponder];
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

    
    

    
                NSString *name = self.name_TextField.text;
                NSString *email = self.email_TextField.text;
                NSString *street = self.street_TextField.text;
                NSString *apt = self.apt_TextField.text;
                NSString *city = self.city_TextField.text;
                NSString *state = self.state_TextField.text;
                NSString *zip = self.zip_TextField.text;
                NSString *shippingAddress;
                if ([apt isEqualToString:@""]) {
                    shippingAddress = [NSString stringWithFormat:@"%@, %@, %@ %@",street,city,state,zip];
                }
                else{
                    shippingAddress = [NSString stringWithFormat:@"%@ %@, %@, %@ %@",street,apt,city,state,zip];
                }
                [self sharedAppDelegate].shippingInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                                         name,@"name",
                                                         email, @"email",
                                                         street,@"street",
                                                         apt,@"apt",
                                                         city,@"city",
                                                         state,@"state",
                                                         zip,@"zip",
                                                         @"US",@"country",
                                                         shippingAddress,@"shipping_address", nil];
                

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
