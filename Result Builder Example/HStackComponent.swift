//
//  HStackComponent.swift
//  Result Builder Example
//
//  Created by Eduard Dzhumagaliev on 17.01.2025.
//

final class HStackComponent: ViewComponent {
    var children: [ViewComponent]

    init(@ViewBuilder _ builder: () -> [ViewComponent]) {
        self.children = builder()
    }
}
