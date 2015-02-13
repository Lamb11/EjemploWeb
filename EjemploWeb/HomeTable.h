//
//  ViewController.h
//  EjemploWeb
//
//  Created by Alberto Cordero Arellanes on 13/02/15.
//  Copyright (c) 2015 AlbertoCorderoArellanes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Accounts/Accounts.h>
#import <Social/Social.h>
#import <Twitter/Twitter.h>
@interface HomeTable : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *lblSelectedName;
- (IBAction)btnSharePressed:(id)sender;
- (IBAction)btnRefreshPressed:(id)sender;
@property (strong, nonatomic) IBOutlet UITableView *tblMain;

@end

