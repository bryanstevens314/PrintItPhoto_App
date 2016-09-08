//
//  UserObject.h
//  Metal Prints
//
//  Created by Bryan Stevens on 8/21/16.
//  Copyright © 2016 Pocket Tools. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserShipping.h"
#import "UserBilling.h"

@interface UserObject : NSObject

@property (retain,nonatomic) UserShipping *shipping;
@property (retain,nonatomic) UserBilling *billing;
@property (retain,nonatomic) NSDictionary *shippingDict;
@end
