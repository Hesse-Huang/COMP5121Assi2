//
//  Question2.swift
//  COMP5121Assi2
//
//  Created by Hesse Huang on 2017/10/31.
//  Copyright © 2017年 Hesse. All rights reserved.
//

import Foundation

fileprivate extension Double {
    var square: Double {
        return self * self
    }
}

extension Array where Element == Double {
    var average: Double {
        return reduce(0, +) / Double(count)
    }
}

fileprivate struct Record: CustomDebugStringConvertible, Equatable {
    
    enum Sex {
        case male, female
        
        var value: Double {
            switch self {
            case .male:     return 0
            case .female:   return 1
            }
        }
    }
    
    enum MarialStatus {
        case yes, no
        
        var value: Double {
            switch self {
            case .no:      return 0
            case .yes:     return 1
            }
        }

    }
    
    var ref: Int
    var age: Double
    var sex: Sex
    var monthlyIncome: Double
    var marialStatus: MarialStatus
    var servicePlan: Double
    var extraUsage: Double
    
    var sexValue: Double
    var marialStatusValue: Double
    
    init(ref: Int, age: Double, sex: Sex, monthlyIncome: Double, marialStatus: MarialStatus, servicePlan: Double, extraUsage: Double) {
        self.ref = ref
        self.age = age
        self.sex = sex
        self.monthlyIncome = monthlyIncome
        self.marialStatus = marialStatus
        self.servicePlan = servicePlan
        self.extraUsage = extraUsage
        
        self.sexValue = sex.value
        self.marialStatusValue = marialStatus.value
    }
    
    func distance(to r: Record) -> Double {
        let a = (age - r.age).square
        let sv = (sexValue - r.sexValue).square
        let m = (monthlyIncome - r.monthlyIncome).square
        let msv = (marialStatusValue - r.marialStatusValue).square
        let s = (servicePlan - r.servicePlan).square
        let e = (extraUsage - r.extraUsage).square
        return sqrt(a + sv + m + msv + s + e)
    }
    
    var debugDescription: String {
        if ref > 0 {
            return "#\(ref)"
        } else {
            return String(format: "(age: %.4f, sex: %.4f, monthlyIncome: %.4f, marialStatus: %.4f， servicePlan: %.4f, extraUsage: %.4f)", age, sexValue, monthlyIncome, marialStatusValue, servicePlan, extraUsage)
        }
        
    }
    
    static func ==(lhs: Record, rhs: Record) -> Bool {
        return lhs.age == rhs.age &&
        lhs.sexValue == rhs.sexValue &&
        lhs.monthlyIncome == rhs.monthlyIncome &&
        lhs.marialStatusValue == rhs.marialStatusValue &&
        lhs.servicePlan == rhs.servicePlan &&
        lhs.extraUsage == rhs.extraUsage
    }
    
}

fileprivate struct Cluster<T>: CustomDebugStringConvertible {
    var center: T
    var elements: [T]
    
    var centerUpdated: Bool
    
    init(center: T) {
        self.center = center
        self.elements = []
        self.centerUpdated = true
    }
    
    var debugDescription: String {
        return "Cluster:\n\t-center: \(center)\n\t-elements: \(elements)\n"
    }
}

fileprivate extension Cluster where T == Record {
    mutating func updateCenter() {
        let previousCenter = center
        let c = Double(elements.count)
        center.age = elements.reduce(0) {
            $0 + $1.age / c
        }
        center.sexValue = elements.reduce(0) {
            $0 + $1.sexValue / c
        }
        center.monthlyIncome = elements.reduce(0) {
            $0 + $1.monthlyIncome / c
        }
        center.marialStatusValue = elements.reduce(0) {
            $0 + $1.marialStatusValue / c
        }
        center.servicePlan = elements.reduce(0) {
            $0 + $1.servicePlan / c
        }
        center.extraUsage = elements.reduce(0) {
            $0 + $1.extraUsage / c
        }
        centerUpdated = previousCenter != center
    }
    
    var averageIntraClusterDistance: Double {
        return elements.map({ center.distance(to: $0) }).average
    }

}

