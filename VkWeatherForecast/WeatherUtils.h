//
//  WeatherUtils.h
//  VkWeatherForecast
//
//  Created by Женя Михайлова on 22.06.14.
//  Copyright (c) 2014 Jane. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeatherUtils : NSObject

+(double)convertCelsiusToFahrenhate:(double)temp;
+(double)convertFahrenhateToCelsuis:(double)temp;
+(double)convertKelvinToCelsius:(double)temp;

@end
