//
//  CMTime.swift
//  Ondemand
//
//  Created by Songwut Maneefun on 6/1/17.
//  Copyright © 2017 Conicle.Co.,Ltd. All rights reserved.
//

import CoreMedia

extension CMTime {
    var readableText:String {
        if self.seconds.isNaN {
            return ""
        } else {
            let secs = Float(self.seconds).roundInt
            let hours = secs / 3600
            let minutes = (secs % 3600) / 60
            let seconds = (secs % 3600) % 60
            let timeLeft = Utility.duration(hrs: hours, mins: minutes, secs: seconds)
            return timeLeft
        }
        
    }
    
    var parameterInt:Int {
        if self.seconds.isNaN {
            return 0
        } else {
            return Int(self.seconds)
        }
    }
}
