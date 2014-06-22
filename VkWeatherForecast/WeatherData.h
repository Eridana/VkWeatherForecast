//
//  WeatherData.h
//  VkWeatherForecast
//
//  Created by Женя Михайлова on 22.06.14.
//  Copyright (c) 2014 Jane. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface WeatherData : NSManagedObject

@property (nonatomic, retain) NSString * cityName;
@property (nonatomic) double cloudsValue;
@property (nonatomic, retain) NSString * dateAsString;
@property (nonatomic) double humidity;
@property (nonatomic) BOOL isFahrenhate;
@property (nonatomic) double temperature;
@property (nonatomic, retain) NSString * weatherDescription;
@property (nonatomic) double windSpeed;

@end
