//
//  AppDelegate.m
//  Metal Prints
//
//  Created by Bryan Stevens on 4/20/16.
//  Copyright © 2016 Pocket Tools. All rights reserved.
//

@import Stripe;
#import "AppDelegate.h"
#import "Reachability.h"
#import "ProductCategorySelectionCollection.h"


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
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    // Override point for customization after application launch.
//    NSError *error;
//    [[NSFileManager defaultManager] removeItemAtPath:[self archiveAddresses] error:&error];
     [[STPPaymentConfiguration sharedConfiguration] setPublishableKey:@"pk_test_ksluG61goDFXFGzyXZiRriat"];
    self.AluminumProductArray = @[@[@"2x3",@"6",[UIImage imageNamed:@"2x3 aluminum.png"], @"00000", @"A2x3", [NSValue valueWithCGSize:CGSizeMake(3.0f, 2.0f)]],
                                @[@"4x4",@"12",[UIImage imageNamed:@"4x4 aluminum.png"], @"00000", @"A4x4", [NSValue valueWithCGSize:CGSizeMake(4.0f, 4.0f)]],
                                  @[@"4x6",@"15",[UIImage imageNamed:@"4x6 aluminum.png"], @"00000", @"A4x6", [NSValue valueWithCGSize:CGSizeMake(4.0f, 6.0f)]],
                                 @[@"5x5",@"15",[UIImage imageNamed:@"5x5  aluminum.png"], @"00000", @"A5x5", [NSValue valueWithCGSize:CGSizeMake(5.0f, 5.0f)]],
                                  
                                 @[@"5x7",@"18",[UIImage imageNamed:@"5x7 aluminum.png"], @"00000", @"A5x7", [NSValue valueWithCGSize:CGSizeMake(5.0f, 7.0f)]],
                                 @[@"5x10",@"22",[UIImage imageNamed:@"5x10 aluminum.png"], @"00000", @"A5x10", [NSValue valueWithCGSize:CGSizeMake(5.0f, 10.0f)]],
                                  @[@"5x11",@"25",[UIImage imageNamed:@"5x11 aluminum.png"], @"00000", @"A5x11", [NSValue valueWithCGSize:CGSizeMake(5.0f, 11.0f)]],
                                  @[@"5x17",@"32",[UIImage imageNamed:@"5x17 aluminum.png"], @"00000", @"A5x17", [NSValue valueWithCGSize:CGSizeMake(5.0f, 17.0f)]],
                                  @[@"8x8",@"22",[UIImage imageNamed:@"8x8 aluminum.png"], @"00000", @"A8x8", [NSValue valueWithCGSize:CGSizeMake(8.0f, 8.0f)]],
                                  @[@"8x10",@"24",[UIImage imageNamed:@"8x10 aluminum.png"], @"00000", @"A8x10", [NSValue valueWithCGSize:CGSizeMake(8.0f, 10.0f)]],
                                 @[@"8x12",@"28",[UIImage imageNamed:@"8x12 aluminum.png"], @"00000", @"A8x12", [NSValue valueWithCGSize:CGSizeMake(8.0f, 12.0f)]],
                                  @[@"10x10",@"28",[UIImage imageNamed:@"10x10 aluminum.png"], @"00000", @"A10x10", [NSValue valueWithCGSize:CGSizeMake(10.0f, 10.0f)]],
                                  @[@"11x14",@"40",[UIImage imageNamed:@"11x14 aluminum.png"], @"00000", @"A11x14", [NSValue valueWithCGSize:CGSizeMake(11.0f, 14.0f)]],
                                  @[@"11x17",@"48",[UIImage imageNamed:@"11x17 aluminum.png"], @"00000", @"A11x17", [NSValue valueWithCGSize:CGSizeMake(11.0f, 17.0f)]],
                                  @[@"12x12",@"40",[UIImage imageNamed:@"12x12 aluminum.png"], @"00000", @"A12x12", [NSValue valueWithCGSize:CGSizeMake(12.0f, 12.0f)]],
                                 @[@"12x18",@"54",[UIImage imageNamed:@"12x18 aluminum.png"], @"00000", @"A12x18", [NSValue valueWithCGSize:CGSizeMake(12.0f, 18.0f)]],];
    
    self.WoodenProductArray = @[@[@"8x8",@"36",[UIImage imageNamed:@"8x8 wood.png"], @"00000", @"W8x8", [NSValue valueWithCGSize:CGSizeMake(8.0f, 8.0f)]],
                               @[@"8x10",@"40",[UIImage imageNamed:@"8x10 wood.png"], @"00000", @"W8x10", [NSValue valueWithCGSize:CGSizeMake(8.0f, 10.0f)]],
                               @[@"10x10",@"44",[UIImage imageNamed:@"10x10 wood.png"], @"00000", @"W10x10", [NSValue valueWithCGSize:CGSizeMake(10.0f, 10.0f)]],
                               @[@"11x14",@"48",[UIImage imageNamed:@"11x14 wood.png"], @"00000", @"W11x14", [NSValue valueWithCGSize:CGSizeMake(11.0f, 14.0f)]],];
    
    self.TileProductArray = @[@[@"4x4",@"14",[UIImage imageNamed:@"4x4 tile.png"], @"00000", @"T4x4", [NSValue valueWithCGSize:CGSizeMake(4.0f, 4.0f)]],
                             @[@"6x6",@"18",[UIImage imageNamed:@"6x6 tile.png"], @"00000", @"T6x6", [NSValue valueWithCGSize:CGSizeMake(6.0f, 6.0f)]],
                              @[@"6x8",@"22",[UIImage imageNamed:@"6x8 tile.png"], @"00000", @"T6x8", [NSValue valueWithCGSize:CGSizeMake(6.0f, 8.0f)]],
                              @[@"8x10",@"30",[UIImage imageNamed:@"8x10 tile.png"], @"00000", @"T8x10", [NSValue valueWithCGSize:CGSizeMake(8.0f, 10.0f)]],];
    
    self.SlateProductArray = @[@[@"6x6",@"24",[UIImage imageNamed:@"6x6 slate.png"], @"00000", @"S6x6", [NSValue valueWithCGSize:CGSizeMake(6.0f, 6.0f)]],
                               @[@"6x8",@"30",[UIImage imageNamed:@"6x8 slate.png"], @"00000", @"S6x8", [NSValue valueWithCGSize:CGSizeMake(6.0f, 8.0f)]],
                               @[@"8x12",@"36",[UIImage imageNamed:@"8x12 slate.png"], @"00000", @"S8x12", [NSValue valueWithCGSize:CGSizeMake(8.0f, 12.0f)]],];
    
    self.OtherProductArray = @[@[@"Square Keychain",@"12",[UIImage imageNamed:@"8x12 slate.png"], @"00000", @"O-SKey", [NSValue valueWithCGSize:CGSizeMake(3.0f, 2.0f)]],
                              @[@"Rectangle Keychain",@"12",[UIImage imageNamed:@"8x12 slate.png"], @"00000", @"O-RKey", [NSValue valueWithCGSize:CGSizeMake(3.0f, 2.0f)]],
                              @[@"Long Keychaing",@"12",[UIImage imageNamed:@"8x12 slate.png"], @"00000", @"O-LKey", [NSValue valueWithCGSize:CGSizeMake(3.0f, 2.0f)]],
                              @[@"Dog Tag",@"12",[UIImage imageNamed:@"8x12 slate.png"], @"00000", @"0-DTag", [NSValue valueWithCGSize:CGSizeMake(3.0f, 2.0f)]],
                              @[@"Square Pendant",@"16",[UIImage imageNamed:@"8x12 slate.png"], @"00000", @"O-SPen", [NSValue valueWithCGSize:CGSizeMake(3.0f, 2.0f)]],
                              @[@"Round Pendant",@"16",[UIImage imageNamed:@"8x12 slate.png"], @"00000", @"O-RPen", [NSValue valueWithCGSize:CGSizeMake(3.0f, 2.0f)]],
                              @[@"Long Pendant",@"18",[UIImage imageNamed:@"8x12 slate.png"], @"00000", @"O-LPen", [NSValue valueWithCGSize:CGSizeMake(3.0f, 2.0f)]],
                              @[@"Clock",@"36",[UIImage imageNamed:@"8x12 slate.png"], @"00000", @"O-Clock", [NSValue valueWithCGSize:CGSizeMake(3.0f, 2.0f)]],];
    
    self.categoryArray = @[@"Aluminum",@"Wood",@"Tile",@"Slate",@"Other Goodies",];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[self archivePathShoppingCart]]) {
        self.shoppingCart = [NSKeyedUnarchiver unarchiveObjectWithFile:[self archivePathShoppingCart]];
    }
    else{
        self.shoppingCart = [[NSMutableArray alloc] init];
    }
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[self archiveAddresses]]) {
        self.savedAddressesArray = [NSKeyedUnarchiver unarchiveObjectWithFile:[self archiveAddresses]];
    }
    else{
        self.savedAddressesArray = [[NSMutableArray alloc] init];
    }
    
