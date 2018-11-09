//
//  MLBasicUserInfoViewController.m
//  meyley
//
//  Created by chsasaw on 2017/2/26.
//  Copyright © 2017年 Meyley. All rights reserved.
//

#import "MLBasicUserInfoViewController.h"
#import "HXSUserInfo.h"
#import "HXSUserAccount.h"
#import "HXSUserBasicInfo.h"
#import "UIImageView+WebCache.h"
#import "AppDelegate.h"
#import "TYAlertController.h"
#import "TYAlertView.h"
#import "HXSPersonalInfoModel.h"
#import "MBProgressHUD+HXS.h"
#import "TZImagePickerController.h"
#import "Masonry.h"

#import "LGPhoneLoginViewController.h"

@interface MLBasicUserInfoViewController ()<UITableViewDelegate, UITableViewDataSource, TZImagePickerControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@end

@implementation MLBasicUserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"修改资料";
    
    self.tableView.backgroundColor = [UIColor clearColor];
    
    [[HXSUserAccount currentAccount].userInfo updateUserInfo];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userInfoUpdated:) name:kUserInfoUpdated object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)userInfoUpdated:(NSNotification *)noti {
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? 5 : 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0 && indexPath.row == 0) {
        return 80;
    }else {
        return 48;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HXSUserBasicInfo *basicInfo = [HXSUserAccount currentAccount].userInfo.basicInfo;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NormalCell"];
    if(indexPath.section == 0) {
        if(indexPath.row == 0) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"HeadCell"];
            UIImageView *imageView = [cell viewWithTag:101];
            [imageView sd_setImageWithURL:[NSURL URLWithString:basicInfo.headPic] placeholderImage:[UIImage imageNamed:@"dsfdl-tx"]];
            imageView.layer.masksToBounds = YES;
            imageView.layer.cornerRadius = imageView.frame.size.width * 0.5;
        }else if(indexPath.row == 1) {
            cell.textLabel.text = @"昵称";
            cell.detailTextLabel.text = basicInfo.userName;
        }else if(indexPath.row == 2) {
            cell.textLabel.text = @"性别";
            cell.detailTextLabel.text = basicInfo.sex ? (basicInfo.sex.integerValue == 0 ? @"男":@"女") : @"保密";
        }else if (indexPath.row == 3) {
            cell.textLabel.text = [NSString stringWithFormat:@"我的手机 %@",basicInfo.mobile];
            cell.detailTextLabel.text = @"更换手机";
        }else {
            cell.textLabel.text = @"个性签名";
            cell.detailTextLabel.text = basicInfo.signature;
        }
    }else {
        if(indexPath.row == 0) {
            cell.textLabel.text = @"绑定微博";
            cell.detailTextLabel.text = @"未绑定";
        }else if(indexPath.row == 1) {
            cell.textLabel.text = @"绑定QQ";
            cell.detailTextLabel.text = @"未绑定";
        }else if(indexPath.row == 2) {
            cell.textLabel.text = @"绑定微信";
            cell.detailTextLabel.text = @"未绑定";
        }
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if(indexPath.section == 0) {
        if(indexPath.row == 0) {
            [self selectImage];
        }else if(indexPath.row == 1) {
            [self showAlertTextFieldWithTitle:@"修改昵称" message:nil palceholderText:@"好的昵称有助于你独步江湖哦" tips:@"每年最多可更改2次，后台审核才会更新" complete:^(BOOL success, NSString *text) {
                if(text.containsEmoji) {
                    [MBProgressHUD showInViewWithoutIndicator:self.view status:@"昵称不能包含Emoji字符" afterDelay:2];
                    
                    return;
                }
                if(text.length > 0) {
                    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                    cell.detailTextLabel.text = text;
                    [self saveUserName:text sex:nil birthday:nil signature:nil headPortrait:nil];
                }
            }];
        }else if(indexPath.row == 2) {
            HXSUserBasicInfo *basicInfo = [HXSUserAccount currentAccount].userInfo.basicInfo;
            if(basicInfo.sex == nil) {
                [self showSelectSexAlert];
            }else {
                [self showAlertWithTitle:@"" message:@"性别不可更改" confirmTitile:@"确定" cancelTitle:nil complete:nil];
            }
        }else if (indexPath.row == 3) {
            LGPhoneLoginViewController *loginVC = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:@"LGPhoneLoginViewController"];
            loginVC.hidesBottomBarWhenPushed = YES;
            loginVC.type = LGInterfaceTypeModify;
            [self.navigationController pushViewController:loginVC animated:YES];
        }else {
            [self showAlertTextFieldWithTitle:@"修改个性签名" message:nil palceholderText:@"据古书记载，个性签名一定要够拉风哦" tips:nil complete:^(BOOL success, NSString *text) {
//                if(text.containsEmoji) {
//                    [MBProgressHUD showInViewWithoutIndicator:self.view status:@"个性签名不能包含Emoji字符" afterDelay:2];
//                    
//                    return;
//                }
                
                if(text.length > 0) {
                    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                    cell.detailTextLabel.text = text;
                    [self saveUserName:nil sex:nil birthday:nil signature:text headPortrait:nil];
                }
            }];
        }
    }else {
        //do nothing
    }
}

