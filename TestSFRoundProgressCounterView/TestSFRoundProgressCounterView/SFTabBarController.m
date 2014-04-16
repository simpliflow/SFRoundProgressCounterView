//
//  SFTabBarController.m
//  TestSFRoundProgressCounterView
//
//  Created by Thomas Winkler on 23/01/14.
//  Copyright (c) 2014 Simpliflow. All rights reserved.
//

#import "SFTabBarController.h"
#import "ViewController.h"

@interface SFTabBarController ()

@end

@implementation SFTabBarController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    
    self.delegate = self;
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    if ([item.title isEqualToString:@"Default"]) {
        
        ViewController* controller = self.viewControllers[0];
        NSNumber* singleValue = [NSNumber numberWithLong:5000];
        controller.intervals = @[singleValue];
        controller.color = nil;

    } else if ([item.title isEqualToString:@"Color"]) {
        
        ViewController* controller = self.viewControllers[1];
        NSNumber* singleValue = [NSNumber numberWithLong:120 * 1000];
        controller.intervals = @[singleValue];
        controller.color = [UIColor colorWithRed:0.4 green:0.6863 blue:0.4 alpha:1];
        controller.bgColor = [UIColor colorWithRed:237.f/255.f green:237.f/255.f blue:237.f/255.f alpha:1.0];
        
    } else if ([item.title isEqualToString:@"Intervals"]) {
        
        ViewController* controller = self.viewControllers[2];
        NSNumber* interval5 = [NSNumber numberWithLong:5000];
        NSNumber* interval10 = [NSNumber numberWithLong:10000];
        controller.intervals = @[interval5, interval10, interval5];
        controller.color = nil;
    }
}

@end
