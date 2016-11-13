//
//  ContactUSTVC.m
//  Metal Prints
//
//  Created by Bryan Stevens on 10/27/16.
//  Copyright © 2016 Pocket Tools. All rights reserved.
//

#import "ContactUSTVC.h"
#import "SWRevealViewController.h"

@interface ContactUSTVC ()
@property (nonatomic) float originalOrigin1;
@property (retain, nonatomic) UIPickerView *picker11;
@property (retain, nonatomic) UIToolbar* keyboardDoneButtonView11;
@property (retain, nonatomic) NSArray* problemArray;
@end

@implementation ContactUSTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.problemArray = @[@"0",@"1",@"2",@"3",@"4",@"5"];
    UIImage *background = [UIImage imageNamed:@"Hamburger_icon.svg.png"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(toggleReveal22) forControlEvents:UIControlEventTouchUpInside]; //adding action
    [button setBackgroundImage:background forState:UIControlStateNormal];
    button.frame = CGRectMake(0 ,0,35,30);
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [self.navigationItem setLeftBarButtonItem:leftBarButtonItem];
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:41.0/255.0 green:127.0/255.0 blue:184.0/255.0 alpha:0.6];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.problemTextField.text = @"0";
    [self.problemTextField setTintColor:[UIColor clearColor]];
    self.picker11 = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 50, 100, 200)];
    [self.picker11 setDataSource: self];
    [self.picker11 setDelegate: self];
    self.picker11.showsSelectionIndicator = YES;
    //[self.picker4 selectRow:self.selectedSection1 inComponent:0 animated:NO];
    self.problemTextField.inputView = self.picker11;
    self.problemTextField.adjustsFontSizeToFitWidth = YES;
    self.problemTextField.textColor = [UIColor blackColor];
    self.problemTextField.inputAssistantItem.leadingBarButtonGroups = @[];
    self.problemTextField.inputAssistantItem.trailingBarButtonGroups = @[];
    
    self.keyboardDoneButtonView11 = [[UIToolbar alloc] init];
    self.keyboardDoneButtonView11.barStyle = UIBarStyleDefault;
    self.keyboardDoneButtonView11.translucent = YES;
    self.keyboardDoneButtonView11.tintColor = nil;
    [self.keyboardDoneButtonView11 sizeToFit];
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                   style:UIBarButtonItemStyleDone target:self
                                                                  action:@selector(pickerDoneClicked1:)];
    
    [self.keyboardDoneButtonView11 setItems:[NSArray arrayWithObjects:flexSpace,doneButton, nil]];
    self.problemTextField.inputAccessoryView = self.keyboardDoneButtonView11;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)pickerDoneClicked1:(id)sender {
    [self.keyboardDoneButtonView11 removeFromSuperview];
    if ([self.problemTextField isFirstResponder]) {
        [self.problemTextField  resignFirstResponder];
    }
    
}


UIButton *proceedButton3;
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    //[self.tableView setContentOffset:CGPointMake(0, -20)];
    [self.navigationItem setTitle:@"Support"];
    if (proceedButton3 == nil) {
        
        proceedButton3 = [UIButton buttonWithType:UIButtonTypeCustom];
        proceedButton3.frame = CGRectMake(0, 0, 353, 50);
        proceedButton3.layer.cornerRadius = 2;
        proceedButton3.clipsToBounds = YES;
        [proceedButton3 addTarget:self action:@selector(Contact) forControlEvents:UIControlEventTouchUpInside];
        [proceedButton3 setTitle:@"Contact Us" forState:UIControlStateNormal];
        proceedButton3.backgroundColor = [UIColor colorWithRed:41.0/255.0 green:127.0/255.0 blue:184.0/255.0 alpha:1];
        proceedButton3.center = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height- 40);
        self.originalOrigin1 = proceedButton3.frame.origin.y;
        [self.view insertSubview:proceedButton3 aboveSubview:self.view];
    }
    else{
        proceedButton3 = nil;
        proceedButton3 = [UIButton buttonWithType:UIButtonTypeCustom];
        proceedButton3.frame = CGRectMake(0, 0, 353, 50);
        proceedButton3.layer.cornerRadius = 2;
        proceedButton3.clipsToBounds = YES;
        [proceedButton3 addTarget:self action:@selector(Contact) forControlEvents:UIControlEventTouchUpInside];
        [proceedButton3 setTitle:@"Contact Us" forState:UIControlStateNormal];
        proceedButton3.backgroundColor = [UIColor colorWithRed:41.0/255.0 green:127.0/255.0 blue:184.0/255.0 alpha:1];
        proceedButton3.center = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height- 40);
        self.originalOrigin1 = proceedButton3.frame.origin.y;
        [self.view insertSubview:proceedButton3 aboveSubview:self.view];
    }


}

