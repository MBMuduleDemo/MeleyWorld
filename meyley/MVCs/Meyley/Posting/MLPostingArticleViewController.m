//
//  MLPostingArticleViewController.m
//  meyley
//
//  Created by chsasaw on 2017/3/31.
//  Copyright © 2017年 Meyley. All rights reserved.
//

#import "MLPostingArticleViewController.h"
#import "TZImagePickerController.h"
#import "WKWebViewController.h"
#import "HXSCommunityPostingModel.h"
#import "MLPostArticleParamEntity.h"
#import "HXSUserAccount.h"
#import "HXSCommunityDetailViewController.h"
#import "NSData+HXSPrintDataMD5.h"
#import "HXSPost.h"
#import "IQKeyboardManager.h"

static NSString *const textViewPlaceholdStr = @"请输入内容";

@interface MLPostingArticleViewController ()<UITextFieldDelegate, UITextViewDelegate, TZImagePickerControllerDelegate>

/** 右上角提交按钮 */
@property (nonatomic ,strong   ) UIBarButtonItem                *postBarButton;
/** 左上角回退按钮 */
@property (nonatomic ,strong   ) UIBarButtonItem                *leftBackBarButton;

@property (strong, nonatomic) IBOutlet UIImageView *coverImageView;
/** 输入标题 */
@property (strong, nonatomic) IBOutlet UITextField  *titleTextField;
@property (strong, nonatomic) IBOutlet UILabel *titleLimitLabel;
/** 输入链接 */
@property (strong, nonatomic) IBOutlet UITextField  *linkTextField;

/** 输入内容 */
@property (strong, nonatomic) IBOutlet UITextView  *contentTextView;
@property (strong, nonatomic) IBOutlet UILabel *contentLimitLabel;

@property (nonatomic, strong) HXSCommunityPostingModel       *postModel;
@property (nonatomic, strong) MLPostArticleParamEntity  *paramEntity;

@end

#define kMaxTitleLengthTextField 32
#define kMaxContentLengthTextView 2000

@implementation MLPostingArticleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [self initialNavigation];
    [self initInputNotify];
    [self initViews];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [IQKeyboardManager sharedManager].enable = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:@"UITextViewTextDidChangeNotification"
                                                 object:_titleTextField];
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:@"UITextViewTextDidChangeNotification"
                                                 object:_linkTextField];
}

#pragma mark - init

- (void)initialNavigation
{
    [self.navigationItem setTitle:@"编辑文章内容"];
    [self.navigationItem setRightBarButtonItem:self.postBarButton];
    [self.navigationItem setLeftBarButtonItem:self.leftBackBarButton];
}

- (void)initViews {
    self.linkTextField.delegate = self;
    self.titleTextField.delegate = self;
    self.contentTextView.delegate = self;
}

/**
 *  增加对键盘输入的监听
 */
- (void)initInputNotify
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)
                                                name:@"UITextFieldTextDidChangeNotification"
                                              object:_titleTextField];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)
                                                name:@"UITextFieldTextDidChangeNotification"
                                              object:_linkTextField];
}

#pragma mark - BarButtonAction

/**
 *  提交帖子操作
 */
