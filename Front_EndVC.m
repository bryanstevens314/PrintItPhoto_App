//
//  Front_EndVC.m
//  Metal Prints
//
//  Created by Bryan Stevens on 4/24/16.
//  Copyright © 2016 Pocket Tools. All rights reserved.
//

#import "Front_EndVC.h"
#import "OrderTVC.h"
#import "DetailsTVC.h"
#import "AppDelegate.h"
@interface Front_EndVC (){

}
@property(nonatomic) NSInteger selectedProduct;
@property(nonatomic) NSInteger selectedProductSection;
@end

@implementation Front_EndVC


- (AppDelegate *)sharedAppDelegate
{
    
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"|||" style:UIBarButtonItemStylePlain target:self action:@selector(Settings)];
    [self.navigationItem setLeftBarButtonItem:leftBarButtonItem];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    [self.navigationItem setRightBarButtonItem:rightBarButtonItem];
    [self.navigationItem setTitle:@"Store"];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewWillAppear:YES];

}
- (void)Settings {
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ProductContainer"]) {
        ProductsTVC *tvc = segue.destinationViewController;
        tvc.delegate = self;
    }
    if ([segue.identifier isEqualToString:@"StartOrder"]) {
        NSLog(@"preparing segue");
        DetailsTVC *order = segue.destinationViewController;
        order.selectedRow = self.selectedProduct;
        order.selectedSection = self.selectedProductSection;
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"Cancel", returnbuttontitle) style:     UIBarButtonItemStyleBordered target:nil action:nil];
        self.navigationItem.backBarButtonItem = backButton;
        
        NSLog(@"initiating segue");
    }
}


- (IBAction)ShoppingCartSelected:(id)sender {



    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://final-project-order-viewer-stevens-apps.c9users.io/recieve_data.php"]];

    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                           @"Bryan Stevens",@"name",
                           @"1930 10th st",@"shipping_address",
                           @"bryan@yahoo.com",@"email", nil];

    NSError *error;

    NSData *jsonData =[NSJSONSerialization dataWithJSONObject:dict options:0 error:&error];

    [request setHTTPBody:jsonData];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[jsonData length]] forHTTPHeaderField:@"Content-Length"];
    

    NSError *err;
    NSURLResponse *response;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    NSString *responseString = [[NSString alloc]initWithData:responseData encoding:NSASCIIStringEncoding];
    

    
    if(responseString)
    {
        NSLog(@"got response==%@", responseString);
    }
    else
    {
        NSLog(@"faield to connect");
    }

}


- (void)ProductSelectedWithRow:(NSInteger)row andSection:(NSInteger)section{
    NSLog(@"Product selected");
    self.selectedProduct = row;
    self.selectedProductSection = section;
    [self performSegueWithIdentifier:@"StartOrder" sender:self];
}
@end
