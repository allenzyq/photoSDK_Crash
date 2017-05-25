//
//  YPProductionStyleViewController.m
//  YAOPAI
//
//  Created by apple on 16/11/29.
//  Copyright © 2016年 YAOPAI. All rights reserved.
//

#import "YPProductionStyleViewController.h"
#import "MBProgressHUD.h"
#import <Photos/Photos.h>
#import "TBPSSizeUtil.h"
#import <TapsbookSDK/TBSDKAlbumManager+StoreLogin.h>
#import <TapsbookSDK/TBSDKAlbumManager+StoreOrderList.h>
#import "UIImage+Save.h"
#import "TZImagePickerController.h"
//#import "IQKeyboardManager.h"
//#import "YPAppServiceViewController.h"
//#import "YPLoginCheck.h"
//#import "YPLoginViewController.h"
//#import <TapsbookSDK/TBSDKAlbumManager+StoreLogin.h>
//#import "YPYouZanUserModel.h" //这个model 保存的有userID
//#import <TapsbookSDK/TBSDKAlbumManager+StoreOrderList.h>
//#import <IQKeyboardManager.h>

@interface YPProductionStyleViewController () <UIScrollViewDelegate,TZImagePickerControllerDelegate,TBSDKAlbumManagerDelegate>
@property (nonatomic, strong) UIScrollView * scrollView;
@property (nonatomic, strong) UIPageControl * pageControl;
@property (nonatomic, strong) UIButton * customizationButton;
@property (nonatomic, strong) NSMutableArray * selecteAssets;
@property (nonatomic, copy) NSString * photoSDKPreferredSKU;
//_selectedPhotos
//_selectedAssets


@end

@implementation YPProductionStyleViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    UINavigationBar * bar = [UINavigationBar appearance];
    [bar setBackgroundImage:[UIImage imageNamed:@"navigationbarbg_White"] forBarMetrics:UIBarMetricsDefault];
    self.title = @"YYYYY";
}

- (void)setNV {
    UIBarButtonItem * rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"remind_icon_select"] style:UIBarButtonItemStyleDone target:self action:@selector(barbuttonAction)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    if (_productionStle == PocketStyle) {
        self.title = @"口袋书";
        self.photoSDKPreferredSKU = @"1004";
    }else {
        self.title = @"全景书"; //138
        self.photoSDKPreferredSKU = @"1003";
    }
}

- (void)barbuttonAction {
//    YPAppServiceViewController *conversationVC = [[YPAppServiceViewController alloc]init];
//    conversationVC.conversationType = ConversationType_CUSTOMERSERVICE;
//    conversationVC.targetId = @"KEFU146071134669130";
//    conversationVC.chatTitle = @"YAOPAI小秘书";
//    [self.navigationController pushViewController:conversationVC animated:YES];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNV];
//    [IQKeyboardManager sharedManager].enable = NO;
    
    [[TBSDKAlbumManager sharedInstance] setDelegate:self];
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, 375, 500 - 64)];
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
//    _scrollView.backgroundColor = [UIColor redColor];
    _scrollView.pagingEnabled = YES;
    _scrollView.scrollEnabled = YES;
    _scrollView.delegate = self;
    _scrollView.contentSize = CGSizeMake(375 * 4, 0);
    [self.view addSubview:_scrollView];
    NSString * str = nil;
    if (_productionStle == PocketStyle) {
        str = @"production_Pocket";
    }else {
        str = @"production_Wholescene";
    }
//    for (int i = 0; i< 4; i++) {
//        NSString * imageStr = [NSString stringWithFormat:@"%@%d",str,i];
//        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(i * YPScreenW, -64, YPScreenW, YPScreenH)];
//        imageView.image = [UIImage imageNamed:imageStr];
//        [_scrollView addSubview:imageView];
//    }

//    _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, YPScreenH - 30, 100, 7)];
//    _pageControl.centerX = self.view.centerX;
//    _pageControl.currentPage = 0;
//    _pageControl.currentPageIndicatorTintColor = YPRGBColor(64, 64, 64);
//    _pageControl.pageIndicatorTintColor = YPRGBColor(204, 204, 204);
//    _pageControl.numberOfPages = 4;
//    [self.view addSubview:_pageControl];
//    
//    CGFloat yToPageControl = 67;
//    if (iPhone5) {
//        yToPageControl = 40;
//    }
    _customizationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _customizationButton.frame = CGRectMake(0, 300  , 170, 48);
