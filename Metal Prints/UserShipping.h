//
//  UserShipping.h
//  Metal Prints
//
//  Created by Bryan Stevens on 8/21/16.
//  Copyright © 2016 Pocket Tools. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserShipping : NSObject
@property (retain, nonatomic) NSString *email;
@property (retain, nonatomic) NSString *Name;
@property (retain, nonatomic) NSString *street;
@property (retain, nonatomic) NSString *apt;
@property (retain, nonatomic) NSString *city;
@property (retain, nonatomic) NSString *state;
@property (retain, nonatomic) NSString *zip;
@property (retain, nonatomic) NSString *country;
@property (retain, nonatomic) NSDictionary *shippingDict;
@end
