//
//  Question1.swift
//  COMP5121Assi2
//
//  Created by Hesse Huang on 2017/10/31.
//  Copyright © 2017年 Hesse. All rights reserved.
//

import Darwin

fileprivate struct Record: CustomDebugStringConvertible {
    
    enum Gender: String, CustomDebugStringConvertible {
        case m, f
        
        var debugDescription: String {
            return self.rawValue
        }
    }
    
    enum SpectaclePrescription: String, CustomDebugStringConvertible {
        case myope = "m", hyper = "h"
        var debugDescription: String {
            return self.rawValue
        }
    }
    
    enum Astigmatism: String, CustomDebugStringConvertible {
        case y, n
        var debugDescription: String {
            return self.rawValue
        }
        
    }
    
    enum TearProdutionRate: String, CustomDebugStringConvertible {
        case normal = "n", reduced = "r"
        var debugDescription: String {
            return self.rawValue
        }
        
    }
    
    enum Recommendation: String, CustomDebugStringConvertible {
        case lifestyle = "l", street = "s", polarized = "p"
        var debugDescription: String {
            return self.rawValue
        }
        
    }
    
    var gender: Gender
    var sp: SpectaclePrescription
    var ast: Astigmatism
    var tpr: TearProdutionRate
    var rmd: Recommendation
    
    var key: String {
        return "\(gender.debugDescription)\(sp.debugDescription)\(ast.debugDescription)\(tpr.debugDescription)"
    }
    
    var debugDescription: String {
        return "\(key) -> \(rmd.debugDescription)"
    }
    
}

func entropy(_ x: Double...) -> Double {
    return x.reduce(0) {
        return $1 > 0 ? $0 - $1 * log2($1) : $0
    }
}

func entropy(each: Double...) -> Double {
    let sum = each.reduce(0.0, +)
    return each.map({ $0 / sum }).reduce(0.0) {
        return $1 > 0 ? $0 - $1 * log2($1) : $0
    }
}

extension Array where Element == Record {
    
    var count_d: Double {
        return Double(count)
    }
    
    // gender field
    var mCount: Double {
        return filter({ $0.gender == .m }).count_d
    }
    var fCount: Double {
        return filter({ $0.gender == .f }).count_d
    }
    
    // sp field
    var myopeCount: Double {
        return filter({ $0.sp == .myope }).count_d
    }
    var hyperCount: Double {
        return filter({ $0.sp == .hyper }).count_d
    }
    
    // ast field
    var yCount: Double {
        return filter({ $0.ast == .y }).count_d
    }
    var nCount: Double {
        return filter({ $0.ast == .n }).count_d
    }
    
    // tpr field
    var reducedCount: Double {
        return filter({ $0.tpr == .reduced }).count_d
    }
    var normalCount: Double {
        return filter({ $0.tpr == .normal }).count_d
    }
    
    // rmd field
    var liftstyleCount: Double {
        return filter({ $0.rmd == .lifestyle }).count_d
    }
    var streetCount: Double {
        return filter({ $0.rmd == .street }).count_d
    }
    var polarizedCount: Double {
        return filter({ $0.rmd == .polarized }).count_d
    }
    
    var prediction: [String: Int] {
        var p = [String: Int]()
        forEach {
            if p[$0.key] == nil {
                p[$0.key] = 1
            } else {
                p[$0.key]! += 1
            }
        }
        return p
    }
    
    var entro: Double {
        return entropy(each: liftstyleCount, streetCount, polarizedCount)
    }
    
    var genderEntro: Double {
        let males = filter({ $0.gender == .m })
        let females = filter({ $0.gender == .f })
        return males.entro * mCount / count_d + females.entro * fCount / count_d
    }
    
    var spEntro: Double {
        let ms = filter({ $0.sp == .myope })
        let hs = filter({ $0.sp == .hyper })
        return ms.entro * myopeCount / count_d + hs.entro * hyperCount / count_d
    }
    
    var astEntro: Double {
        let ys = filter({ $0.ast == .y })
        let ns = filter({ $0.ast == .n })
        return ys.entro * yCount / count_d + ns.entro * nCount / count_d
    }
    
    var tprEntro: Double {
        let rs = filter({ $0.tpr == .reduced })
        let ns = filter({ $0.tpr == .normal })
        return rs.entro * reducedCount / count_d + ns.entro * normalCount / count_d
    }
}



fileprivate let records: [Record] = [
    Record(gender: .m, sp: .myope, ast: .y, tpr: .reduced, rmd: .lifestyle),
    Record(gender: .f, sp: .myope, ast: .n, tpr: .reduced, rmd: .street),
    Record(gender: .m, sp: .hyper, ast: .y, tpr: .normal, rmd: .lifestyle),
    Record(gender: .m, sp: .hyper, ast: .n, tpr: .normal, rmd: .polarized),
    Record(gender: .f, sp: .myope, ast: .n, tpr: .reduced, rmd: .street),
    Record(gender: .f, sp: .hyper, ast: .y, tpr: .normal, rmd: .lifestyle),
    Record(gender: .m, sp: .hyper, ast: .n, tpr: .normal, rmd: .polarized),
    Record(gender: .m, sp: .hyper, ast: .y, tpr: .reduced, rmd: .lifestyle),
    Record(gender: .m, sp: .myope, ast: .n, tpr: .normal, rmd: .street),
    Record(gender: .m, sp: .myope, ast: .y, tpr: .normal, rmd: .polarized),
    Record(gender: .f, sp: .myope, ast: .n, tpr: .reduced, rmd: .street),
    Record(gender: .f, sp: .hyper, ast: .y, tpr: .reduced, rmd: .polarized),
    Record(gender: .m, sp: .myope, ast: .n, tpr: .normal, rmd: .lifestyle),
    Record(gender: .f, sp: .hyper, ast: .y, tpr: .reduced, rmd: .polarized),
    Record(gender: .f, sp: .hyper, ast: .y, tpr: .normal, rmd: .lifestyle)
]

