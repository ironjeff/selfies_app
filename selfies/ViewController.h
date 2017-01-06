//
//  ViewController.h
//  selfies
//
//  Created by Jeff Huang on 12/11/13.
//  Copyright (c) 2013 Jeff Huang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) IBOutlet UIButton *takeSelfieButton;
@property (strong, nonatomic) IBOutlet UIImageView *imageDisplay;

- (IBAction)takePhoto:(id)sender;
- (IBAction)debugClick:(UIButton *)sender;


@end
