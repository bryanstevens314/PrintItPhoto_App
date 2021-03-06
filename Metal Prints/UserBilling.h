//
//  UserBilling.h
//  Metal Prints
//
//  Created by Bryan Stevens on 8/21/16.
//  Copyright © 2016 Pocket Tools. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserPayment.h"

@interface UserBilling : NSObject
@property (retain, nonatomic) NSString *email;
@property (retain, nonatomic) NSString *firstName;
@property (retain, nonatomic) NSString *street;
@property (retain, nonatomic) NSString *apt;
@property (retain, nonatomic) NSString *city;
@property (retain, nonatomic) NSString *state;
@property (retain, nonatomic) NSString *zip;
@property (retain, nonatomic) NSString *tax_Percent;
@property (retain, nonatomic) NSString *tax_TotalCharged;

@property (retain, nonatomic) UserPayment *payment;

@end
