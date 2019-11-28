import Foundation

struct Heap<Element: Equatable> {
    var elements: [Element] = []
    let sort: (Element, Element) -> Bool
    
    init(sort: @escaping(Element, Element) -> Bool, elements: [Element] = []) {
        self.sort = sort
        self.elements = elements
        
        for i in stride(from: elements.count/2 - 1, through: 0, by: -1) {
            siftDown(from: i)
        }
    }
    
    var isEmpty: Bool {
        return elements.isEmpty
    }
    
    var count: Int {
        return elements.count
    }
    
    func leftChildIndex(forParentAt index: Int) -> Int {
        return (2*index) + 1
    }
    
    func rightChildIndex(forParentAt index: Int) -> Int {
        return (2*index) + 2
    }
    
    func parentIndex(forChildAt index: Int) -> Int {
        return (index-1) / 2
    }
}

// inserting into a heap

extension Heap {
    mutating func insert(_ element: Element) {
        elements.append(element)
        siftUp(from: count-1)
    }
    
    mutating func siftUp(from index: Int) {
        var child = index
        var parent = parentIndex(forChildAt: child)
        while child > 0 && sort(elements[child], elements[parent]) {
            elements.swapAt(child, parent)
            child = parent
            parent = parentIndex(forChildAt: child)
        }
    }
}

// removal from heap

extension Heap {
    mutating func remove() -> Element? {
        guard !isEmpty else {
            return nil
        }
        elements.swapAt(0, count-1)
        defer {
            siftDown(from: 0)
        }
        return elements.removeLast()
    }
    
    mutating func siftDown(from index: Int) {
        var parent = index
        while true {
            let left = leftChildIndex(forParentAt: parent)
            let right = rightChildIndex(forParentAt: parent)
            var candidate = parent
            if left < count && sort(elements[left], elements[candidate]) {
                candidate = left
            }
            if right < count && sort(elements[right], elements[candidate]) {
                candidate = right
            }
            if candidate == parent {
                return
            }
            elements.swapAt(parent, candidate)
            parent = candidate
        }
    }
}

// removal from arbitary index

extension Heap {
    mutating func remove(at index: Int) -> Element? {
        guard index < count else {
            return nil
        }
        if index == count - 1 {
            return elements.removeLast()
        }
        elements.swapAt(index, count-1)
        defer {
            siftDown(from: index)
            siftUp(from: index)
        }
        return elements.removeLast()
    }
}

// searching an element

extension Heap {
    func index(of element: Element, startingAt i: Int) -> Int? {
        if i >= count {
            return nil
        }
        if sort(element, elements[i]) {
            return nil
        }
        if element == elements[i] {
            return i
        }
        if let j = index(of: element, startingAt: leftChildIndex(forParentAt: i)) {
            return j
        }
        if let j = index(of: element, startingAt: rightChildIndex(forParentAt: i)) {
            return j
        }
        return nil
    }
}




var heap = Heap(sort: >, elements: [21,10,18,5,3,100])
print(heap)

heap.remove()
print(heap)

heap.insert(33)
print(heap)

heap.insert(31)
print(heap)
heap.insert(35)
print(heap)


/// HEAP CHALLENGES

// 1. Find the nth smallest integer
func nthSmallestInteger(elements: [Int], n: Int) -> Int? {
    var heap = Heap(sort: <, elements: elements)
    var current = 1
    while !heap.isEmpty {
        let element = heap.remove()
        if current == n {
            return element
        }
        current += 1
    }
    return nil
}

if let smallValue = nthSmallestInteger(elements: [3, 10, 18, 5, 21, 100], n: 3) {
    print(smallValue)
}

// 2. Find the kth largest integer
func kthLargestElement(elements: [Int], k: Int) -> Int? {
    var heap = Heap(sort: >, elements: elements)
    var current = 1
    while !heap.isEmpty {
        let element = heap.remove()
        if current == k {
            return element
        }
        current += 1
    }
    return nil
}

if let largeValue = kthLargestElement(elements: [3, 10, 18, 5, 21, 100], k: 3) {
    print(largeValue)
}
