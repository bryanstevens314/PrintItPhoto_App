//
//  Front_EndVC.h
//  Metal Prints
//
//  Created by Bryan Stevens on 4/24/16.
//  Copyright © 2016 Pocket Tools. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductsTVC.h"

@interface Front_EndVC : UIViewController <ProductDelegate>

- (IBAction)ShoppingCartSelected:(id)sender;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *Shopping_Cart_Outlet;
@end