- (void)postBarButtonAction:(UIBarButtonItem *)postBarButton
{
    if(self.titleTextField.text.length == 0) {
        [MBProgressHUD showInViewWithoutIndicator:self.view status:@"请输入文章标题" afterDelay:2.0];
//    }else if(self.linkTextField.text.length == 0) {
//        [MBProgressHUD showInViewWithoutIndicator:self.view status:@"请输入文章链接" afterDelay:2.0];
    }else if(self.contentTextView.text.length == 0) {
        [MBProgressHUD showInViewWithoutIndicator:self.view status:@"请输入文章内容" afterDelay:2.0];
    }
    
    WS(weakSelf);
    
    [_postBarButton setEnabled:NO];
    self.paramEntity.articleTitle = _titleTextField.text;
    self.paramEntity.articleUrl = _linkTextField.text;
    self.paramEntity.articleType = @(0);
    self.paramEntity.articleContent = _contentTextView.text;
    self.paramEntity.userId = [HXSUserAccount currentAccount].userID;
    NSData *imageData = [self checkTheImage:self.coverImageView.image andScaleToTheSize:300];
    HXSCommunitUploadImageEntity *uploadImageEntity = [[HXSCommunitUploadImageEntity alloc]init];
    uploadImageEntity.formData     = imageData;
    uploadImageEntity.nameStr      = @"file";
    uploadImageEntity.filenameStr  = [NSString stringWithFormat:@"%@.jpg", [imageData md5]];
    uploadImageEntity.mimeTypeStr  = @"multipart/form-data";
    uploadImageEntity.uploadType   = kHXSCommunityUploadPhotoTypeUploading;
    uploadImageEntity.defaultImage = self.coverImageView.image;
    self.paramEntity.coverImage = uploadImageEntity;
    
    [MBProgressHUD showInView:self.view.window];
    
    [self.postModel postTheArticle:self.paramEntity complete:^(HXSErrorCode code, NSString *message, HXSPost *post) {
        
        [MBProgressHUD hideHUDForView:weakSelf.view.window animated:NO];
        
        if(code == kHXSNoError) {
            NSString *succMessageStr = @"发帖成功!";
            [MBProgressHUD showInViewWithoutIndicator:weakSelf.view.window
                                               status:succMessageStr
                                           afterDelay:0.5
                                 andWithCompleteBlock:^
            {
             [weakSelf clearTheInputPost];
             [weakSelf.postBarButton setEnabled:YES];
             
             if (post.articleUrl.length > 0) {
                 //H5
                 NSURL *url = [NSURL URLWithString:post.articleUrl];
                 WKWebViewController *viewController = [[WKWebViewController alloc] init];
                 [viewController loadUrl:url];
                 if([viewController isKindOfClass:[UIViewController class]]) {
                     [self.navigationController pushViewController:viewController animated:YES];
                 }
             } else {
                 HXSCommunityDetailViewController *communityDetailViewController = [HXSCommunityDetailViewController createCommunityDetialVCWithPostID:post.dynamicsId replyLoad:NO pop:^{
                     [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                 }];
                 
                 [self.navigationController pushViewController:communityDetailViewController animated:YES];
             }
            }];
            [[NSNotificationCenter defaultCenter] postNotificationName:kMLPOSTADDED object:nil];
        } else {
            [weakSelf.postBarButton setEnabled:YES];
            [MBProgressHUD showInViewWithoutIndicator:weakSelf.view.window status:message afterDelay:2];
        }
    }];
}

/**
 *  根据图片压缩到指定大小
 *
 *  @param sizeM 指定大小,目前默认为5.0M
 *
 */
- (NSData *)checkTheImage:(UIImage *)image andScaleToTheSize:(CGFloat)sizeM
{
    if(!image || sizeM == 0.0)
        return nil;
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
    CGFloat scale     = sizeM/(imageData.length/1024.0);
    NSData *newData   = UIImageJPEGRepresentation(image, scale);
    return newData;
}

/**
 *  发帖成功后清空输入的东西
 */
- (void)clearTheInputPost
{
    [_titleTextField setText:nil];
    [_contentTextView setText:nil];
    [_linkTextField setText:nil];
    [_coverImageView setImage:nil];
}

/**
 *左上角回退按钮事件
 */
- (void)leftBackBarButtonAction:(UIBarButtonItem *)barButtonItem
{
    WS(weakSelf);
    BOOL isNeedToAlertview = NO;
    
    NSString *inputStr = [_titleTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    //在点击左上角回退按钮时,如果帖子尚无发布,提醒用户
    if(inputStr.length > 0) {
        isNeedToAlertview = YES;
    } else {
        isNeedToAlertview = NO;
    }
    if(isNeedToAlertview)
        {
        HXSCustomAlertView *alerView = [[HXSCustomAlertView alloc]initWithTitle:@"提醒"
                                                                        message:@"您还有内容未提交，确认放弃编辑吗？"
                                                                leftButtonTitle:@"取消"
                                                              rightButtonTitles:@"确定"];
        alerView.rightBtnBlock = ^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        };
        [alerView show];
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }
}

/**
 *  检测右上角提交按钮是否可用
 */
- (void)checkThePostBarButtonIsEnable
{
    BOOL isEnable = NO;
    NSString *titleStr = [_titleTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *contentStr = [_contentTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if(!titleStr.length || [contentStr isEqualToString:@""]
       || [contentStr isEqualToString:@""]) {
        isEnable = NO;
    } else {
        isEnable = YES;
    }
    [self.postBarButton setEnabled:isEnable];
}

- (UIBarButtonItem *)postBarButton
{
    if(!_postBarButton) {
        _postBarButton = [[UIBarButtonItem alloc]initWithTitle:@"发布"
                                                         style:UIBarButtonItemStylePlain
                                                        target:self
                                                        action:@selector(postBarButtonAction:)];
        [_postBarButton setEnabled:NO];
    }
    return _postBarButton;
}

- (UIBarButtonItem *)leftBackBarButton
{
    if(!_leftBackBarButton) {
        _leftBackBarButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"nav-back"]
                                                             style:UIBarButtonItemStylePlain
                                                            target:self
                                                            action:@selector(leftBackBarButtonAction:)];
    }
    return _leftBackBarButton;
}

- (HXSCommunityPostingModel *)postModel
{
    if(!_postModel) {
        _postModel = [[HXSCommunityPostingModel alloc]init];
    }
    return _postModel;
}

- (MLPostArticleParamEntity *)paramEntity {
    if(!_paramEntity) {
        _paramEntity = [[MLPostArticleParamEntity alloc] init];
    }
    return _paramEntity;
}

- (IBAction)selectCover:(id)sender {
    TZImagePickerController *controller = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
    controller.sortAscendingByModificationDate = NO;
    controller.allowPickingOriginalPhoto = NO;
    controller.allowCrop = YES;
    controller.showSelectBtn = NO;
    controller.takePictureImageName = @"takePhoto";
    controller.cropRect = CGRectInset([UIScreen mainScreen].bounds, 0, (SCREEN_HEIGHT - SCREEN_WIDTH * 0.6)/2);
    [self presentViewController:controller animated:YES completion:nil];
}

#pragma mark - textfield delegate
- (void)textFiledEditChanged:(NSNotification *)noti {
    if(noti.object == _titleTextField) {
        NSInteger length = ((UITextField *)noti.object).text.length;
        if(length > kMaxTitleLengthTextField) {
            length = kMaxTitleLengthTextField;
        }
        self.titleLimitLabel.text = [NSString stringWithFormat:@"%ld/%d", length, kMaxTitleLengthTextField];
    }
    
    [self checkThePostBarButtonIsEnable];
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    NSInteger length = textView.text.length;
    if(length > kMaxContentLengthTextView) {
        length = kMaxContentLengthTextView;
    }
    self.contentLimitLabel.text = [NSString stringWithFormat:@"%ld/%d", length, kMaxContentLengthTextView];
    
    NSString *text = [textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([text isEqualToString:@""]) {
        textView.text = textViewPlaceholdStr;
        textView.textColor = [UIColor lightGrayColor];
    } else {
        textView.textColor = _titleTextField.textColor;
        self.contentTextView.text = text;
    }
    
    [self checkThePostBarButtonIsEnable];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@""]){
        return YES;
    }
    
    NSMutableString *mutalbeStr = [[NSMutableString alloc] initWithString:textView.text];
    
    [mutalbeStr replaceCharactersInRange:range withString:text];
    
    if (kMaxContentLengthTextView < [mutalbeStr length]) {
        textView.text = [mutalbeStr substringToIndex:kMaxContentLengthTextView];
        return NO;
    }
    
    return YES;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@""]){
        return YES;
    }
    
    NSMutableString *mutalbeStr = [[NSMutableString alloc] initWithString:textField.text];
    
    [mutalbeStr replaceCharactersInRange:range withString:string];
    
    if (kMaxTitleLengthTextField < [mutalbeStr length]) {
        textField.text = [mutalbeStr substringToIndex:kMaxTitleLengthTextField];
        return NO;
    }
    
    return YES;
}

#pragma mark - TZImagePickerControllerDelegate
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    if(photos.count > 0) {
        UIImage *selectedImage = photos[0];
        self.coverImageView.image = selectedImage;
    }
}

@end
