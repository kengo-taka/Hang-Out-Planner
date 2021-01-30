//
//  DistanceCardTVCell.swift
//  Hang-Out Planner
//
//  Created by Takayuki Yamaguchi on 2021-01-17.
//

import UIKit

class DistanceCardTVCell: CardTVCell {

  // Distance symbol
  //  var arrowEmoji = SubTextLabel(text: "⇣")
//  var arrowEmoji = UIImageView(image: UIImage(systemName: "arrowtriangle.down.fill")?.withTintColor(.systemGray3, renderingMode: .alwaysOriginal))
  var distanceLine : VerticalStackView = {
    
    let circleSize : CGFloat = 10
    let color : UIColor = .systemGray5
  
    let upperCircle = UIView()
    upperCircle.backgroundColor = color
    upperCircle.constraintWidth(equalToConstant: circleSize)
    upperCircle.constraintHeight(equalToConstant: circleSize)
    upperCircle.layer.cornerRadius = circleSize/2

    let middleRect = UIView()
    middleRect.backgroundColor = color.withAlphaComponent(0.5)
    middleRect.constraintWidth(equalToConstant: 2)
    middleRect.constraintHeight(equalToConstant: 60)
    
    let lowerCircle = UIView()
    lowerCircle.backgroundColor = color
    lowerCircle.constraintWidth(equalToConstant: circleSize)
    lowerCircle.constraintHeight(equalToConstant: circleSize)
    lowerCircle.layer.cornerRadius = circleSize/2
    
    let sv = VerticalStackView(
      arrangedSubviews: [upperCircle, middleRect, lowerCircle],
      alignment: .center
    )
    sv.setCustomSpacing(-circleSize/2, after: upperCircle)
    sv.setCustomSpacing(-circleSize/2, after: lowerCircle)

    return sv
  }()
  
  
  
  var timeToReachByWalk = SubTextLabel(text: "")
  var timeToReachByCar = SubTextLabel(text: "")

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    contentView.addSubview(distanceLine)
    distanceLine.centerXYin(contentView)
    
    
    let timeStackView = VerticalStackView(
      arrangedSubviews: [timeToReachByCar, timeToReachByWalk],
      spacing: 8
    )
    contentView.addSubview(timeStackView)
    timeStackView.centerYin(distanceLine)
    timeStackView.leadingAnchor.constraint(equalTo: distanceLine.centerXAnchor, constant: 32).isActive = true

    self.backgroundColor = bgColor
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func update(with route: Route) {
    let minuteToCar = totalMinOnCar(distance: route.distance)
    let minuteToTake = totalMinOnFoot(distance: route.distance)
    timeToReachByCar.text = "\(minuteToCar) mins 🚗"
    timeToReachByWalk.text = "\(minuteToTake) mins 🚶‍♀️"
  }
  
  // meter -> how many minutes (1.4m/sec)
  func totalMinOnFoot(distance: Double) -> Double {
    let totalMin = (distance / 1.4) / 60
    return round(totalMin)
  }
  func totalMinOnCar(distance: Double) -> Double {
    let totalMin = (distance / 1.4) / 60 / 8
    return round(totalMin)
  }

}
