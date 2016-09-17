//
//  OrderOverViewTVC.m
//  Metal Prints
//
//  Created by Bryan Stevens on 9/15/16.
//  Copyright © 2016 Pocket Tools. All rights reserved.
//

#import "OrderOverViewTVC.h"
#import "AppDelegate.h"

@interface OrderOverViewTVC ()

@end

@implementation OrderOverViewTVC



- (AppDelegate *)sharedAppDelegate
{
    
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    UIBarButtonItem *rightBarButtonItem7 = [[UIBarButtonItem alloc] initWithTitle:@"Place Order" style:UIBarButtonItemStylePlain target:self action:@selector(PlaceOrder)];
    [self.navigationItem setRightBarButtonItem:rightBarButtonItem7];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


UIAlertController *chargingCardAlert1;
-(void)PlaceOrder{
    chargingCardAlert1 = [UIAlertController alertControllerWithTitle:@""
                                                            message:@"Charging Card"
                                                     preferredStyle:UIAlertControllerStyleAlert]; // 1
    
    UIViewController *customVC     = [[UIViewController alloc] init];
    [chargingCardAlert1.view setFrame:CGRectMake(0, 300, 320, 275)];
    
    UIActivityIndicatorView* spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner startAnimating];
    [customVC.view addSubview:spinner];
    [spinner setCenter:CGPointMake(100, 27)];
    
    [customVC.view addConstraint:[NSLayoutConstraint
                                  constraintWithItem: spinner
                                  attribute:NSLayoutAttributeCenterX
                                  relatedBy:NSLayoutRelationEqual
                                  toItem:customVC.view
                                  attribute:NSLayoutAttributeCenterX
                                  multiplier:1.0f
                                  constant:0.0f]];
    
    
    [chargingCardAlert1 setValue:customVC forKey:@"contentViewController"];
    
    [self presentViewController:chargingCardAlert1 animated:YES completion:^{
        [PaymentVC sharedPaymentVC].delegate = self;
        [[PaymentVC sharedPaymentVC] createBackendChargeWithToken:[self sharedAppDelegate].userSettings.billing.payment.stripe_Token completion:nil];
    }];

}

#pragma  mark PaymentDelegate

UIAlertController *alert;

- (void)CardSuccessFullyCharged{
    NSLog(@"Card Successfully Charged");
    [chargingCardAlert1 dismissViewControllerAnimated:YES completion:^{
        if (alert) {
            alert = nil;
        }
        alert = [UIAlertController alertControllerWithTitle:@"" message:@"Card Charged"preferredStyle:UIAlertControllerStyleAlert];
        
        //    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"OK"
        //                                                           style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        //                                                               [alert dismissViewControllerAnimated:YES completion:nil];
        //                                                           }]; // 2
        //
        //    [alert addAction:cameraAction];
        
        [self presentViewController:alert animated:YES completion:nil];
    }];

}


- (void)CardFailedToCharged{
    NSLog(@"Card Failed To Charge");
    [chargingCardAlert1 dismissViewControllerAnimated:YES completion:^{
        if (alert) {
            alert = nil;
        }
        alert = [UIAlertController alertControllerWithTitle:@"" message:@"Failed to charge card"preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"OK"
                                                               style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                                   [alert dismissViewControllerAnimated:YES completion:nil];
                                                               }]; // 2
        
        [alert addAction:cameraAction];
        
        [self presentViewController:alert animated:YES completion:nil];
    }];

}



UIAlertController *uploadAlert;
-(void)UploadingImages{
    NSLog(@"Uploading images");
    [alert dismissViewControllerAnimated:YES completion:^{
        alert = nil;
        uploadAlert = [UIAlertController alertControllerWithTitle:@""
                                                          message:@"Uploading Images"
                                                   preferredStyle:UIAlertControllerStyleAlert]; // 1
        
        UIViewController *customVC     = [[UIViewController alloc] init];
        [uploadAlert.view setFrame:CGRectMake(0, 300, 320, 275)];
        
        UIActivityIndicatorView* spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [spinner startAnimating];
        [customVC.view addSubview:spinner];
        [spinner setCenter:CGPointMake(100, 27)];
        
        [customVC.view addConstraint:[NSLayoutConstraint
                                      constraintWithItem: spinner
                                      attribute:NSLayoutAttributeCenterX
                                      relatedBy:NSLayoutRelationEqual
                                      toItem:customVC.view
                                      attribute:NSLayoutAttributeCenterX
                                      multiplier:1.0f
                                      constant:0.0f]];
        
        
        [uploadAlert setValue:customVC forKey:@"contentViewController"];
        
        [self presentViewController:uploadAlert animated:YES completion:nil];
    }];

    
}


-(void)ImagesSuccessFullyUploaded{
    
    NSLog(@"Images successfully upload");
    [uploadAlert dismissViewControllerAnimated:YES completion:^{
        uploadAlert = nil;
        [self performSegueWithIdentifier:@"PaymentComplete" sender:self];
    }];

}


-(void)imageUploadFailure{
    NSLog(@"Upload Failed");
    
    [uploadAlert dismissViewControllerAnimated:YES completion:^{
        UIAlertController *alert2 = [UIAlertController alertControllerWithTitle:@"" message:@"There was a problem uploading your images. Please check your internet connection and try again"preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"OK"
                                                               style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                                   [alert2 dismissViewControllerAnimated:YES completion:nil];
                                                               }]; // 2
        
        [alert2 addAction:cameraAction];
        
        [self presentViewController:alert2 animated:YES completion:nil];
    }];

}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (indexPath.row == 2) {
        [self performSegueWithIdentifier:@"showShipping" sender:self];
    }
    
    if (indexPath.row == 3) {
        [self performSegueWithIdentifier:@"showBilling" sender:self];
    }
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showShipping"]) {
        ShippingInfoVC *shipVC = segue.destinationViewController;
        shipVC.delegate = self;
    }
    if ([segue.identifier isEqualToString:@"showBilling"]) {
        BillingVC *billVC = segue.destinationViewController;
        billVC.delegate = self;
    }
}

- (void)FinishedEnteringShippingInformation{
    NSLog(@"!!!");
    [self.navigationController popViewControllerAnimated:YES];
    self.shipping_Address.text = [NSString stringWithFormat:@"%@, %@ %@",[self sharedAppDelegate].userSettings.shipping.street, [self sharedAppDelegate].userSettings.shipping.city, [self sharedAppDelegate].userSettings.shipping.state];
    [self.shipping_Entered setImage:[UIImage imageNamed:@"MW-Icon-CheckMark.svg.png"]];
}

- (void)FinishedEnteringBillingInformation{
    [self.navigationController popViewControllerAnimated:YES];
    self.billing_Card.text = [self sharedAppDelegate].userSettings.billing.payment.CCN;
    self.billing_Exp.text = [NSString stringWithFormat:@"%@/%@",[self sharedAppDelegate].userSettings.billing.payment.expMonth, [self sharedAppDelegate].userSettings.billing.payment.expYear];
    [self.billing_Entered setImage:[UIImage imageNamed:@"MW-Icon-CheckMark.svg.png"]];
    
}

@end
