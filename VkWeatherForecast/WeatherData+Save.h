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
+ (WeatherData *)saveWeatherData:(NSMutableDictionary *)info inManagedObjectContext:(NSManagedObjectContext *)context;
@end
