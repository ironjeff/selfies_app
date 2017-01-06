//
//  LoginViewController.h
//  selfies
//
//  Created by Jeff Huang on 12/11/13.
//  Copyright (c) 2013 Jeff Huang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController

@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;

- (IBAction)loginButtonClick:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *loginButton;

@end
