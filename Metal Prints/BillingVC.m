//
//  BillingVC.m
//  
//
//  Created by Bryan Stevens on 8/22/16.
//
//

#import "BillingVC.h"
#import "CCTVC.h"
#import "AppDelegate.h"

@interface BillingVC (){
    CCTVC *CCTable;
}

@end

@implementation BillingVC


- (AppDelegate *)sharedAppDelegate
{
    
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:self action:@selector(EnterPayment)];
    [self.navigationItem setRightBarButtonItem:rightBarButtonItem];
    
    CCTable = [CCTVC sharedCCTVC];
        CCTable.tableView.frame = CGRectMake(self.tableContentView.frame.origin.x, self.tableContentView.frame.origin.y-110, self.tableContentView.frame.size.width, self.tableContentView.frame.size.height);

    [self.tableContentView addSubview:CCTable.tableView];
    
    
    

}

- (void)EnterPayment {
    
    [self performSegueWithIdentifier:@"Payment" sender:self];
    
//    if (![CCTable.firstName.text isEqualToString:@""] && ![CCTable.streetAddress.text isEqualToString:@""] && ![CCTable.apt.text isEqualToString:@""] && ![CCTable.City.text isEqualToString:@""] && ![CCTable.state.text isEqualToString:@""] && ![CCTable.zip.text isEqualToString:@""]) {
//        
//        [self sharedAppDelegate].userSettings.billing.name = CCTable.firstName.text;
//        
//        [self sharedAppDelegate].userSettings.billing.street = CCTable.streetAddress.text;
//        
//        [self sharedAppDelegate].userSettings.billing.apt = CCTable.apt.text;
//        
//        [self sharedAppDelegate].userSettings.billing.city = CCTable.City.text;
//        
//        [self sharedAppDelegate].userSettings.billing.state = CCTable.state.text;
//        
//        [self sharedAppDelegate].userSettings.billing.zip = CCTable.zip.text;
//        
//        [self performSegueWithIdentifier:@"Payment" sender:self];
//    }
//    else{
//        UIAlertController *alert2 = [UIAlertController alertControllerWithTitle:@"" message:@"Please enter all required information"preferredStyle:UIAlertControllerStyleAlert];
//        
//        UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"OK"
//                                                               style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
//                                                                   [alert2 dismissViewControllerAnimated:YES completion:nil];
//                                                               }]; // 2
//        
//        [alert2 addAction:cameraAction];
//        
//        [self presentViewController:alert2 animated:YES completion:nil];
//    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
