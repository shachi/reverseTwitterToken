//
//  ViewController.m
//  reverseTwitterToken
//
//  Created by shachi on 2014/03/18.
//  Copyright (c) 2014年 THE GUILD. All rights reserved.
//

#import "ViewController.h"
#import <Accounts/Accounts.h>
#import <Social/Social.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSLog(@"こんな感じ");
    
    // twitter
    _apiManager = [[TWAPIManager alloc] init];
    
    [self twitterLogin];
}

#pragma mark - twitter
- (void)twitterLogin
{
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    [accountStore requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error){
        NSLog(@"きた?");
        if (granted) {
            NSArray *accounts = [accountStore accountsWithAccountType:accountType];
            // Check if the users has setup at least one Twitter account
            if (accounts.count > 0)
            {
                ACAccount *twitterAccount = [accounts objectAtIndex:0];
                NSLog(@"どうか?");
                //[self twitterLoginGiftee:twitterAccount];
                [_apiManager performReverseAuthForAccount:twitterAccount withHandler:^(NSData *responseData, NSError *error) {
                    if (responseData) {
                        NSString *responseStr = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
                        
                        NSLog(@"Reverse Auth process returned: %@", responseStr);
                        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                        NSArray *parts = [responseStr componentsSeparatedByString:@"&"];
                        for (NSString *data in parts) {
                            NSArray *dataParts = [data componentsSeparatedByString:@"="];
                            dict[dataParts[0]] = dataParts[1];
                        }
                        NSLog(@"data %@", dict);
                        
                    }
                    else {
                        NSLog(@"Reverse Auth process failed. Error returned was: %@\n", [error localizedDescription]);
                    }
                }];
                
            }
        } else {
            NSLog(@"No access granted");
        }
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