//    _customizationButton.centerX = self.view.centerX;
    [_customizationButton setBackgroundImage:[UIImage imageNamed:@"priduction_customizationButton"] forState:UIControlStateNormal];
    _customizationButton.backgroundColor = [UIColor redColor];
    _customizationButton.titleLabel.text = @"111111";
    [_customizationButton sizeToFit];
    [self.view addSubview:_customizationButton];
    [_customizationButton addTarget:self action:@selector(customAlbums) forControlEvents:UIControlEventTouchUpInside];
    
    
//    UITextView * view = [[UITextView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_customizationButton.frame) + 20, 100, 50)];
//    view.centerX = self.view.centerX;
//    view.text = @"asdada";
//    view.backgroundColor = [UIColor redColor];
//    [self.view addSubview:view];
}

- (void)customAlbums {
    self.mode = PhotoListViewControllerMode_CreateAlbum;
    
    
    //1 判断用户有没有登录。 如果登录了。 2 判断他有没有注册过UserSdk.  如果没有的话，判断下这个用户的ID userID存在否（兼容上版本没有保存的userID 让用户在登录一下）拿到userid 去signin
//    if ([YPLoginCheck loginCheck] == YES) {
//        
//        NSString * str  = [[NSUserDefaults standardUserDefaults] objectForKey:PhotoUserSDK];
//        
//        if ([str isEqualToString:@"0"] || str == nil){
////            __weak typeof(self) weakSelf = self;
//            YPYouZanUserModel * model = [YPYouZanUserModel sharedManage];
//            if (model.userId == nil && ([str isEqualToString:@"0"] || str == nil) ) {
//                //对以前登录更新用户的兼容。 model.userId && 没有sdkID
//                YPLoginViewController * loginVC =  [[ YPLoginViewController alloc] init];
//                [self presentViewController:loginVC animated:YES completion:nil];
//            }
//            [[TBSDKAlbumManager sharedInstance] signinSDKUser:model.userId fromApp:@"wechat" completionBlock:^(BOOL success, TBSDKUser *sdkUser, NSError *error) {
//                if(success){
//                    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:PhotoUserSDK];
//                    [self pickerViewControllerShow];
//                }
//                else {
//
//                    
//                }
//            }];
//        }else {
////            [self goInPhotoSdkOrderViewController];
//            [self pickerViewControllerShow];
//
//        }
//    }else{
//        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:PhotoUserSDK];
//        YPLoginViewController * loginVC =  [[ YPLoginViewController alloc] init];
//        [self presentViewController:loginVC animated:YES completion:nil];
//    }

    [self pickerViewControllerShow];
    
}

- (void)pickerViewControllerShow {
    __weak typeof(self) weakSelf = self;
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:20 delegate:self];
    [imagePickerVc.navigationBar setBackgroundImage:[UIImage imageNamed:@"tab_bg"] forBarMetrics:UIBarMetricsDefault];
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        /**
         *  photos  里面有 imgae地址， 尺寸
         assets 0x7faec4969c30> ED7AC36B-A150-4C38-BB8C-B6D696F4F2ED/L0/001 mediaType=1/0, sourceType=1, (3000x2002), creationDate=2012-08-08 21:55:30 +0000, location=1, hidden=0, favorite=0
         */
        //        [_selectedPhotos addObjectsFromArray:photos];
        //        [_selectedAssets addObjectsFromArray:assets];
        _selecteAssets = [NSMutableArray arrayWithArray:assets];
        //        _layout.itemCount = _selectedPhotos.count;
        //        [_collectionView reloadData];
        [weakSelf createProductWithType:0 WithAssetsArray:_selecteAssets];
        
    }];
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

