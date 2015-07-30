//
//  DetailViewController.h
//  UIPopoverControllerDemo
//
//  Created by mac on 15/7/30.
//  Copyright (c) 2015年 com.liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end

