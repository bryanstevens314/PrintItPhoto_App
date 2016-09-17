//
//  AppDelegate.m
//  Metal Prints
//
//  Created by Bryan Stevens on 4/20/16.
//  Copyright © 2016 Pocket Tools. All rights reserved.
//

@import Stripe;
#import "AppDelegate.h"
#import "Order.h"
#import "Reachability.h"
#import "Front_EndVC.h"

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
     [[STPPaymentConfiguration sharedConfiguration] setPublishableKey:@"pk_test_ksluG61goDFXFGzyXZiRriat"];
    self.AluminumProductArray = @[@[@"2x3",@"6",[UIImage imageNamed:@"2x3 aluminum.png"]],
                                @[@"4x4",@"12",[UIImage imageNamed:@"4x4 aluminum.png"]],
                                 @[@"5x5",@"15",[UIImage imageNamed:@"5x5  aluminum.png"]],
                                  @[@"4x6",@"15",[UIImage imageNamed:@"4x6 aluminum.png"]],
                                 @[@"5x7",@"18",[UIImage imageNamed:@"5x7 aluminum.png"]],
                                 @[@"5x10",@"22",[UIImage imageNamed:@"5x10 aluminum.png"]],
                                  @[@"5x11",@"25",[UIImage imageNamed:@"5x11 aluminum.png"]],
                                  @[@"8x8",@"22",[UIImage imageNamed:@"8x8 aluminum.png"]],
                                 @[@"5x17",@"32",[UIImage imageNamed:@"5x17 aluminum.png"]],
                                  @[@"8x10",@"24",[UIImage imageNamed:@"8x10 aluminum.png"]],
                                 @[@"8x12",@"28",[UIImage imageNamed:@"8x12 aluminum.png"]],
                                  @[@"10x10",@"28",[UIImage imageNamed:@"10x10 aluminum.png"]],
                                 @[@"11x14",@"40",[UIImage imageNamed:@"11x14 aluminum.png"]],
                                  @[@"12x12",@"40",[UIImage imageNamed:@"12x12 aluminum.png"]],
                                 @[@"11x17",@"48",[UIImage imageNamed:@"11x17 aluminum.png"]],
                                 @[@"12x18",@"54",[UIImage imageNamed:@"12x18 aluminum.png"]],];
    
    self.WoodenProductArray = @[@[@"8x8",@"36",[UIImage imageNamed:@"8x8 wood.png"]],
                               @[@"8x10",@"40",[UIImage imageNamed:@"8x10 wood.png"]],
                               @[@"10x10",@"44",[UIImage imageNamed:@"10x10 wood.png"]],
                               @[@"11x14",@"48",[UIImage imageNamed:@"11x14 wood.png"]],];
    
    self.TileProductArray = @[@[@"4x4",@"14",[UIImage imageNamed:@"4x4 tile.png"]],
                             @[@"6x6",@"18",[UIImage imageNamed:@"6x6 tile.png"]],
                              @[@"6x8",@"22",[UIImage imageNamed:@"6x8 tile.png"]],
                              @[@"8x10",@"30",[UIImage imageNamed:@"8x10 tile.png"]],];
    
    self.SlateProductArray = @[@[@"6x6",@"24",[UIImage imageNamed:@"6x6 slate.png"]],
                               @[@"6x8",@"30",[UIImage imageNamed:@"6x8 slate.png"]],
                               @[@"8x12",@"36",[UIImage imageNamed:@"8x12 slate.png"]],];
    
    self.OtherProductArray = @[@[@"Square Keychain",@"12",[UIImage imageNamed:@"8x12 slate.png"]],
                              @[@"Rectangle Keychain",@"12",[UIImage imageNamed:@"8x12 slate.png"]],
                              @[@"Long Keychaing",@"12",[UIImage imageNamed:@"8x12 slate.png"]],
                              @[@"Dog Tag",@"12",[UIImage imageNamed:@"8x12 slate.png"]],
                              @[@"Square Pendant",@"16",[UIImage imageNamed:@"8x12 slate.png"]],
                              @[@"Round Pendant",@"16",[UIImage imageNamed:@"8x12 slate.png"]],
                              @[@"Long Pendant",@"18",[UIImage imageNamed:@"8x12 slate.png"]],
                              @[@"Clock",@"36",[UIImage imageNamed:@"8x12 slate.png"]],];
    
    self.categoryArray = @[@"Aluminum",@"Wood",@"Tile",@"Slate",@"Other Goodies",];
    
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
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://final-project-order-viewer-stevens-apps.c9users.io/recieve_data.php"]];
        NSDictionary *cartItem = [NSDictionary dictionaryWithObjectsAndKeys:
                                  @"1",@"user_Opened_App",nil];
        NSError *error2;
        NSData *finalJSONdata = [NSJSONSerialization dataWithJSONObject:cartItem options:0 error:&error2];
        
        //NSLog(@"%.2f MB",(float)finalJSONdata.length/1024.0f/1024.0f);
        
        [request setHTTPBody:finalJSONdata];
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[finalJSONdata length]] forHTTPHeaderField:@"Content-Length"];
        
        
        NSError *err;
        NSURLResponse *response;
        
        
        
        NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
        NSString *responseString = [[NSString alloc]initWithData:responseData encoding:NSASCIIStringEncoding];
        
        
        if(responseString)
        {
            //[self performSegueWithIdentifier:@"OrderPlaced" sender:self];
            NSLog(@"got response==%@", responseString);
            
        }
    }
    
//    self.loadingImages  = YES;
//    self.reloadImageCollection = NO;
//    [self getAllPhotos];
    

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
                UIImage *thumbImg = [UIImage imageWithCGImage: [result aspectRatioThumbnail]];
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
            int x = 0;
            for (NSArray *imgArray1 in self.phoneImageArray) {
                x++;
                ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
                [library assetForURL:[imgArray1 objectAtIndex:0]
                         resultBlock:^(ALAsset *asset) {
                             
                             if (x < self.phoneImageArray.count) {
                                 NSLog(@"Less than: %i",x);
                                 
                                 UIImage *thumbImg = [UIImage imageWithCGImage: [asset aspectRatioThumbnail]];
                                 
                                 if (thumbImg == nil || thumbImg == NULL) {
                                     [self.phoneImageArray removeObjectAtIndex:x];
                                 }else{
                                     [self.mutableImageArray addObject:thumbImg];
                                 }
                             }
                             if (x == self.phoneImageArray.count) {
                                 NSLog(@"Equal to");
                                 UIImage *thumbImg = [UIImage imageWithCGImage:[asset aspectRatioThumbnail]];
                                 if (thumbImg == nil || thumbImg == NULL) {
                                     [self.phoneImageArray removeObjectAtIndex:x];
                                 }else{
                                     [self.mutableImageArray addObject:thumbImg];
                                 }
                                
                                 
                                 self.loadingImages = NO;
                                 [[Front_EndVC sharedFrontEnd_VC] FinishedLoadingImages];
                                 
                                 
                             }
                                 

                         }
                 
                        failureBlock:^(NSError *error){
                            NSLog(@"operation was not successfull!");
                        }];
                
            }
            

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
                    self.mutableImageArray = [[NSMutableArray alloc] init];
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
                        self.mutableImageArray = [[NSMutableArray alloc] init];
                        if (self.tempPhoneImageArray != nil) {
                            x = self.tempPhoneImageArray.count - 1;
                        }
                        [group enumerateAssetsUsingBlock:assetEnumerator];
                    }
                }
                else{
                    self.phoneImageArray = [[NSMutableArray alloc] init];
                    self.mutableImageArray = [[NSMutableArray alloc] init];
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
