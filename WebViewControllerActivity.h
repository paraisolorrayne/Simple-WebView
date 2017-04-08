//
//  WebViewControllerActivity.h
//  POP Store
//
//  Created by Lorrayne Paraiso on 03/03/17.
//  Copyright © 2017 DevTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewControllerActivity : UIActivity
@property (nonatomic, strong) NSURL *URLToOpen;
@property (nonatomic, strong) NSString *schemePrefix;
@end
