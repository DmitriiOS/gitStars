//
//  StarDatesService.swift
//  testApp
//
//  Created by Dmitriy Orlov on 13.10.2020.
//

import Foundation

protocol DateOptimizer {
    func dateOptimizer(_ datesString: [RepoStarsByDates]) -> [DatesAndStars]
}

final class StarDatesService: DateOptimizer {
    var datesAndStars: [DatesAndStars] = []
    func dateOptimizer(_ datesString: [RepoStarsByDates]) -> [DatesAndStars] {
        var datesDate: [Date] = []
        var stringDate = ""
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        dateFormatter.locale = Locale(identifier: "us_En")
        let calendar = Calendar.current
        for i in 0..<datesString.count {
            stringDate = datesString[i].starredAt
            let date = dateFormatter.date(from: stringDate)
            let components = calendar.dateComponents([.year, .month, .day], from: date!)
            let finalDate = calendar.date(from: components)
            datesDate.append(finalDate!)
        }
        
        var startDate = datesDate.first ?? Date()
        let finishDate = Date()
        while startDate <= finishDate {
            datesAndStars.append(DatesAndStars(dates: startDate))
            startDate = calendar.date(byAdding: .day, value: 1, to: startDate)!
        }
        for x in 0..<datesAndStars.count {
            for i in 0..<datesDate.count {
                if datesAndStars[x].dates == datesDate[i] {
                    datesAndStars[x].stars += 1
                }
            }
        }
        return datesAndStars
    }
}
