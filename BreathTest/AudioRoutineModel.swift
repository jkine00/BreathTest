//
//  AudioRoutineModel.swift
//  NewBreath
//
//  Created by John Kine on 2025-04-19.
//

import Foundation
import AVFoundation

class AudioRoutineViewModel: NSObject, ObservableObject, AVAudioPlayerDelegate {

    //private var breathPlayer: AVAudioPlayer?
    private var currentPlayer: AVAudioPlayer?
    //private var continuation: CheckedContinuation<Void, Never>?


    let inhaleTime: TimeInterval = 1.0
    let tockDuration: TimeInterval = 1.0
    let bellDuration: TimeInterval = 1.0
    let exhaleTime: TimeInterval = 1.0


func startBreathRoutine(breaths:Int, inhaleBeats:Int, exhaleBeats:Int) {

    
        Task {
                        
            for _ in 1...breaths {
                await PlayBreathAudio(named: "Inhale2", duration: 1.0)
                await runBreathCadence(k: inhaleBeats)
                await PlayBreathAudio(named: "Exhale2", duration: 1.0)
                await runBreathCadence(k: exhaleBeats)
            }
        
        }
    }

    private func runBreathCadence(k: Int) async {
        if k <= 0 { return }

        for j in 1...k {
        
            if k == 1 && j == 1 {
                return
            }
            

            if k == 2 && j == 2 {
                

                await PlayBreathAudio(named: "Bell2", duration: bellDuration)
            }

            if k > 2 {
                
                if j < k {
                    await PlayBreathAudio(named: "Tock2", duration: tockDuration)
                } else if j == k {
                    await PlayBreathAudio(named: "Bell2", duration: bellDuration)
                }
            }
        }
    }

    private func delay(seconds: TimeInterval) async {
        try? await Task.sleep(nanoseconds: UInt64(seconds * 1_000_000_000))
    }

    
    private func PlayBreathAudio(named name: String, duration: TimeInterval) async {
        guard let url = Bundle.main.url(forResource: name, withExtension: "m4a") else {
            print("Error: Audio file \(name).m4a not found.")
            return
        }

        do {
            let player = try AVAudioPlayer(contentsOf: url)
            currentPlayer = player // retain so it's not deallocated
            player.prepareToPlay()
            player.play()

            // Wait exactly the desired duration
            await delay(seconds: duration)

            // Stop the audio even if it's not done
            player.stop()
            currentPlayer = nil

        } catch {
            print("Error playing audio \(name): \(error.localizedDescription)")
        }
    }

    
//    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
//        print("inside audioPlayerDidFinishPlaying")
//        continuation?.resume()
//        continuation = nil
//    }

}

