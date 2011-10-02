//
//  CImageLoader.h
//  toxicsoftware.com
//
//  Created by Jonathan Wight on 9/23/11.
//  Copyright (c) 2011 toxicsoftware.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CImageLoader : NSObject

+ (CImageLoader *)sharedInstance;

- (NSDictionary *)imagesNamed:(NSString *)inName;
- (UIImage *)imageNamed:(NSString *)inName state:(UIControlState)inState;
- (UIImage *)imageNamed:(NSString *)inName;

@end

@interface CImageLoader (CImageLoader_ControlExtensions)

- (void)setButtonImages:(UIButton *)inControl withImageNamed:(NSString *)inName;
- (void)setButtonBackgroundImages:(UIButton *)inControl withImageNamed:(NSString *)inName;

@end