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
@property (retain, nonatomic) UIPickerView *monthPicker;
@property (retain, nonatomic) UIPickerView *yearPicker;
@property (retain, nonatomic) NSMutableArray *yearArray;
@property (retain, nonatomic) NSMutableArray *monthArray;
@property (retain, nonatomic) NSString *currentYear;
@property (retain, nonatomic) NSString *currentMonth;
@property (retain, nonatomic) UIToolbar* keyboardDoneButtonView;
@end

@implementation ActualCCTVC


- (AppDelegate *)sharedAppDelegate
{
    
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    NSArray *monArray = [df shortStandaloneMonthSymbols];
    
    self.monthArray = [[NSMutableArray alloc] init];
    NSDateFormatter* formatter2 = [[NSDateFormatter alloc] init];
    [formatter2 setDateFormat:@"MMM"];
    for (NSString *mon in monArray) {
        NSDate *aDate = [formatter2 dateFromString:mon];
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSMonthCalendarUnit fromDate:aDate];
        NSString *astring = [NSString stringWithFormat:@"%li",(long)[components month]];
        if ([astring length] == 1) {
            [self.monthArray addObject:[NSString stringWithFormat:@"0%li",(long)[components month]]];
        }
        else{
            [self.monthArray addObject:[NSString stringWithFormat:@"%li",(long)[components month]]];
        }
        
    }

    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitMonth fromDate:[NSDate date]];
    NSInteger month = [components month];
    self.currentMonth = [NSString stringWithFormat:@"%ld",(long)month];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy"];
    self.currentYear = [formatter stringFromDate:[NSDate date]];
    int curYear = [self.currentYear intValue];
    self.yearArray = [[NSMutableArray alloc] init];
    for( int year = curYear; year <= 2080; year++ ) {
        [self.yearArray addObject:[NSString stringWithFormat:@"%d", year]];
    }

    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Place Order" style:UIBarButtonItemStylePlain target:self action:@selector(PlaceOrder)];
    [self.navigationItem setRightBarButtonItem:rightBarButtonItem];
    [self.navigationItem setTitle:@"Billing"];
    
    [[self expMonth] setTintColor:[UIColor clearColor]];
    self.monthPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 50, 100, 200)];
    [self.monthPicker setDataSource: self];
    [self.monthPicker setDelegate: self];
    self.monthPicker.showsSelectionIndicator = YES;
    [self.monthPicker selectRow:0 inComponent:0 animated:NO];
    self.expMonth.inputView = self.monthPicker;
    self.expMonth.adjustsFontSizeToFitWidth = YES;
    self.expMonth.textColor = [UIColor blackColor];
    
    self.expMonth.inputView = self.monthPicker;
    self.expMonth.inputAssistantItem.leadingBarButtonGroups = @[];
    self.expMonth.inputAssistantItem.trailingBarButtonGroups = @[];
    NSInteger selectmonth = month--;
    [self.monthPicker selectRow:selectmonth inComponent:0 animated:NO];
    self.keyboardDoneButtonView = [[UIToolbar alloc] init];
    self.keyboardDoneButtonView.barStyle = UIBarStyleDefault;
    self.keyboardDoneButtonView.translucent = YES;
    self.keyboardDoneButtonView.tintColor = nil;
    [self.keyboardDoneButtonView sizeToFit];
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                   style:UIBarButtonItemStyleDone target:self
                                                                  action:@selector(pickerDoneClicked:)];
    
    [self.keyboardDoneButtonView setItems:[NSArray arrayWithObjects:flexSpace,doneButton, nil]];
    
    
//    [[self expYear] setTintColor:[UIColor clearColor]];
//    self.yearPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 50, 100, 200)];
//    [self.yearPicker setDataSource: self];
//    [self.yearPicker setDelegate: self];
//    self.yearPicker.showsSelectionIndicator = YES;
//    [self.yearPicker selectRow:0 inComponent:0 animated:NO];
//    self.expYear.inputView = self.yearPicker;
//    self.expYear.adjustsFontSizeToFitWidth = YES;
//    self.expYear.textColor = [UIColor blackColor];
//    
//    self.expYear.inputView = self.yearPicker;
//    self.expYear.inputAssistantItem.leadingBarButtonGroups = @[];
//    self.expYear.inputAssistantItem.trailingBarButtonGroups = @[];
    
    self.expMonth.inputAccessoryView = self.keyboardDoneButtonView;
//    self.expYear.inputAccessoryView = self.keyboardDoneButtonView;
    self.CCN.inputAccessoryView = self.keyboardDoneButtonView;
    self.securityCode.inputAccessoryView = self.keyboardDoneButtonView;
    
    self.expYear.text = self.currentYear;
    self.expMonth.text = self.currentMonth;
}


