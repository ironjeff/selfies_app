//
//  ViewController.m
//  selfies
//
//  Created by Jeff Huang on 12/11/13.
//  Copyright (c) 2013 Jeff Huang. All rights reserved.
//

#import <Parse/Parse.h>
#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.takeSelfieButton.layer.cornerRadius = 8;
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
              message:@"Device is not capable of taking selfies :("
             delegate:nil
            cancelButtonTitle:@"OK"
            otherButtonTitles: nil];
        
        [myAlertView show];
        
    }
    
    [self showCamera];
}

- (void)showCamera
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
    
    
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)takePhoto:(UIButton *)sender {
    
    [self showCamera];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.imageDisplay.image = chosenImage;

    [picker dismissViewControllerAnimated:YES completion:NULL];

    // TODO This reauth is broken if you do it multiple times...
    
    NSLog(@"Checking in! %@ %@", FBSession.activeSession.permissions, [PFFacebookUtils session].permissions);
    
    if ([FBSession.activeSession.permissions
         indexOfObject:@"publish_actions"] == NSNotFound) {
        
        [FBSession.activeSession
         requestNewPublishPermissions:[NSArray arrayWithObject:@"publish_actions"]
         defaultAudience:FBSessionDefaultAudienceOnlyMe
         completionHandler:^(FBSession *session, NSError *error) {
             NSLog(@"did this ever get hit? %@", session.permissions);
             if (!error) {
                 // re-call assuming we now have the permission
                 [self imagePickerController:picker didFinishPickingMediaWithInfo:info];
             }
         }];
    } else {
        NSLog(@"Publishing photo");
        
        // Upload photo to fb
        FBRequestConnection *connection = [[FBRequestConnection alloc] init];
        FBRequest *request1 = [FBRequest
                               requestForUploadPhoto:chosenImage];
        
        // TODO fetch user's profile pic album
        // TODO make this actually upload to that album and not the app's photos album
        [[request1 parameters] setValue:@"10100136846275773" forKey:@"target"];
        [[request1 parameters] setValue:@"1" forKey:@"is_selfie"];
        [[request1 parameters] setValue:@"1" forKey:@"selfie_expiration"];
        
        [connection addRequest:request1
             completionHandler:
         ^(FBRequestConnection *connection, id result, NSError *error) {
             NSString* uploadedPhotoID;
             
             if (error) {
                 NSLog(@"Error uploading photo!%@", error.userInfo);
             } else {
                 NSLog(@"Photo uploaded successfully! %@", result);
                 //             FBGraphObject *fbGraph = (FBGraphObject*) result;
                 //             NSLog(@"Graph object? %@", [fbGraph graphObject]);
                 
                 uploadedPhotoID = [result objectForKey:@"id"];
                 NSLog(@"result id %@", uploadedPhotoID);
                 
             }
             
             NSLog(@"uploaded photo id %@", uploadedPhotoID);
             
             // Send the second request to set the photo as a selfie (must be done as a separate call)
             if (uploadedPhotoID) {
                 FBRequestConnection *connection2 = [[FBRequestConnection alloc] init];
                 
                 NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
                 [params setObject:@"10100136846275773" forKey:@"target"];
                 [params setObject:@"1" forKey:@"is_selfie"];
                 [params setObject:@"1" forKey:@"selfie_expiration"];
                 
                 FBRequest *request2 = [[FBRequest alloc] initWithSession:[PFFacebookUtils session]
                                                                graphPath:uploadedPhotoID
                                                               parameters:params HTTPMethod:@"POST"];
                 
                 [connection2 addRequest:request2
                       completionHandler:
                  ^(FBRequestConnection *connection2, id result, NSError *error) {
                      if (error) {
                          NSLog(@"Error in photo post! %@", error.userInfo);
                      } else {
                          NSLog(@"Photo post success! %@", result);
                      }
                  }
                          batchEntryName:@"photopost"
                  ];
                 
                 [connection2 start];
             }
             
             
             
         }
                batchEntryName:@"photopost"
         ];
        
        [connection start];
        
    }

}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (IBAction)debugClick:(UIButton *)sender {
    
    NSLog(@"Permissions %@", [[PFFacebookUtils session] permissions]);
//    // Debug crap to send GraphAPI calls
//    FBRequestConnection *connection2 = [[FBRequestConnection alloc] init];
//
//    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
//    [params setObject:@"1" forKey:@"is_selfie"];
//    [params setObject:@"1" forKey:@"selfie_expiration"];
//
//    FBRequest *request2 = [[FBRequest alloc] initWithSession:[PFFacebookUtils session]
//                                                   graphPath:@"10102693781177733"
//                                                  parameters:params HTTPMethod:@"POST"];
//    
//    [connection2 addRequest:request2
//          completionHandler:
//     ^(FBRequestConnection *connection2, id result, NSError *error) {
//         if (error) {
//             NSLog(@"Error in connection 2!");
//         }
//     }
//             batchEntryName:@"photopost"
//     ];
//    
//    [connection2 start];
}



@end
