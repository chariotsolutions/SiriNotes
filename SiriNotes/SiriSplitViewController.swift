//
//  SiriSplitViewController.swift
//  SiriNotes
//
//  Created by Steven Beyers on 7/7/17.
//  Copyright © 2017 Chariot. All rights reserved.
//

import UIKit

protocol KeyCommandProvider {
    var shortcutKeys: [UIKeyCommand] { get }
    func handleShortcut(keyCommand: UIKeyCommand) -> Bool
}

class SiriSplitViewController: UISplitViewController {
    
    override var keyCommands: [UIKeyCommand]? {
        let topCommands = keyCommandsFor(viewController: viewControllers.last)
        let bottomCommands = keyCommandsFor(viewController: viewControllers.first)
        
        var allCommands = [UIKeyCommand]()
        if let top = topCommands, let bottom = bottomCommands {
            allCommands = bottom
            allCommands.append(contentsOf: top)
        } else if let top = topCommands {
            allCommands = top
        } else if let bottom = bottomCommands {
            allCommands = bottom
        }
        
        if allCommands.count > 0 {
            var returnCommands = [UIKeyCommand]()
            for command in allCommands {
                returnCommands.append(UIKeyCommand(input: command.input ?? "", modifierFlags: command.modifierFlags, action: #selector(handleKeyCommand(_:)), discoverabilityTitle: command.discoverabilityTitle ?? ""))
            }
            return returnCommands
        } else {
            return nil
        }
    }
    
    private func keyCommandsFor(viewController baseController: UIViewController?) -> [UIKeyCommand]? {
        var keyCommands: [UIKeyCommand]?
        
        if let provider = keyCommandProvider(forViewController: baseController) {
            keyCommands = provider.shortcutKeys
        }
        
        return keyCommands
    }
    
    @objc func handleKeyCommand(_ command: UIKeyCommand) {
        let handled = handleKeyCommand(command, withBaseController: viewControllers.last)
        
        if !handled {
            handleKeyCommand(command, withBaseController: viewControllers.first)
        }
    }
    
    @discardableResult
    private func handleKeyCommand(_ command: UIKeyCommand, withBaseController viewController: UIViewController?) -> Bool {
        var handled = false
        
        if let provider = keyCommandProvider(forViewController: viewController) {
            handled = provider.handleShortcut(keyCommand: command)
        }
        
        return handled
    }
    
    private func keyCommandProvider(forViewController viewController: UIViewController?) -> KeyCommandProvider? {
        var provider: KeyCommandProvider?
        
        if let top = viewController {
            if let nav = top as? UINavigationController {
                var controller: UIViewController? = nav.topViewController
                while (controller != nil && controller!.isKind(of: UINavigationController.classForCoder())) {
                    controller = (controller as? UINavigationController)?.topViewController
                }
                if let controller = controller as? KeyCommandProvider {
                    provider = controller
                } else if let navProvider = nav as? KeyCommandProvider {
                    provider = navProvider
                } else if let topProvider = top as? KeyCommandProvider {
                    provider = topProvider
                }
            }
        }
        
        return provider
    }
    
}
