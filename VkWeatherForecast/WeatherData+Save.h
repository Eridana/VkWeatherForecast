//
//  WeatherData+Save.h
//  VkWeatherForecast
//
//  Created by Jane on 20.06.14.
//  Copyright (c) 2014 Jane. All rights reserved.
//

#import "WeatherData+Save.h"
#import "WeatherData.h"

@interface WeatherData (Save)

#define CATEGORY_ID @"id"
#define CATEGORY_TITLE @"title"
#define CATEGORY_ENTITY_NAME @"MyCategory"

+ (void)saveWeatherData:(WeatherData *)data inManagedObjectContext:(NSManagedObjectContext *)context;
+ (void)saveWeatherDataWithTemperature:(int)temperature
                              humidity:(double)humidity
                           cloudsValue:(int)cloudsValue
                                  date:(NSDate *)date
                             windSpeed:(double)windSpeed
                             isCelsius:(BOOL)isCelsius
                                cityId:(long)cityId
                inManagedObjectContext:(NSManagedObjectContext *)context;
//???

@end
