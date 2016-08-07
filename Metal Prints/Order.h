//
//  User.h
//  The Love Project
//
//  Created by Bryan Stevens on 3/7/16.
//  Copyright © 2016 Bryan Stevens. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <KinveyKit/KinveyKit.h>

@interface Order : NSObject <KCSPersistable>

@property (nonatomic, copy) NSString* entityId; //Kinvey entity _id
@property (nonatomic, copy) NSString* name;
@property (nonatomic, copy) NSString* date;
@property (nonatomic, copy) NSString* email;
@property (nonatomic, copy) NSString* product;
@property (nonatomic, copy) UIImage* Image;
@property (nonatomic, copy) NSString* retouching;
@property (nonatomic, copy) NSString* instructions;
@property (nonatomic, copy) NSString* aluminum_prints;
@property (nonatomic, copy) NSString* shipping_name;
@property (nonatomic, copy) NSString* shipping_address;
@property (nonatomic) BOOL videoUploaded;

@end
