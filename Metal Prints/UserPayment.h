//
//  UserPayment.h
//  Metal Prints
//
//  Created by Bryan Stevens on 8/21/16.
//  Copyright © 2016 Pocket Tools. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserPayment : NSObject

@property (retain, nonatomic) NSString *CCN;
@property (retain, nonatomic) NSString *securityCode;
@property (retain, nonatomic) NSString *expMonth;
@property (retain, nonatomic) NSString *expYear;

@end
