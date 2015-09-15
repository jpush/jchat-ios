
#import "JCHATUpdatePasswordCtl.h"
#import "JChatConstants.h"
#import <JMessage/JMessage.h>
#import "MBProgressHUD+Add.h"
#import "MBProgressHUD.h"
@interface JCHATUpdatePasswordCtl ()

@end

@implementation JCHATUpdatePasswordCtl

- (void)viewDidLoad {
    [super viewDidLoad];
  DDLogDebug(@"Action - viewDidLoad");
    UIButton *leftBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setFrame:CGRectMake(0, 0, 30, 30)];
    [leftBtn setImage:[UIImage imageNamed:@"login_15"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];//为导航栏添加左侧按钮
    self.title=@"修改密码";
    [self.pressBtn setBackgroundColor:[UIColor colorWithRed:96/255.0 green:209/255.0 blue:88/255.0 alpha:1]];
    self.pressBtn.layer.cornerRadius=4;
    self.pressBtn.layer.masksToBounds=YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.passwordField resignFirstResponder];
    [self.passwordFieldAgain resignFirstResponder];
}

- (IBAction)updatePasswordClick:(id)sender {
    if ([self.passwordField.text isEqualToString:@""]) {
        [MBProgressHUD showMessage:@"请输入密码!" view:self.view];
        return;
    }else if ([self.passwordFieldAgain.text isEqualToString:@""]){
        [MBProgressHUD showMessage:@"请确认密码!" view:self.view];
    }else if ([self.passwordField.text isEqualToString:@""] && [self.passwordFieldAgain.text isEqualToString:@""]) {
        [MBProgressHUD showMessage:@"请输入密码!" view:self.view];
    }else if ([self.passwordField.text isEqualToString:self.passwordFieldAgain.text]){
        [MBProgressHUD showMessage:@"正在修改" toView:self.view];
//        [JMSGUser updatePasswordWithNewPassword:self.passwordField.text oldPassword:user.password completionHandler:^(id resultObject, NSError *error) {
//            [MBProgressHUD hideHUDForView:self.view animated:YES];
//            if (error == nil) {
//                JPIMLog(@"更新密码成功");
//                [self.navigationController popViewControllerAnimated:YES];
//                [MBProgressHUD showMessage:@"更新密码成功" view:self.view];
//            } else {
//                JPIMLog(@"更新密码失败");
//                [MBProgressHUD showMessage:@"更新密码失败" view:self.view];
//            }
//        }];
      
      [JMSGUser updateMyPasswordWithNewPassword:self.passwordField.text oldPassword:self.oldpassword.text completionHandler:^(id resultObject, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

        if (error == nil) {
          JPIMLog(@"更新密码成功");
          [self.navigationController popViewControllerAnimated:YES];
          [MBProgressHUD showMessage:@"更新密码成功" view:self.view];
        } else {
          JPIMLog(@"更新密码失败");
          DDLogDebug(@"resultObject   %@       error %@",resultObject,error);
          [MBProgressHUD showMessage:@"更新密码失败" view:self.view];
        }
      }];
    }else {
      [MBProgressHUD showMessage:@"确认密码不一致!" view:self.view];
    }
}

- (void)backClick {
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
