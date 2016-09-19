//
//  PaymentVC.m
//  Metal Prints
//
//  Created by Bryan Stevens on 8/22/16.
//  Copyright © 2016 Pocket Tools. All rights reserved.
//

#import "PaymentVC.h"
#import "AppDelegate.h"
#import "ActualCCTVC.h"
#import <Stripe/Stripe.h>

@interface PaymentVC (){
    ActualCCTVC *paymentTable;
}

@end

@implementation PaymentVC

- (AppDelegate *)sharedAppDelegate
{
    
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

+ (PaymentVC *)sharedPaymentVC
{
    static PaymentVC *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[PaymentVC alloc] init];
    });
    return sharedInstance;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:self action:@selector(PlaceOrderAndUploadImages)];
    [self.navigationItem setRightBarButtonItem:rightBarButtonItem];
    [self.navigationItem setTitle:@"Payment"];
    
    paymentTable = [ActualCCTVC sharedActualCCTVC];
    paymentTable.tableView.frame = CGRectMake(self.tableContentView1.frame.origin.x, self.tableContentView1.frame.origin.y-125, self.tableContentView1.frame.size.width, self.tableContentView1.frame.size.height);
    [self.tableContentView1 addSubview:paymentTable.tableView];
    
    NSLog(@"%@",[self sharedAppDelegate].userSettings.billing);
}

- (void)retrieveStripeToken {
    
    NSLog(@"CCN: %@",[self sharedAppDelegate].userSettings.billing.payment.CCN);
    STPCardParams *params = [[STPCardParams alloc] init];
    params.number = [self sharedAppDelegate].userSettings.billing.payment.CCN;
    params.expMonth = [[self sharedAppDelegate].userSettings.billing.payment.expMonth integerValue];
    params.expYear = [[self sharedAppDelegate].userSettings.billing.payment.expYear integerValue];
    params.cvc = [self sharedAppDelegate].userSettings.billing.payment.securityCode;
    params.name = [self sharedAppDelegate].userSettings.billing.firstName;
    params.addressLine1 = [self sharedAppDelegate].userSettings.billing.street;
    params.addressLine2 = [self sharedAppDelegate].userSettings.billing.apt;
    params.addressCity = [self sharedAppDelegate].userSettings.billing.city;
    params.addressState = [self sharedAppDelegate].userSettings.billing.state;
    params.addressZip = [self sharedAppDelegate].userSettings.billing.zip;
//    params.addressCountry = [billingDict objectForKey:@"country"];

    [[STPAPIClient sharedClient] createTokenWithCard:params completion:^(STPToken *token, NSError *error) {
        if (error) {
            NSLog(@"error %@",error);
            //[error valueForKey:@"invalid_number"];
            
        } else {
            NSString *code = [[self sharedAppDelegate].userSettings.billing.payment.CCN substringFromIndex: [[self sharedAppDelegate].userSettings.billing.payment.CCN length] - 4];
            [self sharedAppDelegate].userSettings.billing.payment.CCN = [NSString stringWithFormat:@"**** **** **** %@",code];
            [self sharedAppDelegate].userSettings.billing.payment.stripe_Token = token;
            [self.delegate retirevedToken];
            //[self createBackendChargeWithToken:token completion:nil];
        }
    }];
    
}

NSTimer *timer2;
- (void)createBackendChargeWithToken:(STPToken *)token completion:(void (^)(PKPaymentAuthorizationStatus))completion {
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://final-project-order-viewer-stevens-apps.c9users.io/stripeStuff.php"]];

    NSInteger totalAmount = [self sharedAppDelegate].cartTotal * 100;
    NSInteger fee = totalAmount * 0.3;
    NSString *stringAmount = [NSString stringWithFormat:@"%li",(long)totalAmount];
    NSString *feeAmount = [NSString stringWithFormat:@"%li",(long)fee];
    NSDictionary *chargeParams = [NSDictionary dictionaryWithObjectsAndKeys:
                                  token.tokenId, @"stripeToken",
                                  stringAmount, @"chargeAmount",
                                  @"example charge", @"description",
                                  @"incrementing ID", @"orderID",
                                  [self sharedAppDelegate].userSettings.billing.firstName, @"name",
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
        NSLog(@"%@",responseString);
        
        [self.delegate CardSuccessFullyCharged];
        timer2 = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(PostData) userInfo:nil repeats:NO];
        
    }
    else{
        NSLog(@"Error!");
        
    }
}