- (void)pickerDoneClicked:(id)sender {
    [self.keyboardDoneButtonView removeFromSuperview];
    if ([self.expMonth isFirstResponder]) {
        [self.expMonth  resignFirstResponder];
    }
    if ([self.expYear isFirstResponder]) {
        [self.expYear  resignFirstResponder];
    }
    if ([self.CCN isFirstResponder]) {
        [self.CCN  resignFirstResponder];
    }
    if ([self.securityCode isFirstResponder]) {
        [self.securityCode  resignFirstResponder];
    }
    
}

UIAlertController *alert;
NSTimer *timer2;
- (void)PlaceOrder {
    alert = [UIAlertController alertControllerWithTitle:@""
                                                message:@"Submitting Order"
                                         preferredStyle:UIAlertControllerStyleAlert]; // 1
    
    UIViewController *customVC     = [[UIViewController alloc] init];
    [alert.view setFrame:CGRectMake(0, 300, 320, 275)];
    
    UIActivityIndicatorView* spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner startAnimating];
    [customVC.view addSubview:spinner];
    [spinner setCenter:CGPointMake(100, 27)];
    
    [customVC.view addConstraint:[NSLayoutConstraint
                                  constraintWithItem: spinner
                                  attribute:NSLayoutAttributeCenterX
                                  relatedBy:NSLayoutRelationEqual
                                  toItem:customVC.view
                                  attribute:NSLayoutAttributeCenterX
                                  multiplier:1.0f
                                  constant:0.0f]];
    
    
    [alert setValue:customVC forKey:@"contentViewController"];
    [self presentViewController:alert animated:YES completion:nil];
    timer2 = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(ChargeCard) userInfo:nil repeats:NO];
}

-(void)ChargeCard{

    [timer2 invalidate];
    timer2 = nil;
    
    NSDictionary *billingDict = [self sharedAppDelegate].billingInfo;
    NSString *fullName = [NSString stringWithFormat:@"%@, %@",[billingDict objectForKey:@"first"], [billingDict objectForKey:@"last"]];
    STPCardParams *params = [[STPCardParams alloc] init];
    params.number = self.CCN.text;
    params.expMonth = [self.expMonth.text integerValue];
    params.expYear = [self.expYear.text integerValue];
    params.cvc = self.securityCode.text;
//    params.name = fullName;
//    params.addressLine1 = [billingDict objectForKey:@"street"];
//    params.addressLine2 = [billingDict objectForKey:@"apt"];
//    params.addressCity = [billingDict objectForKey:@"city"];
//    params.addressState = [billingDict objectForKey:@"state"];
//    params.addressZip = [billingDict objectForKey:@"zip"];
//    params.addressCountry = [billingDict objectForKey:@"country"];
//    params.currency = @"USD";
    [[STPAPIClient sharedClient] createTokenWithCard:params completion:^(STPToken *token, NSError *error) {
         if (error) {
             NSLog(@"error %@",error);
         } else {
             [self createBackendChargeWithToken:token completion:nil];
         }
     }];
    

    
}

- (void)createBackendChargeWithToken:(STPToken *)token completion:(void (^)(PKPaymentAuthorizationStatus))completion {
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://final-project-order-viewer-stevens-apps.c9users.io/stripeStuff.php"]];
    NSDictionary *billingDict = [self sharedAppDelegate].billingInfo;
    int Amount = [[self sharedAppDelegate].cartTotal intValue];
    int totalAmount = Amount * 100;
    int fee = totalAmount *0.1;
    NSString *stringAmount = [NSString stringWithFormat:@"%i",totalAmount];
    NSString *feeAmount = [NSString stringWithFormat:@"%i",fee];
    NSDictionary *chargeParams = [NSDictionary dictionaryWithObjectsAndKeys: token.tokenId, @"stripeToken",
                                                                             stringAmount, @"chargeAmount",
                                                                             @"example charge", @"description",
                                                                             @"incrementing ID", @"orderID",
                                                                             [billingDict objectForKey:@"name"], @"name",
                                                                             feeAmount, @"fee",nil];
    
    NSError *error2;
    NSData *finalJSONdata = [NSJSONSerialization dataWithJSONObject:chargeParams options:0 error:&error2];
    
    
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
        
        
//        NSStringEncoding  encoding;
//        NSData * jsonData = [responseString dataUsingEncoding:encoding];
//        NSError * error=nil;
//        NSDictionary * parsedData = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
        NSLog(@"%@",responseString);
        [alert dismissViewControllerAnimated:YES completion:nil];
        alert = nil;
        alert = [UIAlertController alertControllerWithTitle:@""
                                                    message:@"Successfully charged card, please stay in the app while your images are uploaded."
                                             preferredStyle:UIAlertControllerStyleAlert]; // 1
        
        UIViewController *customVC     = [[UIViewController alloc] init];
        [alert.view setFrame:CGRectMake(0, 300, 320, 275)];
        
        UIActivityIndicatorView* spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [spinner startAnimating];
        [customVC.view addSubview:spinner];
        [spinner setCenter:CGPointMake(100, 27)];
        
        [customVC.view addConstraint:[NSLayoutConstraint
                                      constraintWithItem: spinner
                                      attribute:NSLayoutAttributeCenterX
                                      relatedBy:NSLayoutRelationEqual
                                      toItem:customVC.view
                                      attribute:NSLayoutAttributeCenterX
                                      multiplier:1.0f
                                      constant:0.0f]];
        
        
        [alert setValue:customVC forKey:@"contentViewController"];
        timer2 = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(PostData) userInfo:nil repeats:NO];

    }
    else{
        NSLog(@"Error!");
        
    }
}

