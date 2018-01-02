//
//  ViewController.m
//  TwitterShareProduct
//
//  Created by Tianshu Zhou on 12/16/17.
//  Copyright © 2017 Tianshu Zhou. All rights reserved.
//

#import "ViewController.h"
#import "Social/Social.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextView *tweetTextView;

//- (void) configureTweetTextView;

- (void) showAlertMessage:(NSString *) message;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    [self configureTweetTextView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) showAlertMessage:(NSString *) message {
    UIAlertController *alertController;
    alertController = [UIAlertController alertControllerWithTitle:@"TwitterShare" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alertController animated:YES completion:nil];
}


- (IBAction)showShareAction:(id)sender {
    if ([self.tweetTextView isFirstResponder]) {
        [self.tweetTextView resignFirstResponder];
    }
    
    UIAlertController *actionController = [UIAlertController alertControllerWithTitle:@"Test Title" message:@"Tweet your note" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:nil];
    UIAlertAction *tweetAction = [UIAlertAction actionWithTitle:@"Tweet" style:UIAlertActionStyleDefault handler: ^(UIAlertAction *action) {
        if([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
            SLComposeViewController *twitterVC = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
            if ([self.tweetTextView.text length] < 140) {
                [twitterVC setInitialText:self.tweetTextView.text];
            } else {
                NSString *shortText = [self.tweetTextView.text substringToIndex:140];
                [twitterVC setInitialText:shortText];
            }
            [self presentViewController:twitterVC animated:YES completion:nil];
        } else {
            [self showAlertMessage:@"Please sign in your Twitter account in Settings"];
        }
                }];
    
    UIAlertAction *moreAction = [UIAlertAction actionWithTitle:@"More" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UIActivityViewController *moreVC = [[UIActivityViewController alloc] initWithActivityItems:@[self.tweetTextView.text] applicationActivities:nil];
        [self presentViewController:moreVC animated:YES completion:nil];
    }];
    
    [actionController addAction:tweetAction];
    [actionController addAction:moreAction];
    [actionController addAction:cancelAction];
    
    [self presentViewController:actionController animated:YES completion:nil];
}


//- (void) configureTweetTextView {
//    self.tweetTextView.layer.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:0.9 alpha:1.0].CGColor;
//    self.tweetTextView.layer.cornerRadius = 10.0;
//    self.tweetTextView.layer.borderColor = [UIColor colorWithWhite:0 alpha:1.0].CGColor;
//    self.tweetTextView.layer.borderWidth = 2.0;
//}

@end