//    if ([[NSFileManager defaultManager] fileExistsAtPath:[self archivehighlightedImages]]) {
//        self.highlightedArray = [NSKeyedUnarchiver unarchiveObjectWithFile:[self archivehighlightedImages]];
//    }
//    else{
//        self.highlightedArray = [[NSMutableArray alloc] init];
//    }
    if ([[NSFileManager defaultManager] fileExistsAtPath:[self archiveCartTotals]]) {
        NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithFile:[self archiveCartTotals]];
        self.cartTotal = [[array objectAtIndex:0] integerValue];
        self.cartPrintTotal = [[array objectAtIndex:1] integerValue];
    }
    
    // Initialize Reachability
    Reachability *reachability = [Reachability reachabilityWithHostName:@"https://www.google.com"];
    
    // Start Monitoring
    [reachability startNotifier];

//    if ([self InternetConnected]) {
//        
//        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://final-project-order-viewer-stevens-apps.c9users.io/recieve_data.php"]];
//        NSDictionary *cartItem = [NSDictionary dictionaryWithObjectsAndKeys:
//                                  @"1",@"user_Opened_App",nil];
//        NSError *error2;
//        NSData *finalJSONdata = [NSJSONSerialization dataWithJSONObject:cartItem options:0 error:&error2];
//        
//        //NSLog(@"%.2f MB",(float)finalJSONdata.length/1024.0f/1024.0f);
//        
//        [request setHTTPBody:finalJSONdata];
//        [request setHTTPMethod:@"POST"];
//        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
//        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//        [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[finalJSONdata length]] forHTTPHeaderField:@"Content-Length"];
//        
//        
//        NSError *err;
//        NSURLResponse *response;
//        
//        
//        
//        NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
//        NSString *responseString = [[NSString alloc]initWithData:responseData encoding:NSASCIIStringEncoding];
//        
//        
//        if(responseString)
//        {
//            //[self performSegueWithIdentifier:@"OrderPlaced" sender:self];
//            NSLog(@"got response==%@", responseString);
//            
//        }
//    }
    
    self.loadingImages  = YES;
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
    

    void (^assetEnumerator)( ALAsset *, NSUInteger, BOOL *) = ^(ALAsset *result, NSUInteger index, BOOL *stop) {
        NSLog(@"%lu",(unsigned long)index);
        

        if(result != nil && result != NULL) {
            if([[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypePhoto]) {
                [assetURLDictionaries addObject:[result valueForProperty:ALAssetPropertyURLs]];
                // NSLog(@"assestlibrarymurari%@",assetURLDictionaries);
                
                NSURL *url= (NSURL*) [[result defaultRepresentation]url];
                UIImage *thumbImg = [UIImage imageWithCGImage: [result aspectRatioThumbnail]];
                
                NSArray *array = @[url, @"", thumbImg];
                

                self.totalImageCount++;
                
                [self.phoneImageArray insertObject:array atIndex:0];
   

  
            }
        }
        else{
            self.loadingImages = NO;
            [[ProductCategorySelectionCollection sharedProductCategorySelectionCollection] FinishedLoadingImages];
        }
//        else{
//            int x = 0;
//            for (NSArray *imgArray1 in self.phoneImageArray) {
//                x++;
//                ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
//                [library assetForURL:[imgArray1 objectAtIndex:0]
//                         resultBlock:^(ALAsset *asset) {
//                             
//
//                                 
//
//                         }
//                 
//                        failureBlock:^(NSError *error){
//                            NSLog(@"operation was not successfull!");
//                        }];
//                
//            }
//            
//
////            if (self.reloadImageCollection == YES) {
////                [[ImageCollectionViewController sharedImageCollectionViewController] reloadTheCollectionView];
////            }
//        }
    };
    
    NSMutableArray *assetGroups = [[NSMutableArray alloc] init];
    
    void (^ assetGroupEnumerator) ( ALAssetsGroup *, BOOL *)= ^(ALAssetsGroup *group, BOOL *stop) {
        if(group != nil) {
            
            [assetGroups addObject:group];
            //NSLog(@"AssetGroup%@",assetGroups);
            count = [group numberOfAssets];
            if (count != 0) {
                if (self.phoneImageArray != nil) {
                    self.phoneImageArray = nil;
                }
                self.phoneImageArray = [[NSMutableArray alloc] init];

                [group enumerateAssetsUsingBlock:assetEnumerator];
            }
//            else{
//                if ([[NSFileManager defaultManager] fileExistsAtPath:[self archiveImageArray]]) {
//                    self.tempPhoneImageArray = [NSKeyedUnarchiver unarchiveObjectWithFile:[self archiveImageArray]];
//                    if (count != self.tempPhoneImageArray.count) {
//                        if (self.phoneImageArray != nil) {
//                            self.phoneImageArray = nil;
//                        }
//                        self.phoneImageArray = [[NSMutableArray alloc] init];
//                        self.theNewImageArray = [[NSMutableArray alloc] init];
//                        self.mutableImageArray = [[NSMutableArray alloc] init];
//                        if (self.tempPhoneImageArray != nil) {
//                            x = self.tempPhoneImageArray.count - 1;
//                        }
//                        [group enumerateAssetsUsingBlock:assetEnumerator];
//                    }
//                }
//                else{
//                    self.phoneImageArray = [[NSMutableArray alloc] init];
//                    self.mutableImageArray = [[NSMutableArray alloc] init];
//                    [group enumerateAssetsUsingBlock:assetEnumerator];
//                }
//            }
            
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


- (NSString*)archiveOrderAttemp{
    NSArray *documentDirs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = documentDirs[0];
    return [docDir stringByAppendingPathComponent:@"orderAttempt"];
}

- (NSString*)archiveAddresses{
    NSArray *documentDirs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = documentDirs[0];
    return [docDir stringByAppendingPathComponent:@"addresses"];
}

@end
