//
//  JCHATDebugViewController.m
//  JChat
//
//  Created by HuminiOS on 15/10/29.
//  Copyright © 2015年 HXHG. All rights reserved.
//

#import "JCHATDebugViewController.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+Add.h"

@interface JCHATDebugViewController ()
@property (weak, nonatomic) IBOutlet UISwitch *isDebugMode;

@property (weak, nonatomic) IBOutlet UITextField *sisAddress;
@property (weak, nonatomic) IBOutlet UITextField *sisport;
@property (weak, nonatomic) IBOutlet UITextField *connectAddress;
@property (weak, nonatomic) IBOutlet UITextField *connectPort;
@property (weak, nonatomic) IBOutlet UITextField *reportAddress;
@property (weak, nonatomic) IBOutlet UITextField *userAddress;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *thelastTF_y;


@property (strong, nonatomic)NSString *plistPath;
@property (strong, nonatomic)NSMutableDictionary *configDic;
@property (strong,nonatomic)UIButton *rightBarButton;
@end

@implementation JCHATDebugViewController

- (void)clickToSave {

  if (![_sisAddress.text isEqualToString:@""])[[NSUserDefaults standardUserDefaults] setObject:_sisAddress.text forKey:_sisAddress.placeholder];
  if (![_sisport.text isEqualToString:@""])[[NSUserDefaults standardUserDefaults] setObject:[self converToNumberWithString:_sisport.text] forKey:_sisport.placeholder];
  if (![_connectAddress.text isEqualToString:@""])[[NSUserDefaults standardUserDefaults] setObject:_connectAddress.text forKey:_connectAddress.placeholder];
  if (![_connectPort.text isEqualToString:@""])[[NSUserDefaults standardUserDefaults] setObject:[self converToNumberWithString:_connectPort.text] forKey:_connectPort.placeholder];
  if (![_reportAddress.text isEqualToString:@""])[[NSUserDefaults standardUserDefaults] setObject:_reportAddress.text forKey:_reportAddress.placeholder];
  if (![_userAddress.text isEqualToString:@""])[[NSUserDefaults standardUserDefaults] setObject:_userAddress.text forKey:_userAddress.placeholder];
  
  [self performSelector:@selector(crashApp) withObject:nil afterDelay:1];
}

- (void)crashApp {
  NSArray *arr = @[];
  NSLog(@"%@",arr[1]);
}

- (IBAction)debugModeChange:(id)sender {
  if (((UISwitch *)sender).on) {
    [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:@"isDebugMode"];
  } else {
    [[NSUserDefaults standardUserDefaults] setObject:@(NO) forKey:@"isDebugMode"];
  }
}

- (NSNumber *)converToNumberWithString:(NSString *)theString {
  NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
  [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
  NSNumber *numTemp = [numberFormatter numberFromString:theString];
  return numTemp;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
  [_sisAddress resignFirstResponder];
  [_sisport resignFirstResponder];
  [_connectAddress resignFirstResponder];
  [_connectPort resignFirstResponder];
  
  [_reportAddress resignFirstResponder];
  [_userAddress resignFirstResponder];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.navigationController.navigationBar.translucent = NO;
  
  _rightBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
  [_rightBarButton setFrame:CGRectMake(0, 0, 50, 30)];
  [_rightBarButton addTarget:self action:@selector(clickToSave) forControlEvents:UIControlEventTouchUpInside];
  _rightBarButton.titleLabel.text = @"保持";
  [_rightBarButton setTitle:@"保存" forState:UIControlStateNormal];
  [_rightBarButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_rightBarButton];
  
  
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(inputKeyboardWillShow:)
   
                                               name:UIKeyboardWillShowNotification
                                             object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(inputKeyboardWillHide:)
                                               name:UIKeyboardWillHideNotification
                                             object:nil];
  
  
  _sisAddress.text = [[NSUserDefaults standardUserDefaults] objectForKey:_sisAddress.placeholder];
  _sisport.text = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:_sisport.placeholder]];
  _connectAddress.text = [[NSUserDefaults standardUserDefaults] objectForKey:_connectAddress.placeholder];
  _connectPort.text = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:_connectPort.placeholder]];
  
  _reportAddress.text = [[NSUserDefaults standardUserDefaults] objectForKey:_reportAddress.placeholder];
  _userAddress.text = [[NSUserDefaults standardUserDefaults] objectForKey:_userAddress.placeholder];
  NSNumber *isOn = [[NSUserDefaults standardUserDefaults] objectForKey:@"isDebugMode"];
  _isDebugMode.on = [isOn boolValue];
}

- (void)inputKeyboardWillShow:(NSNotification *)notification{
  _thelastTF_y.constant = 200;
}

- (void)inputKeyboardWillHide:(NSNotification *)notification {
  _thelastTF_y.constant = 310;
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
