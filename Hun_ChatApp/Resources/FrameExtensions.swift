//
//  Extensions.swift
//  Hun_ChatApp
//
//  Created by 신지훈 on 2021/07/31.
//

import Foundation
import UIKit

//대부분의 UI를 코드로 구현할것이기 때문에 반복적인 작업을 피하기 위해 원하는 대로 속성의 일부를 구현하고 UIViewclass에 확장을 추가하여 이를 수행하겠습니다.

//크기 구현
extension UIView {
    public var width: CGFloat {
    return self.frame.size.width
     }
    
    public var height: CGFloat {
     return self.frame.size.width
     }
    
    public var top: CGFloat {
     return self.frame.origin.y
     }
    
    public var bottom: CGFloat {
        return self.frame.size.height + self.frame.origin.y
     }
    
    public var left: CGFloat {
     return self.frame.origin.x
     }
    
    public var right: CGFloat {
        return self.frame.size.width + self.frame.origin.x
     }
}
