//
//  detailViewController.h
//  allFonts
//
//  Created by ucs on 15/1/19.
//  Copyright (c) 2015年 ucs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface detailViewController : AMScrollingNavbarViewController

@property (strong, nonatomic)IBOutlet UIScrollView *myScrollView;

@property(nonatomic,copy)NSString*fontName;

@end
