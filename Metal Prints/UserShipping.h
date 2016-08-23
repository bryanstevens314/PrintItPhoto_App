//
//  UserShipping.h
//  Metal Prints
//
//  Created by Bryan Stevens on 8/21/16.
//  Copyright © 2016 Pocket Tools. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserShipping : NSObject

@property (weak, nonatomic) NSString *name;
@property (weak, nonatomic) NSString *street;
@property (weak, nonatomic) NSString *apt;
@property (weak, nonatomic) NSString *city;
@property (weak, nonatomic) NSString *state;
@property (weak, nonatomic) NSString *zip;
@end
