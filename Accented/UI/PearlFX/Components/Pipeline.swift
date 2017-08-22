//
//  Pipeline.swift
//  Accented
//
//  Created by Tiangong You on 6/9/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit
import GPUImage

class Pipeline: NSObject {
    
    var nodes = [Node]()
    var needsRebuilt = true
    
    func addNode(_ node : Node) {
        if !nodes.contains(node) {
            nodes.append(node)
        }
    }
    
    func insertNode(_ node : Node, at index : Int) {
        if !nodes.contains(node) {
            nodes.insert(node, at: index)
        }
    }
    
    func invalidate() {
        needsRebuilt = true
    }
    
    func build() {
        guard needsRebuilt else { return }
        needsRebuilt = false
        
        for node in nodes {
            node.removeAllTargets()
        }
        
        var previousNode : Node?
        for node in nodes {
            guard node.enabled else { continue }
            
            if previousNode != nil {
                previousNode!.addNode(node: node)
            }
            
            previousNode = node
        }
    }
    
    func render() {
        guard nodes.count >= 2 else { return }
        guard nodes[0] is InputNode else { return }
        
        if needsRebuilt {
            build()
        }
        
        let firstNode = nodes[0] as! InputNode
        firstNode.input.processImage(synchronously: true)
    }
}