func answerQ1a() {
    
    print(records.filter({ $0.rmd == .lifestyle }))
    print(records.filter({ $0.rmd == .street }))
    print(records.filter({ $0.rmd == .polarized }))
    
    print(records.entro)
    print(records.genderEntro)
    print(records.spEntro)
    print(records.astEntro)
    print(records.tprEntro)
    print("We firstly choose Asti!")
    
    let subAsti_y = records.filter({ $0.ast == .y })
    let subAsti_n = records.filter({ $0.ast == .n })
    print(subAsti_y.entro)
    print(subAsti_y.genderEntro)
    print(subAsti_y.spEntro)
    print(subAsti_y.tprEntro)
    print("Choose Gender for subAsti_y")
    print(subAsti_n.entro)
    print(subAsti_n.genderEntro)
    print(subAsti_n.spEntro)
    print(subAsti_n.tprEntro)
    print("Choose SP for subAsti_n")
    
    let subGender_m_asti_y = subAsti_y.filter({ $0.gender == .m })
    print(subGender_m_asti_y.entro)
    print(subGender_m_asti_y.spEntro)
    print(subGender_m_asti_y.tprEntro)
    print("Choosing eigher sp or tpr is ok")
    
    let subGender_f_asti_y = subAsti_y.filter({ $0.gender == .f })
    print(subGender_f_asti_y.entro)
    print(subGender_f_asti_y.spEntro)
    print(subGender_f_asti_y.tprEntro)
    print("Undoubtly choose tpr")
    
    let subSp_m_asti_n = subAsti_n.filter({ $0.sp == .myope })
    print(subSp_m_asti_n.entro)
    print(subSp_m_asti_n.genderEntro)
    print(subSp_m_asti_n.tprEntro)
    print("Choosing either gender or tpr is ok")
}






// Naive Bayesian Approach
extension Array where Element == Record {
    
    var liftstyleSubset: [Record] {
        return filter({ $0.rmd == .lifestyle })
    }
    var streetSubset: [Record] {
        return filter({ $0.rmd == .street })
    }
    var polarizedSubset: [Record] {
        return filter({ $0.rmd == .polarized })
    }
    func naiveBayesianPrediction(with record: Record, onSubsetWithRec rec: Record.Recommendation) -> Double {
        var rc: Double
        var targetSet: [Record]
        switch rec {
        case .lifestyle:    rc = liftstyleCount; targetSet = liftstyleSubset
        case .street:       rc = streetCount;    targetSet = streetSubset
        case .polarized:    rc = polarizedCount; targetSet = polarizedSubset
        }
        
        var a1, a2, a3, a4: Double
        switch record.gender {
        case .m:        a1 = targetSet.mCount / rc
        case .f:        a1 = targetSet.fCount / rc
        }
        switch record.sp {
        case .myope:    a2 = targetSet.myopeCount / rc
        case .hyper:    a2 = targetSet.hyperCount / rc
        }
        switch record.ast {
        case .y:        a3 = targetSet.yCount / rc
        case .n:        a3 = targetSet.nCount / rc
        }
        switch record.tpr {
        case .normal:   a4 = targetSet.normalCount / rc
        case .reduced:  a4 = targetSet.reducedCount / rc
        }
        
        return a1 * a2 * a3 * a4 * rc / count_d
    }
    func naiveBayesianPrediction(with record: Record) -> [String: Double] {
        return [
            "l": naiveBayesianPrediction(with: record, onSubsetWithRec: .lifestyle),
            "s": naiveBayesianPrediction(with: record, onSubsetWithRec: .street),
            "p": naiveBayesianPrediction(with: record, onSubsetWithRec: .polarized),
        ]
    }
}

func answerQ1c() {
    let testRecord1 = Record(gender: .f, sp: .hyper, ast: .y, tpr: .reduced, rmd: .street)
    let testRecord2 = Record(gender: .f, sp: .hyper, ast: .n, tpr: .normal, rmd: .street)
    let testRecord3 = Record(gender: .f, sp: .myope, ast: .y, tpr: .reduced, rmd: .polarized)
    let testRecord4 = Record(gender: .f, sp: .hyper, ast: .n, tpr: .normal, rmd: .polarized)
    let testRecord5 = Record(gender: .m, sp: .myope, ast: .n, tpr: .reduced, rmd: .lifestyle)
    
    print(records.naiveBayesianPrediction(with: testRecord1))
    print(records.naiveBayesianPrediction(with: testRecord2))
    print(records.naiveBayesianPrediction(with: testRecord3))
    print(records.naiveBayesianPrediction(with: testRecord4))
    print(records.naiveBayesianPrediction(with: testRecord5))
}




