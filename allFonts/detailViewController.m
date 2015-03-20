//
//  detailViewController.m
//  allFonts
//
//  Created by ucs on 15/1/19.
//  Copyright (c) 2015年 ucs. All rights reserved.
//

#import "detailViewController.h"
#import "ZTypewriteEffectLabel.h"

@interface detailViewController ()<UIGestureRecognizerDelegate>

@end

@implementation detailViewController
{
    ZTypewriteEffectLabel*label;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    NSMutableDictionary *textAttrs=[NSMutableDictionary dictionary];
    textAttrs[NSFontAttributeName]=[UIFont fontWithName:self.fontName size:15];
    textAttrs[NSForegroundColorAttributeName]=[UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:textAttrs];
    
    
    UIBarButtonItem*backBtn=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backToFontList)];
    self.navigationItem.leftBarButtonItem=backBtn;
    
    
    self.title=self.fontName;
    
    NSString*content=@"Hello,my name is LuZizheng,hahahr~this handbook is designed by me.hope it will give you a strong hand in your designing jobs, especially if UIDs.\n OK,now I will give you some tips how to use this app:\n First you can touch the this message double time to control this typing stop or start. you can hold on pressing the font you like, and one second later you can copy the font name. and ! You can also search font by some key words! Is it a simple thing? Is it amazing? Enjoy it!";
    
    
//    self.myScrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, MainWidth, Mainheight)];
//    [self.view addSubview:self.myScrollView];
    
    UIFont*contentFont=[UIFont fontWithName:self.fontName size:17];
    
    CGFloat contentLabelMaxW = MainWidth-40;
    CGRect labelRect= [content boundingRectWithSize:CGSizeMake(contentLabelMaxW, 9999) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:contentFont,NSFontAttributeName, nil] context:nil];
    label=[[ZTypewriteEffectLabel alloc] initWithFrame:CGRectMake(20, 20, MainWidth-40, labelRect.size.height)];
    label.tag=10;
    label.font=contentFont;
    label.text=content;
    label.textAlignment=NSTextAlignmentCenter;
    label.numberOfLines=0;
    label.lineBreakMode=NSLineBreakByWordWrapping;
    self.myScrollView.contentSize=CGSizeMake(MainWidth, labelRect.size.height+100);
    
    
    label.textColor=[UIColor clearColor];
    label.typewriteEffectColor = [UIColor blackColor];
    label.hasSound = YES;
    label.typewriteTimeInterval = 0.1;
    label.typewriteEffectBlock = ^{
        
        NSLog(@"done");
        
    };
    
    
    [self.myScrollView addSubview:label];
    
    // 长按手势
    UILongPressGestureRecognizer*longPressGreRec=[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressNav:)];
    longPressGreRec.minimumPressDuration=1.0;
    longPressGreRec.delegate=self;
    [self.view addGestureRecognizer:longPressGreRec];
    
    
    // 双击手势
    UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
    tap.numberOfTapsRequired=2;
    [self.view addGestureRecognizer:tap];
    
    
    [self followScrollView:self.myScrollView];
    
    // 1秒后开始打印
    [self performSelector:@selector(startOutPut) withObject:nil afterDelay:1];
}

// 双击
-(void)doubleTap:(UITapGestureRecognizer*)tap
{
    if (label.isTyping)
    {
        [label stop];
    }
    else
    {
        [label startTypewrite];
    }
}

// 长按
-(void)longPressNav:(UILongPressGestureRecognizer*)longpress
{
    [self.navigationController.navigationBar becomeFirstResponder];
    UIMenuController*menuController=[UIMenuController sharedMenuController];
    UIMenuItem*item_copy=[[UIMenuItem alloc] initWithTitle:@"Copy font name" action:@selector(copyFontName:)];
    UIMenuItem*item_cancel=[[UIMenuItem alloc] initWithTitle:@"Cancel" action:@selector(nothing:)];
    [menuController setMenuItems:[NSArray arrayWithObjects:item_cancel, item_copy,nil]];
    [menuController setTargetRect:self.navigationController.navigationBar.frame inView:self.navigationController.navigationBar.superview];
    [menuController setArrowDirection:UIMenuControllerArrowUp];
    [menuController setMenuVisible:YES animated:YES];
    
}

-(BOOL)canBecomeFirstResponder
{
    return YES;
}


-(void)copyFontName:(id)sender
{
    UIPasteboard*pb=[UIPasteboard generalPasteboard];
    pb.string=self.title;
    [ProgressHUD showSuccess:@"Fonts name has copied to the pasteboard"];
}

-(void)nothing:(id)sender{}


-(void)startOutPut
{
    [label startTypewrite];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}

-(void)backToFontList
{
    NSLog(@"后退");
    [label stop];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