-(void)PostData{
    [timer2 invalidate];
    timer2 = nil;
    [self.delegate UploadingImages];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://final-project-order-viewer-stevens-apps.c9users.io/recieve_data.php"]];
    
    
    
    NSMutableDictionary *mutDict = [[NSMutableDictionary alloc] init];
    NSString *name = [self sharedAppDelegate].userSettings.shipping.Name;
    NSString *email = [self sharedAppDelegate].userSettings.shipping.email;
    NSString *street = [self sharedAppDelegate].userSettings.shipping.street;
    NSString *apt = [self sharedAppDelegate].userSettings.shipping.apt;
    NSString *city = [self sharedAppDelegate].userSettings.shipping.city;
    NSString *state = [self sharedAppDelegate].userSettings.shipping.state;
    NSString *zip = [self sharedAppDelegate].userSettings.shipping.zip;
    NSString *shippingAddress;
    if ([apt isEqualToString:@""]) {
        shippingAddress = [NSString stringWithFormat:@"%@, %@, %@ %@",street,city,state,zip];
    }
    else{
        shippingAddress = [NSString stringWithFormat:@"%@ %@, %@, %@ %@",street,apt,city,state,zip];
    }
    [self sharedAppDelegate].userSettings.shipping.shippingDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                                                   name,@"name",
                                                                   email, @"email",
                                                                   street,@"street",
                                                                   apt,@"apt",
                                                                   city,@"city",
                                                                   state,@"state",
                                                                   zip,@"zip",
                                                                   @"US",@"country",
                                                                   shippingAddress,@"shipping_address", nil];
    [mutDict setObject:[self sharedAppDelegate].userSettings.shipping.shippingDict forKey:@"customer"];
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
        NSString *imgString = [array1 objectAtIndex:7];
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
        [self sendEmail];
        [self.delegate ImagesSuccessFullyUploaded];

    }
    else
    {
        NSLog(@"faield to connect");
        [self.delegate imageUploadFailure];
        
    }
    
}