-(void)PostData{
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://final-project-order-viewer-stevens-apps.c9users.io/recieve_data.php"]];
        
        
        
        NSMutableDictionary *mutDict = [[NSMutableDictionary alloc] init];
        [mutDict setObject:[self sharedAppDelegate].shippingInfo forKey:@"customer"];
        int i = 0;
        NSMutableDictionary *mutDict1 = [[NSMutableDictionary alloc] init];
        NSData *imgData;
        for (NSArray *array1 in [self sharedAppDelegate].shoppingCart) {
            
            //        NSArray *array = @[self.Product_Outlet.text,
            //                           self.Quantity_TextField.text,
            //                           price,
            //                           self.Retouching_TextField.text,
            //                           self.For_Aluminum_TextField.text,
            //                           self.textView.text,
            //                           imgData
            //                           ];
            
            NSString *prod = [array1 objectAtIndex:0];
            NSString *quan = [array1 objectAtIndex:1];
            NSString *retouch = [array1 objectAtIndex:3];
            NSString *alum = [array1 objectAtIndex:4];
            NSString *instructions = [array1 objectAtIndex:5];
            NSString *imgString = [array1 objectAtIndex:6];
//            NSLog(@"%@",imgString);
            NSDictionary *cartItem = [NSDictionary dictionaryWithObjectsAndKeys:
                                      prod,@"product",
                                      
                                      quan,@"quantity",
                                      retouch,@"retouching",
                                      alum,@"aluminumOptions",
                                      instructions,@"instructions",
                                      imgString,@"image",nil];
            
            [mutDict1 setObject:cartItem forKey:[NSString stringWithFormat:@"cart_Item%i",i]];
            i++;
        }
        
        [mutDict setObject:mutDict1 forKey:@"shopping_Cart"];
        
        NSError *error2;
        NSData *finalJSONdata = [NSJSONSerialization dataWithJSONObject:mutDict options:0 error:&error2];
        
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
            [alert dismissViewControllerAnimated:YES completion:nil];
            [self performSegueWithIdentifier:@"OrderComplete" sender:self];
        }
        else
        {
            NSLog(@"faield to connect");
            [alert dismissViewControllerAnimated:YES completion:nil];
            UIAlertController *alert2 = [UIAlertController alertControllerWithTitle:@"" message:@"There was a problem uploading your images. Please check your internet connection and try again"preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"OK"
                                                                   style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                                       [alert2 dismissViewControllerAnimated:YES completion:nil];
                                                                   }]; // 2
            
            [alert2 addAction:cameraAction];
            
            [self presentViewController:alert2 animated:YES completion:nil];
            
        }
        
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    return 2;
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


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    NSInteger rows = 0;

    if (component == 0) {
        
        rows = self.monthArray.count;
        
    }
    if (component == 1) {
        rows = self.yearArray.count;
    }

    return rows;
}


// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *string;
    if (component == 1) {
        
        string = [self.yearArray objectAtIndex:row];
    }
    if (component == 0) {
        
        string = [self.monthArray objectAtIndex:row];
        
    }
    
    return string;
}

// Catpure the picker view selection
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    NSString *string;
    if (component == 1) {
        
        string = [self.yearArray objectAtIndex:row];
        self.expYear.text = string;
    }
    if (component == 0) {
        
        string = [self.monthArray objectAtIndex:row];
        self.expMonth.text = string;
    }
    
}


- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    
    return 100;
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
