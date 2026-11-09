/// A calendar year in the Gregorian calendar.
nonisolated struct Year {
    let value: Int

    init(_ value: Int) {
        self.value = value
    }

    /// A year has 366 days when it divides by 4, except a century year that does
    /// not divide by 400.
    var isLeap: Bool {
        value % 4 == 0 && (value % 100 != 0 || value % 400 == 0)
    }
}