-(void)sendEmail
{
    
    Sendpulse* sendpulse = [[Sendpulse alloc] initWithUserIdandSecret:@"8663ca13cd9f05ef1f538f8d6295ff0e" :@"1af4a885aaaa45faa3ee21e763cc5667"];
    
    NSString *htmlString = @" \
    \
    <!DOCTYPE html> \
    <html  style=\"font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; box-sizing: border-box; font-size: 14px; margin: 0;\"> \
    <head> \
    <meta name=\"viewport\" content=\"width=device-width\" /> \
    <meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\" /> \
    <title>Billing e.g. invoices and receipts</title> \
    \
    \
    <style type=\"text/css\"> \
    img { \
    max-width: 100%; \
    } \
    body { \
    -webkit-font-smoothing: antialiased; -webkit-text-size-adjust: none; width: 100% !important; height: 100%; line-height: 1.6em; \
    } \
    body { \
    background-color: #f6f6f6; \
    } \
    @media only screen and (max-width: 640px) { \
    body { \
    padding: 0 !important; \
    } \
    h1 { \
    font-weight: 800 !important; margin: 20px 0 5px !important; \
    } \
    h2 { \
    font-weight: 800 !important; margin: 20px 0 5px !important; \
    } \
    h3 { \
    font-weight: 800 !important; margin: 20px 0 5px !important; \
    } \
    h4 { \
    font-weight: 800 !important; margin: 20px 0 5px !important; \
    } \
    h1 { \
    font-size: 22px !important; \
    } \
    h2 { \
    font-size: 18px !important; \
    } \
    h3 { \
    font-size: 16px !important; \
    } \
    .container { \
    padding: 0 !important; width: 100% !important; \
    } \
    .content { \
    padding: 0 !important; \
    } \
    .content-wrap { \
    padding: 10px !important; \
    } \
    .invoice { \
    width: 100% !important; \
    } \
    } \
    </style> \
    </head> \
    <style> \
    p { \
    margin-left: 10px; \
    } \
    </style> \
    \
    <body itemscope itemtype=\"EmailIOn\" style=\"font-family: 'Helvetica Neue',Helvetica,Arial,sans-serif; box-sizing: border-box; font-size: 14px; -webkit-font-smoothing: antialiased; -webkit-text-size-adjust: none; width: 100% !important; height: 100%; line-height: 1.6em; background-color: #f6f6f6; margin: 0;\" bgcolor=\"#f6f6f6\"> \
    \
    <table class=\"body-wrap\" style=\"font-family: 'Helvetica Neue',Helvetica,Arial,sans-serif; box-sizing: border-box; font-size: 14px; width: 100%; background-color: #f6f6f6; margin: 0;\" bgcolor=\"#f6f6f6\"> \
    <tr style=\"font-family: 'Helvetica Neue',Helvetica,Arial,sans-serif; box-sizing: border-box; font-size: 14px; margin: 0;\"> \
    <td style=\"font-family: 'Helvetica Neue',Helvetica,Arial,sans-serif; box-sizing: border-box; font-size: 14px; vertical-align: top; margin: 0;\" valign=\"top\"> \
    \
    </td> \
    <td class=\"container\" width=\"600\" style=\"font-family: 'Helvetica Neue',Helvetica,Arial,sans-serif; box-sizing: border-box; font-size: 14px; vertical-align: top; display: block !important; max-width: 100% !important; clear: both !important; margin: 0 auto;\" valign=\"top\"> \
    <div class=\"content\" style=\"font-family: 'Helvetica Neue',Helvetica,Arial,sans-serif; box-sizing: border-box; font-size: 14px; max-width: 600px; display: block; margin: 0 auto; padding: 20px;\"> \
				<table class=\"main\" width=\"100%\" cellpadding=\"0\" cellspacing=\"0\" style=\"font-family: 'Helvetica Neue',Helvetica,Arial,sans-serif; box-sizing: border-box; font-size: 14px; border-radius: 3px; background-color: #fff; margin: 0; border: 1px solid #e9e9e9;\" bgcolor=\"#fff\"> \
    <tr style=\"font-family: 'Helvetica Neue',Helvetica,Arial,sans-serif; box-sizing: border-box; font-size: 14px; margin: 0;\"> \
    <td class=\"content-wrap aligncenter\" style=\"font-family: 'Helvetica Neue',Helvetica,Arial,sans-serif; box-sizing: border-box; font-size: 14px; vertical-align: top; text-align: center; margin: 0; padding: 20px;\" align=\"center\" valign=\"top\"> \
    <table width=\"100%\" cellpadding=\"0\" cellspacing=\"0\" style=\"font-family: 'Helvetica Neue',Helvetica,Arial,sans-serif; box-sizing: border-box; font-size: 14px; margin: 0;\"> \
    <tr style=\"font-family: 'Helvetica Neue',Helvetica,Arial,sans-serif; box-sizing: border-box; font-size: 14px; margin: 0;\"> \
    <td class=\"content-block\" style=\"font-family: 'Helvetica Neue',Helvetica,Arial,sans-serif; box-sizing: border-box; font-size: 14px; vertical-align: top; margin: 0; padding: 0 0 20px;\" valign=\"top\"> \
    <h1 class=\"aligncenter\" style=\"font-family: 'Helvetica Neue',Helvetica,Arial,'Lucida Grande',sans-serif; box-sizing: border-box; font-size: 32px; color: #000; line-height: 1.2em; font-weight: 500; text-align: center; margin: 40px 0 0;\" align=\"center\"> \
    $33.98 Paid</h1> \
    </td> \
    </tr><tr style=\"font-family: 'Helvetica Neue',Helvetica,Arial,sans-serif; box-sizing: border-box; font-size: 14px; margin: 0;\"> \
    <td class=\"content-block\" style=\"font-family: 'Helvetica Neue',Helvetica,Arial,sans-serif; box-sizing: border-box; font-size: 14px; vertical-align: top; margin: 0; padding: 0 0 20px;\" valign=\"top\"> \
    <h2 class=\"aligncenter\" style=\"font-family: 'Helvetica Neue',Helvetica,Arial,'Lucida Grande',sans-serif; box-sizing: border-box; font-size: 24px; color: #000; line-height: 1.2em; font-weight: 400; text-align: center; margin: 40px 0 0;\" align=\"center\"> \
    Thanks for placing an order!</h2> \
    </td> \
    </tr><tr style=\"font-family: 'Helvetica Neue',Helvetica,Arial,sans-serif; box-sizing: border-box; font-size: 14px; margin: 0;\"> \
    <td class=\"content-block aligncenter\" style=\"font-family: 'Helvetica Neue',Helvetica,Arial,sans-serif; box-sizing: border-box; font-size: 14px; vertical-align: top; text-align: center; margin: 0; padding: 0 0 20px;\" align=\"center\" valign=\"top\"> \
    <table class=\"invoice\" style=\"font-family: 'Helvetica Neue',Helvetica,Arial,sans-serif; box-sizing: border-box; font-size: 14px; text-align: left; width: 80%; margin: 40px auto;\"> \
    <tr style=\"font-family: 'Helvetica Neue',Helvetica,Arial,sans-serif; box-sizing: border-box; font-size: 14px; margin: 0;\"> \
    <td style=\"font-family: 'Helvetica Neue',Helvetica,Arial,sans-serif; box-sizing: border-box; font-size: 14px; vertical-align: top; margin: 0; padding: 5px 0;\" valign=\"top\"> \
    \
    <b>Shipping To</b> \
    <br style=\"font-family: 'Helvetica Neue',Helvetica,Arial,sans-serif; box-sizing: border-box; font-size: 16px; margin: 0;\" /> \
    <p> \
    Bryan Stevens<br> \
    1930 10th st<br> \
    Los Osos, CA<br> \
    </p>  \
    \
    </tr><tr style=\"font-family: 'Helvetica Neue',Helvetica,Arial,sans-serif; box-sizing: border-box; font-size: 14px; margin: 0;\" \
    ><td style=\"font-family: 'Helvetica Neue',Helvetica,Arial,sans-serif; box-sizing: border-box; font-size: 14px; vertical-align: top; margin: 0; padding: 5px 0;\" valign=\"top\"> \
    <table class=\"invoice-items\" cellpadding=\"0\" cellspacing=\"0\" style=\"font-family: 'Helvetica Neue',Helvetica,Arial,sans-serif; box-sizing: border-box; font-size: 14px; width: 100%; margin: 0;\"> \
    <tr style=\"font-family: 'Helvetica Neue',Helvetica,Arial,sans-serif; box-sizing: border-box; font-size: 14px; margin: 0;\" \
    ><td style=\"font-family: 'Helvetica Neue',Helvetica,Arial,sans-serif; box-sizing: border-box; font-size: 14px; vertical-align: top; border-top-width: 1px; border-top-color: #eee; border-top-style: solid; margin: 0; padding: 5px 0;\" valign=\"top\"> \
    Service 2</td> \
    <td class=\"alignright\" style=\"font-family: 'Helvetica Neue',Helvetica,Arial,sans-serif; box-sizing: border-box; font-size: 14px; vertical-align: top; text-align: right; border-top-width: 1px; border-top-color: #eee; border-top-style: solid; margin: 0; padding: 5px 0;\" align=\"right\" valign=\"top\"> \
    $ 9.99</td> \
    </tr> \
    <tr style=\"font-family: 'Helvetica Neue',Helvetica,Arial,sans-serif; box-sizing: border-box; font-size: 14px; margin: 0;\" \
    ><td style=\"font-family: 'Helvetica Neue',Helvetica,Arial,sans-serif; box-sizing: border-box; font-size: 14px; vertical-align: top; border-top-width: 1px; border-top-color: #eee; border-top-style: solid; margin: 0; padding: 5px 0;\" valign=\"top\"> \
    Service 2</td> \
    <td class=\"alignright\" style=\"font-family: 'Helvetica Neue',Helvetica,Arial,sans-serif; box-sizing: border-box; font-size: 14px; vertical-align: top; text-align: right; border-top-width: 1px; border-top-color: #eee; border-top-style: solid; margin: 0; padding: 5px 0;\" align=\"right\" valign=\"top\"> \
    $ 9.99</td> \
    </tr> \
    \
    <tr class=\"total\" style=\"font-family: 'Helvetica Neue',Helvetica,Arial,sans-serif; box-sizing: border-box; font-size: 14px; margin: 0;\"> \
    <td class=\"alignright\" width=\"80%\" style=\"font-family: 'Helvetica Neue',Helvetica,Arial,sans-serif; box-sizing: border-box; font-size: 14px; vertical-align: top; text-align: right; border-top-width: 2px; border-top-color: #333; border-top-style: solid; border-bottom-color: #333; border-bottom-width: 2px; border-bottom-style: solid; font-weight: 700; margin: 0; padding: 5px 0;\" align=\"right\" valign=\"top\"> \
    Total</td> \
    <td class=\"alignright\" style=\"font-family: 'Helvetica Neue',Helvetica,Arial,sans-serif; box-sizing: border-box; font-size: 14px; vertical-align: top; text-align: right; border-top-width: 2px; border-top-color: #333; border-top-style: solid; border-bottom-color: #333; border-bottom-width: 2px; border-bottom-style: solid; font-weight: 700; margin: 0; padding: 5px 0;\" align=\"right\" valign=\"top\"> \
    $ 33.98</td> \
    </tr> \
    </table> \
    </td> \
    </tr> \
    </table> \
    </td> \
    </tr> \
    <tr style=\"font-family: 'Helvetica Neue',Helvetica,Arial,sans-serif; box-sizing: border-box; font-size: 14px; margin: 0;\"> \
    <td class=\"content-block aligncenter\" style=\"font-family: 'Helvetica Neue',Helvetica,Arial,sans-serif; box-sizing: border-box; font-size: 14px; vertical-align: top; text-align: center; margin: 0; padding: 0 0 20px;\" align=\"center\" valign=\"top\"> \
    <!--<a href=\"http://www.mailgun.com\" style=\"font-family: 'Helvetica Neue',Helvetica,Arial,sans-serif; box-sizing: border-box; font-size: 14px; color: #348eda; text-decoration: underline; margin: 0;\">View in browser</a>--> \
    </td> \
    </tr> \
    <tr style=\"font-family: 'Helvetica Neue',Helvetica,Arial,sans-serif; box-sizing: border-box; font-size: 14px; margin: 0;\"> \
    <td class=\"content-block aligncenter\" style=\"font-family: 'Helvetica Neue',Helvetica,Arial,sans-serif; box-sizing: border-box; font-size: 14px; vertical-align: top; text-align: center; margin: 0; padding: 0 0 20px;\" align=\"center\" valign=\"top\"> \
    The Love Story Project<br> 734 Main Street, Cambria Ca, 93428 \
    </td> \
    </tr> \
    </table> \
    </td> \
    </tr> \
    </table> \
    <div class=\"footer\" style=\"font-family: 'Helvetica Neue',Helvetica,Arial,sans-serif; box-sizing: border-box; font-size: 14px; width: 100%; clear: both; color: #999; margin: 0; padding: 20px;\"> \
    <table width=\"100%\" style=\"font-family: 'Helvetica Neue',Helvetica,Arial,sans-serif; box-sizing: border-box; font-size: 14px; margin: 0;\"> \
    <tr style=\"font-family: 'Helvetica Neue',Helvetica,Arial,sans-serif; box-sizing: border-box; font-size: 14px; margin: 0;\"> \
    <td class=\"aligncenter content-block\" style=\"font-family: 'Helvetica Neue',Helvetica,Arial,sans-serif; box-sizing: border-box; font-size: 12px; vertical-align: top; color: #999; text-align: center; margin: 0; padding: 0 0 20px;\" align=\"center\" valign=\"top\">Questions? Email <a href=\"mailto:\" style=\"font-family: 'Helvetica Neue',Helvetica,Arial,sans-serif; box-sizing: border-box; font-size: 12px; color: #999; text-decoration: underline; margin: 0;\">support@acme.inc</a></td> \
    </tr> \
    </table> \
    </div> \
    </div> \
    </td> \
    <td style=\"font-family: 'Helvetica Neue',Helvetica,Arial,sans-serif; box-sizing: border-box; font-size: 14px; vertical-align: top; margin: 0;\" valign=\"top\"> \
			 \
    </td> \
    </tr> \
    </table> \
    </body> \
    </html> \
    \
    ";
    NSDictionary *from = [NSDictionary dictionaryWithObjectsAndKeys:@"Bryan Stevens", @"name", @"b.stevens.photo@gmail.com", @"email", nil];
    NSMutableArray* to = [[NSMutableArray alloc] initWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:[self sharedAppDelegate].userSettings.shipping.Name, @"name", [self sharedAppDelegate].userSettings.shipping.email, @"email", nil], nil];
    //NSString *messageBody = [NSString stringWithFormat:@"test Email"];
    NSMutableDictionary *emaildata = [NSMutableDictionary dictionaryWithObjectsAndKeys:htmlString, @"html", @"", @"text",@"The Love Story Project",@"subject",from,@"from",to,@"to", nil];
    [sendpulse smtpSendMail:emaildata];
    
    
    
    
}

