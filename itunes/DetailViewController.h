//
//  DetailViewController.h
//  itunes
//
//  Created by Martin Lloyd on 31/10/2015.
//  Copyright © 2015 Martin Lloyd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end

