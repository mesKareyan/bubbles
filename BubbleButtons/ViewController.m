// Copyright (C) ABBYY (BIT Software), 1993-2019 . All rights reserved.
// Автор: Mesrop Kareyan
// Описание: @warning добавить описание

#import "ViewController.h"
#import "UIView+draggable.h"
#import "MESScrollView.h"

@interface ViewController () <UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet MESScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *buttonPositions;
@property (nonatomic, assign) BOOL isPositionsSet;


@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	[self.buttons enumerateObjectsUsingBlock:^(UIButton* obj, NSUInteger idx, BOOL *stop) {
		[obj enableDragging];
		obj.layer.cornerRadius  = CGRectGetWidth(obj.bounds) / 2.0;
		obj.cagingArea = [UIApplication sharedApplication].keyWindow.frame;
		UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapButton:)];
		tap.delegate = self;
		[obj addGestureRecognizer:tap];
	}];
}

- (void)viewDidLayoutSubviews {
	[super viewDidLayoutSubviews];
	if(!self.isPositionsSet) {
		self.buttonPositions = [NSMutableArray array];
		for(int i = 0; i < 5; i++) {
			[self.buttonPositions addObject:@(0)];
		}
		for(UIButton *button in self.buttons) {
			NSString *position = NSStringFromCGPoint(button.center);
			NSLog(position);
			self.buttonPositions[button.tag] = position;
		}
		self.isPositionsSet = YES;
	}
}

- (void)didTapButton:(UITapGestureRecognizer *)tap {
	UIButton *button = (UIButton *)tap.view;
	NSString *position = self.buttonPositions[button.tag];
	NSLog(position);
	if(position) {
		CGPoint origin = CGPointFromString(position);
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
			[UIView animateWithDuration:0.3 animations:^{
				button.center = origin;
				//NSLog(NSStringFromCGPoint(button.center));
				[self.view setNeedsLayout];
			}];
		});
	}
}


@end
