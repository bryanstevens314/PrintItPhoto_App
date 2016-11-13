//
//  OrderOverViewTVC.m
//  Metal Prints
//
//  Created by Bryan Stevens on 9/15/16.
//  Copyright © 2016 Pocket Tools. All rights reserved.
//

#import "OrderOverViewTVC.h"
#import "AppDelegate.h"
#import "CartTVC.h"

@interface OrderOverViewTVC ()
{

}

@end

@implementation OrderOverViewTVC



- (AppDelegate *)sharedAppDelegate
{
    
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"!!!");
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
//    UIBarButtonItem *rightBarButtonItem7 = [[UIBarButtonItem alloc] initWithTitle:@"Place Order" style:UIBarButtonItemStylePlain target:self action:@selector(PlaceOrder)];
//    [self.navigationItem setRightBarButtonItem:rightBarButtonItem7];
[self.navigationItem setTitle:@"Confirmation"];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    displayIt = YES;
    
    

    
}

BOOL displayIt;
NSString *cartID;
NSString *taxPercentString;
NSString *taxTotalString;
float totalPlusTaxToCharge;
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.placeOrderOutlet.layer.cornerRadius = 2;
    self.placeOrderOutlet.clipsToBounds = YES;
    self.cartTotal_Outlet.text = [NSString stringWithFormat:@"$%ld.00",(long)[self sharedAppDelegate].cartTotal];
    if ([self sharedAppDelegate].cartTotal < 50)
    {
        self.shipping_Outlet.text = @"Free";
    }
    if ([self sharedAppDelegate].shippingOK == YES) {

        if ([self sharedAppDelegate].shippingOK == YES) {
            self.shipping_Address.text = [NSString stringWithFormat:@"%@",[self sharedAppDelegate].userSettings.shipping.Name];
            self.shipping_City.text = [NSString stringWithFormat:@"%@",[self sharedAppDelegate].userSettings.shipping.street];
            self.shipping_ZIP.text = [NSString stringWithFormat:@"%@ %@, %@", [self sharedAppDelegate].userSettings.shipping.city, [self sharedAppDelegate].userSettings.shipping.state, [self sharedAppDelegate].userSettings.shipping.zip];
            //    self.shipping_ZIP.text = [NSString stringWithFormat:@"%@",[self sharedAppDelegate].userSettings.shipping.zip];
            [self.shipping_Entered setImage:[UIImage imageNamed:@"MW-Icon-CheckMark.svg.png"]];
            
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
            [cell setAccessoryType:UITableViewCellAccessoryNone];
            NSInteger shippingCost = 0;
            if ([self sharedAppDelegate].cartTotal > 50) {
                self.shipping_Outlet.text = @"Free";
            }
            else{
                self.shipping_Outlet.text = @"$7.00";
                shippingCost = 7;
            }
            if (![[self sharedAppDelegate].taxPercentString isEqualToString:@"0"]) {
                float totalTax = [taxPercentString floatValue] * [self sharedAppDelegate].cartTotal;
                float totalPrice = totalTax + [self sharedAppDelegate].cartTotal + shippingCost;
                taxTotalString = [NSString stringWithFormat:@"$%.2f",totalTax];;
                self.tax_Outlet.text = taxTotalString;
                self.totalPrice_Outlet.text = [NSString stringWithFormat:@"$%.2f",totalPrice];
                self.cartTotal_Outlet.text = [NSString stringWithFormat:@"$%ld.00",(long)[self sharedAppDelegate].cartTotal];
            }
            else{
                float totalPrice = [self sharedAppDelegate].cartTotal + shippingCost;
                self.tax_Outlet.text = @"No Tax";
                self.totalPrice_Outlet.text = [NSString stringWithFormat:@"$%.2f",totalPrice];

                self.cartTotal_Outlet.text = [NSString stringWithFormat:@"$%ld.00",(long)[self sharedAppDelegate].cartTotal];
            }
        }
        if ([self sharedAppDelegate].billingOK == YES) {
            NSString *code = [[self sharedAppDelegate].userSettings.billing.payment.CCN substringFromIndex: [[self sharedAppDelegate].userSettings.billing.payment.CCN length] - 4];
            
            [self sharedAppDelegate].userSettings.billing.payment.CCN = [NSString stringWithFormat:@"**** **** **** %@",code];
            self.billing_Name.text = [NSString stringWithFormat:@"%@",[self sharedAppDelegate].userSettings.billing.firstName];
            self.billing_Card.text = [NSString stringWithFormat:@"**** **** **** %@",code] ;
//            self.billing_Exp.text = [NSString stringWithFormat:@"%@/%@",[self sharedAppDelegate].userSettings.billing.payment.expMonth, [self sharedAppDelegate].userSettings.billing.payment.expYear];
            [self.billing_Entered setImage:[UIImage imageNamed:@"MW-Icon-CheckMark.svg.png"]];
            
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
            [cell setAccessoryType:UITableViewCellAccessoryNone];
        }

   }
}



