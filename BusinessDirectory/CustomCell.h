//
//  CustomCell.h
//  BusinessDirectory
//
//  Created by Mossy O Mahony on 05/03/2019.
//  Copyright © 2019 Mossy O Mahony. All rights reserved.
//

#ifndef CustomCell_h
#define CustomCell_h


#endif /* CustomCell_h */

#import <Foundation/Foundation.h>

@interface CustomCell : UITableViewCell

@end

@implementation CustomCell

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // grab bound for contentView
    CGRect contentViewBound = self.contentView.bounds;
    // grab the frame for the imageView
    CGRect imageViewFrame = self.imageView.frame;
    // change x position
    imageViewFrame.origin.x = contentViewBound.size.width - imageViewFrame.size.width;
    // assign the new frame
    self.imageView.frame = imageViewFrame;
}

@end
