//
//  ViewController.m
//  CurrencyConversion
//
//  Created by Tianshu Zhou on 12/13/17.
//  Copyright © 2017 Tianshu Zhou. All rights reserved.
//

#import "ViewController.h"
#import "CurrencyRequest/CRCurrencyRequest.h"
#import "CurrencyRequest/CRCurrencyResults.h"

@interface ViewController () <CRCurrencyRequestDelegate>
@property (nonatomic) CRCurrencyRequest *req;
@property (weak, nonatomic) IBOutlet UITextField *inputField;
@property (weak, nonatomic) IBOutlet UIButton *convertButton;
@property (weak, nonatomic) IBOutlet UILabel *currencyA;
@property (weak, nonatomic) IBOutlet UILabel *currencyB;
@property (weak, nonatomic) IBOutlet UILabel *currencyC;

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
    self.convertButton.enabled = NO;
    
    self.req = [[CRCurrencyRequest alloc] init];
    self.req.delegate = self;
    [self.req start];
}

- (void)currencyRequest:(CRCurrencyRequest *)req
    retrievedCurrencies:(CRCurrencyResults *)currencies {
    self.convertButton.enabled = YES;
    
    double inputValue = [self.inputField.text floatValue];
    
    double euroValue = inputValue * currencies.EUR;
    NSString *euroValueOutput = [NSString stringWithFormat:@"%.2f",euroValue];
    self.currencyA.text = euroValueOutput;
    double yenValue = inputValue * currencies.JPY;
    NSString *yenValueOutput = [NSString stringWithFormat:@"%.2f",yenValue];
    self.currencyB.text = yenValueOutput;
    double gbpValue = inputValue * currencies.GBP;
    NSString *gbpValueOutput = [NSString stringWithFormat:@"%.2f",gbpValue];
    self.currencyC.text = gbpValueOutput;
    
}

@end
