//
//  searchResultTableViewController.h
//  allFonts
//
//  Created by ucs on 15/1/30.
//  Copyright (c) 2015年 ucs. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ResultDelegate <NSObject>

@required
-(void)selectFontWithName:(NSString*)fontName;
@end

@interface searchResultTableViewController : UITableViewController

@property(nonatomic,strong)UISearchController*searchController;
@property(nonatomic,weak)id<ResultDelegate>delegate;

-(void)displayWithSearchText:(NSString*)searchText;
@end
 