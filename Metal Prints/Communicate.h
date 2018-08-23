//
//  Communicate.h
//  Metal Prints
//
//  Created by Bryan Stevens on 7/27/18.
//  Copyright © 2018 Pocket Tools. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PaymentVC.h"

@interface Communicate : UIViewController

-(NSString*)authenticate;
-(void)launched:(NSString*)token;
-(NSArray*)stripeCharge:(NSDictionary*)params;
-(BOOL)postData:(NSMutableDictionary*)params withDelegate:(PaymentVC*)theDelegate;
-(BOOL)supportMessageSent:(NSString *)token;
@end
