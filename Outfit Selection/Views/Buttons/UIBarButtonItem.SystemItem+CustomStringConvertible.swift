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
        let prefix = String(describing: Self.self)
        switch self {
        case .done:
            return "\(prefix).done"
        case .cancel:
            return "\(prefix).cancel"
        case .edit:
            return "\(prefix).edit"
        case .save:
            return "\(prefix).save"
        case .add:
            return "\(prefix).add"
        case .flexibleSpace:
            return "\(prefix).flexibleSpace"
        case .fixedSpace:
            return "\(prefix).fixedSpace"
        case .compose:
            return "\(prefix).compose"
        case .reply:
            return "\(prefix).reply"
        case .action:
            return "\(prefix).action"
        case .organize:
            return "\(prefix).organize"
        case .bookmarks:
            return "\(prefix).bookmarks"
        case .search:
            return "\(prefix).search"
        case .refresh:
            return "\(prefix).refresh"
        case .stop:
            return "\(prefix).stop"
        case .camera:
            return "\(prefix).camera"
        case .trash:
            return "\(prefix).trash"
        case .play:
            return "\(prefix).play"
        case .pause:
            return "\(prefix).pause"
        case .rewind:
            return "\(prefix).rewind"
        case .fastForward:
            return "\(prefix).fastForward"
        case .undo:
            return "\(prefix).undo"
        case .redo:
            return "\(prefix).redo"
        case .pageCurl:
            return "\(prefix).pageCurl"
        case .close:
            return "\(prefix).close"
        default:
            return "Unknown UIBarButtonItem.SystemItem"
        }
    }
}
