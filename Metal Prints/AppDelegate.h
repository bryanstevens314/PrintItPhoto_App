//
//  AppDelegate.h
//  Metal Prints
//
//  Created by Bryan Stevens on 4/20/16.
//  Copyright © 2016 Pocket Tools. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <KinveyKit/KinveyKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "TabController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

-(BOOL)InternetConnection;
@property (nonatomic) BOOL InternetConnected;
@property (nonatomic) BOOL lastConnectionState;
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic)NSArray *AluminumProductArray;
@property (strong, nonatomic)NSArray *WoodenProductArray;
@property (retain, nonatomic)NSMutableArray *shoppingCart;
@property (retain, nonatomic)NSDictionary *shippingInfo;

@property (retain, nonatomic)NSDictionary *billingInfo;
@property (retain, nonatomic)NSString *cartTotal;
@property (retain, nonatomic) KCSAppdataStore *store;
@property (retain, nonatomic) TabController *TheTabController;
@property (nonatomic) BOOL signedIn;
@property (nonatomic) BOOL newCartItem;
@property (nonatomic) NSInteger totalImageCount;
@property (retain, nonatomic) NSMutableArray *mutableArray;
@property (retain, nonatomic) NSMutableArray *highlightedArray;
@property (retain, nonatomic) NSMutableArray *imagesInCartArray;
@end

