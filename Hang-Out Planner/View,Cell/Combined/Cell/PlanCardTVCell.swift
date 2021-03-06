//
//  PlanCardTVCell.swift
//  Hang-Out Planner
//
//  Created by Takayuki Yamaguchi on 2021-01-17.
//

import UIKit


class PlanCardTVCell: CardTVCell {
  // cell content
  
  
  var topNLabel : LargeHeaderLabel = {
    let lb = LargeHeaderLabel(text: "a") // 1,2,3...
    lb.constraintHeight(equalToConstant: lb.intrinsicContentSize.height - 11)
    return lb
  }()
  
  var popularityField = TextLabel(text : "") // ⭐️⭐️⭐️
  var totalDistanceField = TextLabel(text: "") // Total 2.3km
  var totalTimeField = TextLabel(text: "") // 🚗 1h 🚶‍♂️2.3h
  
  var locationLabel =  SmallHeaderLabel(text: "") // Route
  //  var locationField = TextLabel(text: "") // Location A, B, ....
//  var locationFields : [TextLabel] = [TextLabel(text: "already")]
  let locationListStackView = VerticalStackView(
    arrangedSubviews: [] as [TextLabel],
    spacing: 8,
    alignment: .leading
  )

  
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: .default, reuseIdentifier: reuseIdentifier)


    let totalInfoStackView = VerticalStackView(
      arrangedSubviews: [popularityField, totalDistanceField,totalTimeField],
      spacing: 8,
      alignment: .leading
    )
    let upperInfoStackView = HorizontalStackView(
      arrangedSubviews: [topNLabel, totalInfoStackView],
      spacing: 0,
      alignment: .top
    )
    totalInfoStackView.matchSizeWith(widthRatio: 0.6, heightRatio: nil)
    
  
    let lowerInfoStackView = HorizontalStackView(
      arrangedSubviews: [locationLabel, locationListStackView],
      alignment: .top
    )
    locationListStackView.matchSizeWith(widthRatio: 0.6, heightRatio: nil)
    
    
    let mainStackView = VerticalStackView(
      arrangedSubviews: [upperInfoStackView, lowerInfoStackView],
      spacing: 24
    )
    mainStackView.isLayoutMarginsRelativeArrangement = true
    mainStackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 32, leading: 16, bottom: 32, trailing: 16)
  
    contentView.addSubview(mainStackView)
    mainStackView.matchParent()
    
    
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  /// update cell content based on `plan`
  /// - Parameter plan: current plan on the cell
  /// - Parameter planIndex: plan index. 0 is best.
  func update(with plan: Plan, planIndex: Int) {
  
    topNLabel.text = "\(planIndex + 1)"
    let guessDistance = plan.totalDistance
    totalDistanceField.text = "\(PlanCardTVCell.meterToKm(distance: guessDistance)) Km"
    if PlanCardTVCell.calcCarSpeed(distance: guessDistance) == 0.0 {
      totalTimeField.text = "\(PlanCardTVCell.calcWalkingSpeed(distance: guessDistance)) 🚶‍♂️"
    } else {
      totalTimeField.text = "\(PlanCardTVCell.calcCarSpeed(distance: guessDistance)) h 🚗  \(PlanCardTVCell.calcWalkingSpeed(distance: guessDistance)) 🚶‍♂️"
    }
   
    popularityField.text = Location.starConverter(score: plan.averageRating)
    
    
    locationLabel.text = "Route"
    locationListStackView.removeAllArrangedSubviews() // reusing cell, so must reset array.
    for i in 1..<plan.destinationList.count-1{
      let lb = TextLabel(text: "")
      let text = allLocations[plan.destinationList[i]].title
      lb.text =  text
      lb.numberOfLines = 1 // no break line.
      locationListStackView.addArrangedSubview(lb)
    }
    
  }
  
  static func meterToKm(distance: Double) -> Double{
    let km = distance * 0.001
    return round(km * 10)/10
  }
  
  // average human: 5km per hour, 85m per minute
  static func calcWalkingSpeed(distance: Double) -> String{
    let walkingSpeedInMinute = distance / 85
    let result = round(walkingSpeedInMinute * 10)/10
    if result <= 1 {
      return "\(result) min"
    } else if result < 60 {
      return  "\(result) mins"
    } else {
        let distanceInKm = distance * 0.001
        let walkingSpeed = distanceInKm / 5
        let result = round(walkingSpeed * 10)/10
      return "\(result) h"
    }
  }
  
  
  // average car: 40km per hour
  static func calcCarSpeed(distance: Double) -> Double{
   
    
    
    
    
    let distanceInKm = distance * 0.001
    let carSpped = distanceInKm / 40
    let result = round(carSpped * 10)/10
      return result
  }

  // return Location title by location id
  static func checkLocationName(id: Int) -> String {
    var locationName = ""
    for location in allLocations {
      if location.id == id {
        locationName = location.title
      }
    }
    return locationName
  }
}
