//
//  UserPayment.h
//  Metal Prints
//
//  Created by Bryan Stevens on 8/21/16.
//  Copyright © 2016 Pocket Tools. All rights reserved.
//

#import <Foundation/Foundation.h>
@import Stripe;

@interface UserPayment : NSObject

@property (retain, nonatomic) NSString *CCN;
@property (retain, nonatomic) NSString *securityCode;
@property (retain, nonatomic) NSString *expMonth;
@property (retain, nonatomic) NSString *expYear;
@property (retain, nonatomic) STPToken *stripe_Token;

@end
