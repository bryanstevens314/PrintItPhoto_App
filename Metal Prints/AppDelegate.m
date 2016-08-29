//
//  AppDelegate.m
//  Metal Prints
//
//  Created by Bryan Stevens on 4/20/16.
//  Copyright © 2016 Pocket Tools. All rights reserved.
//

#import "AppDelegate.h"
#import "Order.h"
#import "Reachability.h"
#import <Stripe/Stripe.h>

@interface AppDelegate (){
    NSTimer *pingTimer;
}

@end

@implementation AppDelegate


- (NSString*)archivePathShoppingCart{
    NSArray *documentDirs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = documentDirs[0];
    return [docDir stringByAppendingPathComponent:@"Cart"];
}



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // Override point for customization after application launch.
[Stripe setDefaultPublishableKey:@"pk_test_ksluG61goDFXFGzyXZiRriat"];
    self.AluminumProductArray = @[@[@"4x4 Aluminum",@"12"],
                                 @[@"5x5 Aluminum",@"15"],
                                 @[@"5x7 Aluminum",@"18"],
                                 @[@"8x10 Aluminum",@"26"],
                                 @[@"5x10 Aluminum",@"22"],
                                 @[@"5x17 Aluminum",@"30"],
                                 @[@"8x12 Aluminum",@"30"],
                                 @[@"11x14 Aluminum",@"48"],
                                 @[@"11x17 Aluminum",@"48"],
                                 @[@"12x18 Aluminum",@"54"],];
    
    self.WoodenProductArray = @[@[@"8x8 Wood",@"36"],
                               @[@"8x10 Wood",@"40"],
                               @[@"10x10 Wood",@"44"],
                               @[@"11x14 Wood",@"48"],];
    
    self.MugProductArray = @[@[@"11oz Mug",@"12"],
                             @[@"15oz Mug",@"14"],];
    
    self.TileProductArray = @[@[@"8x8 Tile",@"36"],];
    
    self.allProductsArray = [[NSMutableArray alloc] init];
    
    [self.allProductsArray addObject:@"Aluminum Products"];
    
    [self.allProductsArray addObjectsFromArray:self.AluminumProductArray];
    
    [self.allProductsArray addObject:@"Wood Products"];
    
    [self.allProductsArray addObjectsFromArray:self.WoodenProductArray];
    
    [self.allProductsArray addObject:@"Mugs"];
    
    [self.allProductsArray addObjectsFromArray:self.MugProductArray];
    
    [self.allProductsArray addObject:@"Tile Products"];
    
    [self.allProductsArray addObjectsFromArray:self.TileProductArray];
    
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[self archivePathShoppingCart]]) {
        self.shoppingCart = [NSKeyedUnarchiver unarchiveObjectWithFile:[self archivePathShoppingCart]];
    }
    else{
        self.shoppingCart = [[NSMutableArray alloc] init];
    }
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[self archivehighlightedImages]]) {
        self.highlightedArray = [NSKeyedUnarchiver unarchiveObjectWithFile:[self archivehighlightedImages]];
    }
    else{
        self.highlightedArray = [[NSMutableArray alloc] init];
    }
    if ([[NSFileManager defaultManager] fileExistsAtPath:[self archiveCartTotals]]) {
        NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithFile:[self archiveCartTotals]];
        self.cartTotal = [[array objectAtIndex:0] integerValue];
        self.cartPrintTotal = [[array objectAtIndex:1] integerValue];
    }
    // Initialize Reachability
    Reachability *reachability = [Reachability reachabilityWithHostName:@"https://www.google.com"];
    
    // Start Monitoring
    [reachability startNotifier];

    if ([self InternetConnected]) {
        
        
        [[KCSClient sharedClient] initializeKinveyServiceForAppKey:@"kid_-JBnJ8W_Z-"
                                                     withAppSecret:@"4c300297d06541a6920e893f201f5d50"
                                                      usingOptions:nil];
        
        [KCSUser loginWithUsername:@"1" password:@"1" withCompletionBlock:^(KCSUser *user, NSError *errorOrNil, KCSUserActionResult result) {
            if (errorOrNil ==  nil) {
                //the log-in was successful and the user is now the active user and credentials saved
                //hide log-in view and show main app content
                self.signedIn = YES;


            } else {
                //there was an error with the update save
                self.signedIn = NO;
                //NSString* message = [errorOrNil localizedDescription];
                pingTimer = [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(InternetConnection) userInfo:nil repeats:YES];
            }
        }];
    }
    self.gettingPhotos = YES;
    self.reloadImageCollection = NO;
    [self getAllPhotos];
    

    return YES;
}