UIAlertController *calculatingTax;
-(void)viewDidAppear:(BOOL)animated{
    if ([self sharedAppDelegate].shippingOK) {

        [super viewDidAppear:YES];

    }
    else{
        if (self.displayedIt == NO) {
            self.displayedIt = YES;
            [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
            [self.tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] animated:YES];
            [self performSegueWithIdentifier:@"showShipping" sender:self];
        }
        

    }

}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];

}

-(void)PlaceOrder{
    

}

#pragma  mark PaymentDelegate

UIAlertController *alert;

- (void)CardSuccessFullyCharged{
    NSLog(@"Card Successfully Charged");

//    [chargingCardAlert1 dismissViewControllerAnimated:YES completion:^{
//        if (alert) {
//            alert = nil;
//        }
//        alert = [UIAlertController alertControllerWithTitle:@"" message:@"Card Charged"preferredStyle:UIAlertControllerStyleAlert];
//        
//        //    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"OK"
//        //                                                           style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
//        //                                                               [alert dismissViewControllerAnimated:YES completion:nil];
//        //                                                           }]; // 2
//        //
//        //    [alert addAction:cameraAction];
//        
//        [self presentViewController:alert animated:YES completion:nil];
//    }];

}


- (void)CardFailedToCharged{
    NSLog(@"Card Failed To Charge");
    [chargingCardAlert1 dismissViewControllerAnimated:YES completion:^{
        if (alert) {
            alert = nil;
        }
        alert = [UIAlertController alertControllerWithTitle:@"" message:@"Card declined"preferredStyle:UIAlertControllerStyleAlert];
        
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
//    [alert dismissViewControllerAnimated:YES completion:^{
//        alert = nil;
//        uploadAlert = [UIAlertController alertControllerWithTitle:@""
//                                                          message:@"Uploading Images"
//                                                   preferredStyle:UIAlertControllerStyleAlert]; // 1
//        
//        UIViewController *customVC     = [[UIViewController alloc] init];
//        [uploadAlert.view setFrame:CGRectMake(0, 300, 320, 275)];
//        
//        UIActivityIndicatorView* spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//        [spinner startAnimating];
//        [customVC.view addSubview:spinner];
//        [spinner setCenter:CGPointMake(100, 27)];
//        
//        [customVC.view addConstraint:[NSLayoutConstraint
//                                      constraintWithItem: spinner
//                                      attribute:NSLayoutAttributeCenterX
//                                      relatedBy:NSLayoutRelationEqual
//                                      toItem:customVC.view
//                                      attribute:NSLayoutAttributeCenterX
//                                      multiplier:1.0f
//                                      constant:0.0f]];
//        
//        
//        [uploadAlert setValue:customVC forKey:@"contentViewController"];
//        
//        [self presentViewController:uploadAlert animated:YES completion:nil];
//    }];

    
}

-(void)imageUploadPercent:(float)uploadPercent{

        progressLabel.text = [NSString stringWithFormat:@"%lu%%",(unsigned long)uploadPercent];
        progressBar.progress = uploadPercent/100;
    
}


-(void)ImagesSuccessFullyUploaded{
    
    [chargingCardAlert1 dismissViewControllerAnimated:YES completion:^{
        chargingCardAlert1 = nil;
        [self sharedAppDelegate].shoppingCart = nil;
        [self sharedAppDelegate].cartTotal = 0;
        [self sharedAppDelegate].cartPrintTotal = 0;
//        NSArray *array2 = @[[NSString stringWithFormat:@"%ld",(long)[self sharedAppDelegate].cartTotal], [NSString stringWithFormat:@"%ld",(long)[self sharedAppDelegate].cartPrintTotal]];
//        [NSKeyedArchiver archiveRootObject:array2 toFile:[self archiveCartTotals]];
//        [NSKeyedArchiver archiveRootObject:[self sharedAppDelegate].shoppingCart toFile:[self archivePathShoppingCart]];
        [self performSegueWithIdentifier:@"OrderPlaced" sender:self];
    }];
    
    


}


-(void)imageUploadFailure{
    NSLog(@"Upload Failed");
    
    [chargingCardAlert1 dismissViewControllerAnimated:YES completion:^{
        UIAlertController *alert2 = [UIAlertController alertControllerWithTitle:@"" message:@"There was a problem uploading your images. Please check your internet connection and try again"preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"OK"
                                                               style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                                   [alert2 dismissViewControllerAnimated:YES completion:nil];
                                                               }]; // 2
        
        [alert2 addAction:cameraAction];
        
        [self presentViewController:alert2 animated:YES completion:nil];
    }];

}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (indexPath.row == 1) {
        [self performSegueWithIdentifier:@"showShipping" sender:self];
    }
    
    if (indexPath.row == 2) {
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
        shipVC.savingAddress = NO;
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"", returnbuttontitle) style:UIBarButtonItemStylePlain target:nil action:nil];
        self.navigationItem.backBarButtonItem = backButton;
    }
    if ([segue.identifier isEqualToString:@"showBilling"]) {
        BillingVC *billVC = segue.destinationViewController;
        billVC.delegate = self;
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"", returnbuttontitle) style:UIBarButtonItemStylePlain target:nil action:nil];
        self.navigationItem.backBarButtonItem = backButton;
    }
    if ([segue.identifier isEqualToString:@"OrderPlaced"]) {
        
    }
    
    
}

