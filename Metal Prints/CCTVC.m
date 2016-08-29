//
//  CCTVC.m
//  Metal Prints
//
//  Created by Bryan Stevens on 4/20/16.
//  Copyright © 2016 Pocket Tools. All rights reserved.
//

#import "CCTVC.h"
#import "AppDelegate.h"

@interface CCTVC ()
@property (retain, nonatomic) UIToolbar* keyboardDoneButtonView2;
@end

@implementation CCTVC

- (AppDelegate *)sharedAppDelegate
{
    
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

+ (CCTVC *)sharedCCTVC
{
    static CCTVC *sharedInstance = nil;
    
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
        sharedInstance = (CCTVC*)[storyboard instantiateViewControllerWithIdentifier: @"cctvc"];
    });
    return sharedInstance;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *rightBarButtonItem1 = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:self action:@selector(Next)];
    [self.navigationItem setRightBarButtonItem:rightBarButtonItem1];
    [self.navigationItem setTitle:@"Billing"];
    self.BillingSameAsShippingOutlet.on  = NO;
    
    self.keyboardDoneButtonView2 = [[UIToolbar alloc] init];
    self.keyboardDoneButtonView2.barStyle = UIBarStyleDefault;
    self.keyboardDoneButtonView2.translucent = YES;
    self.keyboardDoneButtonView2.tintColor = nil;
    [self.keyboardDoneButtonView2 sizeToFit];
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Next"
                                                                   style:UIBarButtonItemStyleDone target:self
                                                                  action:@selector(NextClicked1:)];
    
    [self.keyboardDoneButtonView2 setItems:[NSArray arrayWithObjects:flexSpace,doneButton, nil]];
    
    self.firstName.inputAccessoryView = self.keyboardDoneButtonView2;
    
    self.LastName.inputAccessoryView = self.keyboardDoneButtonView2;
    
    self.streetAddress.inputAccessoryView = self.keyboardDoneButtonView2;
    
    self.apt.inputAccessoryView = self.keyboardDoneButtonView2;
    
    self.City.inputAccessoryView = self.keyboardDoneButtonView2;
    
    self.zip.inputAccessoryView = self.keyboardDoneButtonView2;
    
    self.state.inputAccessoryView = self.keyboardDoneButtonView2;
}


-(void)NextClicked1:(id)sender{
    BOOL stop = NO;
    [self.delegate moveViewDown];
    
    if ([self.firstName isFirstResponder]&& stop == NO) {
        stop = YES;
        [self.LastName becomeFirstResponder];
    }
    
    if ([self.LastName isFirstResponder]&& stop == NO) {
        stop = YES;
        [self.streetAddress becomeFirstResponder];
    }
    
    if ([self.streetAddress isFirstResponder]&& stop == NO) {
        stop = YES;
        [self.apt becomeFirstResponder];
    }
    
    if ([self.apt isFirstResponder]&& stop == NO) {
        stop = YES;
        [self.City becomeFirstResponder];
    }
    
    if ([self.City isFirstResponder]&& stop == NO) {
        stop = YES;
        [self.state becomeFirstResponder];
        [self.delegate moveViewUp];
    }
    
    if ([self.state isFirstResponder]&& stop == NO) {
        stop = YES;
        [self.zip becomeFirstResponder];
    }
    
    if ([self.zip isFirstResponder]&& stop == NO) {
        stop = YES;
        [self.keyboardDoneButtonView2 removeFromSuperview];
        [self.zip resignFirstResponder];
        
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField == self.firstName) {
        [self.LastName becomeFirstResponder];
    }
    
    if (textField == self.LastName) {
        [self.streetAddress becomeFirstResponder];
    }
    
    if (textField == self.streetAddress) {
        [self.apt becomeFirstResponder];
    }
    
    if (textField == self.apt) {
        [self.City becomeFirstResponder];
    }
    
    if (textField == self.City) {
        [self.state becomeFirstResponder];
        [self.delegate moveViewUp];
    }
    
    if (textField == self.state) {
        [self.zip becomeFirstResponder];
    }
    
    if (textField == self.zip) {
        [self.keyboardDoneButtonView2 removeFromSuperview];
        [self.zip resignFirstResponder];
        [self.delegate moveViewDown];
    }
    
    return YES;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 8;
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"shipping"]) {
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"Back", returnbuttontitle) style:     UIBarButtonItemStyleBordered target:nil action:nil];
        self.navigationItem.backBarButtonItem = backButton;
    }
}

- (IBAction)BillingSameAsShipping:(id)sender {
    if (self.BillingSameAsShippingOutlet.on == YES) {
        NSLog(@"State: %@",[self sharedAppDelegate].userSettings.shipping.state);
        NSLog(@"Street: %@",[self sharedAppDelegate].userSettings.shipping.street);
        self.firstName.text = [self sharedAppDelegate].userSettings.shipping.firstName;
        
        self.LastName.text = [self sharedAppDelegate].userSettings.shipping.lastName;
        
        self.streetAddress.text = [self sharedAppDelegate].userSettings.shipping.street;
        
        self.apt.text = [self sharedAppDelegate].userSettings.shipping.apt;
        
        self.City.text = [self sharedAppDelegate].userSettings.shipping.city;
        
        self.state.text = [self sharedAppDelegate].userSettings.shipping.state;
        
        self.zip.text = [self sharedAppDelegate].userSettings.shipping.zip;
        
    }
    else{
        self.firstName.text = @"";
        
        self.LastName.text = @"";
        
        self.streetAddress.text = @"";
        
        self.apt.text = @"";
        
        self.City.text = @"";
        
        self.state.text = @"";
        
        self.zip.text = @"";
    }

}
@end