- (IBAction)logout:(id)sender {

    [[HXSUserAccount currentAccount] logout];
    [AppDelegate sharedDelegate].rootViewController.selectedIndex = 0;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showSelectSexAlert {
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"选择性别" message:@"选择后不可修改" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [controller addAction:cancelAction];
    
    UIAlertAction *nanAction = [UIAlertAction actionWithTitle:@"男" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [controller addAction:nanAction];
    UIAlertAction *nvAction = [UIAlertAction actionWithTitle:@"女" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [controller addAction:nvAction];
    
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)selectSex:(NSNumber *)sex {
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    cell.detailTextLabel.text = sex.integerValue == 0 ? @"男" : @"女";
    [self saveUserName:nil sex:sex birthday:nil signature:nil headPortrait:nil];
}

- (void)showAlertWithTitle:(NSString *)title
                   message:(NSString *)message
             confirmTitile:(NSString *)confirm
               cancelTitle:(NSString *)cancel
                  complete:(void (^)(BOOL cancel))complete {
    TYAlertView *alertView = [TYAlertView alertViewWithTitle:title message:message];
    alertView.layer.masksToBounds = YES;
    alertView.layer.cornerRadius = 5;
    alertView.buttonContentViewEdge = 0;
    alertView.buttonSpace = 0;
    alertView.buttonCornerRadius = 0;
    alertView.buttonDefaultBgColor = ML_ACCENT_COLOR;
    alertView.buttonDefaultTextColor = [UIColor whiteColor];
    alertView.buttonCancelBgColor = UIColorFromRGB(0xF7F7F7);
    alertView.buttonCancelTextColor = UIColorFromRGB(0x6e6e6e);
    
    if(cancel.length > 0) {
        [alertView addAction:[TYAlertAction actionWithTitle:cancel style:TYAlertActionStyleCancel handler:^(TYAlertAction *action) {
            if(complete) {
                complete(YES);
            }
        }]];
    }
    
    if(confirm.length > 0) {
        [alertView addAction:[TYAlertAction actionWithTitle:confirm style:TYAlertActionStyleDefault handler:^(TYAlertAction *action) {
            if(complete) {
                complete(NO);
            }
        }]];
    }
    
    // first way to show
    TYAlertController *alertController = [TYAlertController alertControllerWithAlertView:alertView preferredStyle:TYAlertControllerStyleAlert];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)showAlertTextFieldWithTitle:(NSString *)title
                            message:(NSString *)message
                    palceholderText:(NSString *)placeholder
                               tips:(NSString *)tips
                           complete:(void (^)(BOOL success, NSString *))complete {
    TYAlertView *alertView = [TYAlertView alertViewWithTitle:title message:message];
    alertView.layer.masksToBounds = YES;
    alertView.layer.cornerRadius = 5;
    alertView.buttonContentViewEdge = 0;
    alertView.buttonSpace = 0;
    alertView.buttonCornerRadius = 0;
    alertView.buttonDefaultBgColor = ML_ACCENT_COLOR;
    alertView.buttonDefaultTextColor = [UIColor whiteColor];
    alertView.buttonCancelBgColor = UIColorFromRGB(0xF7F7F7);
    alertView.buttonCancelTextColor = UIColorFromRGB(0x6e6e6e);
    
    [alertView addAction:[TYAlertAction actionWithTitle:@"取消" style:TYAlertActionStyleCancel handler:^(TYAlertAction *action) {
        complete(NO, nil);
    }]];
    
    __typeof (alertView) __weak weakAlertView = alertView;
    [alertView addAction:[TYAlertAction actionWithTitle:@"保存" style:TYAlertActionStyleDefault handler:^(TYAlertAction *action) {
        UITextField *textField = weakAlertView.textFieldArray[0];
        complete(YES, textField.text);
    }]];
    
    [alertView addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = placeholder;
        
        if(tips.length > 0) {
            UILabel *tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 220, 20)];
            tipsLabel.text = tips;
            tipsLabel.textColor = UIColorFromRGB(0x6e6e6e);
            tipsLabel.font = [UIFont systemFontOfSize:12];
            [textField.superview.superview addSubview:tipsLabel];
            
            [tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(textField.superview.mas_bottom).offset(5);
                make.left.equalTo(textField.superview.mas_left);
            }];
            
            [tipsLabel layoutSubviews];
        }
    }];
    
    // first way to show
    TYAlertController *alertController = [TYAlertController alertControllerWithAlertView:alertView preferredStyle:TYAlertControllerStyleAlert];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - select image
