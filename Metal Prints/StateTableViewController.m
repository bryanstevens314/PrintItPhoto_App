//
//  StateTableViewController.m
//  Metal Prints
//
//  Created by Bryan Stevens on 10/4/16.
//  Copyright © 2016 Pocket Tools. All rights reserved.
//

#import "StateTableViewController.h"

@interface StateTableViewController ()

@end

@implementation StateTableViewController

NSArray *arr;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *stateJSON = @" \
    [ \
    {\"name\":\"Alabama\",\"alpha-2\":\"AL\"}, \
    {\"name\":\"Alaska\",\"alpha-2\":\"AK\"}, \
    {\"name\":\"Arizona\",\"alpha-2\":\"AZ\"}, \
    {\"name\":\"Arkansas\",\"alpha-2\":\"AR\"}, \
    {\"name\":\"California\",\"alpha-2\":\"CA\"}, \
    {\"name\":\"Colorado\",\"alpha-2\":\"CO\"}, \
    {\"name\":\"Connecticut\",\"alpha-2\":\"CT\"}, \
    {\"name\":\"Delaware\",\"alpha-2\":\"DE\"}, \
    {\"name\":\"District of Columbia\",\"alpha-2\":\"DC\"}, \
    {\"name\":\"Florida\",\"alpha-2\":\"FL\"}, \
    {\"name\":\"Georgia\",\"alpha-2\":\"GA\"}, \
    {\"name\":\"Hawaii\",\"alpha-2\":\"HI\"}, \
    {\"name\":\"Idaho\",\"alpha-2\":\"ID\"}, \
    {\"name\":\"Illinois\",\"alpha-2\":\"IL\"}, \
    {\"name\":\"Indiana\",\"alpha-2\":\"IN\"}, \
    {\"name\":\"Iowa\",\"alpha-2\":\"IA\"}, \
    {\"name\":\"Kansa\",\"alpha-2\":\"KS\"}, \
    {\"name\":\"Kentucky\",\"alpha-2\":\"KY\"}, \
    {\"name\":\"Lousiana\",\"alpha-2\":\"LA\"}, \
    {\"name\":\"Maine\",\"alpha-2\":\"ME\"}, \
    {\"name\":\"Maryland\",\"alpha-2\":\"MD\"}, \
    {\"name\":\"Massachusetts\",\"alpha-2\":\"MA\"}, \
    {\"name\":\"Michigan\",\"alpha-2\":\"MI\"}, \
    {\"name\":\"Minnesota\",\"alpha-2\":\"MN\"}, \
    {\"name\":\"Mississippi\",\"alpha-2\":\"MS\"}, \
    {\"name\":\"Missouri\",\"alpha-2\":\"MO\"}, \
    {\"name\":\"Montana\",\"alpha-2\":\"MT\"}, \
    {\"name\":\"Nebraska\",\"alpha-2\":\"NE\"}, \
    {\"name\":\"Nevada\",\"alpha-2\":\"NV\"}, \
    {\"name\":\"New Hampshire\",\"alpha-2\":\"NH\"}, \
    {\"name\":\"New Jersey\",\"alpha-2\":\"NJ\"}, \
    {\"name\":\"New Mexico\",\"alpha-2\":\"NM\"}, \
    {\"name\":\"New York\",\"alpha-2\":\"NY\"}, \
    {\"name\":\"North Carolina\",\"alpha-2\":\"NC\"}, \
    {\"name\":\"North Dakota\",\"alpha-2\":\"ND\"}, \
    {\"name\":\"Ohio\",\"alpha-2\":\"OH\"}, \
    {\"name\":\"Oklahoma\",\"alpha-2\":\"OK\"}, \
    {\"name\":\"Oregon\",\"alpha-2\":\"OR\"}, \
    {\"name\":\"Pennsylvania\",\"alpha-2\":\"PA\"}, \
    {\"name\":\"Rhode Island\",\"alpha-2\":\"RI\"}, \
    {\"name\":\"South Carolina\",\"alpha-2\":\"SC\"}, \
    {\"name\":\"South Dakota\",\"alpha-2\":\"SD\"}, \
    {\"name\":\"Tennessee\",\"alpha-2\":\"TN\"}, \
    {\"name\":\"Texas\",\"alpha-2\":\"TX\"}, \
    {\"name\":\"Utah\",\"alpha-2\":\"UT\"}, \
    {\"name\":\"Vermont\",\"alpha-2\":\"VT\"}, \
    {\"name\":\"Virginia\",\"alpha-2\":\"VA\"}, \
    {\"name\":\"Washington\",\"alpha-2\":\"WA\"}, \
    {\"name\":\"West Virginia\",\"alpha-2\":\"WV\"}, \
    {\"name\":\"Wisconsin\",\"alpha-2\":\"WI\"}, \
    {\"name\":\"Wyoming\",\"alpha-2\":\"WY\"} \
    ] \
    ";
    
    NSData *data = [stateJSON dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    arr = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&err];

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
    return arr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"stateCell" forIndexPath:indexPath];
    
    NSDictionary *stateDict = [arr objectAtIndex:indexPath.row];
    cell.textLabel.text = [stateDict objectForKey:@"name"];
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"!!!");
    NSDictionary *stateDict = [arr objectAtIndex:indexPath.row];
    [self.delegate pickedState:[stateDict objectForKey:@"alpha-2"]];
    
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