//-(void)messageSent:(SKPSMTPMessage *)message{
//    NSLog(@"sent");
//    [alert dismissViewControllerAnimated:YES completion:nil];
//    [self performSegueWithIdentifier:@"OrderComplete" sender:self];
//    //save was successful
//}
//-(void)messageFailed:(SKPSMTPMessage *)message error:(NSError *)error{
//    NSLog(@"Failed to send: %@",error);
//}
//- (void)paymentContextDidChange:(STPPaymentContext *)paymentContext {
//    self.activityIndicator.animating = paymentContext.loading;
//    self.paymentButton.enabled = paymentContext.selectedPaymentMethod != nil;
//    self.paymentLabel.text = paymentContext.selectedPaymentMethod.label;
//    self.paymentIcon.image = paymentContext.selectedPaymentMethod.image;
//}
//
//- (void)paymentContext:(STPPaymentContext *)paymentContext
//didCreatePaymentResult:(STPPaymentResult *)paymentResult
//            completion:(STPErrorBlock)completion {
//    [self.apiClient createCharge:paymentResult.source.stripeID completion:^(NSError *error) {
//        if (error) {
//            completion(error);
//        } else {
//            completion(nil);
//        }
//    }];
//}
//
//- (void)paymentContext:(STPPaymentContext *)paymentContext
//   didFinishWithStatus:(STPPaymentStatus)status
//                 error:(NSError *)error {
//    switch (status) {
//        case STPPaymentStatusSuccess:
//            [self showReceipt];
//        case STPPaymentStatusError:
//            [self showError:error];
//        case STPPaymentStatusUserCancellation:
//            return; // Do nothing
//    }
//}

- (void)paymentContext:(STPPaymentContext *)paymentContext didFailToLoadWithError:(NSError *)error {
    [self.navigationController popViewControllerAnimated:YES];
    // Show the error to your user, etc.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