- (void)FinishedEnteringShippingInformationWithTaxPercent:(float)percent{
    NSLog(@"!!!");
    [self sharedAppDelegate].shippingOK = YES;
    [self.navigationController popViewControllerAnimated:YES];
    if (percent != 0) {

        [self sharedAppDelegate].taxPercentString = [NSString stringWithFormat:@"%.2f",percent];
        float totalTax = percent * [self sharedAppDelegate].cartTotal;
        float totalPrice = totalTax + [self sharedAppDelegate].cartTotal + 7;
        totalPlusTaxToCharge = totalPrice;
        taxPercentString = [NSString stringWithFormat:@"%f",percent];
        taxTotalString = [NSString stringWithFormat:@"%.2f",totalTax];
        self.tax_Outlet.text = taxTotalString;
        self.totalPrice_Outlet.text = [NSString stringWithFormat:@"$%.2f",totalPrice];
        self.shipping_Outlet.text = @"$7.00";
        self.cartTotal_Outlet.text = [NSString stringWithFormat:@"$%ld.00",(long)[self sharedAppDelegate].cartTotal];
    }
    else{
        [self sharedAppDelegate].userSettings.billing.tax_Percent = @"0";
        float totalPrice = [self sharedAppDelegate].cartTotal + 7;
        self.tax_Outlet.text = @"No Tax";
        self.totalPrice_Outlet.text = [NSString stringWithFormat:@"$%.2f",totalPrice];
        self.shipping_Outlet.text = @"$7.00";
        self.cartTotal_Outlet.text = [NSString stringWithFormat:@"$%ld.00",(long)[self sharedAppDelegate].cartTotal];
    }

    self.shipping_Address.text = [NSString stringWithFormat:@"%@",[self sharedAppDelegate].userSettings.shipping.Name];
    self.shipping_City.text = [NSString stringWithFormat:@"%@ %@, %@",[self sharedAppDelegate].userSettings.shipping.street, [self sharedAppDelegate].userSettings.shipping.city, [self sharedAppDelegate].userSettings.shipping.state];
    //    self.shipping_ZIP.text = [NSString stringWithFormat:@"%@",[self sharedAppDelegate].userSettings.shipping.zip];
    [self.shipping_Entered setImage:[UIImage imageNamed:@"MW-Icon-CheckMark.svg.png"]];
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    [cell setAccessoryType:UITableViewCellAccessoryNone];
}

