//
//  OrderTVC.m
//  Metal Prints
//
//  Created by Bryan Stevens on 4/20/16.
//  Copyright © 2016 Pocket Tools. All rights reserved.
//

#import "OrderTVC.h"
#import "AppDelegate.h"

@interface OrderTVC (){

    BOOL chosePic;
}
@property (retain, nonatomic) UIPickerView *picker;
@property (nonatomic, retain) UIImagePickerController *imagePicker;
@property (nonatomic, retain) UIImage *image;
@property (nonatomic, retain) UIImageView* imgView ;
@end

@implementation OrderTVC


- (AppDelegate *)sharedAppDelegate
{
    
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:self action:@selector(Continue)];

    [self.navigationItem setRightBarButtonItem:rightBarButtonItem];
    [self.navigationItem setTitle:@"Custom Print"];


//[[self.Product_Outlet valueForKey:@"textInputTraits"] setValue:[UIColor clearColor] forKey:@"insertionPointColor"];

    
}

- (void)Continue {
    [self performSegueWithIdentifier:@"ContinueSegue" sender:self];
    // Dispose of any resources that can be recreated.
}

-(void)cropImage{
    
}


- (void)camera
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        self.imagePicker= [[UIImagePickerController alloc] init];
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        //self.imagePicker.allowsEditing = YES;
        self.imagePicker.delegate = self;
        [self presentViewController:self.imagePicker animated:YES completion:nil];
    }
    else
    {
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                              message:@"Device has no camera"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
        [myAlertView show];
    }
}



- (void)library{
    self.imagePicker = [[UIImagePickerController alloc] init];
    [self.imagePicker setSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
    //self.imagePicker.allowsEditing = YES;
    self.imagePicker.delegate = self;
    
    [self presentViewController:self.imagePicker animated:YES completion:nil];
}




#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{

    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    NSInteger integer = [self sharedAppDelegate].AluminumProductArray.count + [self sharedAppDelegate].WoodenProductArray.count;
    return integer;
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *string;
    if (row <= 9) {
        NSLog(@"%li",(long)row);
        NSArray *array = [[self sharedAppDelegate].AluminumProductArray objectAtIndex:row];
        string = [array objectAtIndex:0];
    }
    if (row >= 10) {
        NSArray *array = [[self sharedAppDelegate].WoodenProductArray objectAtIndex:row-10];
        string = [array objectAtIndex:0];
    }
    return string;
}

// Catpure the picker view selection
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSString *string;
    if (row <= 9) {
        NSLog(@"%li",(long)row);
        NSArray *array = [[self sharedAppDelegate].AluminumProductArray objectAtIndex:row];
        string = [array objectAtIndex:0];
    }
    if (row >= 10) {
        NSLog(@">10");
        NSArray *array = [[self sharedAppDelegate].WoodenProductArray objectAtIndex:row-10];
        string = [array objectAtIndex:0];
    }
    self.Product_Outlet.text = string;
}


-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if (self.image) {
        self.image =  nil;
    }
    if (self.imgView) {
        [self.imgView removeFromSuperview];
        self.imgView = nil;
    }
    self.image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self.imagePicker dismissViewControllerAnimated:YES completion:nil];
    
    if (self.image.size.width < self.image.size.height) {
        NSLog(@"<");
        self.imgView = [[UIImageView alloc] initWithFrame:CGRectMake(146, 40, 93.75, 125)];
    }
    if (self.image.size.width > self.image.size.height) {
        NSLog(@">");
        self.imgView = [[UIImageView alloc] initWithFrame:CGRectMake(108, 44, 158, 118.5)];
    }
    if (self.image.size.width == self.image.size.height) {
        NSLog(@">");
        self.imgView = [[UIImageView alloc] initWithFrame:CGRectMake(125, 41, 124, 124)];
    }
    //Initialization
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];

    
    tapGesture.numberOfTapsRequired = 1;
    tapGesture.cancelsTouchesInView = NO;
    self.imgView.userInteractionEnabled = YES;
    [self.imgView addGestureRecognizer:tapGesture];
    
    
//    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
//    tapGesture.numberOfTapsRequired = 1;
//    tapGesture.cancelsTouchesInView = NO;
//    self.Addimage.userInteractionEnabled = YES;
//    [self.Addimage addGestureRecognizer:tapGesture];
    chosePic = YES;
    [self.imgView setImage:self.image];
    [self.cell addSubview:self.imgView];

    self.Choose_Image_Outlet.hidden = YES;
    //self.image_View.hidden = NO;
}


-(void)handleTap:(UIGestureRecognizer *)sender{
    UIAlertController *alert2 = [UIAlertController alertControllerWithTitle:@"" message:@""preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cropAction = [UIAlertAction actionWithTitle:@"Crop Image"
                                                            style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                                [self cropImage];
                                                            }]; // 2
    
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"Take Photo"
                                                           style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                               [self camera];
                                                           }]; // 2
    
    UIAlertAction *libraryAction = [UIAlertAction actionWithTitle:@"Choose Image"
                                                            style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                                [self library];
                                                            }]; // 2
    [cropAction setValue:[[UIImage imageNamed:@"camera.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forKey:@"image"];
    [cameraAction setValue:[[UIImage imageNamed:@"camera.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forKey:@"image"];
    [libraryAction setValue:[[UIImage imageNamed:@"photo icon.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]   forKey:@"image"];
    
    [alert2 addAction:cropAction];
    [alert2 addAction:cameraAction];
    [alert2 addAction:libraryAction];
    
    [self presentViewController:alert2 animated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"ContinueSegue"]) {
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"Back", returnbuttontitle) style:     UIBarButtonItemStyleBordered target:nil action:nil];
        self.navigationItem.backBarButtonItem = backButton;
    }
}


- (IBAction)ChooseImage:(id)sender {
    
UIAlertController *alert2 = [UIAlertController alertControllerWithTitle:@"" message:@""preferredStyle:UIAlertControllerStyleActionSheet];
    
        UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"Take Photo"
                                                              style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                                  [self camera];
                                                              }]; // 2
    
        UIAlertAction *libraryAction = [UIAlertAction actionWithTitle:@"Choose Image"
                                                              style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                                  [self library];
                                                              }]; // 2
    [cameraAction setValue:[[UIImage imageNamed:@"camera.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forKey:@"image"];
    [libraryAction setValue:[[UIImage imageNamed:@"photo icon.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]   forKey:@"image"];
    
    [alert2 addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        // Called when user taps outside
    }]];
    [alert2 addAction:cameraAction];
    [alert2 addAction:libraryAction];
    
    [self presentViewController:alert2 animated:YES completion:nil];
    
//    UIAlertController *alert2 = [UIAlertController alertControllerWithTitle:@""
//                                                                    message:@""
//                                                             preferredStyle:UIAlertControllerStyleAlert]; // 1
//    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@""
//                                                          style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
//                                                              [alert2 dismissViewControllerAnimated:YES completion:nil];
//                                                          }]; // 2
//
//    UIAlertAction *libraryAction = [UIAlertAction actionWithTitle:@""
//                                                          style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
//                                                              [alert2 dismissViewControllerAnimated:YES completion:nil];
//                                                          }]; // 2
//    [cameraAction setValue:[[UIImage imageNamed:@"camera.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forKey:@"image"];
//    [libraryAction setValue:[[UIImage imageNamed:@"photo icon.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]   forKey:@"image"];
//
//    
//    [alert2 addAction:cameraAction]; // 4
//    [alert2 addAction:libraryAction]; // 4
//    [self presentViewController:alert2 animated:YES completion:nil];
}
@end
