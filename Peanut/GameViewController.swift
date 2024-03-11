//
//  GameViewController.swift
//  GameApp
//
//  Created by Alex Carlin on 3/11/24.
//

import UIKit
import QuartzCore
import SceneKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        // create a new scene
//        let scene = SCNScene(named: "art.scnassets/ship.scn")!
//
//        // create and add a camera to the scene
//        let cameraNode = SCNNode()
//        cameraNode.camera = SCNCamera()
//        scene.rootNode.addChildNode(cameraNode)
//
//        // place the camera
//        cameraNode.position = SCNVector3(x: 0, y: 0, z: 15)
//
//        // create and add a light to the scene
//        let lightNode = SCNNode()
//        lightNode.light = SCNLight()
//        lightNode.light!.type = .omni
//        lightNode.position = SCNVector3(x: 0, y: 10, z: 10)
//        scene.rootNode.addChildNode(lightNode)
//
//        // create and add an ambient light to the scene
//        let ambientLightNode = SCNNode()
//        ambientLightNode.light = SCNLight()
//        ambientLightNode.light!.type = .ambient
//        ambientLightNode.light!.color = UIColor.darkGray
//        scene.rootNode.addChildNode(ambientLightNode)
//
//        // retrieve the ship node
//        let ship = scene.rootNode.childNode(withName: "ship", recursively: true)!
//
//        // animate the 3d object
//        ship.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 2, z: 0, duration: 1)))
//
//        // retrieve the SCNView
//        let scnView = self.view as! SCNView
//
//        // set the scene to the view
//        scnView.scene = scene
//
//        // allows the user to manipulate the camera
//        scnView.allowsCameraControl = true
//
//        // show statistics such as fps and timing information
//        scnView.showsStatistics = true
//
//        // configure the view
//        scnView.backgroundColor = UIColor.black
//

        
        // Create a scene view to display the 3D scene
        let sceneView = SCNView(frame: view.bounds)
        sceneView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(sceneView)
        
        // Create a basic scene with a white background color
        let scene = SCNScene()
        sceneView.scene = scene
        
        // Create a camera and add it to the scene
        let camera = SCNCamera()
        let cameraNode = SCNNode()
        cameraNode.camera = camera
        scene.rootNode.addChildNode(cameraNode)
        
        // Position the camera
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 5)
        
        // Create a point cloud geometry
//        let pointCloud = SCNParticleSystem()
//        pointCloud.particleSize = 0.05
//        pointCloud.birthRate = 1000
//        pointCloud.particleColor = UIColor.red
//
//        // Create a node to hold the point cloud geometry
//        let pointCloudNode = SCNNode()
//        pointCloudNode.addParticleSystem(pointCloud)
//
//        // Add the point cloud node to the scene
//        scene.rootNode.addChildNode(pointCloudNode)

        // Create a box geometry
        let box = SCNBox(width: 1.0, height: 1.0, length: 1.0, chamferRadius: 0.0)

        // Create a material for the box
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.blue

        // Apply the material to the box
        box.materials = [material]

        // Create a node to hold the box geometry
        let boxNode = SCNNode(geometry: box)

        // Add the box node to the scene
        scene.rootNode.addChildNode(boxNode)
        
        // Create a sphere geometry
        let sphereRadius: CGFloat = 0.02
        let sphereGeometry = SCNSphere(radius: sphereRadius)

        // Create a material for the spheres
        let sphereMaterial = SCNMaterial()
        sphereMaterial.diffuse.contents = UIColor.red

        // Apply the material to the sphere geometry
        sphereGeometry.materials = [sphereMaterial]

        // Create a container node to hold the sphere instances
        let spheresContainerNode = SCNNode()

        // Define the number of spheres you want to render
        let sphereCount = 10000

        // Create instances of the sphere geometry and add them to the container node
        for _ in 0..<sphereCount {
            let sphereNode = SCNNode(geometry: sphereGeometry)
            spheresContainerNode.addChildNode(sphereNode)
        }

        // Position and distribute the spheres within the scene
        let sphereSpacing: Float = 0.1
        for (index, sphereNode) in spheresContainerNode.childNodes.enumerated() {
            let x = Float(index % 100) * sphereSpacing
            let y = Float((index / 100) % 100) * sphereSpacing
            let z = Float(index / (100 * 100)) * sphereSpacing
            sphereNode.position = SCNVector3(x, y, z)
        }

        // Add the spheres container node to the scene
        scene.rootNode.addChildNode(spheresContainerNode)
        
        // allows the user to manipulate the camera
        sceneView.allowsCameraControl = true
        
        // show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // configure the view
        sceneView.backgroundColor = UIColor.black
        
        // add a tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        sceneView.addGestureRecognizer(tapGesture)

    }
    
    @objc
    func handleTap(_ gestureRecognize: UIGestureRecognizer) {
        // retrieve the SCNView
        let scnView = self.view as! SCNView
        
        // check what nodes are tapped
        let p = gestureRecognize.location(in: scnView)
        let hitResults = scnView.hitTest(p, options: [:])
        // check that we clicked on at least one object
        if hitResults.count > 0 {
            // retrieved the first clicked object
            let result = hitResults[0]
            
            // get its material
            let material = result.node.geometry!.firstMaterial!
            
            // highlight it
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 0.5
            
            // on completion - unhighlight
            SCNTransaction.completionBlock = {
                SCNTransaction.begin()
                SCNTransaction.animationDuration = 0.5
                
                material.emission.contents = UIColor.black
                
                SCNTransaction.commit()
            }
            
            material.emission.contents = UIColor.red
            
            SCNTransaction.commit()
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

}
