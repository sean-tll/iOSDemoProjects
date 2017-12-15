//
//  ViewController.m
//  UnitConverter
//
//  Created by Tianshu Zhou on 12/4/17.
//  Copyright © 2017 Tianshu Zhou. All rights reserved.
//

#import "ViewController.h"

double convertOneToTwo(double unitOneValue) {
    double unitTwoValue;
    unitTwoValue = 1.61 * unitOneValue;
    return unitTwoValue;
}

double convertOneToThree(double unitOneValue) {
    double unitThreeValue;
    unitThreeValue = 63360 * unitOneValue;
    return unitThreeValue;
}

double convertOneToFour(double unitOneValue) {
    double unitFourValue;
    unitFourValue = 1760 * unitOneValue;
    return unitFourValue;
}

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *inputField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentController;
@property (weak, nonatomic) IBOutlet UILabel *outputField;

@end

@implementation ViewController

- (IBAction)updateButton:(id)sender {
    NSMutableString *buf = [NSMutableString new];
    
    double userInput = [self.inputField.text doubleValue];
    if (self.segmentController.selectedSegmentIndex == 0) {
        double unitTwoValue = convertOneToTwo(userInput);
        [buf appendString: [@(unitTwoValue) stringValue]];
    } else if (self.segmentController.selectedSegmentIndex == 1) {
        double unitThreeValue = convertOneToThree(userInput);
        [buf appendString: [@(unitThreeValue) stringValue]];
    } else {
        double unitFourValue = convertOneToFour(userInput);
        [buf appendString: [@(unitFourValue) stringValue]];
    }
    
    self.outputField.text = buf;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
