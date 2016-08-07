//
//  TestVC.m
//  Metal Prints
//
//  Created by Bryan Stevens on 5/23/16.
//  Copyright © 2016 Pocket Tools. All rights reserved.
//

#import "TestVC.h"
#import <Stripe/Stripe.h>

@interface TestVC ()

@end

@implementation TestVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

- (IBAction)button:(id)sender {
    STPCardParams *params = [[STPCardParams alloc] init];
    params.number = @"";
    params.expMonth = 0;
    params.expYear = 0;
    params.cvc = @"";
    params.name = @"";
    params.addressLine1 = @"";
    params.addressLine2 = @"";
    params.addressCity = @"";
    params.addressState = @"";
    params.addressZip = @"";
    params.addressCountry = @"";
    params.currency = @"";
    [[STPAPIClient sharedClient]
     createTokenWithCard:params
     completion:^(STPToken *token, NSError *error) {
         if (error) {
             NSLog(@"%@",error);
         } else {
             [self createBackendChargeWithToken:token completion:nil];
         }
     }];
        
    
}

- (void)createBackendChargeWithToken:(STPToken *)token completion:(void (^)(PKPaymentAuthorizationStatus))completion {
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://final-project-order-viewer-stevens-apps.c9users.io/stripeStuff.php"]];
    NSDictionary *chargeParams = [NSDictionary dictionaryWithObjectsAndKeys: token.tokenId, @"stripeToken",
                                                                             @"1", @"chargeAmount",
                                                                             @"example charge", @"description",
                                                                             @"incrementing ID", @"orderID",nil];
    
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
      }
      else{
          NSLog(@"Error!");
          
      }

}
@end
