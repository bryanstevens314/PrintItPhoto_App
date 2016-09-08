//
//  ActualCCTVC.m
//  Metal Prints
//
//  Created by Bryan Stevens on 5/8/16.
//  Copyright © 2016 Pocket Tools. All rights reserved.
//

#import "ActualCCTVC.h"
#import "AppDelegate.h"
#import <Stripe/Stripe.h>

@interface ActualCCTVC ()

@property (retain, nonatomic) UIToolbar* keyboardDoneButtonView3;
@end

@implementation ActualCCTVC


- (AppDelegate *)sharedAppDelegate
{
    
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

+ (ActualCCTVC *)sharedActualCCTVC
{
    static ActualCCTVC *sharedInstance = nil;
    
    UIStoryboard *storyboard;
    
    // detect the height of our screen
    int height = [UIScreen mainScreen].bounds.size.height;
    
    if (height == 480) {
        storyboard = [UIStoryboard storyboardWithName:@"Main_3.5_inch" bundle:nil];
        // NSLog(@"Device has a 3.5inch Display.");
    }
    if (height == 568) {
        storyboard = [UIStoryboard storyboardWithName:@"Main_4_inch" bundle:nil];
        // NSLog(@"Device has a 4inch Display.");
    }
    if (height == 667) {
        storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        // NSLog(@"Device has a 4inch Display.");
    }
    if (height == 736) {
        storyboard = [UIStoryboard storyboardWithName:@"Main_5.5_inch" bundle:nil];
        // NSLog(@"Device has a 4inch Display.");
    }
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = (ActualCCTVC*)[storyboard instantiateViewControllerWithIdentifier: @"Actualcctvc"];
    });
    return sharedInstance;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    

}



- (void)BackClicked11:(id)sender {
    BOOL stop = NO;
    if ([self.CCN isFirstResponder] && stop == NO) {
        NSLog(@"name");
        stop = YES;
    }
    
    if ([self.securityCode isFirstResponder] && stop == NO) {
        NSLog(@"email");
        stop = YES;
        [self.CCN becomeFirstResponder];
    }
    
    if ([self.expMonth isFirstResponder] && stop == NO) {
        NSLog(@"street");
        stop = YES;
        [self.securityCode becomeFirstResponder];
    }
    
    if ([self.expYear isFirstResponder] && stop == NO) {
        NSLog(@"city");
        stop = YES;
        [self.expMonth becomeFirstResponder];
    }

}

- (void)DoneClicked11:(id)sender {
    [self.keyboardDoneButtonView3 removeFromSuperview];
    if ([self.CCN isFirstResponder]) {
        NSLog(@"name");
        [self.CCN resignFirstResponder];
    }
    
    if ([self.securityCode isFirstResponder]) {
        NSLog(@"email");
        [self.securityCode resignFirstResponder];
    }
    
    if ([self.expMonth isFirstResponder]) {
        NSLog(@"street");
        [self.expMonth resignFirstResponder];
    }
    
    if ([self.expYear isFirstResponder]) {
        NSLog(@"city");
        [self.expYear resignFirstResponder];
    }

}


- (void)NextClicked11:(id)sender {
    BOOL stop = NO;
    if ([self.CCN isFirstResponder] && stop == NO) {
        NSLog(@"name");
        stop = YES;
        [self.securityCode becomeFirstResponder];
    }
    
    if ([self.securityCode isFirstResponder] && stop == NO) {
        NSLog(@"email");
        stop = YES;
        [self.expMonth becomeFirstResponder];
    }
    
    if ([self.expMonth isFirstResponder] && stop == NO) {
        NSLog(@"street");
        stop = YES;
        [self.expYear becomeFirstResponder];
    }
    
    if ([self.expYear isFirstResponder] && stop == NO) {
        NSLog(@"city");
        stop = YES;
        [self.keyboardDoneButtonView3 removeFromSuperview];
        [self.expYear resignFirstResponder];
    }

}





#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}





- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
//    if (textField == self.expMonth) {
//        if ([self.expMonth.text isEqualToString:@""]) {
//            self.expMonth.text = @"Easel";
//        }
//        
//    }
//    if (textField == self.expYear) {
//        if ([self.expYear.text isEqualToString:@""]) {
//            self.expYear.text = @"No retouching";
//        }
//    }
}




/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
