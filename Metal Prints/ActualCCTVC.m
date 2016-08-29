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
    UIBarButtonItem *nextButton = [[UIBarButtonItem alloc] initWithTitle:@"Next"
                                                                   style:UIBarButtonItemStyleDone target:self
                                                                  action:@selector(pickerNextClicked:)];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                   style:UIBarButtonItemStyleDone target:self
                                                                  action:@selector(pickerDoneClicked:)];
    
    [self.keyboardDoneButtonView setItems:[NSArray arrayWithObjects:nextButton,flexSpace,doneButton, nil]];
    
    
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



- (void)pickerNextClicked:(id)sender {
    if ([self.CCN isFirstResponder]) {
        [self.securityCode  becomeFirstResponder];
    }
    
    if ([self.securityCode isFirstResponder]) {
        [self.expMonth  becomeFirstResponder];
    }
    
    if ([self.expMonth isFirstResponder]) {
        [self.expYear  becomeFirstResponder];
    }
    if ([self.expYear isFirstResponder]) {
        [self.keyboardDoneButtonView removeFromSuperview];
        [self.expYear  resignFirstResponder];
    }


    
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


- (void)PlaceOrder {

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
