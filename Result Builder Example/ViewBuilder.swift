//
//  ViewBuilder.swift
//  Result Builder Example
//
//  Created by Eduard Dzhumagaliev on 14.01.2025.
//

@resultBuilder
enum ViewBuilder {
    /// Combines individual ViewComponent arguments into an array
    /// Allows the result builder to collect all components
    static func buildBlock(_ components: ViewComponent...) -> [ViewComponent] {
        components
    }

    /// Handles cases where for ... in loop is used to generate multiple ViewComponent items
    /// Flattens nested arrays into a single-level array
    /// > Warning: Returns an array, not enough to support for ... in loops within @result, @resultBuilder can't yet handle arrays of ViewComponent
    static func buildArray(_ components: [[any ViewComponent]]) -> [any ViewComponent] {
        components.flatMap { $0 }
    }

    /// Combines individual arrays of ViewComponent (arguments) into an array
    /// Combines arrays into a single flat array, simplifying processing, also erases
    /// Once the arrays are generated from for ... in loop via buildArray method, this method accepts generated arrays as arguments and flattens them into one single array
    static func buildBlock(_ components: [ViewComponent]...) -> [ViewComponent] {
        components.flatMap { $0 }
    }

    /// Transforms a single `ViewComponent` expression into an array of `ViewComponent`
    /// This method allows the result builder to handle individual expressions by wrapping them in an array,
    /// making it easier to compose and process in the context of the result builder.
    /// For example, if a single `ViewComponent` is provided in a builder block,
    /// this method ensures it is treated as a collection of components.
    static func buildExpression(_ expression: ViewComponent) -> [ViewComponent] {
        [expression]
    }
}