- (void)createProductWithType:(ProductionStyle) productType WithAssetsArray:(NSMutableArray * )assets {
    __weak typeof(self) weakSelf = self;
    NSArray *selectedIndexes = @[@"1",@"2"];
//    UITableViewCell
    if (selectedIndexes.count > 0) {
//        NSMutableIndexSet *indexSet = [[NSMutableIndexSet alloc] init];
//        
//        for (NSIndexPath *indexPath in selectedIndexes) {
//            [indexSet addIndex:indexPath.row];
//        }
//    
        NSArray *selectedAssets = assets;
//       11 [assets objectsAtIndexes:indexSet];
        
//        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        
//         Saving assetes to disk
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            // Cache image to disk
            NSString *cachePath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Library"] stringByAppendingPathComponent:@"ImageCache"];
            NSFileManager *fileManager = [NSFileManager defaultManager];
            
            if (![fileManager fileExistsAtPath:cachePath isDirectory:NULL]) {
                [fileManager createDirectoryAtPath:cachePath withIntermediateDirectories:YES attributes:nil error:NULL];
            }
            
            NSMutableArray *tbImages = [NSMutableArray arrayWithCapacity:selectedAssets.count];
            
            NSInteger counter = 0;
        
            for (PHAsset *asset in selectedAssets) {
                @autoreleasepool {
                    
                    NSString *name = [[[asset localIdentifier] componentsSeparatedByString:@"/"] firstObject];
                    
                    // Size
                    CGSize boundingSize_s = [TBPSSizeUtil sizeFromPSImageSize:(TBPSImageSize)TBImageSize_s];
                    CGSize boundingSize_l = [TBPSSizeUtil sizeFromPSImageSize:(TBPSImageSize)TBImageSize_l];
                    CGSize convertedSize_s = boundingSize_s;
                    CGSize convertedSize_l = boundingSize_l;
                    if (asset.pixelWidth * asset.pixelHeight > 0) {
                        CGSize photoSize = CGSizeMake(asset.pixelWidth, asset.pixelHeight);
                        convertedSize_s = [TBPSSizeUtil convertSize:photoSize toSize:boundingSize_s contentMode:UIViewContentModeScaleAspectFill];
                        convertedSize_l = [TBPSSizeUtil convertSize:photoSize toSize:boundingSize_l contentMode:UIViewContentModeScaleAspectFill];
                    }
                    else {
                        NSAssert(NO, @"asset should have a size");
                    }
                    
                    NSString *sPath = [cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_s", name]];
                    NSString *lPath = [cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_l", name]];
                    PHImageRequestOptions *requestOptions = [[PHImageRequestOptions alloc] init];
                    requestOptions.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;
                    requestOptions.networkAccessAllowed = YES;
                    requestOptions.resizeMode = PHImageRequestOptionsResizeModeFast;
                    
                    if (![fileManager fileExistsAtPath:sPath]) {
                        
                        [[PHImageManager defaultManager] requestImageForAsset:asset
                                                                   targetSize:convertedSize_s
                                                                  contentMode:PHImageContentModeAspectFill
                                                                      options:requestOptions
                                                                resultHandler:^(UIImage *result, NSDictionary *info) {
                                                                    [result writeToFile:sPath withCompressQuality:1];
                                                                }];
                        
                    }
                    
                    if (![fileManager fileExistsAtPath:lPath]) {
                        [[PHImageManager defaultManager] requestImageForAsset:asset
                                                                   targetSize:convertedSize_l
                                                                  contentMode:PHImageContentModeAspectFill
                                                                      options:requestOptions
                                                                resultHandler:^(UIImage *result, NSDictionary *info) {
                                                                    [result writeToFile:lPath withCompressQuality:1];
                                                                }];
                    }
                    
                    TBImage *tbImage = [[TBImage alloc] initWithIdentifier:name];
                    
                    [tbImage setImagePath:sPath size:TBImageSize_s];
                    [tbImage setImagePath:lPath size:TBImageSize_l];
                    [tbImage setImagePath:lPath size:TBImageSize_xxl];
//                    [tbImage setim]
                    [tbImage setDesc:@(counter++).description];
                    [tbImage setImageCSURLString:@"http://awesome.web/where/is/my/photo_full.jpg" size:TBImageSize_xxl];
                    [tbImage setImageCSURLString:@"http://awesome.web/where/is/my/photo_regular.jpg" size:TBImageSize_l];
                    [tbImages addObject:tbImage];
                }//end of autorelease
            }//enf of for loop
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.mode == PhotoListViewControllerMode_CreateAlbum) {
                    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                    NSDictionary * albumOptionBase = @{
                                                       kTBProductMaxPageCount:     @"20",   //set max=min will limit the page count
                                                       kTBProductMinPageCount:     @"20",
//                                                       kTBBookHasInsideCover:      @"NO",// 12 23 加入新的字段
                                                       kTBPreferredUIDirection:    @"LTR",   //set this RTL or LTR
//                                                       kTBPreferredPageTypeSpread: @(YES)
                                                       };
                    NSDictionary * albumBookType8x8 =@{
                                                       kTBProductPreferredTheme:   @"200",  //200 is for square book
                                                       kTBProductPreferredSKU:     weakSelf.photoSDKPreferredSKU, //1003 is a layflat square book
                                                       };
                    
                    NSMutableDictionary *  albumOption = [albumOptionBase mutableCopy];
                    [albumOption addEntriesFromDictionary:albumBookType8x8];
                    
                    //the createSDKAlbumWithImages process include facial recognition, which might take sometime..
                    hud.mode = MBProgressHUDModeIndeterminate;
                    hud.labelText = @"recognizing faces...";
                    

                    
//                    
//                    [[TBSDKAlbumManager sharedInstance] createSDKAlbumWithImages:tbImages identifier:nil title:@"Album" tag:0 options:albumOption completionBlock:^(BOOL success, TBSDKAlbum *sdkAlbum, NSError *error)
                    [[TBSDKAlbumManager sharedInstance] createSDKAlbumWithProductType:TBProductType_Photobook images:tbImages identifier:nil title:@"Album" tag:0 options:albumOption completionBlock:^(BOOL success, TBSDKAlbum *sdkAlbum, NSError *error) {
                        
                        [hud hide:YES];
                        //进入sdk
//                        [self.view endEditing:YES];
                        [[TBSDKAlbumManager sharedInstance] openSDKAlbum:sdkAlbum presentOnViewController:self.navigationController shouldPrintDirectly:NO];
                        
                    }];
                    
                }
                else if (self.mode == PhotoListViewControllerMode_AddPhoto) {

                    self.tb_completionBlock(tbImages);
                }
            });
        });
    }
}

