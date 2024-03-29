//
//  QSProgressHUD.swift
//  QSBaoKan
//
//  Created by mba on 16/6/7.
//  Copyright © 2016年 cqs. All rights reserved.
//

import UIKit
import SVProgressHUD

class MBAProgressHUD: NSObject {
    
    class func setupHUD() {
        SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.custom)
        SVProgressHUD.setForegroundColor(UIColor.white)
        SVProgressHUD.setBackgroundColor(UIColor(white: 0.0, alpha: 0.8))
        SVProgressHUD.setFont(UIFont.boldSystemFont(ofSize: 16))
        SVProgressHUD.setMinimumDismissTimeInterval(2.0)
        
        SVProgressHUD.setDefaultMaskType(.clear) // 设置是否背景可以点击
        
        /*
         + (void)setDefaultStyle:(SVProgressHUDStyle)style;                  // default is SVProgressHUDStyleLight
         + (void)setDefaultMaskType:(SVProgressHUDMaskType)maskType;         // default is SVProgressHUDMaskTypeNone
         + (void)setDefaultAnimationType:(SVProgressHUDAnimationType)type;   // default is SVProgressHUDAnimationTypeFlat
         + (void)setMinimumSize:(CGSize)minimumSize;                         // default is CGSizeZero, can be used to avoid resizing for a larger message
         + (void)setRingThickness:(CGFloat)width;                            // default is 2 pt
         + (void)setRingRadius:(CGFloat)radius;                              // default is 18 pt
         + (void)setRingNoTextRadius:(CGFloat)radius;                        // default is 24 pt
         + (void)setCornerRadius:(CGFloat)cornerRadius;                      // default is 14 pt
         + (void)setFont:(UIFont*)font;                                      // default is [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline]
         + (void)setForegroundColor:(UIColor*)color;                         // default is [UIColor blackColor], only used for SVProgressHUDStyleCustom
         + (void)setBackgroundColor:(UIColor*)color;                         // default is [UIColor whiteColor], only used for SVProgressHUDStyleCustom
         + (void)setBackgroundLayerColor:(UIColor*)color;                    // default is [UIColor colorWithWhite:0 alpha:0.4], only used for SVProgressHUDMaskTypeCustom
         + (void)setInfoImage:(UIImage*)image;                               // default is the bundled info image provided by Freepik
         + (void)setSuccessImage:(UIImage*)image;                            // default is bundled success image from Freepik
         + (void)setErrorImage:(UIImage*)image;                              // default is bundled error image from Freepik
         + (void)setViewForExtension:(UIView*)view;                          // default is nil, only used if #define SV_APP_EXTENSIONS is set
         + (void)setMinimumDismissTimeInterval:(NSTimeInterval)interval;     // default is 5.0 seconds
         + (void)setFadeInAnimationDuration:(NSTimeInterval)duration;        // default is 0.15 seconds
         + (void)setFadeOutAnimationDuration:(NSTimeInterval)duration;       // default is 0.15 seconds
         */

    }
    
    class func show() {
//        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.show()
    }
    
    class func showWithStatus(_ status: String) {
        SVProgressHUD.show(withStatus: status)
    }
    
    class func showInfoWithStatus(_ status: String) {
        SVProgressHUD.showInfo(withStatus: status)
    }
    
    class func showSuccessWithStatus(_ status: String) {
        SVProgressHUD.showSuccess(withStatus: status)
    }
    
    class func showErrorWithStatus(_ status: String) {
        SVProgressHUD.showError(withStatus: status)
    }
    
    class func dismiss() {
        DispatchQueue.main.async { () -> Void in
            SVProgressHUD.dismiss()
        }
    }
}
