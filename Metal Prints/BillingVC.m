//
//  BillingVC.m
//  
//
//  Created by Bryan Stevens on 8/22/16.
//
//
#import "Sendpulse.h"
#import "BillingVC.h"
#import "AppDelegate.h"
#import "UserBilling.h"

@interface BillingVC (){
    CCTVC *CCTable;
}

@end

@implementation BillingVC


- (AppDelegate *)sharedAppDelegate
{
    
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:self action:@selector(EnterPayment)];
    [self.navigationItem setRightBarButtonItem:rightBarButtonItem];
    [self.navigationItem setTitle:@"Billing"];
    
    CCTable = [CCTVC sharedCCTVC];
    CCTable.delegate = self;
        CCTable.tableView.frame = CGRectMake(self.tableContentView.frame.origin.x, self.tableContentView.frame.origin.y-110, self.tableContentView.frame.size.width, self.tableContentView.frame.size.height);

    [self.tableContentView addSubview:CCTable.tableView];
    
    NSLog(@"%@",[self sharedAppDelegate].userSettings.shipping);
    

}

- (void)EnterPayment {
    
    
    if (![CCTable.firstName.text isEqualToString:@""] && ![CCTable.LastName.text isEqualToString:@""] && ![CCTable.streetAddress.text isEqualToString:@""] && ![CCTable.City.text isEqualToString:@""] && ![CCTable.state.text isEqualToString:@""] && ![CCTable.zip.text isEqualToString:@""]) {
        
        [self sharedAppDelegate].userSettings.billing = [[UserBilling alloc] init];
        
        [self sharedAppDelegate].userSettings.billing.firstName = CCTable.firstName.text;
        
        [self sharedAppDelegate].userSettings.billing.lastName = CCTable.LastName.text;
        
        [self sharedAppDelegate].userSettings.billing.street = CCTable.streetAddress.text;
        
        [self sharedAppDelegate].userSettings.billing.apt = CCTable.apt.text;
        
        [self sharedAppDelegate].userSettings.billing.city = CCTable.City.text;
        
        [self sharedAppDelegate].userSettings.billing.state = CCTable.state.text;
        
        [self sharedAppDelegate].userSettings.billing.zip = CCTable.zip.text;
        
        
        //[self performSegueWithIdentifier:@"Payment" sender:self];
    }
    else{
//        UIAlertController *alert2 = [UIAlertController alertControllerWithTitle:@"" message:@"Please enter all required information"preferredStyle:UIAlertControllerStyleAlert];
//        
//        UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"OK"
//                                                               style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
//                                                                   [alert2 dismissViewControllerAnimated:YES completion:nil];
//                                                               }]; // 2
//        
//        [alert2 addAction:cameraAction];
//        
//        [self presentViewController:alert2 animated:YES completion:nil];

    [self PostData];
    }
}

- (void)shippingSameAsBilling{
    [self sharedAppDelegate].userSettings.billing = [[UserBilling alloc] init];
    [self sharedAppDelegate].userSettings.billing.firstName = CCTable.firstName.text;
    
    [self sharedAppDelegate].userSettings.billing.lastName = CCTable.LastName.text;
    
    [self sharedAppDelegate].userSettings.billing.street = CCTable.streetAddress.text;
    
    [self sharedAppDelegate].userSettings.billing.apt = CCTable.apt.text;
    
    [self sharedAppDelegate].userSettings.billing.city = CCTable.City.text;
    
    [self sharedAppDelegate].userSettings.billing.state = CCTable.state.text;
    
    [self sharedAppDelegate].userSettings.billing.zip = CCTable.zip.text;
    
    [self performSegueWithIdentifier:@"Payment" sender:self];
}


-(void)moveViewUp{
    
    [UIView animateWithDuration:0.25f animations:^{
        [self.view setFrame:CGRectMake(0,-30,self.view.bounds.size.width,self.view.bounds.size.height)];
    }];
    
}

-(void)moveViewDown{
    
    [UIView animateWithDuration:0.25f animations:^{
        [self.view setFrame:CGRectMake(0,0,self.view.bounds.size.width,self.view.bounds.size.height)];
    }];
}


-(void)PostData{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://final-project-order-viewer-stevens-apps.c9users.io/recieve_data.php"]];
    
    
    
    NSMutableDictionary *mutDict = [[NSMutableDictionary alloc] init];
    [mutDict setObject:[self sharedAppDelegate].userSettings.shippingDict forKey:@"customer"];
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
        [self sendEmail];
        
    }
    else
    {
        NSLog(@"faield to connect");
        UIAlertController *alert2 = [UIAlertController alertControllerWithTitle:@"" message:@"There was a problem uploading your images. Please check your internet connection and try again"preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"OK"
                                                               style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                                   [alert2 dismissViewControllerAnimated:YES completion:nil];
                                                               }]; // 2
        
        [alert2 addAction:cameraAction];
        
        [self presentViewController:alert2 animated:YES completion:nil];
        
    }
    
}