fileprivate extension Array where Element == Cluster<Record> {
    var anyCenterChanged: Bool {
        return contains(where: { $0.centerUpdated })
    }
    
    var averageInterClusterDistance: Double {
        var allDistances = [Double]()
        for i in 0 ..< count {
            for j in (i + 1) ..< count {
                allDistances.append(self[i].center.distance(to: self[j].center))
            }
        }
        return allDistances.average
    }
}

fileprivate extension Array where Element == Record {
    var normalized: Array<Element> {
        var s = self
        s.normalize()
        return s
    }
    mutating func normalize() {
        let ages = map { $0.age }
        let maxA = ages.max()!
        let minA = ages.min()!
        
        let monthlyIncomes = map { $0.monthlyIncome }
        let maxMI = monthlyIncomes.max()!
        let minMI = monthlyIncomes.min()!
        
        let servicePlans = map { $0.servicePlan }
        let maxSP = servicePlans.max()!
        let minSP = servicePlans.min()!
        
        let extraUsages = map { $0.extraUsage }
        let maxEU = extraUsages.max()!
        let minEU = extraUsages.min()!
        
        for i in 0 ..< count {
            self[i].age = (self[i].age - minA) / (maxA - minA)
            self[i].monthlyIncome = (self[i].monthlyIncome - minMI) / (maxMI - minMI)
            self[i].servicePlan = (self[i].servicePlan - minSP) / (maxSP - minSP)
            self[i].extraUsage = (self[i].extraUsage - minEU) / (maxEU - minEU)
        }
    }
}

fileprivate let records: [Record] = [
    Record(ref: 1, age: 54, sex: .female, monthlyIncome: 3000, marialStatus: .yes, servicePlan: 100, extraUsage: 0),
    Record(ref: 2, age: 59, sex: .female, monthlyIncome: 4000, marialStatus: .no, servicePlan: 600, extraUsage: 54),
    Record(ref: 3, age: 38, sex: .male, monthlyIncome: 7800, marialStatus: .no, servicePlan: 200, extraUsage: 31),
    Record(ref: 4, age: 18, sex: .female, monthlyIncome: 8500, marialStatus: .no, servicePlan: 600, extraUsage: 311),
    Record(ref: 5, age: 27, sex: .male, monthlyIncome: 14000, marialStatus: .yes, servicePlan: 100, extraUsage: 211),
    Record(ref: 6, age: 29, sex: .female, monthlyIncome: 31000, marialStatus: .yes, servicePlan: 1600, extraUsage: 25),
    Record(ref: 7, age: 17, sex: .male, monthlyIncome: 7500, marialStatus: .no, servicePlan: 600, extraUsage: 254),
    Record(ref: 8, age: 22, sex: .female, monthlyIncome: 7900, marialStatus: .no, servicePlan: 200, extraUsage: 31),
    Record(ref: 9, age: 34, sex: .male, monthlyIncome: 24700, marialStatus: .no, servicePlan: 100, extraUsage: 7),
    Record(ref: 10, age: 46, sex: .female, monthlyIncome: 31110, marialStatus: .yes, servicePlan: 600, extraUsage: 0),
    Record(ref: 11, age: 38, sex: .female, monthlyIncome: 21000, marialStatus: .yes, servicePlan: 600, extraUsage: 64),
    Record(ref: 12, age: 35, sex: .female, monthlyIncome: 30000, marialStatus: .no, servicePlan: 1600, extraUsage: 0),
    Record(ref: 13, age: 39, sex: .male, monthlyIncome: 40500, marialStatus: .yes, servicePlan: 1600, extraUsage: 50),
    Record(ref: 14, age: 18, sex: .male, monthlyIncome: 7800, marialStatus: .no, servicePlan: 1000, extraUsage: 290)
]


