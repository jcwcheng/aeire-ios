//
//  UIKitExtension.swift
//  Giftpack Delivery
//
//  Created by Archerwind on 7/5/16.
//  Copyright © 2016 Giftpack. All rights reserved.
//

import UIKit

extension CGFloat {
   static func random( _ max: Int ) -> CGFloat {
      return CGFloat( arc4random() % UInt32( max ) )
   }
}

extension UIFont {
   func blackJackWithSize( size: Double ) -> UIFont {
      return UIFont( name: "BlackJack", size: CGFloat(size) )!
   }
}

extension UIColor {
   class var random: UIColor {
      switch arc4random()%5 {
      case 0: return UIColor( red: 0.23, green: 0.89, blue: 0.91, alpha: 0.2 )
      case 1: return UIColor( red: 0.23, green: 0.89, blue: 0.91, alpha: 0.4 )
      case 2: return UIColor( red: 0.23, green: 0.89, blue: 0.91, alpha: 0.6 )
      case 3: return UIColor( red: 0.23, green: 0.89, blue: 0.91, alpha: 0.8 )
      case 4: return UIColor( red: 0.23, green: 0.89, blue: 0.91, alpha: 1.0 )
      default: return UIColor.gray
      }
   }
   
   class var transparent: UIColor {
      return UIColor( red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0 )
   }
   
   class var placeHolderGray: UIColor {
      return UIColor( red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0 )
   }
   
   class var smokeGray: UIColor {
      return UIColor( red: 0.96, green: 0.96, blue: 0.96, alpha: 1.0 )
   }
   
   class var giftpackDarkGray: UIColor {
      return UIColor( red: 0.29, green: 0.29, blue: 0.29, alpha: 1.0 )
   }
   
   class var giftpackPink: UIColor {
      return UIColor( red: 0.95, green: 0.46, blue: 0.55, alpha: 1.0 )
   }
   
   class var giftpackPinkMedium: UIColor {
      return UIColor( red: 0.95, green: 0.46, blue: 0.55, alpha: 0.7 )
   }
   
   class var giftpackPinkLight: UIColor {
      return UIColor( red: 0.95, green: 0.46, blue: 0.55, alpha: 0.4 )
   }
   
   class var loadingBackground: UIColor {
      return UIColor( red: 1, green: 1, blue: 1, alpha: 0.8 )
   }
}

extension CGRect {
   var mid: CGPoint { return CGPoint( x: midX, y: midY ) }
   var upperLeft: CGPoint { return CGPoint( x: minX, y: minY ) }
   var upperRight: CGPoint { return CGPoint( x: maxX, y: minY ) }
   var lowerLeft: CGPoint { return CGPoint( x: minX, y: minY ) }
   var lowerRight: CGPoint { return CGPoint( x: minX, y: maxY ) }
   
   init( center: CGPoint, size: CGSize ) {
      let upperLeft = CGPoint( x: center.x-size.width/2, y: center.y-size.height/2 )
      self.init( origin: upperLeft, size: size )
   }
}

extension UILabel {
   func kern( _ kerningValue: CGFloat ) {
      self.attributedText = NSAttributedString( string: self.text ?? "", attributes: [NSKernAttributeName: kerningValue, NSFontAttributeName: font, NSForegroundColorAttributeName: self.textColor] )
   }
   
   func lineheight( _ heightValue: CGFloat ) {
      let style = NSMutableParagraphStyle()
      style.lineSpacing = heightValue
      let attributes = [NSParagraphStyleAttributeName : style]
      self.attributedText = NSAttributedString( string: self.text ?? "", attributes:attributes )
   }
}

extension UIButton {
   func kern( _ kerningValue: CGFloat ) {
      let attributedText = NSAttributedString( string: self.titleLabel!.text!, attributes: [NSKernAttributeName: kerningValue, NSFontAttributeName: self.titleLabel!.font, NSForegroundColorAttributeName:self.titleLabel!.textColor])
      self.setAttributedTitle( attributedText, for: UIControlState() )
   }
   
   func kernWithText( _ kerningValue: CGFloat, with text: String ) {
      let attributedText = NSAttributedString( string: text, attributes: [NSKernAttributeName: kerningValue, NSFontAttributeName: self.titleLabel!.font, NSForegroundColorAttributeName:self.titleLabel!.textColor])
      self.setAttributedTitle( attributedText, for: UIControlState() )
   }
}

extension UITextField {
   func kern( _ kerningValue: CGFloat ) {
      self.attributedPlaceholder = NSAttributedString( string: self.placeholder ?? "", attributes: [NSKernAttributeName: kerningValue, NSFontAttributeName: font!, NSForegroundColorAttributeName: UIColor.placeHolderGray] )
      self.attributedText = NSAttributedString( string: self.text ?? "", attributes: [NSKernAttributeName: kerningValue, NSFontAttributeName: font!, NSForegroundColorAttributeName: self.textColor!] )
   }
}

extension UITextView {
   func kern( _ kerningValue: CGFloat ) {
      self.attributedText = NSAttributedString( string: self.text ?? "", attributes: [NSKernAttributeName: kerningValue, NSFontAttributeName: font!, NSForegroundColorAttributeName: self.textColor!] )
   }
   
   func kernWithLineHeight( _ kerningValue: CGFloat, lineHeight: CGFloat ) {
      let style = NSMutableParagraphStyle()
      style.lineSpacing = lineHeight
      style.alignment = .center
      self.attributedText = ( NSAttributedString( string: self.text ?? "", attributes: [
         NSKernAttributeName: kerningValue,
         NSParagraphStyleAttributeName: style,
         NSFontAttributeName: font!,
         NSForegroundColorAttributeName: self.textColor!
         ]))
   }
}

extension UIImageView {
   func downloadedFrom( url: URL, contentMode mode: UIViewContentMode = .scaleAspectFill ) {
      contentMode = mode
      URLSession.shared.dataTask(with: url) { (data, response, error) in
         guard
            let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
            let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
            let data = data, error == nil,
            let image = UIImage(data: data)
            else { return }
         DispatchQueue.main.async() { () -> Void in
            self.image = image
            UIView.animate( withDuration: 2.0, animations: {
               self.alpha = 1.0
            })
         }
         }.resume()
   }
   func downloadedFrom( link: String, contentMode mode: UIViewContentMode = .scaleAspectFill ) {
      guard let url = URL( string: link ) else { return }
      downloadedFrom( url: url, contentMode: mode )
   }
}

extension UIView {
   func roundCorners( corners: UIRectCorner, radius: CGFloat ) {
      let path = UIBezierPath( roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize( width: radius, height: radius ) )
      let mask = CAShapeLayer()
      mask.path = path.cgPath
      self.layer.mask = mask
   }
}

extension CALayer {
   func addBorder( edge: UIRectEdge, color: UIColor, thickness: CGFloat ) {
      
      let border = CALayer()
      
      switch edge {
      case UIRectEdge.top:
         border.frame = CGRect.init(x: 0, y: 0, width: frame.width, height: thickness)
         break
      case UIRectEdge.bottom:
         border.frame = CGRect.init(x: 0, y: frame.height - thickness, width: frame.width, height: thickness)
         break
      case UIRectEdge.left:
         border.frame = CGRect.init(x: 0, y: 0, width: thickness, height: frame.height)
         break
      case UIRectEdge.right:
         border.frame = CGRect.init(x: frame.width - thickness, y: 0, width: thickness, height: frame.height)
         break
      default:
         break
      }
      
      border.backgroundColor = color.cgColor;
      
      self.addSublayer(border)
   }
}
