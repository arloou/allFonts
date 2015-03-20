//
//  ViewController.m
//  allFonts
//
//  Created by ucs on 15/1/19.
//  Copyright (c) 2015年 ucs. All rights reserved.
//

#import "ViewController.h"
#import "detailViewController.h"
#import "searchResultTableViewController.h"

@interface ViewController ()<UISearchControllerDelegate,UISearchResultsUpdating,ResultDelegate,UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong)UISearchController*searchController;
@property(nonatomic,strong)searchResultTableViewController*resultVC;
@property (strong, nonatomic) IBOutlet UIButton *upBtn;
@end

@implementation ViewController
{
    NSIndexPath * selectIndexPath;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"Fonts In iOS";
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.modalPresentationCapturesStatusBarAppearance = NO;
//    self.tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, MainWidth, Mainheight) style:UITableViewStylePlain];
//    [self.view addSubview:self.tableView];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    
    [self.view setBackgroundColor:[UIColor blackColor]];
    [self.tableView setBackgroundColor:[UIColor blackColor]];
    UIView * bgView=[[UIView alloc] initWithFrame:self.view.window.bounds];
    [bgView setBackgroundColor:[UIColor blackColor]];
    [self.tableView setBackgroundView:bgView];
//
    _resultVC=[self.storyboard instantiateViewControllerWithIdentifier:@"searchResultView"];
    _searchController=[[UISearchController alloc] initWithSearchResultsController:_resultVC];
    _searchController.delegate=self;
    self.searchController.searchResultsUpdater = self;
    [self.searchController.searchBar sizeToFit];
    self.searchController.searchBar.barTintColor=[UIColor blackColor];
    self.searchController.searchBar.tintColor=[UIColor whiteColor];
    self.searchController.searchBar.placeholder=@"search fonts";
    self.searchController.searchBar.keyboardAppearance=UIKeyboardAppearanceDark;
    self.searchController.searchBar.returnKeyType=UIReturnKeySearch;
    _resultVC.searchController=_searchController;
    _resultVC.delegate=self;
    self.tableView.tableHeaderView = self.searchController.searchBar;
    
    self.definesPresentationContext=YES;
    
    

    self.navigationController.navigationBar.barStyle=UIBarStyleBlackTranslucent;
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    [self.navigationController.navigationBar setBarTintColor:[UIColor clearColor]];
    
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    self.navigationItem.backBarButtonItem = backItem;
    backItem.title = @"";
    
    
    [self followScrollView:self.tableView];
    
    
    // 长按手势
    UILongPressGestureRecognizer*longPressGreRec=[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressCell:)];
    longPressGreRec.minimumPressDuration=1.0;
    longPressGreRec.delegate=self;
    [_tableView addGestureRecognizer:longPressGreRec];
}

-(void)longPressCell:(UILongPressGestureRecognizer*)longPress
{
    CGPoint p=[longPress locationInView:_tableView];
    
    NSIndexPath * indexPath=[_tableView indexPathForRowAtPoint:p];
    
    if (indexPath)
    {
        selectIndexPath=indexPath;
        UITableViewCell*cell=[_tableView cellForRowAtIndexPath:selectIndexPath];
        
        [cell becomeFirstResponder];
        
        UIMenuController*menuController=[UIMenuController sharedMenuController];
        UIMenuItem*item_copy=[[UIMenuItem alloc] initWithTitle:@"Copy font name" action:@selector(copyFontName:)];
        UIMenuItem*item_cancel=[[UIMenuItem alloc] initWithTitle:@"Cancel" action:@selector(nothing:)];
        [menuController setMenuItems:[NSArray arrayWithObjects:item_cancel, item_copy,nil]];
        
        [menuController setTargetRect:cell.frame inView:cell.superview];
        
        [menuController setMenuVisible:YES animated:YES];
    }
    
}

-(BOOL)canBecomeFirstResponder
{
    return YES;
}

-(void)nothing:(id)sender{}
// 复制字体名称
-(void)copyFontName:(id)sender
{
    NSString*fontName=[[UIFont fontNamesForFamilyName:[[UIFont familyNames] objectAtIndex:selectIndexPath.section]] objectAtIndex:selectIndexPath.row];
    
    UIPasteboard*pb=[UIPasteboard generalPasteboard];
    pb.string=fontName;
    [ProgressHUD showSuccess:@"Fonts name has copied to the pasteboard"];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_upBtn setHidden:YES];
}

