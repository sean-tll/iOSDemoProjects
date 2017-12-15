//
//  ViewController.m
//  DistanceCalculator
//
//  Created by Tianshu Zhou on 12/14/17.
//  Copyright © 2017 Tianshu Zhou. All rights reserved.
//

#import "ViewController.h"
#import "DistanceGetter/DGDistanceRequest.h"

@interface ViewController ()
@property (nonatomic) DGDistanceRequest *req;
@property (weak, nonatomic) IBOutlet UITextField *startLocation;
@property (weak, nonatomic) IBOutlet UITextField *endLocationA;
@property (weak, nonatomic) IBOutlet UITextField *endLocationB;
@property (weak, nonatomic) IBOutlet UITextField *endLocationC;
@property (weak, nonatomic) IBOutlet UILabel *distanceA;
@property (weak, nonatomic) IBOutlet UILabel *distanceB;
@property (weak, nonatomic) IBOutlet UILabel *distanceC;
@property (weak, nonatomic) IBOutlet UISegmentedControl *unitController;
@property (weak, nonatomic) IBOutlet UIButton *calculateButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)buttonTapped:(id)sender {
    self.calculateButton.enabled = NO;
    
    self.req = [DGDistanceRequest alloc];
    
    NSString *start = self.startLocation.text;
    NSString *destA = self.endLocationA.text;
    NSString *destB = self.endLocationB.text;
    NSString *destC = self.endLocationC.text;
    NSArray *dests = @[destA, destB, destC];
    
    self.req = [self.req initWithLocationDescriptions:dests sourceDescription:start];
    
    __weak ViewController *weakSelf = self;
    
    self.req.callback = ^void(NSArray *responses) {
        ViewController *strongSelf = weakSelf;
        if (!strongSelf) {
            return;
        }
        
        NSUInteger unitIndex = strongSelf.unitController.selectedSegmentIndex;
        
        NSNull *badResult =[NSNull null];
        if (responses[0] != badResult) {
            NSString *distanceAValue = [strongSelf calculateDistanceByUnit:(unitIndex) andResponse:(responses[0])];
            NSString *distanceAOutput = [NSString stringWithFormat:@"%@", distanceAValue];
            strongSelf.distanceA.text = distanceAOutput;
        }
        if (responses[1] != badResult) {
            NSString *distanceBValue = [strongSelf calculateDistanceByUnit:(unitIndex) andResponse:(responses[1])];
            NSString *distanceBOutput = [NSString stringWithFormat:@"%@", distanceBValue];
            strongSelf.distanceB.text = distanceBOutput;
        }
        if (responses[2] != badResult) {
            NSString *distanceCValue = [strongSelf calculateDistanceByUnit:(unitIndex) andResponse:(responses[2])];
            NSString *distanceCOutput = [NSString stringWithFormat:@"%@", distanceCValue];
            strongSelf.distanceC.text = distanceCOutput;
        }
        
        strongSelf.req = nil;
        strongSelf.calculateButton.enabled = YES;
    };
    
    [self.req start];
    
}

- (NSString *) calculateDistanceByUnit: (NSUInteger)unitIndex
                       andResponse: (id) response {
    double distanceValue;
    NSString *unit;
    if ([response floatValue] < 0) {
        return @"N/A";
    }
    if (unitIndex == 0) {
        distanceValue = [response floatValue];
        unit = @"Meters";
    } else if (unitIndex == 1) {
        distanceValue = [response floatValue] / 1000.0;
        unit = @"Kilometers";
    } else {
        distanceValue = ([response floatValue] / 1000.0) * 0.621371;
        unit = @"Miles";
    }
    NSString *result = [NSString stringWithFormat:@"%.2f %@", distanceValue, unit];
    return result;
}


@end
