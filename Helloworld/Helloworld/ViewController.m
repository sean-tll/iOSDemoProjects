//
//  ViewController.m
//  Helloworld
//
//  Created by Tianshu Zhou on 11/28/17.
//  Copyright © 2017 Tianshu Zhou. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *testLabel;

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

- (IBAction)testButtonAction:(id)sender {
    self.testLabel.text = @"Goodbye";
}

@end
