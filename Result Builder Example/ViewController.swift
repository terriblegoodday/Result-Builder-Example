//
//  ViewController.swift
//  Result Builder Example
//
//  Created by Eduard Dzhumagaliev on 10.01.2025.
//

import UIKit

class ViewController: UIViewController {
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.contentInsetAdjustmentBehavior = .always
        return scrollView
    }()

    private let rootStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .leading
        stackView.spacing = 16
        stackView.axis = .vertical
        stackView.distribution = .fill

        return stackView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(scrollView)
        scrollView.addSubview(rootStackView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        NSLayoutConstraint.activate([
            rootStackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            rootStackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            rootStackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            rootStackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            rootStackView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor)
        ])

        let strings = [
            "The Culture: A symphony of stars, a whisper of infinite possibilities.",
            "‘Mind the gaps,’ said the drone, buzzing around its human companion.",
            "Space was vast, indifferent, and achingly beautiful.",
            "‘Minds,’ mused the ship, ‘are the true explorers of the galaxy.’",
            "In the shadow of the Orbital, humanity danced with the stars."
        ]

        buildViews { // <= (3) buildBlock([TextComponent, ...], [TextComponent, ...], ...) -> [TextComponent, ...] where each [TextComponent, ...] within invocation is result of buildArray, in this case it's going to be one argument
            for string in strings { // <= (2) buildArray([[TextComponent, ...], ...]) -> [TextComponent, ...]
                TextComponent(text: string) // <= (1) buildBlock([TextComponent], ...) → [TextComponent, ...]
            }

            HStackComponent {
                TextComponent(text: "Label left")
                TextComponent(text: "Label right")
            }
        }
    }

    private func makeLabel(text: String) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text
        label.numberOfLines = 0

        return label
    }

    private func buildViews(@ViewBuilder _ builder: () -> [ViewComponent]) {
        let components = builder()

        buildViewHierarchy(components)
    }

    private func buildViewHierarchy(
        _ components: [ViewComponent],
        parent: UIStackView? = nil
    ) {
        let parent = parent ?? rootStackView

        for component in components {
            if let component = component as? HStackComponent {
                let stackView = UIStackView()
                stackView.translatesAutoresizingMaskIntoConstraints = false
                stackView.spacing = 16
                stackView.axis = .horizontal
                stackView.distribution = .fillEqually

                parent.addArrangedSubview(stackView)
                NSLayoutConstraint.activate([
                    stackView.leadingAnchor.constraint(equalTo: parent.leadingAnchor),
                    stackView.trailingAnchor.constraint(equalTo: parent.trailingAnchor),
                ])

                buildViewHierarchy(component.children, parent: stackView)
            } else if let view = convertComponentToView(component) {
                parent.addArrangedSubview(view)
            }
        }
    }

    private func convertComponentToView(_ component: ViewComponent) -> UIView? {
        switch component.self {
        case is TextComponent:
            let textComponent = component as! TextComponent
            return makeLabel(text: textComponent.text)
        default:
            return nil
        }
    }
}
