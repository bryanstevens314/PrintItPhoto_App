//
//  CropController.m
//  Metal Prints
//
//  Created by Bryan Stevens on 11/4/16.
//  Copyright © 2016 Pocket Tools. All rights reserved.
//

#import "CropController.h"

@interface CropController ()
@property (retain, nonatomic)UIImageView *imageView;
@end

@implementation CropController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:41.0/255.0 green:127.0/255.0 blue:184.0/255.0 alpha:1];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(DoneCropping)];
    [self.navigationItem setRightBarButtonItem:rightBarButtonItem];
    
    int height = 300 * self.cropRatio;
    NSLog(@"%d",height);
    self.cropView = [[UIView alloc] init];
    self.cropView.frame = CGRectMake(0, 0, 300, height);
    self.cropView.center = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2);
    self.cropView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.cropView];
    
    self.imageView = [[UIImageView alloc] initWithImage:self.cropImage];
    float imageRatio = self.cropImage.size.width/self.cropImage.size.height;
    if (self.cropImage.size.width < self.cropImage.size.height) {
        NSLog(@"portrait");
        
        float newHeight = self.cropView.frame.size.width / imageRatio;
        [self.imageView setFrame:CGRectMake(0, 0, self.cropView.frame.size.width, newHeight)];
        [self.imageView setCenter:CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2)];
    }
    if (self.cropImage.size.width > self.cropImage.size.height) {
        NSLog(@"landscape");
        float newHeight = self.cropView.frame.size.height / imageRatio;
        [self.imageView setFrame:CGRectMake(0, 0, newHeight, self.cropView.frame.size.height)];
        [self.imageView setCenter:CGPointMake(self.view.bounds.size.width/2,self.view.bounds.size.height/2)];
        self.imageView.image = self.cropImage;
    }
    if (self.cropImage.size.width == self.cropImage.size.height) {
        NSLog(@"square");
        [self.imageView setFrame:CGRectMake(0, 0, self.cropView.frame.size.height, self.cropView.frame.size.height)];
        [self.imageView setCenter:CGPointMake(self.view.bounds.size.width/2,self.view.bounds.size.height/2)];
        self.imageView.image = self.cropImage;
    }
    [self.view addSubview:self.imageView];
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveViewWithGestureRecognizer1:)];
    [self.view addGestureRecognizer:panGestureRecognizer];
    UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchWithGestureRecognizer1:)];

    [self.view addGestureRecognizer:pinchGestureRecognizer];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];

    UIBezierPath *overlayPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-44)];
    UIBezierPath *transparentPath = [UIBezierPath bezierPathWithRect:self.cropView.frame];
    [overlayPath appendPath:transparentPath];
    [overlayPath setUsesEvenOddFillRule:YES];
    
    fillLayer = [CAShapeLayer layer];
    fillLayer.path = overlayPath.CGPath;
    fillLayer.fillRule = kCAFillRuleEvenOdd;
    fillLayer.fillColor = [UIColor colorWithRed:74/255.0 green:74/255.0 blue:74/255.0 alpha:0.9].CGColor;
    
    [self.view.layer addSublayer:fillLayer];
    [self.view bringSubviewToFront:self.cropView];
}

-(void)viewDidAppear:(BOOL)animated{
    float height = self.cropView.frame.size.height;
    float width = self.cropView.frame.size.width;
    NSLog(@"%f",height);
    NSLog(@"%f",width);
}

-(void)moveViewWithGestureRecognizer1:(UIPanGestureRecognizer *)panGestureRecognizer{
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan ||
        panGestureRecognizer.state == UIGestureRecognizerStateChanged)
    {

            CGPoint currentPoint = self.imageView.center;
            CGPoint translation = [panGestureRecognizer translationInView: self.imageView];
            self.imageView.center = CGPointMake(currentPoint.x + translation.x, currentPoint.y + translation.y);
            [panGestureRecognizer setTranslation: CGPointZero inView: self.imageView];
        
//        // Get active location upon move
//        CGPoint activePoint = [panGestureRecognizer locationInView:self.view];
//        
//        // Determine new point based on where the touch is now located
//        CGPoint newPoint = CGPointMake(self.cropView.center.x + (activePoint.x - self.cropView.center.x),
//                                       self.cropView.center.y + (activePoint.y - self.cropView.center.y));
//        
//        //--------------------------------------------------------
//        // Make sure we stay within the bounds of the parent view
//        //--------------------------------------------------------
//        float midPointX = CGRectGetMidX(self.cropView.bounds);
//        // If too far right...
//        if (newPoint.x > self.cropView.superview.bounds.size.width  - midPointX)
//            newPoint.x = self.cropView.superview.bounds.size.width - midPointX;
//        else if (newPoint.x < midPointX)  // If too far left...
//            newPoint.x = midPointX;
//        
//        float midPointY = CGRectGetMidY(self.cropView.bounds);
//        // If too far down...
//        if (newPoint.y > self.cropView.superview.bounds.size.height  - midPointY)
//            newPoint.y = self.cropView.superview.bounds.size.height - midPointY;
//        else if (newPoint.y < midPointY)  // If too far up...
//            newPoint.y = midPointY;
//        
//        // Set new center location
//        self.imageView.center = newPoint;
    }
    
}


