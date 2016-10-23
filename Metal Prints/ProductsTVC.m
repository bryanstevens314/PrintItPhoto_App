//
//  ProductsTVC.m
//  Metal Prints
//
//  Created by Bryan Stevens on 4/20/16.
//  Copyright © 2016 Pocket Tools. All rights reserved.
//

#import "ProductsTVC.h"
#import "ProductTVCCell.h"
#import "AppDelegate.h"


@interface ProductsTVC (){
    NSInteger selectedProduct;
    NSInteger selectedProductSection;

}

@end

@implementation ProductsTVC


- (AppDelegate *)sharedAppDelegate
{
    
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
//    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Start" style:UIBarButtonItemStylePlain target:self action:@selector(start)];
//    [self.navigationItem setRightBarButtonItem:rightBarButtonItem];
//    [self.navigationItem setTitle:@"Products"];
   self.tableView.contentInset = UIEdgeInsetsMake(-65, 0, 0, 0);

}

- (void)start {
    [self performSegueWithIdentifier:@"StartOrder" sender:self];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger totalRows = 0;
    if (section == 0) {
        totalRows = [self sharedAppDelegate].AluminumProductArray.count;
    }
    if (section == 1) {
        totalRows = [self sharedAppDelegate].WoodenProductArray.count;
    }
    return totalRows;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ProductTVCCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Product" forIndexPath:indexPath];
    if (indexPath.section == 0) {
        NSArray *array = [[self sharedAppDelegate].AluminumProductArray objectAtIndex:indexPath.row];
        cell.Product_Name.text = [array objectAtIndex:0];
        cell.Price.text = [NSString stringWithFormat:@"$%@",[array objectAtIndex:1] ];
    }
    if (indexPath.section == 1) {
        NSArray *array = [[self sharedAppDelegate].WoodenProductArray objectAtIndex:indexPath.row];
        cell.Product_Name.text = [array objectAtIndex:0];
        cell.Price.text = [NSString stringWithFormat:@"$%@",[array objectAtIndex:1] ];
    }
    
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    NSInteger section = 0;
//    NSLog(@"%li",(long)indexPath.row);
//    if (indexPath.row <= 9) {
//        section = 0;
//    }
//    if (indexPath.row >= 10) {
//        section = 1;
//    }
    NSLog(@"Clicked row");
    [self.delegate ProductSelectedWithRow:indexPath.row andSection:indexPath.section];
}
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"StartOrder"]) {
        //OrderTVC *order = segue.destinationViewController;

    }
}


@end