-(void)viewWillDisappear:(BOOL)animated{
    displayFAQ = NO;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    NSInteger rows = 0;
    if (self.problemTextField.inputView == pickerView) {
        
        rows = self.problemArray.count;
    }
    return rows;
}


// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *string;
    if (self.problemTextField.inputView == pickerView) {
        string = [self.problemArray objectAtIndex:row];
    }

    return string;
}

// Catpure the picker view selection
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    selectedProblem = YES;
    if (self.problemTextField.inputView == pickerView) {

        self.problemTextField.text = [self.problemArray objectAtIndex:row];
        
    }

    
}



// to make the button float over the tableView including tableHeader
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGRect tableBounds = self.tableView.bounds;
    CGRect floatingButtonFrame = proceedButton3.frame;
    floatingButtonFrame.origin.y = self.originalOrigin1 + tableBounds.origin.y;
    proceedButton3.frame = floatingButtonFrame;
    
    [self.view bringSubviewToFront:proceedButton3]; // float over the tableHeader
}


BOOL selectedProblem;
-(void)Contact{
    
    if (selectedProblem == NO) {
        UIAlertController *alert2 = [UIAlertController alertControllerWithTitle:@"" message:@"Please select the problem you're having"preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"OK"
                                                               style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                                   [alert2 dismissViewControllerAnimated:YES completion:nil];
                                                                   [self.problemTextField becomeFirstResponder];
                                                               }]; // 2
        
        [alert2 addAction:cameraAction];
        
        [self presentViewController:alert2 animated:YES completion:nil];

    }
    else{
        // From within your active view controller
        if([MFMailComposeViewController canSendMail]) {
            [UINavigationBar appearance].barTintColor = [UIColor colorWithRed:41.0/255.0 green:127.0/255.0 blue:184.0/255.0 alpha:0.6];
            [UINavigationBar appearance].tintColor = [UIColor whiteColor];
            
            MFMailComposeViewController *mailCont = [[MFMailComposeViewController alloc] init];
            [mailCont.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
            mailCont.navigationBar.tintColor = [UIColor whiteColor];
            mailCont.mailComposeDelegate = self;
            
            [mailCont setSubject:@""];
            [mailCont setToRecipients:[NSArray arrayWithObject:@"bryan_stevens314@yahoo.com"]];
            [mailCont setMessageBody:@"" isHTML:NO];
            
            [self presentModalViewController:mailCont animated:YES];
        }
    }
    
    

}
// Then implement the delegate method
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    [self dismissModalViewControllerAnimated:YES];
}

UITapGestureRecognizer *singleTap22;
-(void)toggleReveal22{
    if ([self.problemTextField isFirstResponder]) {
        [self.problemTextField resignFirstResponder];
    }
    //collView.collectionView.userInteractionEnabled = NO;
    singleTap22 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(SingleTap22:)];
    singleTap22.numberOfTapsRequired = 1;
    [self.tableView  addGestureRecognizer:singleTap22];
    [self.revealViewController revealToggle];
}

-(void)SingleTap22:(UITapGestureRecognizer *)gesture{
    
    [self.revealViewController revealToggle];
    [self.tableView removeGestureRecognizer:singleTap22];
    singleTap22 = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

BOOL displayFAQ;
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    NSInteger cellHeight;
    if (indexPath.row == 0) {
        cellHeight = 32;
        
    }
    else{
        cellHeight = 83;
    }
    return cellHeight;
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
