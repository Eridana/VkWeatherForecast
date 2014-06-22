//
//  JsonParser.h
//  VkWeatherForecast
//
//  Created by Женя Михайлова on 21.06.14.
//  Copyright (c) 2014 Jane. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeatherData.h"

@interface JsonParser : NSObject
+(NSMutableDictionary *)getDataFromJson:(NSData *)json error:(NSError **)error;
@end
