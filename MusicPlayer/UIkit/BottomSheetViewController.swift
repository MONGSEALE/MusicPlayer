//
//  TestView.swift
//  MusicPlayer
//
//  Created by DongHyeokHwang on 2/12/25.
//

// BottomSheetViewController.swift
import UIKit
import SwiftUI
import AVFAudio

class BottomSheetViewController: UIViewController {
    
    var bottomSheetView = UIView()
    var bottomSheetTopConstraint: NSLayoutConstraint!
    
    // 전체 높이와 처음 노출되는 높이 설정
    let bottomSheetTotalHeight: CGFloat = UIScreen.main.bounds.height * 0.9
    let bottomSheetVisibleHeight: CGFloat = 80
    
    // ContentView에서 전달받을 데이터
    var songs: [SongModel] = []
    var currentSongIndexBinding: Binding<Int> = .constant(0)
    var currentHeightBinding: Binding<CGFloat> = .constant(80)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchDurations()
        setupBottomSheet()
    }
    
    func setupBottomSheet() {
        // 1. 컨테이너 뷰 생성
        bottomSheetView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bottomSheetView)
        // 상단 모서리만 둥글게 처리
        bottomSheetView.layer.cornerRadius = 16
        bottomSheetView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        bottomSheetView.clipsToBounds = true

        
        // 2. 화면 하단에서 visibleHeight만 보이도록 top constraint 설정
        bottomSheetTopConstraint = bottomSheetView.topAnchor.constraint(equalTo: view.bottomAnchor, constant: -bottomSheetVisibleHeight)
        NSLayoutConstraint.activate([
            bottomSheetView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomSheetView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomSheetView.heightAnchor.constraint(equalToConstant: bottomSheetTotalHeight),
            bottomSheetTopConstraint
        ])
        
        // 3. SwiftUI PlayListSheet를 UIHostingController로 감싸서 추가
        let hostingController = UIHostingController(rootView: PlayListSheet(SongDatas: songs, currentSong: currentSongIndexBinding))
        addChild(hostingController)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        bottomSheetView.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)
        
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: bottomSheetView.topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: bottomSheetView.bottomAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: bottomSheetView.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: bottomSheetView.trailingAnchor)
        ])
        
        // 4. UIPanGestureRecognizer 추가하여 드래그 제스처 처리
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        bottomSheetView.addGestureRecognizer(panGesture)
    }
    
    private func fetchDurations() {
        // 각 노래 파일의 duration을 추출해서 업데이트
      
        for index in songs.indices {
            if let url = Bundle.main.url(forResource: songs[index].audioFileName, withExtension: "mp3") {
                do {
                    let player = try AVAudioPlayer(contentsOf: url)
                    let duration = player.duration
                    songs[index].duration = duration  // duration 값을 할당
                } catch {
                    print("Error loading audio file for duration extraction.")
                }
            }
        }
    }
    
    @objc func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
          let translation = gesture.translation(in: view)
          
          switch gesture.state {
          case .changed:
              let newConstant = bottomSheetTopConstraint.constant + translation.y
              let minConstant = -(bottomSheetTotalHeight - bottomSheetVisibleHeight)
              let maxConstant = -bottomSheetVisibleHeight
              if newConstant >= minConstant && newConstant <= maxConstant {
                  bottomSheetTopConstraint.constant = newConstant
                  gesture.setTranslation(.zero, in: view)
                  let currentVisibleHeight = bottomSheetTotalHeight + bottomSheetTopConstraint.constant
                  currentHeightBinding.wrappedValue = currentVisibleHeight
              }
              
          case .ended:
              let velocity = gesture.velocity(in: view).y
              let threshold: CGFloat = 150
              let minConstant = -(bottomSheetTotalHeight - bottomSheetVisibleHeight)
              let maxConstant = -bottomSheetVisibleHeight
              
              if velocity < -threshold || bottomSheetTopConstraint.constant < (maxConstant + minConstant) / 0.5 {
                  bottomSheetTopConstraint.constant = minConstant
              } else {
                  bottomSheetTopConstraint.constant = maxConstant
              }
              
              UIView.animate(withDuration: 0.3) {
                  self.view.layoutIfNeeded()
                  self.currentHeightBinding.wrappedValue = -self.bottomSheetTopConstraint.constant
              }
              
          default:
              break
          }
      }

}






#Preview {
    BottomSheetViewController()
}
