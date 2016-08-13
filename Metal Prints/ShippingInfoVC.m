//
//  ShippingInfoVC.m
//  Metal Prints
//
//  Created by Bryan Stevens on 8/12/16.
//  Copyright © 2016 Pocket Tools. All rights reserved.
//

#import "ShippingInfoVC.h"
#import <Stripe/Stripe.h>
#import "AppDelegate.h"

@interface ShippingInfoVC (){
    ShippingTVC *shipping;
    CCTVC *billing;
    ActualCCTVC *CC;
}

@end

@implementation ShippingInfoVC


- (AppDelegate *)sharedAppDelegate
{
    
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    shipping = [ShippingTVC sharedShippingTVC];
    billing = [CCTVC sharedCCTVC];
    CC = [ActualCCTVC sharedActualCCTVC];
    [self.orderDataView addSubview:shipping.tableView];
    shipping.ShippingPresenting = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

UIAlertController *alert;
NSTimer *timer2;
- (IBAction)PresentNextView:(id)sender {
    if (CC.CCPresenting) {
        CC.CCPresenting = NO;

        alert = [UIAlertController alertControllerWithTitle:@""
                                                    message:@"Submitting Order"
                                             preferredStyle:UIAlertControllerStyleAlert]; // 1
        
        UIViewController *customVC     = [[UIViewController alloc] init];
        [alert.view setFrame:CGRectMake(0, 300, 320, 275)];
        
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
        
        
        [alert setValue:customVC forKey:@"contentViewController"];
        [self presentViewController:alert animated:YES completion:nil];
        timer2 = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(ChargeCard) userInfo:nil repeats:NO];
    }
    if (billing.BillingPresenting) {
        [billing.tableView removeFromSuperview];
        [self.view addSubview:CC.tableView];
        CC.CCPresenting = YES;
        billing.BillingPresenting = NO;
    }
    if (shipping.ShippingPresenting) {
        [shipping.tableView removeFromSuperview];
        [self.view addSubview:billing.tableView];
        billing.BillingPresenting = YES;
        shipping.ShippingPresenting = NO;
    }
    
}


-(void)ChargeCard{
    
    [timer2 invalidate];
    timer2 = nil;
    
    NSDictionary *billingDict = [self sharedAppDelegate].billingInfo;
    NSString *fullName = [NSString stringWithFormat:@"%@, %@",[billingDict objectForKey:@"first"], [billingDict objectForKey:@"last"]];
    STPCardParams *params = [[STPCardParams alloc] init];
    params.number = CC.CCN.text;
    params.expMonth = [CC.expMonth.text integerValue];
    params.expYear = [CC.expYear.text integerValue];
    params.cvc = CC.securityCode.text;
    //    params.name = fullName;
    //    params.addressLine1 = [billingDict objectForKey:@"street"];
    //    params.addressLine2 = [billingDict objectForKey:@"apt"];
    //    params.addressCity = [billingDict objectForKey:@"city"];
    //    params.addressState = [billingDict objectForKey:@"state"];
    //    params.addressZip = [billingDict objectForKey:@"zip"];
    //    params.addressCountry = [billingDict objectForKey:@"country"];
    //    params.currency = @"USD";
    [[STPAPIClient sharedClient] createTokenWithCard:params completion:^(STPToken *token, NSError *error) {
        if (error) {
            NSLog(@"error %@",error);
        } else {
            [self createBackendChargeWithToken:token completion:nil];
        }
    }];
    
    
    
}

