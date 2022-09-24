//
//  UIBarButtonItem.SystemItem+CustomStringConvertible.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 17.11.2020.
//  Copyright © 2020 Denis Bystruev. All rights reserved.
//

import UIKit

extension UIBarButtonItem.SystemItem: CustomStringConvertible {
    public var description: String {
        let className = String(describing: Self.self)
        switch self {
        case .done:
            return "\(className).done"
        case .cancel:
            return "\(className).cancel"
        case .edit:
            return "\(className).edit"
        case .save:
            return "\(className).save"
        case .add:
            return "\(className).add"
        case .flexibleSpace:
            return "\(className).flexibleSpace"
        case .fixedSpace:
            return "\(className).fixedSpace"
        case .compose:
            return "\(className).compose"
        case .reply:
            return "\(className).reply"
        case .action:
            return "\(className).action"
        case .organize:
            return "\(className).organize"
        case .bookmarks:
            return "\(className).bookmarks"
        case .search:
            return "\(className).search"
        case .refresh:
            return "\(className).refresh"
        case .stop:
            return "\(className).stop"
        case .camera:
            return "\(className).camera"
        case .trash:
            return "\(className).trash"
        case .play:
            return "\(className).play"
        case .pause:
            return "\(className).pause"
        case .rewind:
            return "\(className).rewind"
        case .fastForward:
            return "\(className).fastForward"
        case .undo:
            return "\(className).undo"
        case .redo:
            return "\(className).redo"
        case .pageCurl:
            return "\(className).pageCurl"
        case .close:
            return "\(className).close"
        default:
            return "Unknown UIBarButtonItem.SystemItem"
        }
    }
}
