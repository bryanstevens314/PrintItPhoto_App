//
//  User.m
//  The Love Project
//
//  Created by Bryan Stevens on 3/7/16.
//  Copyright © 2016 Bryan Stevens. All rights reserved.
//

#import "Order.h"

@implementation Order


- (NSDictionary *)hostToKinveyPropertyMapping
{
    return @{
             @"entityId" : KCSEntityKeyId, //the required _id field
             @"name" : @"name",
             @"date" : @"date",
             @"email" : @"email",
             @"product" : @"product",
             @"Image" : @"image",
             @"retouching" : @"retouching",
             @"instructions" : @"instructions",
             @"aluminum_prints" : @"aluminum_prints",
             @"shipping_name" : @"shipping_name",
             @"shipping_address" : @"shipping_address",
             
             };
}


@end
