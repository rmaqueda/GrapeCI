//
//  WelcomeView.swift
//  GrapeCI
//
//  Created by Ricardo.Maqueda on 27/04/2020.
//  Copyright © 2020 Ricardo Maqueda Martinez. All rights reserved.
//

import SwiftUI

// swiftlint:disable all

struct WelcomeView: View {
    private let presenter: WelcomePresenter?
    private weak var flowController: FlowControllerProtocol?
    @ObservedObject private var viewModel: WelcomeViewModel

    init(viewModel: WelcomeViewModel) {
        self.viewModel = viewModel
        self.presenter = nil
    }

    init(presenter: WelcomePresenter, flowController: FlowControllerProtocol) {
        self.presenter = presenter
        self.flowController = flowController
        self.viewModel = presenter.viewModel
    }

    var body: some View {
        VStack {
            Text("Welcome to Grape CI")
                .font(.title)
                .frame(maxWidth: .infinity, maxHeight: 200)

            Text("Connected accounts:")
                .frame(maxWidth: .infinity, maxHeight: 30)

            VStack(alignment: .trailing, spacing: 10) {
                Toggle(isOn: self.$viewModel.isBitbucketAuthenticated) {
                    Text("Bitbucket")
                }
                .toggleStyle(SwitchToggleStyle())

                Toggle(isOn: self.$viewModel.isGitHubAutheticated) {
                    Text("GitHub")
                }
                .toggleStyle(SwitchToggleStyle())
            }

            Button(action: didPressShowIntegratedButton) {
                Text("Integration")
            }
            .padding()
        }
        
    }

    private func didPressShowIntegratedButton() {
        flowController?.loadListModule()
    }

}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView(viewModel: WelcomeViewModel())
    }
}

// swiftlint:enable all
