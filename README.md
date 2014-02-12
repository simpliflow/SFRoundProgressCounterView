SFRoundProgressCounterView
==========================
A custom UIView with a rounded progress bar and a counter in the center of the circle.
Supports multiple time intervals (in milliseconds), start/stop/resuming counter, set custom color, etc. (see example project)

![Alt text](/screenshot_color.png "Custom Color")
![Alt text](/screenshot_intervals.png "Intervals")

Setup
-----

**Installing with [CocoaPods](http://cocoapods.org)**

If you're unfamiliar with CocoaPods you can check out this tutorial [here](http://www.raywenderlich.com/12139/introduction-to-cocoapods).

1. In Terminal navigate to the root of your project.
2. Run 'touch Podfile' to create the Podfile.
3. Open the Podfile using 'open -e Podfile'
4. Add the pod `SFRoundProgressCounterView` to your [Podfile](https://github.com/CocoaPods/CocoaPods/wiki/A-Podfile).

        platform :ios, '7.0'
        pod 'SFRoundProgressCounterView'
        
5. Run `pod install`.
6. Open your app's `.xcworkspace` file to launch Xcode and start using the control!

Usage
-----
1. Either create SFRoundProgressCounterView by dragging UIView from storyboard and change implementing class or create it programmatically
2. Create an outlet (if create via storyboard)
3. Set up time intervals

        self.sfProgressCounterView.delegate = self;
        NSNumber* interval = [NSNumber numberWithLong:5000.0];
        self.sfProgressCounterView.intervals = @[interval];
        // you could also define multiple intervals
        //self.sfProgressCounterView.intervals = @[interval, interval, interval];
        
4. Counter interaction

        [self.sfProgressCounterView start];
        [self.sfProgressCounterView stop];
        [self.sfProgressCounterView resume];
        [self.sfProgressCounterView reset];
        

5. Appearance Settings
        
        // thickness of outer circle
        self.sfProgressCounterView.outerCircleThickness = [NSNumber numberWithFloat:3.0];

        // thickness of inner circle
        self.sfProgressCounterView.innerCircleThickness = [NSNumber numberWithFloat:1.0];

        // track color of outer circle
        self.sfProgressCounterView.innerTrackColor = [UIColor redColor];
        
        // track color of inner circle
        self.sfProgressCounterView.outerTrackColor = [UIColor blackColor];

        // distance between two circles (if multiple intervals)
        self.sfProgressCounterView.circleDistance = [NSNumber numberWithFloat:6.0]; 

        // set color of outer progress circles
        self.sfProgressCounterView.outerProgressColor = color;

        // set color of inner progress circle
        self.sfProgressCounterView.innerProgressColor = color;
        
        // set color of counter label
        self.sfProgressCounterView.labelColor = color;


Delegate Methods
---------

        - (void)countdownDidEnd:(SFRoundProgressCounterView*)progressCounterView;
        - (void)intervalDidEnd:(SFRoundProgressCounterView*)progressCounterView WithIntervalPosition:(int)position;
        - (void)counter:(SFRoundProgressCounterView *)progressCounterView didReachValue:(unsigned long long)value;



Author(s)
-------

[Simpliflow GmbH](https://github.com/simpliflow)

[Thomas Winkler](https://github.com/tomgong)

Licence
-------

Distributed under the MIT License.

Attributation
--------------

[TTCounterLabel](https://github.com/TriggerTrap/TTCounterLabel)

[CERoundProgressView](https://github.com/Ceroce/CERoundProgressView)
