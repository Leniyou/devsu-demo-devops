export default {
    rootDir: ".",
    verbose: true,
    testEnvironment: "node",
    transform: {
        "^.+\\.js?$": "babel-jest"
    },
    testRegex: "(/__tests__/.*|(\\.|/)(test|spec))\\.js$",
    collectCoverage: true,
    collectCoverageFrom: [
        "**/*.js",
        "!**/node_modules/**",
        "!**/shared/**",
        "!**/coverage/**",
        "!**/*.test.js"
    ],
    coverageDirectory: "<rootDir>/test-results/coverage",
    coverageReporters: [
        "cobertura",
        "text-summary",
        "html",
        "lcov"
    ],
    testResultsProcessor: "jest-sonar-reporter",
    reporters: [
        "default",
        [
            "jest-junit",{
                outputDirectory: "<rootDir>/test-results",
                outputName: "junit.xml"
            }
        ]
    ],
}
