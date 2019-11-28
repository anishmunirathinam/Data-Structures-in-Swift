import Foundation

// Linked list is a linear data structure, basically a chain of nodes.

// defining a node, node has a value and a next node reference
class Node<Value> {
    var value: Value
    var next: Node<Value>?
    
    init(value: Value, next: Node<Value>? = nil) {
        self.value = value
        self.next = next
    }
}

extension Node: CustomStringConvertible {
    var description: String {
        guard let next = next else {
            return "\(value)"
        }
        return "\(value) -> " + String(describing: next)
    }
}

struct LinkedList<Value> {
    var head: Node<Value>?
    var tail: Node<Value>?
    
    var isEmpty: Bool {
        return head == nil
    }
    
    // add value to front of the list
    mutating func push(_ value: Value) {
        head = Node(value: value, next: head)
        if tail == nil {
            tail = head
        }
    }
    
    // add value to end of the list
    mutating func append(_ value: Value) {
        guard !isEmpty else {
            push(value)
            return
        }
        tail!.next = Node(value: value)
        tail = tail!.next
    }
    
    func node(at index: Int) -> Node<Value>? {
        var currentNode = head
        var currentIndex = 0
        while currentNode != nil && currentIndex < index {
            currentNode = currentNode?.next
            currentIndex += 1
        }
        return currentNode
    }
    
    // add value after a node at specific index in the list
    @discardableResult
    mutating func insert(_ value: Value, after node: Node<Value>) -> Node<Value> {
        guard tail !== node else {
            append(value)
            return tail!
        }
        node.next = Node(value: value, next: node.next)
        return node.next!
    }
    
    // pop - removes the node from the front of the list
    @discardableResult
    mutating func pop() -> Value? {
        defer {
            head = head?.next
            if isEmpty {
                tail = nil
            }
        }
        return head?.value
    }
    
    // remove last - eliminates the last node
    @discardableResult
    mutating func removeLast() -> Value? {
        guard let head = head else {
            return nil
        }
        guard head.next != nil else {
            return pop()
        }
        var current = head
        var previous = head
        while let next = current.next {
            previous = current
            current = next
        }
        previous.next = nil
        tail = previous
        return current.value
    }
    
    // remove after a node at specific index
    @discardableResult
    mutating func remove(after node: Node<Value>) -> Value? {
        defer {
            if node.next === tail {
                tail = node
            }
            node.next = node.next?.next
        }
        return node.next?.value
    }
}

extension LinkedList: CustomStringConvertible {
    var description: String {
        guard let head = head else {
            return "Empty Linked List"
        }
        return String(describing: head)
    }
}

var integerList = LinkedList<Int>()
print("INSERTION:\n")
print("Push")
integerList.push(30)
integerList.push(20)
integerList.push(10)
print(integerList)
print("\nAppend")
integerList.append(40)
integerList.append(50)
print(integerList)
print("\nInsert 22 after node at index 1")
if let indexOndeNode = integerList.node(at: 1) {
    integerList.insert(22, after: indexOndeNode)
}
print(integerList)

print("\nREMOVAL:\n")
print("Pop")
integerList.pop()
integerList.pop()
print(integerList)
print("\nRemove Last")
integerList.removeLast()
print(integerList)
print("\nRemove after node at index 1")
if let indexOndeNode = integerList.node(at: 1) {
    integerList.remove(after: indexOndeNode)
}
print(integerList)
