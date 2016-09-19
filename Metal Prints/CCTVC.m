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
@property (retain, nonatomic) UIPickerView *monthPicker;
@property (retain, nonatomic) UIPickerView *yearPicker;
@property (retain, nonatomic) NSMutableArray *yearArray;
@property (retain, nonatomic) NSMutableArray *monthArray;


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

    self.BillingSameAsShippingOutlet.on  = NO;
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
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
    
    self.currentMonth = [self.monthArray objectAtIndex:month-1];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy"];
    self.currentYear = [formatter stringFromDate:[NSDate date]];
    int curYear = [self.currentYear intValue];
    self.yearArray = [[NSMutableArray alloc] init];
    for( int year = curYear; year <= 2080; year++ ) {
        [self.yearArray addObject:[NSString stringWithFormat:@"%d", year]];
    }
    
    

    
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
    NSInteger selectmonth = month- 1;
    [self.monthPicker selectRow:selectmonth inComponent:0 animated:NO];
    
    
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
    
    self.keyboardDoneButtonView2 = [[UIToolbar alloc] init];
    self.keyboardDoneButtonView2.barStyle = UIBarStyleDefault;
    self.keyboardDoneButtonView2.translucent = YES;
    self.keyboardDoneButtonView2.tintColor = nil;
    [self.keyboardDoneButtonView2 sizeToFit];
    UIBarButtonItem *flexSpace1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *backButton1 = [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                                    style:UIBarButtonItemStyleDone target:self
                                                                   action:@selector(BackClicked1:)];
    UIBarButtonItem *nextButton1 = [[UIBarButtonItem alloc] initWithTitle:@"Next"
                                                                    style:UIBarButtonItemStyleDone target:self
                                                                   action:@selector(NextClicked1:)];
    UIBarButtonItem *doneButton1 = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                    style:UIBarButtonItemStyleDone target:self
                                                                   action:@selector(DoneClicked1:)];
    
    [self.keyboardDoneButtonView2 setItems:[NSArray arrayWithObjects:backButton1,nextButton1,flexSpace1,doneButton1, nil]];
    
    self.email.inputAccessoryView = self.keyboardDoneButtonView2;
    
    self.expMonth.inputAccessoryView = self.keyboardDoneButtonView2;
    
    self.ccn.inputAccessoryView = self.keyboardDoneButtonView2;
    
    self.cvc.inputAccessoryView = self.keyboardDoneButtonView2;
    
    self.firstName.inputAccessoryView = self.keyboardDoneButtonView2;
    
    self.LastName.inputAccessoryView = self.keyboardDoneButtonView2;
    
    self.streetAddress.inputAccessoryView = self.keyboardDoneButtonView2;
    
    self.apt.inputAccessoryView = self.keyboardDoneButtonView2;
    
    self.City.inputAccessoryView = self.keyboardDoneButtonView2;
    
    self.zip.inputAccessoryView = self.keyboardDoneButtonView2;
    
    self.state.inputAccessoryView = self.keyboardDoneButtonView2;
    

    
    //self.expMonth.text = [NSString stringWithFormat:@"%@/%@",self.currentMonth,self.currentYear];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    [self.email becomeFirstResponder];
}


- (void)BackClicked1:(id)sender {
    BOOL stop = NO;
    if ([self.email isFirstResponder] && stop == NO) {
        NSLog(@"name");
        stop = YES;
        
    }
    if ([self.ccn isFirstResponder] && stop == NO) {
        NSLog(@"name");
        stop = YES;
        [self.email becomeFirstResponder];
        
    }
    if ([self.expMonth isFirstResponder] && stop == NO) {
        NSLog(@"name");
        stop = YES;
        [self.ccn becomeFirstResponder];
        
    }
    if ([self.cvc isFirstResponder] && stop == NO) {
        NSLog(@"name");
        stop = YES;
        [self.expMonth becomeFirstResponder];
        
    }
    if ([self.firstName isFirstResponder] && stop == NO) {
        NSLog(@"name");
        stop = YES;
        [self.delegate moveViewDown];
        [self.cvc becomeFirstResponder];
        
    }
    
    if ([self.streetAddress isFirstResponder] && stop == NO) {
        NSLog(@"street");
        stop = YES;
        [self.firstName becomeFirstResponder];
    }
    
    if ([self.apt isFirstResponder] && stop == NO) {
        NSLog(@"city");
        stop = YES;
        [self.streetAddress becomeFirstResponder];
    }
    
    if ([self.City isFirstResponder] && stop == NO) {
        NSLog(@"city");
        stop = YES;
        [self.apt becomeFirstResponder];
    }
    
    if ([self.state isFirstResponder] && stop == NO) {
        NSLog(@"state");
        stop = YES;
        [self.City becomeFirstResponder];
    }
    
    if ([self.zip isFirstResponder] && stop == NO) {
        NSLog(@"Zip");
        stop = YES;
        [self.state becomeFirstResponder];
        
        
    }
}

