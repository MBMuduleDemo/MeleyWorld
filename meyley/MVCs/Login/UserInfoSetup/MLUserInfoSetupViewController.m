//
//  MLUserInfoSetupViewController.m
//  meyley
//
//  Created by chsasaw on 2017/2/25.
//  Copyright © 2017年 Meyley. All rights reserved.
//

#import "MLUserInfoSetupViewController.h"
#import "RadioButton.h"
#import "TZImagePickerController.h"
#import "MBProgressHUD+HXS.h"
#import "HXSPersonalInfoModel.h"
#import "Masonry.h"

@interface MLUserInfoSetupViewController ()<UITextFieldDelegate, TZImagePickerControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, weak) IBOutlet UIImageView *headImageView;
@property (nonatomic, weak) IBOutlet UITextField *userNameTextField;

@property (nonatomic, weak) IBOutlet RadioButton *baomiButton;
@property (nonatomic, weak) IBOutlet RadioButton *nanButton;
@property (nonatomic, weak) IBOutlet RadioButton *nvButton;

@property (nonatomic, weak) IBOutlet UITextField *birthdayTextField;

@property (nonatomic, strong) UIImage *selectedImage;

@end

@implementation MLUserInfoSetupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectImage)];
    tap.numberOfTouchesRequired = 1;
    tap.numberOfTapsRequired = 1;
    [self.headImageView addGestureRecognizer:tap];
    self.headImageView.userInteractionEnabled = YES;
    
    self.birthdayTextField.delegate = self;
    self.birthdayTextField.returnKeyType = UIReturnKeyDone;
    
    self.userNameTextField.delegate = self;
    self.userNameTextField.returnKeyType = UIReturnKeyDone;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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

- (IBAction)onClickConfirm:(id)sender {
    if(self.selectedImage == nil) {
        [MBProgressHUD showInViewWithoutIndicator:self.view status:@"请选择头像！" afterDelay:1.5];
        
        return;
    }
    
    if(self.userNameTextField.text.length == 0) {
        [MBProgressHUD showInViewWithoutIndicator:self.view status:@"请输入昵称！" afterDelay:1.5];
        
        return;
    }
    
    if([self.userNameTextField.text containsEmoji]) {
        [MBProgressHUD showInViewWithoutIndicator:self.view status:@"昵称不可以包含表情符号！" afterDelay:1.5];
        
        return;
    }
    
    [HXSPersonalInfoModel updateUserName:self.userNameTextField.text sex:@(self.baomiButton.selectedButton.tag) birthday:self.birthdayTextField.text signature:@"" headPortrait:self.selectedImage complete:^(HXSErrorCode code, NSString *message, NSDictionary *nickNameDic) {
        if(code == kHXSNoError) {
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            [[HXSUserAccount currentAccount].userInfo updateUserInfo];
        }else {
            [MBProgressHUD showInViewWithoutIndicator:self.view status:message afterDelay:1.5];
        }
    }];
}

#pragma mark - UITextFieldDelegate
- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField {
    if(textField == self.birthdayTextField) {
        [self showDatePick];
        
        return NO;
    }
    
    return YES;
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    return YES;
}

#pragma mark - TZImagePickerControllerDelegate
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    if(photos.count > 0) {
        UIImage *selectedImage = photos[0];
        self.headImageView.image = selectedImage;
        self.selectedImage = selectedImage;
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(nonnull NSDictionary<NSString *,id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *editedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    self.headImageView.image = editedImage;
    self.selectedImage = editedImage;
}

#pragma mark - date picker
- (void)showDatePick {
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    datePicker.datePickerMode = UIDatePickerModeDate;
    datePicker.maximumDate = [NSDate date];
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    dateFormat.timeZone = [NSTimeZone localTimeZone];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];//设定时间格式
    datePicker.minimumDate = [dateFormat dateFromString:@"1900-01-01"];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"\n\n\n\n\n\n\n\n\n\n" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alert.view addSubview:datePicker];
    alert.view.layer.masksToBounds = YES;
    [alert.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(datePicker.mas_centerX);
        make.width.equalTo(datePicker.mas_width);
    }];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
        dateFormat.timeZone = [NSTimeZone localTimeZone];
        [dateFormat setDateFormat:@"yyyy-MM-dd"];//设定时间格式
        
        NSString *dateString = [dateFormat stringFromDate:datePicker.date];
        
        self.birthdayTextField.text = dateString;
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:ok];//添加按钮
    
    [alert addAction:cancel];//添加按钮
    
    [self presentViewController:alert animated:YES completion:nil];
}

@end
