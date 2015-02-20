#import "RTActivityCell.h"

@implementation RTActivityCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.icon = [self createIcon];
        self.label = [self createLabel];

        [self.contentView addSubview:self.icon];
        [self.contentView addSubview:self.label];
    }
    return self;
}

- (UIImageView *)createIcon {
    CGRect iconFrame = [self iconFrameFromContentViewFrame:self.contentView.frame];
    return [[UIImageView alloc] initWithFrame:iconFrame];
}

- (CGRect)iconFrameFromContentViewFrame:(CGRect)frame {
    CGFloat x = 8.0;
    CGFloat y = CGRectGetMidY(frame);
    
    CGFloat width = 16.0;
    CGFloat height = 16.0;
    
    return CGRectMake(x, y, width, height);
}

- (TTTAttributedLabel *)createLabel {
    CGRect labelFrame = [self labelFrameFromContentViewFrame:self.contentView.frame];
    return [[TTTAttributedLabel alloc] initWithFrame:labelFrame];
}

- (CGRect)labelFrameFromContentViewFrame:(CGRect)frame {
    CGFloat x = CGRectGetMidX(frame) + 8.0;
    CGFloat y = CGRectGetMidY(frame);

    CGFloat width = frame.size.width - 16.0;
    CGFloat height = frame.size.height - 16.0;

    return CGRectMake(x, y, width, height);
}

@end