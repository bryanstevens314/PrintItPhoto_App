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

#import "UserObject.h"
#import "ImageCollectionViewController.h"

#import "LaunchController.h"
#import "CropController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

-(BOOL)InternetConnection;
@property (nonatomic) BOOL InternetConnected;
@property (nonatomic) BOOL lastConnectionState;
@property (strong, nonatomic) UIWindow *window;
@property (retain, nonatomic) NSMutableArray *allProductsArray;
@property (strong, nonatomic)NSArray *AluminumProductArray;
@property (strong, nonatomic)NSArray *WoodenProductArray;
@property (strong, nonatomic)NSArray *SlateProductArray;
@property (strong, nonatomic)NSArray *TileProductArray;
@property (strong, nonatomic)NSArray *OtherProductArray;
@property (strong, nonatomic)NSArray *categoryArray;
@property (retain, nonatomic)NSMutableArray *shoppingCart;
@property (retain, nonatomic)NSDictionary *shippingInfo;

@property (retain, nonatomic)NSDictionary *billingInfo;
@property ( nonatomic)NSInteger cartTotal;
@property ( nonatomic) BOOL shippingOK;
@property ( nonatomic) BOOL billingOK;
@property ( nonatomic) BOOL cartIsMainController;
@property ( nonatomic) BOOL displayingCart;
@property (nonatomic)NSInteger cartPrintTotal;
@property (retain, nonatomic) KCSAppdataStore *store;
@property (retain, nonatomic) UserObject *userSettings;
@property (retain, nonatomic)NSString *taxPercentString;
@property (retain, nonatomic)NSString *total_TaxCharged;
@property (retain, nonatomic)NSString *serverToken;
@property (nonatomic) BOOL signedIn;
@property (nonatomic) BOOL newCartItem;
@property (nonatomic) BOOL reloadImageCollection;
@property (nonatomic) BOOL loadingImages;
@property (nonatomic) NSInteger totalImageCount;

@property (retain, nonatomic) NSMutableArray *phoneImageArray;
@property (retain, nonatomic) NSMutableArray *savedAddressesArray;
@property (retain, nonatomic) NSMutableArray *highlightedArray;

@end