- (void)createBackendChargeWithToken:(STPToken *)token completion:(void (^)(PKPaymentAuthorizationStatus))completion {
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://final-project-order-viewer-stevens-apps.c9users.io/stripeStuff.php"]];
    NSDictionary *billingDict = [self sharedAppDelegate].billingInfo;
    int Amount = [[self sharedAppDelegate].cartTotal intValue];
    int totalAmount = Amount * 100;
    int fee = totalAmount *0.1;
    NSString *stringAmount = [NSString stringWithFormat:@"%i",totalAmount];
    NSString *feeAmount = [NSString stringWithFormat:@"%i",fee];
    NSDictionary *chargeParams = [NSDictionary dictionaryWithObjectsAndKeys: token.tokenId, @"stripeToken",
                                  stringAmount, @"chargeAmount",
                                  @"example charge", @"description",
                                  @"incrementing ID", @"orderID",
                                  [billingDict objectForKey:@"name"], @"name",
                                  feeAmount, @"fee",nil];
    
    NSError *error2;
    NSData *finalJSONdata = [NSJSONSerialization dataWithJSONObject:chargeParams options:0 error:&error2];
    
    
    [request setHTTPBody:finalJSONdata];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[finalJSONdata length]] forHTTPHeaderField:@"Content-Length"];
    
    
    NSError *err;
    NSURLResponse *response;
    
    
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    NSString *responseString = [[NSString alloc]initWithData:responseData encoding:NSASCIIStringEncoding];
    
    
    if(responseString)
    {
        
        
        //        NSStringEncoding  encoding;
        //        NSData * jsonData = [responseString dataUsingEncoding:encoding];
        //        NSError * error=nil;
        //        NSDictionary * parsedData = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
        NSLog(@"%@",responseString);
        [alert dismissViewControllerAnimated:YES completion:nil];
        alert = nil;
        alert = [UIAlertController alertControllerWithTitle:@""
                                                    message:@"Successfully charged card, please stay in the app while your images are uploaded."
                                             preferredStyle:UIAlertControllerStyleAlert]; // 1
        
        UIViewController *customVC     = [[UIViewController alloc] init];
        [alert.view setFrame:CGRectMake(0, 300, 320, 275)];
        
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
        
        
        [alert setValue:customVC forKey:@"contentViewController"];
        timer2 = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(PostData) userInfo:nil repeats:NO];
        
    }
    else{
        NSLog(@"Error!");
        
    }
}

-(void)PostData{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://final-project-order-viewer-stevens-apps.c9users.io/recieve_data.php"]];
    
    
    
    NSMutableDictionary *mutDict = [[NSMutableDictionary alloc] init];
    [mutDict setObject:[self sharedAppDelegate].shippingInfo forKey:@"customer"];
    int i = 0;
    NSMutableDictionary *mutDict1 = [[NSMutableDictionary alloc] init];

    for (NSArray *array1 in [self sharedAppDelegate].shoppingCart) {
        
        //        NSArray *array = @[self.Product_Outlet.text,
        //                           self.Quantity_TextField.text,
        //                           price,
        //                           self.Retouching_TextField.text,
        //                           self.For_Aluminum_TextField.text,
        //                           self.textView.text,
        //                           imgData
        //                           ];
        
        NSString *prod = [array1 objectAtIndex:0];
        NSString *quan = [array1 objectAtIndex:1];
        NSString *retouch = [array1 objectAtIndex:3];
        NSString *alum = [array1 objectAtIndex:4];
        NSString *instructions = [array1 objectAtIndex:5];
        NSString *imgString = [array1 objectAtIndex:6];
        //            NSLog(@"%@",imgString);
        NSDictionary *cartItem = [NSDictionary dictionaryWithObjectsAndKeys:
                                  prod,@"product",
                                  
                                  quan,@"quantity",
                                  retouch,@"retouching",
                                  alum,@"aluminumOptions",
                                  instructions,@"instructions",
                                  imgString,@"image",nil];
        
        [mutDict1 setObject:cartItem forKey:[NSString stringWithFormat:@"cart_Item%i",i]];
        i++;
    }
    
    [mutDict setObject:mutDict1 forKey:@"shopping_Cart"];
    
    NSError *error2;
    NSData *finalJSONdata = [NSJSONSerialization dataWithJSONObject:mutDict options:0 error:&error2];
    
    //NSLog(@"%.2f MB",(float)finalJSONdata.length/1024.0f/1024.0f);
    
    [request setHTTPBody:finalJSONdata];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[finalJSONdata length]] forHTTPHeaderField:@"Content-Length"];
    
    
    NSError *err;
    NSURLResponse *response;
    
    
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    NSString *responseString = [[NSString alloc]initWithData:responseData encoding:NSASCIIStringEncoding];
    
    
    if(responseString)
    {
        //[self performSegueWithIdentifier:@"OrderPlaced" sender:self];
        NSLog(@"got response==%@", responseString);
        [alert dismissViewControllerAnimated:YES completion:nil];
        [self performSegueWithIdentifier:@"OrderComplete" sender:self];
    }
    else
    {
        NSLog(@"faield to connect");
        [alert dismissViewControllerAnimated:YES completion:nil];
        UIAlertController *alert2 = [UIAlertController alertControllerWithTitle:@"" message:@"There was a problem uploading your images. Please check your internet connection and try again"preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"OK"
                                                               style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                                   [alert2 dismissViewControllerAnimated:YES completion:nil];
                                                               }]; // 2
        
        [alert2 addAction:cameraAction];
        
        [self presentViewController:alert2 animated:YES completion:nil];
        
    }
    
}
@end
