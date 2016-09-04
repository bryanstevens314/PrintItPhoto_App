//
//  StripeViewController.m
//  Metal Prints
//
//  Created by Bryan Stevens on 9/2/16.
//  Copyright © 2016 Pocket Tools. All rights reserved.
//

#import "StripeViewController.h"

@interface StripeViewController ()

@end

@implementation StripeViewController



//- (instancetype)init {
//    self = [super initWithNibName:nil bundle:nil];
//    if (self) {
//        // Here, MyAPIAdapter is your class that implements STPBackendAPIAdapter (see above)
//        id<STPBackendAPIAdapter> apiAdapter = [[MyAPIAdapter alloc] init];
//        self.paymentContext = [[STPPaymentContext alloc] initWithAPIAdapter:apiAdapter];
//        self.paymentContext.delegate = self;
//        self.paymentContext.hostViewController = self;
//        self.paymentContext.paymentAmount = 5000; // Measured in cents, i.e. $50 USD
//    }
//    return self;
//}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}



//// If you prefer a modal presentation
//- (void)choosePaymentButtonTapped {
//    [self.paymentContext presentPaymentMethodsViewController];
//}

// If you prefer a navigation transition
- (void)choosePaymentButtonTapped {
    [self.paymentContext pushPaymentMethodsViewController];
}

- (void)payButtonTapped {
    [self.paymentContext requestPayment];
}

@end