-(IBAction)scrollToTop:(id)sender
{
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    [self showNavbar];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSMutableDictionary *textAttrs=[NSMutableDictionary dictionary];
    textAttrs[NSFontAttributeName]=[UIFont fontWithName:@"SavoyeLetPlain" size:22];
    textAttrs[NSForegroundColorAttributeName]=[UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:textAttrs];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y > 110) {
        if (_upBtn.hidden) {
            _upBtn.hidden = NO;
            [_upBtn setHidden:NO];
            _upBtn.alpha = .1;
            //            _upBtn.transform = CGAffineTransformMakeScale(0.1, 0.1);
            [UIView animateWithDuration:0.15 animations:^{
                _upBtn.alpha = 1.;
                //                _upBtn.transform = CGAffineTransformMakeScale(1.0, 1.0);
            } completion:^(BOOL finished) {
                
            }];
        }
    }else{
        if (_upBtn.hidden==NO) {
            _upBtn.hidden = YES;
            [UIView animateWithDuration:0.15 animations:^{
                _upBtn.alpha = .0;
            } completion:^(BOOL finished) {
                [_upBtn setHidden:YES];
                
            }];
            
        }
    }
}

#pragma mark - search bar delegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    [_resultVC displayWithSearchText:searchController.searchBar.text];
}
#pragma makr - Result Delegate
-(void)selectFontWithName:(NSString *)fontName
{
    int section = 0;
    int row = 0;
    
    for (int i=0; i<[UIFont familyNames].count; i++)
    {
        NSArray*fonts=[UIFont fontNamesForFamilyName:[[UIFont familyNames] objectAtIndex:i]];
        for (int j=0; j<fonts.count; j++)
        {
            if ([fonts[j] isEqualToString:fontName])
            {
                section=i;
                row=j;
            }
        }
    }
    
    NSIndexPath*indexPath=[NSIndexPath indexPathForRow:row inSection:section];
    
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    
}



#pragma mark - delegate tableView Delegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[UIFont familyNames] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[UIFont fontNamesForFamilyName:[[UIFont familyNames] objectAtIndex:section] ] count];
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView*headView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, MainWidth, 20)];
    [headView setBackgroundColor:[UIColor colorWithWhite:0.6 alpha:1]];
    UILabel*label=[[UILabel alloc] initWithFrame:CGRectMake(20, 0, headView.bounds.size.width-20, headView.bounds.size.height)];
    [label setBackgroundColor:[UIColor clearColor]];
    label.textColor=[UIColor whiteColor];
    label.textAlignment=NSTextAlignmentLeft;
    label.text=[[UIFont familyNames] objectAtIndex:section];
    [headView addSubview:label];
    return headView;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    return [[UIFont familyNames] objectAtIndex:section];
//}



- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
    return index;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    // Configure the cell.
    cell.textLabel.textColor =[UIColor blackColor];
    
    NSString *familyName= [[UIFont familyNames] objectAtIndex:indexPath.section];
    NSString *fontName  = [[UIFont fontNamesForFamilyName:[[UIFont familyNames] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    
    cell.textLabel.font = [UIFont fontWithName:fontName size:15.0f];
    
    if([fontName isEqualToString:@"MicrosoftYaHei"]) {
        NSLog(@"微软雅黑");
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@ - %@", familyName, fontName ];
    
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell*cell=[tableView cellForRowAtIndexPath:indexPath];
    NSString*fontName=cell.textLabel.font.fontName;
    cell.textLabel.font=[UIFont fontWithName:fontName size:20.0f];
}

-(void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell*cell=[tableView cellForRowAtIndexPath:indexPath];
    NSString*fontName=cell.textLabel.font.fontName;
    cell.textLabel.font=[UIFont fontWithName:fontName size:15.0f];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self showNavbar];
    detailViewController*vc=[self.storyboard instantiateViewControllerWithIdentifier:@"detailViewController"];
    vc.fontName= [[UIFont fontNamesForFamilyName:[[UIFont familyNames] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    vc.title=[[UIFont fontNamesForFamilyName:[[UIFont familyNames] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)touchDownAnimation:(UIButton *)sender {
    
    [UIView animateWithDuration:0.5 animations:^{
        sender.transform=CGAffineTransformScale(CGAffineTransformIdentity, 1.6, 1.6);
    } completion:^(BOOL finished) {
        sender.transform=CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
    }];
    
    
}




@end