#pragma mark - TBSDKAlbumManagerDelegate
- (UIViewController *)photoSelectionViewControllerInstanceForAlbumManager:(TBSDKAlbumManager *)albumManager withSDKAlbum:(TBSDKAlbum *)sdkAlbum existingTBImages:(NSArray *)existingTBImages maxPhotoCount:(NSInteger) maxPhotoCount allowMultiple:(BOOL)allowMultiple completionBlock:(void (^)(NSArray *newImages))completionBlock {
    //通过add allowMultiple  返回的是nil。。。  加号 返回的是YES
    //maxPhotoCount   这个一直是80 。
     NSInteger picCount = 1;
    if (allowMultiple == YES) {
        picCount = 20;
    }
    self.tb_completionBlock = completionBlock;
    __weak typeof(self) weakSelf = self;
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:picCount delegate:self];
    imagePickerVc.autoDismiss = NO;
    imagePickerVc.selectedAssets = _selecteAssets;
    [imagePickerVc.navigationBar setBackgroundImage:[UIImage imageNamed:@"tab_bg"] forBarMetrics:UIBarMetricsDefault];
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto){
        weakSelf.mode = PhotoListViewControllerMode_AddPhoto;
        _selecteAssets = [NSMutableArray arrayWithArray:assets];
        [weakSelf createProductWithType:0 WithAssetsArray:_selecteAssets];
        
    }];
//     [self presentViewController:imagePickerVc animated:YES completion:nil];
    return imagePickerVc;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger tag = scrollView.contentOffset.x / 375;
    _pageControl.currentPage = tag;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)albumManager:(TBSDKAlbumManager *)albumManager didFinishEditingSDKAlbum:(TBSDKAlbum *)sdkAlbum {
    //    UIInterfaceOrientation
    SEL selector = NSSelectorFromString(@"setOrientation:");
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
    [invocation setSelector:selector];
    [invocation setTarget:[UIDevice currentDevice]];
    int val = UIInterfaceOrientationPortrait;
    [invocation setArgument:&val atIndex:2];//前两个参数已被target和selector占用
    [invocation invoke];

    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

- (void)dealloc{
    NSArray * imageArray =  _scrollView.subviews;
    for (int i = 0; i < imageArray.count ; i++) {
        UIView * view = imageArray[i];
        if ([view isKindOfClass:[UIImageView class]]) {
            [view removeFromSuperview];
            view = nil;
        }
    }
}

//#pragma mark - Orientation
//- (UIInterfaceOrientationMask)tabBarControllerSupportedInterfaceOrientations:(UITabBarController *)tabBarController{
//    return UIInterfaceOrientationMaskPortrait;
//}
//
//- (BOOL)shouldAutorotate {
//    return YES;
//}


@end
