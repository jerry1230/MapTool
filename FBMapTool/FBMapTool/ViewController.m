//
//  ViewController.m
//  FBMapTool
//
//  Created by Bird on 14/12/30.
//  Copyright (c) 2014年 flyingbird. All rights reserved.
//

#import "ViewController.h"
#import "FBMacro.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *radiusTF;

@property (weak, nonatomic) IBOutlet UITextField *deviationTF;

- (IBAction)trackAction:(id)sender;




@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
//Test
    


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
# pragma mark -
# pragma mark - Action
- (IBAction)trackAction:(id)sender
{
    if ([self.radiusTF.text intValue]>40000)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您输入的距离太远，请重新输入！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_DATAOK object:self.radiusTF.text];
    }
}
@end