- (void)FinishedEnteringBillingInformation{
    [self.navigationController popViewControllerAnimated:YES];
    [self sharedAppDelegate].billingOK = YES;
    NSString *code = [[self sharedAppDelegate].userSettings.billing.payment.CCN substringFromIndex: [[self sharedAppDelegate].userSettings.billing.payment.CCN length] - 4];
    
    [self sharedAppDelegate].userSettings.billing.payment.CCN = [NSString stringWithFormat:@"**** **** **** %@",code];
    self.billing_Name.text = [NSString stringWithFormat:@"%@",[self sharedAppDelegate].userSettings.billing.firstName];
    self.billing_Card.text = [NSString stringWithFormat:@"**** **** **** %@",code] ;
//    self.billing_Exp.text = [NSString stringWithFormat:@"%@/%@",[self sharedAppDelegate].userSettings.billing.payment.expMonth, [self sharedAppDelegate].userSettings.billing.payment.expYear];
    [self.billing_Entered setImage:[UIImage imageNamed:@"MW-Icon-CheckMark.svg.png"]];
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    [cell setAccessoryType:UITableViewCellAccessoryNone];
}
UIAlertController *chargingCardAlert1;
UIProgressView *progressBar;
UILabel *progressLabel;
- (IBAction)PlaceTheOrder:(id)sender {
    

    if ([self sharedAppDelegate].shippingOK == YES && [self sharedAppDelegate].billingOK == YES) {
        NSLog(@"%@",taxTotalString);
        NSLog(@"%@",taxPercentString);
        [self sharedAppDelegate].total_TaxCharged = taxTotalString;
        [self sharedAppDelegate].taxPercentString = taxPercentString;
        chargingCardAlert1 = [UIAlertController alertControllerWithTitle:@""
                                                                 message:@"Submitting your order...."
                                                          preferredStyle:UIAlertControllerStyleAlert]; // 1
        
        [chargingCardAlert1.view setFrame:CGRectMake(0, 300, 320, 275)];
        if (progressBar) {
            progressBar = nil;
            progressLabel = nil;
        }
        progressLabel = [[UILabel alloc] init];
        progressLabel.textAlignment = NSTextAlignmentCenter;
        progressLabel.frame = CGRectMake(0, 10, 270, 15);
        //progressLabel.center = CGPointMake(self.view.center.x, progressLabel.center.y);
        progressLabel.text = @"0%";
        [chargingCardAlert1.view addSubview:progressLabel];
        
        progressBar = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        progressBar.frame = CGRectMake(35, 52, 200, 15);
        //progressBar.center = CGPointMake(self.view.center.x, 60);
        progressBar.progress = 0.01;
        [chargingCardAlert1.view addSubview:progressBar];
        
        //        [customVC.view addConstraint:[NSLayoutConstraint
        //                                      constraintWithItem: progressBar
        //                                      attribute:NSLayoutAttributeCenterX
        //                                      relatedBy:NSLayoutRelationEqual
        //                                      toItem:customVC.view
        //                                      attribute:NSLayoutAttributeCenterX
        //                                      multiplier:1.0f
        //                                      constant:0.0f]];
        //
        //
        //        [chargingCardAlert1 setValue:customVC forKey:@"contentViewController"];
        
        [self presentViewController:chargingCardAlert1 animated:YES completion:^{
            if ([PaymentVC sharedPaymentVC].delegate) {
                [PaymentVC sharedPaymentVC].delegate = nil;
            }
            [PaymentVC sharedPaymentVC].delegate = self;
            [PaymentVC sharedPaymentVC].totalPlusTax = totalPlusTaxToCharge;
            [[PaymentVC sharedPaymentVC] createBackendChargeWithToken:[self sharedAppDelegate].userSettings.billing.payment.stripe_Token completion:nil];
        }];
        
    }
    else{
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"" message:@"Please enter your shipping and billing information"preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"OK"
                                                               style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                                   [alertC dismissViewControllerAnimated:YES completion:nil];
                                                               }]; // 2
        
        [alertC addAction:cameraAction];
        
        [self presentViewController:alertC animated:YES completion:nil];
    }
    
    
}


- (NSString*)archiveCartTotals{
    NSArray *documentDirs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = documentDirs[0];
    return [docDir stringByAppendingPathComponent:@"cartTotals"];
}


- (NSString*)archivePathShoppingCart{
    NSArray *documentDirs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = documentDirs[0];
    return [docDir stringByAppendingPathComponent:@"Cart"];
}
@end
