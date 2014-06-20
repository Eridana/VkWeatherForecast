//
//  WeatherApi.h
//  VkWeatherForecast
//
//  Created by Jane on 20.06.14.
//  Copyright (c) 2014 Jane. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

@interface WeatherManager : NSObject

//-(void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;
+ (WeatherManager *)sharedInstance;


@end
