//
//  UIView+ActivityIndicator.h
//  VkWeatherForecast
//
//  Created by Женя Михайлова on 22.06.14.
//  Copyright (c) 2014 Jane. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ActivityIndicator)

- (void)showActivityIndicator;
- (void)showActivityIndicatorWithStyle:(UIActivityIndicatorViewStyle)style;
- (void)hideActivityIndicator;

@end
