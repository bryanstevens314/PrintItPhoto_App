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
#import "UserObject.h"
#import "ImageCollectionViewController.h"
#import "TabController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

-(BOOL)InternetConnection;
@property (nonatomic) BOOL InternetConnected;
@property (nonatomic) BOOL lastConnectionState;
@property (strong, nonatomic) UIWindow *window;
@property (retain, nonatomic) NSMutableArray *allProductsArray;
@property (strong, nonatomic)NSArray *AluminumProductArray;
@property (strong, nonatomic)NSArray *WoodenProductArray;
@property (strong, nonatomic)NSArray *MugProductArray;
@property (strong, nonatomic)NSArray *TileProductArray;
@property (retain, nonatomic)NSMutableArray *shoppingCart;
@property (retain, nonatomic)NSDictionary *shippingInfo;

@property (retain, nonatomic)NSDictionary *billingInfo;
@property ( nonatomic)NSInteger cartTotal;
@property (nonatomic)NSInteger cartPrintTotal;
@property (retain, nonatomic) KCSAppdataStore *store;
@property (retain, nonatomic) TabController *TheTabController;
@property (retain, nonatomic) UserObject *userSettings;
@property (nonatomic) BOOL signedIn;
@property (nonatomic) BOOL newCartItem;
@property (nonatomic) BOOL gettingPhotos;
@property (nonatomic) BOOL reloadImageCollection;
@property (nonatomic) NSInteger totalImageCount;

@property (retain, nonatomic) NSMutableArray *phoneImageArray;
@property (retain, nonatomic) NSMutableArray *tempPhoneImageArray;
@property (retain, nonatomic) NSMutableArray *highlightedArray;
@property (retain, nonatomic) NSMutableArray *imagesInCartArray;
@property (retain, nonatomic) NSMutableArray *theNewImageArray;
@end