- (void)selectImage {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"去相册查找" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        TZImagePickerController *controller = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
        controller.sortAscendingByModificationDate = NO;
        controller.allowPickingOriginalPhoto = NO;
        controller.allowCrop = YES;
        controller.showSelectBtn = NO;
        controller.takePictureImageName = @"takePhoto";
        [self presentViewController:controller animated:YES completion:nil];
    }];
    
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"打开相机拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            UIImagePickerController *picker = [[UIImagePickerController alloc]init];
            picker.delegate = self;
            picker.allowsEditing = YES;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:picker animated:YES completion:nil];
        }
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    
    [alert addAction:photoAction];
    [alert addAction:cameraAction];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - TZImagePickerControllerDelegate
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    if(photos.count > 0) {
        UIImage *selectedImage = photos[0];
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        UIImageView *imageView = [cell viewWithTag:101];
        imageView.image = selectedImage;
        
        [self saveUserName:nil sex:nil birthday:nil signature:nil headPortrait:selectedImage];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(nonnull NSDictionary<NSString *,id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *editedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    UIImageView *imageView = [cell viewWithTag:101];
    imageView.image = editedImage;
    
    [self saveUserName:nil sex:nil birthday:nil signature:nil headPortrait:editedImage];
}

- (void)saveUserName:(NSString *)nickNameStr sex:(NSNumber *)sex birthday:(NSString *)birthday signature:(NSString *)signature headPortrait:(UIImage *)headPortrait {
    [MBProgressHUD showInView:self.view];
    [HXSPersonalInfoModel updateUserName:nickNameStr sex:sex birthday:birthday signature:signature headPortrait:headPortrait complete:^(HXSErrorCode code, NSString *message, NSDictionary *nickNameDic) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if(code != kHXSNoError) {
            [MBProgressHUD showInViewWithoutIndicator:self.view status:message afterDelay:1.5];
        }
        
        [[HXSUserAccount currentAccount].userInfo updateUserInfo];
    }];
}

@end