-(void)sendEmail
{
    
    Sendpulse* sendpulse = [[Sendpulse alloc] initWithUserIdandSecret:@"8663ca13cd9f05ef1f538f8d6295ff0e" :@"1af4a885aaaa45faa3ee21e763cc5667"];
    NSDictionary *from = [NSDictionary dictionaryWithObjectsAndKeys:@"Bryan Stevens", @"name", @"b.stevens.photo@gmail.com", @"email", nil];
    NSMutableArray* to = [[NSMutableArray alloc] initWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:@"Bryan Stevens", @"name", @"btcfaucetfree@gmail.com", @"email", nil], nil];
    NSString *messageBody = @" \
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
                             <table class=\"body-wrap\" style=\"font-family: 'Helvetica Neue',Helvetica,Arial,sans-serif; box-sizing: border-box; font-size: 14px; width: 100%; background-color: #f6f6f6; margin: 0;\" bgcolor=\"#f6f6f6\"><tr style=\"font-family: 'Helvetica Neue',Helvetica,Arial,sans-serif; box-sizing: border-box; font-size: 14px; margin: 0;\"> \
                             <td style=\"font-family: 'Helvetica Neue',Helvetica,Arial,sans-serif; box-sizing: border-box; font-size: 14px; vertical-align: top; margin: 0;\" valign=\"top\"></td> \
                             <td class=\"container\" width=\"600\" style=\"font-family: 'Helvetica Neue',Helvetica,Arial,sans-serif; box-sizing: border-box; font-size: 14px; vertical-align: top; display: block !important; max-width: 600px !important; clear: both !important; margin: 0 auto;\" valign=\"top\"> \
                             <div class=\"content\" style=\"font-family: 'Helvetica Neue',Helvetica,Arial,sans-serif; box-sizing: border-box; font-size: 14px; max-width: 600px; display: block; margin: 0 auto; padding: 20px;\"> \
                             <table class=\"main\" width=\"100%\" cellpadding=\"0\" cellspacing=\"0\" style=\"font-family: 'Helvetica Neue',Helvetica,Arial,sans-serif; box-sizing: border-box; font-size: 14px; border-radius: 3px; background-color: #fff; margin: 0; border: 1px solid #e9e9e9;\" bgcolor=\"#fff\"> \
                             <tr style=\"font-family: 'Helvetica Neue',Helvetica,Arial,sans-serif; box-sizing: border-box; font-size: 14px; margin: 0;\"> \
                             <td class=\"content-wrap aligncenter\" style=\"font-family: 'Helvetica Neue',Helvetica,Arial,sans-serif; box-sizing: border-box; font-size: 14px; vertical-align: top; text-align: center; margin: 0; padding: 20px;\" align=\"center\" valign=\"top\"> \
                             <table width=\"100%\" cellpadding=\"0\" cellspacing=\"0\" style=\"font-family: 'Helvetica Neue',Helvetica,Arial,sans-serif; box-sizing: border-box; font-size: 14px; margin: 0;\"> \
                             <tr style=\"font-family: 'Helvetica Neue',Helvetica,Arial,sans-serif; box-sizing: border-box; font-size: 14px; margin: 0;\"> \
                             <td class=\"content-block\" style=\"font-family: 'Helvetica Neue',Helvetica,Arial,sans-serif; box-sizing: border-box; font-size: 14px; vertical-align: top; margin: 0; padding: 0 0 20px;\" valign=\"top\"> \
                             <h1 class=\"aligncenter\" style=\"font-family: 'Helvetica Neue',Helvetica,Arial,'Lucida Grande',sans-serif; box-sizing: border-box; font-size: 32px; color: #000; line-height: 1.2em; font-weight: 500; text-align: center; margin: 40px 0 0;\" align=\"center\"> \
                    $%@ Paid</h1> \
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
                    %@<br> \
                    %@<br> \
                    %@, %@<br> \
                             </p>  \
                             \
                             </tr><tr style=\"font-family: 'Helvetica Neue',Helvetica,Arial,sans-serif; box-sizing: border-box; font-size: 14px; margin: 0;\" \
                             ><td style=\"font-family: 'Helvetica Neue',Helvetica,Arial,sans-serif; box-sizing: border-box; font-size: 14px; vertical-align: top; margin: 0; padding: 5px 0;\" valign=\"top\"> \
                             <table class=\"invoice-items\" cellpadding=\"0\" cellspacing=\"0\" style=\"font-family: 'Helvetica Neue',Helvetica,Arial,sans-serif; box-sizing: border-box; font-size: 14px; width: 100%; margin: 0;\"> \
                             \
                             \
                             \
                             \
                             <tr class=\"total\" style=\"font-family: 'Helvetica Neue',Helvetica,Arial,sans-serif; box-sizing: border-box; font-size: 14px; margin: 0;\"> \
                             <td class=\"alignright\" width=\"80%\" style=\"font-family: 'Helvetica Neue',Helvetica,Arial,sans-serif; box-sizing: border-box; font-size: 14px; vertical-align: top; text-align: right; border-top-width: 2px; border-top-color: #333; border-top-style: solid; border-bottom-color: #333; border-bottom-width: 2px; border-bottom-style: solid; font-weight: 700; margin: 0; padding: 5px 0;\" align=\"right\" valign=\"top\"> \
                    Total</td> \
                             <td class=\"alignright\" style=\"font-family: 'Helvetica Neue',Helvetica,Arial,sans-serif; box-sizing: border-box; font-size: 14px; vertical-align: top; text-align: right; border-top-width: 2px; border-top-color: #333; border-top-style: solid; border-bottom-color: #333; border-bottom-width: 2px; border-bottom-style: solid; font-weight: 700; margin: 0; padding: 5px 0;\" align=\"right\" valign=\"top\"> \
                    $ $@</td> \
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
    
    NSMutableString *mutableMessageBody = [messageBody mutableCopy];
    NSString *insertAtString = @" \
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
    <table class=\"body-wrap\" style=\"font-family: 'Helvetica Neue',Helvetica,Arial,sans-serif; box-sizing: border-box; font-size: 14px; width: 100%; background-color: #f6f6f6; margin: 0;\" bgcolor=\"#f6f6f6\"><tr style=\"font-family: 'Helvetica Neue',Helvetica,Arial,sans-serif; box-sizing: border-box; font-size: 14px; margin: 0;\"> \
    <td style=\"font-family: 'Helvetica Neue',Helvetica,Arial,sans-serif; box-sizing: border-box; font-size: 14px; vertical-align: top; margin: 0;\" valign=\"top\"></td> \
    <td class=\"container\" width=\"600\" style=\"font-family: 'Helvetica Neue',Helvetica,Arial,sans-serif; box-sizing: border-box; font-size: 14px; vertical-align: top; display: block !important; max-width: 600px !important; clear: both !important; margin: 0 auto;\" valign=\"top\"> \
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
    Lee Munroe<br> \
    1930 10th st<br> \
    Los Osos, CA<br> \
    </p>  \
    \
    </tr><tr style=\"font-family: 'Helvetica Neue',Helvetica,Arial,sans-serif; box-sizing: border-box; font-size: 14px; margin: 0;\" \
    ><td style=\"font-family: 'Helvetica Neue',Helvetica,Arial,sans-serif; box-sizing: border-box; font-size: 14px; vertical-align: top; margin: 0; padding: 5px 0;\" valign=\"top\"> \
    <table class=\"invoice-items\" cellpadding=\"0\" cellspacing=\"0\" style=\"font-family: 'Helvetica Neue',Helvetica,Arial,sans-serif; box-sizing: border-box; font-size: 14px; width: 100%; margin: 0;\"> \
    ";
    NSLog(@"%lu",(unsigned long)messageBody.length);
    NSLog(@"%lu",(unsigned long)insertAtString.length);
    for (NSArray *itemArray in [self sharedAppDelegate].shoppingCart) {
        NSString *prod = [itemArray objectAtIndex:0];
        NSString *quan = [itemArray objectAtIndex:1];
        NSString *price = [itemArray objectAtIndex:2];
        
        NSString *itemString = [NSString stringWithFormat:@"    <tr style=\"font-family: 'Helvetica Neue',Helvetica,Arial,sans-serif; box-sizing: border-box; font-size: 14px; margin: 0;\" \
                                ><td style=\"font-family: 'Helvetica Neue',Helvetica,Arial,sans-serif; box-sizing: border-box; font-size: 14px; vertical-align: top; border-top-width: 1px; border-top-color: #eee; border-top-style: solid; margin: 0; padding: 5px 0;\" valign=\"top\"> \
                                %@x %@</td> \
                                <td class=\"alignright\" style=\"font-family: 'Helvetica Neue',Helvetica,Arial,sans-serif; box-sizing: border-box; font-size: 14px; vertical-align: top; text-align: right; border-top-width: 1px; border-top-color: #eee; border-top-style: solid; margin: 0; padding: 5px 0;\" align=\"right\" valign=\"top\"> \
                                $ %@</td> \
                                </tr> ",quan,prod,price ];
        [mutableMessageBody insertString:itemString atIndex:insertAtString.length];
    }
    NSMutableDictionary *emaildata = [NSMutableDictionary dictionaryWithObjectsAndKeys:mutableMessageBody, @"html", @"", @"text",@"BTC Faucet Withdrawal",@"subject",from,@"from",to,@"to", nil];
    [sendpulse smtpSendMail:emaildata];
    
    
    
    
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
