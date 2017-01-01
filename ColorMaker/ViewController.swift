//
//  ViewController.swift
//  ColorMaker
//
//  Created by Luke Van In on 2017/01/01.
//  Copyright © 2017 Luke Van In. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    enum ChannelMode : Int {
        case rgb
        case hsb
        case cmy
        
        func makeColorFor(x : CGFloat, y : CGFloat, z : CGFloat) -> UIColor {
            switch self {
            case .rgb:
                return UIColor(red: x, green: y, blue: z, alpha: 1.0)
                
            case .hsb:
                return UIColor(hue: x, saturation: y, brightness: z, alpha: 1.0)
                
            case .cmy:
                return UIColor(red: 1.0 - x, green: 1.0 - y, blue: 1.0 - z, alpha: 1.0)
            }
        }
    }
    
    @IBOutlet weak var xChannelLabel : UILabel!
    @IBOutlet weak var yChannelLabel : UILabel!
    @IBOutlet weak var zChannelLabel : UILabel!
    @IBOutlet weak var xColorSlider : UISlider!
    @IBOutlet weak var yColorSlider : UISlider!
    @IBOutlet weak var zColorSlider : UISlider!
    @IBOutlet weak var channelSelector : UISegmentedControl!
    @IBOutlet weak var previewView : UIView!
    
    private var channelMode : ChannelMode = .rgb
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateChannels()
        updateColor()
        updateLabels()
    }

    @IBAction func onSliderValueChanged(_ sender: Any) {
        updateColor()
        updateLabels()
    }
    
    @IBAction func onChannelChanged(_ sender: Any) {
        resetSliders()
        updateChannels()
        updateColor()
        updateLabels()
    }
    
    private func resetSliders() {
        xColorSlider.value = 0.5
        yColorSlider.value = 0.5
        zColorSlider.value = 0.5
    }
    
    private func updateChannels() {
        channelMode = ChannelMode(rawValue: channelSelector.selectedSegmentIndex)!
    }
    
    private func updateColor() {
        let color = makeColor()
        previewView.backgroundColor = color
        view.backgroundColor = makeFadedColor(from: color)
    }
    
    private func updateLabels() {
        let xChannelName : String
        let yChannelName : String
        let zChannelName : String
        
        switch channelMode {
            
        case .rgb:
            xChannelName = "RED"
            yChannelName = "GREEN"
            zChannelName = "BLUE"
            
        case .hsb:
            xChannelName = "HUE"
            yChannelName = "SATURATION"
            zChannelName = "BRIGHTNESS"
            
        case .cmy:
            xChannelName = "CYAN"
            yChannelName = "MAGENTA"
            zChannelName = "YELLOW"
        }
        
        xChannelLabel.text = "\(xChannelName) \(Int(xColorSlider.value * 100))%"
        yChannelLabel.text = "\(yChannelName) \(Int(yColorSlider.value * 100))%"
        zChannelLabel.text = "\(zChannelName) \(Int(zColorSlider.value * 100))%"
    }
    
    private func makeColor() -> UIColor {
        return channelMode.makeColorFor(
            x: CGFloat(xColorSlider.value),
            y: CGFloat(yColorSlider.value),
            z: CGFloat(zColorSlider.value)
        )
    }
    
    private func makeFadedColor(from color: UIColor) -> UIColor {
        
        let base = CGFloat(0.25)
        let delta = CGFloat(0.25)
        var r : CGFloat = 0
        var g : CGFloat = 0
        var b : CGFloat = 0
        
        guard color.getRed(&r, green: &g, blue: &b, alpha: nil) else {
            return UIColor.black
        }
        
        return UIColor(
            red: base + (r * delta),
            green: base + (g * delta),
            blue: base + (b * delta),
            alpha: 1.0
        )
    }
}

