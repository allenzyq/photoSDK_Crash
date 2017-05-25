//
//  YPProductionStyleViewController.h
//  YAOPAI
//
//  Created by apple on 16/11/29.
//  Copyright © 2016年 YAOPAI. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    PocketStyle,
    WholesceneStyle,
} ProductionStyle;

typedef NS_ENUM(NSInteger, PhotoListViewControllerMode) {
    PhotoListViewControllerMode_CreateAlbum,
    PhotoListViewControllerMode_AddPhoto,
};


@interface YPProductionStyleViewController : UIViewController

@property (nonatomic, assign) ProductionStyle  productionStle;
@property (strong, nonatomic) void (^tb_completionBlock)(NSArray *newImages);


@property (assign, nonatomic) PhotoListViewControllerMode mode;
- (void)createProductWithType:(ProductionStyle) productType WithAssetsArray:(NSMutableArray * )assets;
//@property (nonatomic, assign) 

@end
