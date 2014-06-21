//
//  ViewController.h
//  VkWeatherForecast
//
//  Created by Jane on 20.06.14.
//  Copyright (c) 2014 Jane. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeatherManagerDelegate.h"

@interface ViewController : UIViewController <WeatherManagerDelegate, CLLocationManagerDelegate>

@end
