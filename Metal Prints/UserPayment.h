//
//  UserPayment.h
//  Metal Prints
//
//  Created by Bryan Stevens on 8/21/16.
//  Copyright © 2016 Pocket Tools. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserPayment : NSObject

@property (weak, nonatomic) NSString *CCN;
@property (weak, nonatomic) NSString *securityCode;
@property (weak, nonatomic) NSString *expMonth;
@property (weak, nonatomic) NSString *expYear;

@end
