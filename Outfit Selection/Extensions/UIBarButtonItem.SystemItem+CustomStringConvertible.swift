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
        switch self {
        case .done:
            return "\(Self.self).done"
        case .cancel:
            return "\(Self.self).cancel"
        case .edit:
            return "\(Self.self).edit"
        case .save:
            return "\(Self.self).save"
        case .add:
            return "\(Self.self).add"
        case .flexibleSpace:
            return "\(Self.self).flexibleSpace"
        case .fixedSpace:
            return "\(Self.self).fixedSpace"
        case .compose:
            return "\(Self.self).compose"
        case .reply:
            return "\(Self.self).reply"
        case .action:
            return "\(Self.self).action"
        case .organize:
            return "\(Self.self).organize"
        case .bookmarks:
            return "\(Self.self).bookmarks"
        case .search:
            return "\(Self.self).search"
        case .refresh:
            return "\(Self.self).refresh"
        case .stop:
            return "\(Self.self).stop"
        case .camera:
            return "\(Self.self).camera"
        case .trash:
            return "\(Self.self).trash"
        case .play:
            return "\(Self.self).play"
        case .pause:
            return "\(Self.self).pause"
        case .rewind:
            return "\(Self.self).rewind"
        case .fastForward:
            return "\(Self.self).fastForward"
        case .undo:
            return "\(Self.self).undo"
        case .redo:
            return "\(Self.self).redo"
        case .pageCurl:
            return "\(Self.self).pageCurl"
        case .close:
            return "\(Self.self).close"
        default:
            return "Unknown UIBarButtonItem.SystemItem"
        }
    }
}