fileprivate func runKmeans(k: Int, with records: [Record], initialCenterRef: Int...) -> [Cluster<Record>] {
    
    // normalize
    var normalizedRecords = records
    normalizedRecords.normalize()
    
    // assign inital centers
    var allClusters: [Cluster<Record>] = initialCenterRef.map {
        var center = normalizedRecords[$0 - 1]
        center.ref = 0
        return Cluster(center: center)
    }
    
    var timesOfIteration = -1
    // if any center of cluster changed after last iteration, run the algorithm again
    while allClusters.anyCenterChanged {
        
        // before calculating next new center, we need to clear all the members
        for x in 0 ..< allClusters.count {
            allClusters[x].elements.removeAll(keepingCapacity: false)
        }
        
        // compare each record with each center of cluster, find the minimum distance and append it to the corresponding cluster
        for j in 1 ... normalizedRecords.count {
            let r = normalizedRecords[j - 1]
            var distances = allClusters.enumerated().map({ ($0, $1.center.distance(to: r)) })
            distances.sort(by: { $0.1 < $1.1 })
            allClusters[distances[0].0].elements.append(r)
        }
        
        // find out the new center
        for i in 1 ... allClusters.count {
            allClusters[i - 1].updateCenter()
        }
        
        timesOfIteration += 1
    }
    
    allClusters.enumerated().forEach {
        print("#\($0 + 1) \($1)")
    }
    print("Times of iteration: \(timesOfIteration)\n")

    
    return allClusters
}

func answerQ2a() {
    let clusters = runKmeans(k: 2, with: records, initialCenterRef: 1, 2)
    clusters.forEach {
        print($0.averageIntraClusterDistance)
    }
    print(clusters.averageInterClusterDistance)
}

func answerQ2b() {
    let clusters = runKmeans(k: 3, with: records, initialCenterRef: 3, 5, 12)
    clusters.forEach {
        print($0.averageIntraClusterDistance)
    }
    print(clusters.averageInterClusterDistance)
}


fileprivate struct SingleLinkagePair: CustomDebugStringConvertible {
    var cluster1: Cluster<Record>
    var cluster2: Cluster<Record>
    var distance: Double
    
    var debugDescription: String {
        return "SingleLinkagePair - \(distance)\n\t\(cluster1.elements)\n\t\(cluster2.elements)"
    }
    
    var joined: Cluster<Record> {
        var c = Cluster(center: cluster1.center)
        c.elements.append(contentsOf: cluster1.elements)
        c.elements.append(contentsOf: cluster2.elements)
        return c
    }
}

fileprivate extension Cluster where T == Record {
    
    init(sinlgeRecord: Record) {
        self.init(center: sinlgeRecord)
        self.elements = [sinlgeRecord]
    }
    
    func formPair(with anotherCluster: Cluster<T>) -> SingleLinkagePair {
        var minDistance: Double = .infinity
        for x in elements {
            for y in anotherCluster.elements {
                let dis = x.distance(to: y)
                if dis < minDistance {
                    minDistance = dis
                }
            }
        }
        return SingleLinkagePair(cluster1: self, cluster2: anotherCluster, distance: minDistance)
    }
}

fileprivate extension Array where Element == Cluster<Record> {
    mutating func join(with pair: SingleLinkagePair) {
        let i = index(where: { $0.elements == pair.cluster1.elements })!
        let j = index(where: { $0.elements == pair.cluster2.elements })!
        print("Joining \(self[i]) and \(self[j]) with distance = \(pair.distance)")
        [i, j].sorted(by: >).forEach {
            remove(at: $0)
        }
        let formedCluster = pair.joined
        append(formedCluster)
        print("RESULT is \(formedCluster)")
    }
}

fileprivate extension Array where Element == SingleLinkagePair {
    var minDisPair: SingleLinkagePair? {
        if let minimum = self.min(by: { $0.distance < $1.distance })?.distance {
            if let i = index(where: { $0.distance == minimum }) {
                return self[i]
            }
        }
        return nil
    }
}

func answerQ2e() {
    
    var clusters = records.normalized.map {
        Cluster(sinlgeRecord: $0)
    }
    
    while clusters.count > 1 {
        var pairs = [SingleLinkagePair]()
        for i in 0 ..< clusters.count {
            for j in (i + 1) ..< clusters.count {
                let d = clusters[i].formPair(with: clusters[j])
                pairs.append(d)
            }
        }
        if let minDisPair = pairs.minDisPair {
            clusters.join(with: minDisPair)
        }
    }
    
    
}
