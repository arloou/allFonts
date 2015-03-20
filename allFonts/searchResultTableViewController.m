//
//  searchResultTableViewController.m
//  allFonts
//
//  Created by ucs on 15/1/30.
//  Copyright (c) 2015年 ucs. All rights reserved.
//

#import "searchResultTableViewController.h"

@interface searchResultTableViewController ()
@property(nonatomic,strong)NSMutableArray*displayFontArr;
@property(nonatomic,strong)NSMutableArray*allFontArr;
@end

@implementation searchResultTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _displayFontArr=[NSMutableArray array];
    _allFontArr=[NSMutableArray array];
    
    
    
    for (int i=0; i<[UIFont familyNames].count; i++)
    {
        NSArray*fonts=[UIFont fontNamesForFamilyName:[[UIFont familyNames] objectAtIndex:i]];
        for (int j=0; j<fonts.count; j++)
        {
            [_allFontArr addObject:[fonts objectAtIndex:j]];
        }
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


-(void)displayWithSearchText:(NSString*)searchText
{
    [_displayFontArr removeAllObjects];
    
    //NSPredicate*predicate = [NSPredicate predicateWithFormat:@"name CONTAINS '%@'",searchText];
    for (NSString*fontName in _allFontArr)
    {
        if ([[fontName lowercaseString] containsString:[searchText lowercaseString]])
        {
            [_displayFontArr addObject:fontName];
        }
    }
    
    
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _displayFontArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.textColor =[UIColor blackColor];
    cell.textLabel.text=[_displayFontArr objectAtIndex:indexPath.row];
    cell.textLabel.font=[UIFont fontWithName:[_displayFontArr objectAtIndex:indexPath.row] size:15];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate selectFontWithName:[_displayFontArr objectAtIndex:indexPath.row]];
    [_searchController setActive:NO];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