- (void)DoneClicked1:(id)sender {
    [self.keyboardDoneButtonView2 removeFromSuperview];
    [self.delegate moveViewDown];
    
    if ([self.email isFirstResponder]) {
        NSLog(@"name");
        [self.email resignFirstResponder];
    }
    
    if ([self.ccn isFirstResponder]) {
        NSLog(@"name");
        [self.ccn resignFirstResponder];
    }
    
    if ([self.expMonth isFirstResponder]) {
        NSLog(@"name");
        [self.expMonth resignFirstResponder];
    }
    
    if ([self.cvc isFirstResponder]) {
        NSLog(@"name");
        [self.cvc resignFirstResponder];
    }
    
    if ([self.firstName isFirstResponder]) {
        NSLog(@"name");
        [self.firstName resignFirstResponder];
    }
    
    if ([self.streetAddress isFirstResponder]) {
        NSLog(@"street");
        [self.streetAddress resignFirstResponder];
    }
    
    if ([self.apt isFirstResponder]) {
        NSLog(@"city");
        [self.apt resignFirstResponder];
    }
    
    if ([self.City isFirstResponder]) {
        NSLog(@"city");
        [self.City resignFirstResponder];
    }
    
    if ([self.state isFirstResponder]) {
        NSLog(@"state");
        [self.state resignFirstResponder];
    }
    
    if ([self.zip isFirstResponder]) {
        NSLog(@"Zip");
        [self.zip resignFirstResponder];
        
    }
}


- (void)NextClicked1:(id)sender {
    BOOL stop = NO;
    if ([self.email isFirstResponder] && stop == NO) {
        NSLog(@"name");
        stop = YES;
        [self.ccn becomeFirstResponder];
    }
    if ([self.ccn isFirstResponder] && stop == NO) {
        NSLog(@"name");
        stop = YES;
        [self.expMonth becomeFirstResponder];
        
        self.expMonth.text = [NSString stringWithFormat:@"%@/%@",self.currentMonth,self.currentYear];
        
    }
    if ([self.expMonth isFirstResponder] && stop == NO) {
        NSLog(@"name");
        stop = YES;
        [self.cvc becomeFirstResponder];
    }
    if ([self.cvc isFirstResponder] && stop == NO) {
        NSLog(@"name");
        stop = YES;
         [self.delegate moveViewUp];
        [self.firstName becomeFirstResponder];
    }
    
    if ([self.firstName isFirstResponder] && stop == NO) {
        NSLog(@"email");
        stop = YES;
       
        [self.streetAddress becomeFirstResponder];
    }
    
    if ([self.streetAddress isFirstResponder] && stop == NO) {
        NSLog(@"street");
        stop = YES;
        [self.apt becomeFirstResponder];
    }
    
    if ([self.apt isFirstResponder] && stop == NO) {
        NSLog(@"city");
        stop = YES;
        [self.City becomeFirstResponder];
    }
    
    if ([self.City isFirstResponder] && stop == NO) {
        NSLog(@"city");
        stop = YES;
        [self.state becomeFirstResponder];
        
    }
    
    if ([self.state isFirstResponder] && stop == NO) {
        NSLog(@"state");
        stop = YES;
        [self.zip becomeFirstResponder];
        
    }
    
    if ([self.zip isFirstResponder] && stop == NO) {
        NSLog(@"Zip");
        stop = YES;
        [self.delegate moveViewDown];
        [self.zip resignFirstResponder];
        [self.keyboardDoneButtonView2 removeFromSuperview];
        
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


- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField == self.firstName) {
        [self.delegate moveViewUp];
    }
    
    if (textField == self.streetAddress) {
        [self.delegate moveViewUp];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rows = 0;
    
    if (section == 0) {
        rows = 1;
    }
    if (section == 1) {
        rows = 1;
    }
    if (section == 2) {
        rows = 7;
    }
    
    return 12;
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

#pragma mark Picker Delegate


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    return 2;
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
    if (component == 1) {
        
        self.currentYear = [self.yearArray objectAtIndex:row];
        self.expMonth.text = [NSString stringWithFormat:@"%@/%@",self.currentMonth,self.currentYear];
    }
    if (component == 0) {
        
        self.currentMonth = [self.monthArray objectAtIndex:row];
        self.expMonth.text = [NSString stringWithFormat:@"%@/%@",self.currentMonth,self.currentYear];
    }
    
}


- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    
    return 100;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"shipping"]) {
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"Back", returnbuttontitle) style:     UIBarButtonItemStyleBordered target:nil action:nil];
        self.navigationItem.backBarButtonItem = backButton;
    }
}

- (IBAction)BillingSameAsShipping:(id)sender {
    if ([self sharedAppDelegate].userSettings.shipping != nil) {
        if (self.BillingSameAsShippingOutlet.on == YES) {
            NSLog(@"State: %@",[self sharedAppDelegate].userSettings.shipping.state);
            NSLog(@"Street: %@",[self sharedAppDelegate].userSettings.shipping.street);
            self.firstName.text = [self sharedAppDelegate].userSettings.shipping.Name;
            
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
    else{
        self.BillingSameAsShippingOutlet.on = NO;
    }

}
@end
