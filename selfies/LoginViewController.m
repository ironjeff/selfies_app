//
//  LoginViewController.m
//  selfies
//
//  Created by Jeff Huang on 12/11/13.
//  Copyright (c) 2013 Jeff Huang. All rights reserved.
//

#import <Parse/Parse.h>
#import "LoginViewController.h"
#import "ViewController.h"


@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"Selfies";
    self.loginButton.layer.cornerRadius = 8;
    
    // TODO We can uncomment this so people don't have to click every time but it made my demos more reliable
//    // Check if user is cached and linked to Facebook, if so, bypass login
//    if ([PFUser currentUser] && [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) {
//        [self.navigationController pushViewController:[[ViewController alloc] initWithNibName:@"ViewController" bundle:nil] animated:YES];
//    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginButtonClick:(UIButton *)sender {
    // Set permissions required from the facebook user account
    NSArray *permissionsArray = @[ @"user_about_me", @"user_relationships", @"user_birthday", @"user_location"];
    
    // Login PFUser using facebook
    [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
        [self.loadingIndicator stopAnimating]; // Hide loading indicator
        
        if (!user) {
            if (!error) {
                NSLog(@"Uh oh. The user cancelled the Facebook login.");
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Log In Error" message:@"Uh oh. The user cancelled the Facebook login." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Dismiss", nil];
                [alert show];
            } else {
                NSLog(@"Uh oh. An error occurred: %@", error);
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Log In Error" message:[error description] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Dismiss", nil];
                [alert show];
            }
        } else if (user.isNew) {
            NSLog(@"User with facebook signed up and logged in!");
            [self.navigationController pushViewController:[[ViewController alloc] initWithNibName:@"ViewController" bundle:nil] animated:YES];
        } else {
            NSLog(@"User with facebook logged in!");
            [self.navigationController pushViewController:[[ViewController alloc] initWithNibName:@"ViewController" bundle:nil] animated:YES];
        }
    }];
    
    [self.loadingIndicator startAnimating]; // Show loading indicator until login is finished
}

@end
