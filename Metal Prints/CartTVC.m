//
//  CartTVC.m
//  Metal Prints
//
//  Created by Bryan Stevens on 9/15/16.
//  Copyright © 2016 Pocket Tools. All rights reserved.
//

#import "CartTVC.h"
#import "AppDelegate.h"
#import "CartItemTVCCell.h"
#import "TaxTVCCell.h"
#import "TotalTVCell.h"

@interface CartTVC ()

@end

@implementation CartTVC



- (AppDelegate *)sharedAppDelegate
{
    
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    NSInteger scrollable = [self sharedAppDelegate].shoppingCart.count + 3;
    if (scrollable > 8) {
        self.tableView.scrollEnabled = YES;
    }
    else{
        self.tableView.scrollEnabled = NO;
    }
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    
    NSInteger totalRows = [self sharedAppDelegate].shoppingCart.count + 3;
    return totalRows;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;



    if (indexPath.row <= [self sharedAppDelegate].shoppingCart.count - 1) {
        CartItemTVCCell *item_Cell = [tableView dequeueReusableCellWithIdentifier:@"cartItem" forIndexPath:indexPath];
//        array = @[product,
//                  self.Quantity_TextField.text,
//                  price,
//                  self.Retouching_TextField.text,
//                  @"",
//                  self.textView.text,
//                  [self.selectedImageURL absoluteString],
//                  imgString,
//                  [NSString stringWithFormat:@"%li",(long)self.selectedRow],
//                  [NSString stringWithFormat:@"%li",(long)self.selectedSection1]
//                  ];
        NSArray *item_Array = [[self sharedAppDelegate].shoppingCart objectAtIndex:indexPath.row];
        item_Cell.quantity.text = [NSString stringWithFormat:@"%@x",[item_Array objectAtIndex:1]];
        item_Cell.product.text = [item_Array objectAtIndex:0];
        int price = [[item_Array objectAtIndex:2] intValue];
        int quan = [[item_Array objectAtIndex:1] intValue];
        
        int total = price * quan;
        item_Cell.item_Price.text = [NSString stringWithFormat:@"$%i",total];
        item_Cell.product_Image_String = [item_Array objectAtIndex:7];
        item_Cell.view_Image_Outlet.tag = indexPath.row;
        cell = item_Cell;
    }
    
    if (indexPath.row == [self sharedAppDelegate].shoppingCart.count) {
        TaxTVCCell *tax_Cell = [tableView dequeueReusableCellWithIdentifier:@"tax" forIndexPath:indexPath];
        tax_Cell.tax_Percent.text = [NSString stringWithFormat:@"(8%%)"];
        tax_Cell.total_Tax.text = [NSString stringWithFormat:@"$3.52"];
        cell = tax_Cell;
    }
    
    if ([self sharedAppDelegate].cartTotal >= 50) {
        if (indexPath.row == [self sharedAppDelegate].shoppingCart.count + 1) {
            TotalTVCell *total_Cell = [tableView dequeueReusableCellWithIdentifier:@"total" forIndexPath:indexPath];
            total_Cell.total_Label.text = @"Shipping";
            total_Cell.total.text = [NSString stringWithFormat:@"Free"];
            cell = total_Cell;
        }
        if (indexPath.row == [self sharedAppDelegate].shoppingCart.count + 2) {
            TotalTVCell *total_Cell = [tableView dequeueReusableCellWithIdentifier:@"total" forIndexPath:indexPath];
            total_Cell.total.text = [NSString stringWithFormat:@"$%ld",(long)[self sharedAppDelegate].cartTotal];
            cell = total_Cell;
        }
    }
    else{
        if (indexPath.row == [self sharedAppDelegate].shoppingCart.count + 1) {
            TotalTVCell *total_Cell = [tableView dequeueReusableCellWithIdentifier:@"total" forIndexPath:indexPath];
            total_Cell.total_Label.text = @"Shipping";
            total_Cell.total.text = [NSString stringWithFormat:@"$7"];
            cell = total_Cell;
        }
        
        if (indexPath.row == [self sharedAppDelegate].shoppingCart.count + 2) {
            TotalTVCell *total_Cell = [tableView dequeueReusableCellWithIdentifier:@"total" forIndexPath:indexPath];
            total_Cell.total.text = [NSString stringWithFormat:@"$%ld",(long)[self sharedAppDelegate].cartTotal+7];
            cell = total_Cell;
        }
    }
    // Configure the cell...
    
    return cell;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
