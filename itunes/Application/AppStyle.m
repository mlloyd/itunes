//
//  AppStyle.m
//  itunes
//
//  Created by Martin Lloyd on 31/10/2015.
//  Copyright © 2015 Martin Lloyd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppStyle.h"

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
@implementation AppStyle

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
+ (void)applyAppStyle
{
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
#pragma GCC diagnostic pop
    
    [[UINavigationBar appearance] setBarTintColor:[AppStyle purple]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
//    [[UISearchBar     appearance] setBarTintColor:[AppStyle purple]];
//    [[UISearchBar     appearance] setBackgroundImage:[[UIImage alloc] init]];
//    [[UISearchBar     appearance] setBackgroundColor:[AppStyle purple]];
    
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
}

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
+ (UIColor *)purple
{
    return [UIColor colorWithRed:0.47 green:0.53 blue:0.60 alpha:1.0];
}

@end
