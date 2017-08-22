//
//  Processor.swift
//  Accented
//
//  Created by Tiangong You on 6/9/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit
import GPUImage

class Node : NSObject {
    var enabled : Bool = true
    
    func addNode(node : Node) {
    
    }
    
    func removeAllTargets() {
    
    }
}

class FilterNode : Node {
    var filter : BasicOperation
    
    init(filter : BasicOperation) {
        self.filter = filter
        super.init()
    }
    
    override func addNode(node: Node) {
        if node is FilterNode {
            let filterNode = node as! FilterNode
            filter.addTarget(filterNode.filter)
        } else if node is OutputNode {
            let outputNode = node as! OutputNode
            filter.addTarget(outputNode.output)
        }
    }
    
    override func removeAllTargets() {
        filter.removeAllTargets()
    }
    
    func cloneFilter() -> FilterNode? {
        // Base class has no implementation
        return nil
    }
}

class InputNode : Node {
    var input : PictureInput
    
    init(input : PictureInput) {
        self.input = input
        super.init()
    }
    
    override func addNode(node: Node) {
        if node is FilterNode {
            let filterNode = node as! FilterNode
            input.addTarget(filterNode.filter)
        } else if node is OutputNode {
            let outputNode = node as! OutputNode
            input.addTarget(outputNode.output)
        }
    }
    
    override func removeAllTargets() {
        input.removeAllTargets()
    }
}

class OutputNode : Node {
    var output : ImageConsumer
    
    init(output : ImageConsumer) {
        self.output = output
        super.init()
    }
    
    override func addNode(node: Node) {
        // Do nothing
    }
    
    override func removeAllTargets() {
        // Do nothing
    }
}