CGFloat lastScale1 ;
-(void)handlePinchWithGestureRecognizer1:(UIPinchGestureRecognizer *)pinchGestureRecognizer{
    
    if([pinchGestureRecognizer state] == UIGestureRecognizerStateBegan) {
        // Reset the last scale, necessary if there are multiple objects with different scales
        lastScale1 = [pinchGestureRecognizer scale];
    }
    
    if ([pinchGestureRecognizer state] == UIGestureRecognizerStateBegan ||
        [pinchGestureRecognizer state] == UIGestureRecognizerStateChanged) {
        
        CGFloat currentScale = [[self.imageView.layer valueForKeyPath:@"transform.scale"] floatValue];
        
        // Constants to adjust the max/min values of zoom
        const CGFloat kMaxScale = 2.0;
        const CGFloat kMinScale = .2;
        
        CGFloat newScale = 1 -  (lastScale1 - [pinchGestureRecognizer scale]); // new scale is in the range (0-1)
        newScale = MIN(newScale, kMaxScale / currentScale);
        newScale = MAX(newScale, kMinScale / currentScale);
        CGAffineTransform transform = CGAffineTransformScale([self.imageView transform], newScale, newScale);
        self.imageView.transform = transform;
        
        lastScale1 = [pinchGestureRecognizer scale];  // Store the previous scale factor for the next pinch gesture call
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)DoneCropping{
    
//    UIImage *cropped;
//    if (self.cropImage != nil){
//        CGRect CropRect = self.cropView.frame;
//        CGImageRef imageRef = CGImageCreateWithImageInRect([self.cropImage CGImage], CropRect) ;
//        cropped = [UIImage imageWithCGImage:imageRef];
//        CGImageRelease(imageRef);
//    }
//    [self.delegate FinishedCroppingImageWithImage:cropped];


    
//    CGSize itemSize = CGSizeMake(self.cropView.frame.size.width, self.cropView.frame.size.height);
//    UIGraphicsBeginImageContext(itemSize);
//    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
//    [self.cropImage drawInRect:imageRect];
//    
//    UIImage *cropped = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();

    CGImageRef imageRef = CGImageCreateWithImageInRect([self.imageView.image CGImage], self.cropView.frame);
    
    
    UIImage *cropped = [UIImage imageWithCGImage:imageRef];
    
    CGImageRelease(imageRef);
    [self.delegate FinishedCroppingImageWithImage:cropped];
}

#define rad(angle) ((angle) / 180.0 * M_PI)
- (CGAffineTransform)orientationTransformedRectOfImage:(UIImage *)img
{
    CGAffineTransform rectTransform;
    switch (img.imageOrientation)
    {
        case UIImageOrientationLeft:
            rectTransform = CGAffineTransformTranslate(CGAffineTransformMakeRotation(rad(90)), 0, -img.size.height);
            break;
        case UIImageOrientationRight:
            rectTransform = CGAffineTransformTranslate(CGAffineTransformMakeRotation(rad(-90)), -img.size.width, 0);
            break;
        case UIImageOrientationDown:
            rectTransform = CGAffineTransformTranslate(CGAffineTransformMakeRotation(rad(-180)), -img.size.width, -img.size.height);
            break;
        default:
            rectTransform = CGAffineTransformIdentity;
    };
    
    return CGAffineTransformScale(rectTransform, img.scale, img.scale);
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


CAShapeLayer *fillLayer;
- (IBAction)RotateCrop:(id)sender {
    float height = self.cropView.frame.size.height;
    float width = self.cropView.frame.size.width;
    NSLog(@"%f",height);
    NSLog(@"%f",width);
    [self.cropView setFrame:CGRectMake(0, 0, height, width)];
    [self.cropView setCenter:CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2)];
    [fillLayer removeFromSuperlayer];
    fillLayer = nil;
    UIBezierPath *overlayPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-44)];
    UIBezierPath *transparentPath = [UIBezierPath bezierPathWithRect:self.cropView.frame];
    [overlayPath appendPath:transparentPath];
    [overlayPath setUsesEvenOddFillRule:YES];
    
    fillLayer = [CAShapeLayer layer];
    fillLayer.path = overlayPath.CGPath;
    fillLayer.fillRule = kCAFillRuleEvenOdd;
    fillLayer.fillColor = [UIColor colorWithRed:74/255.0 green:74/255.0 blue:74/255.0 alpha:0.9].CGColor;
    
    [self.view.layer addSublayer:fillLayer];
    
}
@end