NSInteger count;
NSInteger x = 0;
-(void)getAllPhotos{
    
    //NSArray  *imageArray=[[NSArray alloc] init];
    NSMutableArray* assetURLDictionaries = [[NSMutableArray alloc] init];
    
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    
    NSMutableArray *tempMutArray = [[NSMutableArray alloc] init];
    

    void (^assetEnumerator)( ALAsset *, NSUInteger, BOOL *) = ^(ALAsset *result, NSUInteger index, BOOL *stop) {
        NSLog(@"%@",result);
        

        if(result != nil && result != NULL) {
            if([[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypePhoto]) {
                [assetURLDictionaries addObject:[result valueForProperty:ALAssetPropertyURLs]];
                // NSLog(@"assestlibrarymurari%@",assetURLDictionaries);
                
                NSURL *url= (NSURL*) [[result defaultRepresentation]url];

                NSArray *array;
                if (self.tempPhoneImageArray != nil) {
                    if (x >= 0) {
                        if ([self.tempPhoneImageArray objectAtIndex:x] != nil) {
                            NSArray *array1 = [self.tempPhoneImageArray objectAtIndex:x];
                            array = @[url, [array1 objectAtIndex:1]];
                            x--;
                        }

                    }
                    else{
                        
                        array = @[url, @""];
                        [self.theNewImageArray addObject:array];
                    }
                }
                else{
                    array = @[url, @""];
                }

                self.totalImageCount++;
                
                [self.phoneImageArray insertObject:array atIndex:0];
                //NSLog(@"Array:%@",self.phoneImageArray);
                
                
                //                if (counting == 25) {
                //                    counting = 0;
                //                    [self allPhotosCollected:mutableArray];
                //                    *stop = YES;
                //                }
                
                //                                 [mutableArray addObject:[UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]]];
                //                if (counting == 5) {
                //                    NSLog(@"found 5 images");
                //                    [self allPhotosCollected:mutableArray];
                //                    *stop = YES;
                //                }
                
                
            }
        }
        else{
            self.gettingPhotos = NO;
//            if (self.reloadImageCollection == YES) {
//                [[ImageCollectionViewController sharedImageCollectionViewController] reloadTheCollectionView];
//            }
        }
    };
    
    NSMutableArray *assetGroups = [[NSMutableArray alloc] init];
    
    void (^ assetGroupEnumerator) ( ALAssetsGroup *, BOOL *)= ^(ALAssetsGroup *group, BOOL *stop) {
        if(group != nil) {
            
            [assetGroups addObject:group];
            //NSLog(@"AssetGroup%@",assetGroups);
            count = [group numberOfAssets];
            if (self.phoneImageArray.count != 0) {
                if (count != self.phoneImageArray.count) {
                    NSLog(@"");
                    self.tempPhoneImageArray = self.phoneImageArray;
                    if (self.phoneImageArray != nil) {
                        self.phoneImageArray = nil;
                    }
                    self.phoneImageArray = [[NSMutableArray alloc] init];
                    self.theNewImageArray = [[NSMutableArray alloc] init];
                    if (self.tempPhoneImageArray != nil) {
                        x = self.tempPhoneImageArray.count - 1;
                    }

                    [group enumerateAssetsUsingBlock:assetEnumerator];
                }
            }
            else{
                if ([[NSFileManager defaultManager] fileExistsAtPath:[self archiveImageArray]]) {
                    self.tempPhoneImageArray = [NSKeyedUnarchiver unarchiveObjectWithFile:[self archiveImageArray]];
                    if (count != self.tempPhoneImageArray.count) {
                        if (self.phoneImageArray != nil) {
                            self.phoneImageArray = nil;
                        }
                        self.phoneImageArray = [[NSMutableArray alloc] init];
                        self.theNewImageArray = [[NSMutableArray alloc] init];
                        if (self.tempPhoneImageArray != nil) {
                            x = self.tempPhoneImageArray.count - 1;
                        }
                        [group enumerateAssetsUsingBlock:assetEnumerator];
                    }
                }
                else{
                    self.phoneImageArray = [[NSMutableArray alloc] init];
                    [group enumerateAssetsUsingBlock:assetEnumerator];
                }
            }
            
        }
    };
    
    assetGroups = [[NSMutableArray alloc] init];
    
    [library enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos
                           usingBlock:assetGroupEnumerator
                         failureBlock:^(NSError *error) {NSLog(@"There is an error");}];
    
    
}


-(BOOL)InternetConnection{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        NSLog(@"NOT Connected to The Internet");
        self.InternetConnected = NO;
        return NO;
    } else {
        NSLog(@"Connected to The Internet");
        if (self.InternetConnected == NO) {
            self.InternetConnected = YES;

                [pingTimer invalidate];
                pingTimer = nil;
                [KCSUser loginWithUsername:@"1" password:@"1" withCompletionBlock:^(KCSUser *user, NSError *errorOrNil, KCSUserActionResult result) {
                    if (errorOrNil ==  nil) {
                        //the log-in was successful and the user is now the active user and credentials saved
                        //hide log-in view and show main app content
                        self.signedIn = YES;
                        
                    } else {
                        //there was an error with the update save
                        self.signedIn = NO;
                        //NSString* message = [errorOrNil localizedDescription];
                        pingTimer = [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(InternetConnection) userInfo:nil repeats:YES];
                    }
                }];
            
        }
        
        
        
        return YES;
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    NSLog(@"Got To Here");
    [NSKeyedArchiver archiveRootObject:self.phoneImageArray toFile:[self archiveImageArray]];
    [NSKeyedArchiver archiveRootObject:self.imagesInCartArray toFile:[self archiveImagesInCart]];
    [NSKeyedArchiver archiveRootObject:self.highlightedArray toFile:[self archivehighlightedImages]];
    NSArray *array = @[[NSString stringWithFormat:@"%ld",(long)self.cartTotal], [NSString stringWithFormat:@"%ld",(long)self.cartPrintTotal]];
    [NSKeyedArchiver archiveRootObject:array toFile:[self archiveCartTotals]];
    NSLog(@"got here");
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
//    if (self.gettingPhotos == NO) {
//        self.reloadImageCollection = YES;
//        [self getAllPhotos];
//    }

    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (NSString*)archivehighlightedImages{
    NSArray *documentDirs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = documentDirs[0];
    return [docDir stringByAppendingPathComponent:@"highlightedImageArray"];
}


- (NSString*)archiveImagesInCart{
    NSArray *documentDirs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = documentDirs[0];
    return [docDir stringByAppendingPathComponent:@"cartImages"];
}

- (NSString*)archiveImageArray{
    NSArray *documentDirs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = documentDirs[0];
    return [docDir stringByAppendingPathComponent:@"ImageArray"];
}

- (NSString*)archiveCartTotals{
    NSArray *documentDirs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = documentDirs[0];
    return [docDir stringByAppendingPathComponent:@"cartTotals"];
}

@end
